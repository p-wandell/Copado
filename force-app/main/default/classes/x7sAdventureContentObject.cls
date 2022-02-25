/*
 * Copyright (c) 2020. 7Summits Inc.
 */
public with sharing class x7sAdventureContentObject
{

    @AuraEnabled public X7S_Adventure__c adventure{get;set;}
    @AuraEnabled public List<x7sAdventureStepWrapper> adventureStepWrapper{get;set;}
    @AuraEnabled public Map<String,String> topics{get;set;}
    @AuraEnabled public String ownerSmallPhotoURL{get;set;}
}