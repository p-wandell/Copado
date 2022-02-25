/* Copyright ©2016-2018 7Summits Inc. All rights reserved. */

global with sharing class SVNSUMMITS_EventVolunteerWrapper {
    @AuraEnabled global Volunteer_Need__c volunteerNeed{get;set;}
    @AuraEnabled global Boolean currentUserRegistered{get;set;}
}