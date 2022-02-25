/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

public with sharing class x7sFacebookFeaturedController {

    @AuraEnabled
    public static String getMetaData(String recordLabel){
        System.debug(recordLabel);
        // No PMD for CMT
        X7S_Social_Component_Setting__mdt setting = [SELECT Facebook_Featured_Posts__c FROM X7S_Social_Component_Setting__mdt WHERE DeveloperName = :recordLabel]; //NOPMD
        return setting.Facebook_Featured_Posts__c;
    }
}