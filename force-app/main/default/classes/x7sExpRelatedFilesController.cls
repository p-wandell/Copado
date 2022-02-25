/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpRelatedFilesController {

    /*
        Get attachments a User added to a Record
     */
    @AuraEnabled
    public static x7sExpResponse getFilesForCurrentUserForRecord(String recordIdString) {
        // Init response
        x7sExpResponse expResponse = new x7sExpResponse();

        // Call Helper
        expResponse = x7sExpFilesHelper.getFilesForCurrentUserForRecord(UserInfo.getUserId(), Id.valueOf(recordIdString));

        // Return
        return expResponse;
    }

}