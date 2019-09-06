@isTest
global class skedGeoservicesApi_Mock implements HttpCalloutMock {

    public string calloutMethod {get;set;}
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        string finalResult;
        
        if (this.calloutMethod == 'calculateMultiDistances') {
            finalResult = '{"result":{"matrix":[[{"duration":{"durationInSeconds":1359},"distance":{"distanceInMeters":10045},"status":"OK"}],[{"duration":{"durationInSeconds":1373},"distance":{"distanceInMeters":8252},"status":"OK"}],[{"duration":{"durationInSeconds":1616},"distance":{"distanceInMeters":12746},"status":"OK"}]]}}';
        }
        else if (this.calloutMethod == 'findDirections') {
            finalResult = '{"result":{"routes":[[{"leg":{"origin":{"lat":43.04,"lng":-87.9},"destination":{"lat":43.083564,"lng":-86.144724},"avoid":[]},"travelInfo":{"duration":{"durationInSeconds":12165},"distance":{"distanceInMeters":162986},"status":"OK"}}]]}}';
        }
        res.setBody(finalResult);
        res.setStatusCode(200);
        
        return res;
    }
    
}