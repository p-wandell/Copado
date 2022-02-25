/**
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

public with sharing class x7sVideoController {
    // Packaging org field name

    // non packaging org field name
    private static final String LIST_FIELD_NAME = 'x7s_video_list__c';
    public static final String ERROR_MISSING_FIELDS = 'The Video List custom field, 7S Video List (x7s_video_list__c), has not yet been created for this object.';

    public static String AccountFieldName {
        get {
            if (String.isBlank(AccountFieldName)) {
                String nameSpacePrefix = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'x7sVideoController' LIMIT 1].NamespacePrefix;
                String nameSpace = String.isBlank(nameSpacePrefix) ? '' : nameSpacePrefix + '__';
                AccountFieldName = nameSpace + LIST_FIELD_NAME;
            }
            return AccountFieldName;
        }
        private set {AccountFieldName = value;}
    }

    /**
     * Get the video data from a record
     * @param recordId Target record Id
     *
     * @return x7sVideoResponse Response
     */
    @AuraEnabled
    public static x7sVideoResponse getInitialData(Id recordId) {
        x7sVideoResponse response = new x7sVideoResponse();

        //get the object Name and Field
        Schema.DescribeSObjectResult objDescribe = recordId.getSobjectType().getDescribe();

        String sObjName  = objDescribe.getName();
        String fieldName = sObjName == 'Account' ? AccountFieldName : LIST_FIELD_NAME;

        String queryString = 'select id,'
            + fieldName
            + ' FROM '
            + sObjName
            + ' Where id =: recordId';

        //check if field Video_List_7S__c exist on object or not
        if (objDescribe.fields.getMap().keySet().contains(fieldName)) {
            List<SObject> listOfResults = Database.query(String.escapeSingleQuotes(queryString));

            if (listOfResults != null && listOfResults.size() > 0) {
                String listOfVideoIds = (String) listOfResults[0].get(fieldName);
                if (!String.isEmpty(listOfVideoIds)) {
                    response.results.addAll(listOfVideoIds.split(','));
                }
                response.success = true;
            }
        } else {
            response.messages.add(ERROR_MISSING_FIELDS);
        }

        return response;
    }
}