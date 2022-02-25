/*
 * Copyright (c) 2020. 7Summits Inc.
 */

/**
    Get a single record, returning a x7sExp Response
        results list = well, just the one record
        expResults list = fields with translated labels, passing through security!
 */
public with sharing class x7sExpRecordDetailController {

    @AuraEnabled
    public static x7sExpResponse getRecordDetail(String recordIdString, String objectType, String fieldsString) {
        x7sExpResponse expResponse = new x7sExpResponse();

        // Split incoming string after removing any white space
        fieldsString = fieldsString.replaceAll(' ', '');
        List<String> fields = fieldsString.split(',');

        // Build query string for this object, fields, and record ID
        String queryString = x7sExpRecordQueryHelper.buildQueryString(objectType, fields, x7sExpRecordQueryHelper.buildIdWhereClause(recordIdString));

        try {
            expResponse.results = x7sExpRecordQueryHelper.executeQuery(queryString);

            // If results are found (we did get the record detail), format fields with translated labels
            if (!x7sExpUtils.isNullOrEmpty(expResponse.results)) {
                expResponse.expResults = x7sExpRecordQueryHelper.formatRecordDetailWithLabels(objectType, expResponse.results[0], fields);
            }
        } catch (Exception e) {
            expResponse.success = false;
            expResponse.messages.add(e.getMessage());
        }
        return expResponse;
    }


}