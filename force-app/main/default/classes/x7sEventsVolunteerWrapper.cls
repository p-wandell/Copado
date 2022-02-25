/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sEventsVolunteerWrapper {
    @AuraEnabled public X7S_Events_Volunteer_Need__c volunteerNeed{get;set;}
    @AuraEnabled public Boolean currentUserRegistered{get;set;}
}