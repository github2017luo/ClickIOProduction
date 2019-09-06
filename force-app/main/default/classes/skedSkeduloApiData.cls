global class skedSkeduloApiData {
    
    global virtual class resultBase extends skedCalloutResultBase {
        public error error;
    }

    public class error {
        public string errorType;
        public string message;
        public string errorKey;
    }

    /* NOTIFICATION */
    global class notificationResult extends resultBase {
        public notificationReturnedData result;
    }
    public class notificationReturnedData {
        public string jobId;
        public List<allocationData> results;
    }
    public class allocationData {
        public string resourceId;
        public string protocol;
        public error error;
    }

    /* GEOLOCATION */
    public class directionsRequest {
        public latlng origin;
        public latlng destination;
    }
    public class latlng {
        public decimal lng;
        public decimal lat;
    }

    global class directionsResult extends resultBase {
        public directionsResultData result;
    }
    public class directionsResultData {
        public List<List<direction>> routes;
    }

    public class direction {
        public leg leg;
        public travelInfo travelInfo;
    }
    public class leg {
        public latlng origin;
        public latlng destination;
        public List<String> avoid;
    }
    public class travelInfo {
        public duration duration;
        public distance distance;
        public string status; 
    }
    public class duration {
        public decimal durationInSeconds;
    }
    public class distance {
        public decimal distanceInMeters;
    }
}