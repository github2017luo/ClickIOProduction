global virtual class skedSkeduloApiManager {
    
    public static final string NOTIFY_DISPATCH_ENDPOINT = 'https://api.skedulo.com/notifications/dispatch';
    public static final string FIND_DIRECTIONS_ENDPOINT = 'https://api.skedulo.com/geoservices/directions';

    protected string longLiveToken;

    public void dispatchJobs(Set<Id> jobIds) {
        List<sked__Job__c> skedJobs = [SELECT Id, Name, Skedulo_API_Error__c, Skedulo_API_Error_Message__c,
                                       (SELECT Id, sked__Job__c, sked__Resource__c, sked__Status__c
                                        FROM sked__Job_Allocations__r
                                        WHERE sked__Status__c != :skedConstants.JOB_ALLOCATION_STATUS_DELETED)
                                       FROM sked__Job__c
                                       WHERE Id IN :jobIds];
        List<sked__Job_Allocation__c> skedAllocationsToUpdate = new List<sked__Job_Allocation__c>();
        for (sked__Job__c skedJob : skedJobs) {
            skedSkeduloApiData.notificationResult result = notifyDispatch(skedJob.Id);
            if (result.success == false) {
                skedJob.Skedulo_API_Error_Message__c += 'Error Code: ';
                skedJob.Skedulo_API_Error_Message__c += result.error.message;
                skedJob.Skedulo_API_Error_Message__c += '\n';
            }
            else {
                skedJob.sked__Job_Status__c = skedConstants.JOB_STATUS_DISPATCHED;
                skedSkeduloApiData.notificationReturnedData returnData = result.result;
                for (sked__Job_Allocation__c skedAllocation : skedJob.sked__Job_Allocations__r) {
                    for (skedSkeduloApiData.allocationData allocation : returnData.results) {
                        if (allocation.error == NULL) {
                            continue;
                        }
                        if (skedAllocation.sked__Resource__c == allocation.resourceId) {
                            skedAllocation.Skedulo_API_Error__c = TRUE;
                            skedAllocation.Skedulo_API_Error_Message__c = '';
                            if (String.isNotBlank(allocation.error.message)) {
                                skedAllocation.Skedulo_API_Error_Message__c += 'Error Code: ';
                                skedAllocation.Skedulo_API_Error_Message__c += allocation.error.errorType;
                                skedAllocation.Skedulo_API_Error_Message__c += '\n';
                            }
                            if (String.isNotBlank(allocation.error.message)) {
                                skedAllocation.Skedulo_API_Error_Message__c += 'Error Message: ';
                                skedAllocation.Skedulo_API_Error_Message__c += allocation.error.message;
                            }
                        }
                    }
                    skedAllocation.sked__Status__c = skedConstants.JOB_ALLOCATION_STATUS_DISPATCHED;
                    skedAllocationsToUpdate.add(skedAllocation);
                }
            }
        }
        update skedJobs;
        if (!skedAllocationsToUpdate.isEmpty()) {
            update skedAllocationsToUpdate;
        }
    }

    public void dispatchJobAllocations(Set<Id> jobAllocationIds) {
        List<sked__Job_Allocation__c> skedAllocations = [SELECT Id, sked__Job__c, sked__Resource__c, 
                                                         sked__Status__c
                                                         FROM sked__Job_Allocation__c
                                                         WHERE Id IN :jobAllocationIds];
        Set<Id> jobIdsToUpdateStatus = new Set<Id>();
        for (sked__Job_Allocation__c skedAllocation : skedAllocations) {
            skedSkeduloApiData.notificationResult result = notifyDispatch(skedAllocation.sked__Job__c, skedAllocation.sked__Resource__c);
            if (result.success == TRUE) {
                skedSkeduloApiData.notificationReturnedData returnData = result.result;
                for (skedSkeduloApiData.allocationData allocation : returnData.results) {
                    if (allocation.error == NULL) {
                        jobIdsToUpdateStatus.add(skedAllocation.sked__Job__c);
                        continue;
                    }
                    if (skedAllocation.sked__Resource__c == allocation.resourceId) {
                        skedAllocation.Skedulo_API_Error__c = TRUE;
                        skedAllocation.Skedulo_API_Error_Message__c = '';
                        if (String.isNotBlank(allocation.error.message)) {
                            skedAllocation.Skedulo_API_Error_Message__c += 'Error Code: ';
                            skedAllocation.Skedulo_API_Error_Message__c += allocation.error.errorType;
                            skedAllocation.Skedulo_API_Error_Message__c += '\n';
                        }
                        if (String.isNotBlank(allocation.error.message)) {
                            skedAllocation.Skedulo_API_Error_Message__c += 'Error Message: ';
                            skedAllocation.Skedulo_API_Error_Message__c += allocation.error.message;
                        }
                    }
                }
            }
        }
        update skedAllocations;

        if (!jobIdsToUpdateStatus.isEmpty()) {
            skedJobService.updateJobStatus(jobIdsToUpdateStatus);
        }
    }

    /******************************************* Skedulo Notifications *******************************************/
    public skedSkeduloApiData.notificationResult notifyDispatch(string jobId) {
        return notify('dispatch', jobId, NULL);
    }

    public skedSkeduloApiData.notificationResult notifyDispatch(string jobId, string resourceId) {
        return notify('dispatch', jobId, resourceId);
    }

    /******************************************* Skedulo Geolocation *******************************************/
    public skedSkeduloApiData.directionsResult findDirections(List<skedSkeduloApiData.directionsRequest> requests, List<String> avoid) {
        Map<string, object> mapBody = new Map<string, object>();
        mapBody.put('requests', requests);
        mapBody.put('avoid', avoid);
        string jsonBody = Json.serialize(mapBody);
        system.debug('#mapBody#' + jsonBody);

        actionBase action = new actionBase();
        return (skedSkeduloApiData.directionsResult)action.execute(skedSkeduloApiData.directionsResult.class, FIND_DIRECTIONS_ENDPOINT, 'POST', getDefaultHeader(), jsonBody);
    }

    /******************************************* Protected methods *******************************************/
    protected skedSkeduloApiData.notificationResult notify(string notifyType, string jobId, string resourceId) {
        Map<string, string> mapBody = new Map<string, string>();
        mapBody.put('jobId', jobId);
        if (!string.isBlank(resourceId)) {
            mapBody.put('resourceId', resourceId);
        }
        string jsonBody = Json.serialize(mapBody);

        actionBase action = new actionBase();
        return (skedSkeduloApiData.notificationResult)action.execute(skedSkeduloApiData.notificationResult.class, NOTIFY_DISPATCH_ENDPOINT, 'POST', getDefaultHeader(), jsonBody);
    }
    
    /******************************************* Private methods *******************************************/
    private Map<string, string> getDefaultHeader() {
        Map<string, string> mapHeader = new Map<string, string>();
        mapHeader.put('Content-Type', 'application/json');
        
        if (string.isBlank(this.longLiveToken)) {
            List<sked__Admin_Setting__mdt> skedLongLiveTokens = [SELECT sked__Value__c 
                                                                 FROM sked__Admin_Setting__mdt 
                                                                 WHERE DeveloperName = 'Skedulo_API_Token'];
            for (sked__Admin_Setting__mdt skedLongLiveToken : skedLongLiveTokens) {
                if (skedLongLiveToken.sked__Value__c != NULL) {
                    this.longLiveToken = skedLongLiveToken.sked__Value__c;
                    break;
                }
            }
        }
        mapHeader.put('Authorization', 'Bearer ' + this.longLiveToken);
        return mapHeader;
    }

    /******************************************* Nested Classes *******************************************/
    public virtual class actionBase extends skedCalloutActionBase {
        public override skedCalloutResultBase processError(Type resultType, skedCalloutResultBase result, string response) {
            result = (skedCalloutResultBase)resultType.newInstance();
            ((skedSkeduloApiData.resultBase)result).error = (skedSkeduloApiData.error)Json.deserialize(response, skedSkeduloApiData.error.class);
            return result;
        }
    }

}