/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sLinkedInFeaturedController {
    @AuraEnabled
    public static String getMetaData(String recordLabel){
        System.debug(recordLabel);

        X7S_Social_Component_Setting__mdt setting = [SELECT LinkedIn_Featured_Posts__c FROM X7S_Social_Component_Setting__mdt WHERE DeveloperName = :recordLabel]; //NOPMD

        return setting.LinkedIn_Featured_Posts__c;
    }
}