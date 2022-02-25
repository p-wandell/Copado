public with sharing class x7S_CommunityAssetsController {
    @AuraEnabled(cacheable=true)
    public static String getObjectAPIName(Id recordId) {
        return recordId.getSObjectType().getDescribe().getName();
    }
    @AuraEnabled(cacheable=true)
    public static x7S_AssetResponse getFieldLabels(List<String> assetFields, Boolean testThrowException) {
        x7S_AssetResponse assetResponse = new x7S_AssetResponse();
        // Get all of the fields on the object
        try{
            if(Test.isRunningTest() && testThrowException) {
                CalloutException testException = new CalloutException();
                testException.setMessage('This is a constructed exception for testing and code coverage');
                throw testException;
            }
            Map<String,Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Community_Asset__c').getDescribe().fields.getMap();
            for(String currentField : assetFields){
                assetResponse.labels.add(fieldMap.get(currentField) != null ? fieldMap.get(currentField).getDescribe().getLabel() : currentField);
            }
            assetResponse.success = true;
            System.debug(assetResponse);
        }catch (Exception e){
            assetResponse.success = false;
            assetResponse.messages.add(e.getMessage());
        }

        return assetResponse;
    }
    @AuraEnabled
    public static Peak_Response getAssets(String parentId, Boolean testThrowException) {
        Peak_Response peakResponse = new Peak_Response();
        // Get all of the fields on the object
        try{
            if(Test.isRunningTest() && testThrowException) {
                CalloutException testException = new CalloutException();
                testException.setMessage('This is a constructed exception for testing and code coverage');
                throw testException;
            }
            Set<String> fieldNames = Community_Asset__c.sObjectType.getDescribe().fields.getMap().keySet();
            // Build a Dynamic Query String.
            String soqlQuery = 'SELECT ' + String.join(new List<String>(fieldNames), ',') + ',Asset_Owner__r.Name FROM Community_Asset__c WHERE Project__r.Id =:parentId OR Client__r.Id =:parentId OR Related_Record__c =:parentId ORDER BY Order__c ASC, Name ASC NULLS LAST';
            peakResponse.success = true;
            peakResponse.results = Database.query(soqlQuery);
        }catch (Exception e){
            peakResponse.success = false;
            peakResponse.messages.add(e.getMessage());
        }
        System.debug('RESULTS ================= ' + peakResponse.results);
        return peakResponse;
    }
}