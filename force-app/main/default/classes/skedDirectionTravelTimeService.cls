global class skedDirectionTravelTimeService extends skedTravelTimeServiceBase {
    
    public override void initialize(List<skedBaseModels.geometry> origins, List<skedBaseModels.geometry> destinations) {
    }

	public void calculateTravelTimes(List<skedSkeduloApiData.directionsRequest> requests) {
        //process matrix distance request
        this.mapJourney = new Map<string, skedBaseModels.journeyModel>();
        system.debug('#requests#' + requests.size());

        skedSkeduloApiManager apiManager = new skedSkeduloApiManager();
        List<String> avoid = new List<String>();
        avoid.add('ferry');
        skedSkeduloApiData.directionsResult directionsResult = apiManager.findDirections(requests, avoid);

        if (directionsResult.error == NULL && directionsResult.result != NULL && directionsResult.result.routes != NULL) {
            integer minDistance;
            for (integer i = 0; i < directionsResult.result.routes.size(); i++) {
                skedSkeduloApiData.directionsRequest request = requests.get(i);
                List<skedSkeduloApiData.direction> directions = directionsResult.result.routes.get(i);

                integer totalDurationInSeconds;
                integer totaldistanceInMeters;
                for (integer j = 0; j < directions.size(); j++) {
                    skedSkeduloApiData.direction direction = directions.get(j);
                    if (direction.travelInfo.status == 'OK') {
                        system.debug('#direction: #' + direction);
                        if (totalDurationInSeconds == NULL) {
                            totalDurationInSeconds = 0;
                        }
                        if (totaldistanceInMeters == NULL) { 
                            totaldistanceInMeters = 0;
                        }
                        totalDurationInSeconds += (integer)direction.travelInfo.duration.durationInSeconds;
                        totaldistanceInMeters += (integer)direction.travelInfo.distance.distanceInMeters;
                    }
                }

                skedBaseModels.journeyModel journey = new skedBaseModels.journeyModel();
                journey.distance = totaldistanceInMeters;
                journey.travelTime = totalDurationInSeconds;

                journey.originGeometry = new skedBaseModels.geometry(Location.newInstance(request.origin.lat, request.origin.lng));
                string originKey = journey.originGeometry.lat + ',' + journey.originGeometry.lng;
                journey.destinationGeometry = new skedBaseModels.geometry(Location.newInstance(request.destination.lat, request.destination.lng));
                string destinationKey = journey.destinationGeometry.lat + ',' + journey.destinationGeometry.lng;
                
                this.mapJourney.put(originKey + '|' + destinationKey, journey);
            }
        }
        else {
            system.debug('#mapOrigin#' + requests.size());
            system.debug('#matrixResult#' + directionsResult);
            string errorMessage = directionsResult.error.message;
            if (string.isBlank(errorMessage)) {
                errorMessage = 'We are experiencing a high usage volume at present. Please try again in a few seconds.';
            }
            throw new skedException('Google Distance Matrix API Error: ' + errorMessage);
        }

    }
}