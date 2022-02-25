/*
 * Copyright (c) 2020. 7Summits Inc.
 */

/**
 * Log Errors into a Custom Object
 */

public with sharing class x7sExpErrorLogger {

     public static void logError(Exception e) {
         if (!X7S_Error_Log__c.SObjectType.getDescribe().isCreateable()) {
             System.debug('logError() - unable to insert X7S_Error_Log__c object.');
             return;
         }

        // Set up new record
        X7S_Error_Log__c errorLog = new X7S_Error_Log__c();

        // Add properties
        errorLog.Type__c = e.getTypeName();
        errorLog.Message__c = e.getMessage();
        errorLog.Stack_Trace__c = e.getStackTraceString();

        // Insert
        insert errorLog;
    }
}