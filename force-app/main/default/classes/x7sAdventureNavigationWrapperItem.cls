/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureNavigationWrapperItem {
    @AuraEnabled public String title;
    @AuraEnabled public String id;
    @AuraEnabled public Integer userRemainingTaskCount;
    @AuraEnabled public Double progress;

    public x7sAdventureNavigationWrapperItem(X7S_Adventure_Step__c step, Integer tasksRemaining, Double stepProgress) {
        title = step.Title__c;
        id = step.Id;
        userRemainingTaskCount = tasksRemaining;
        progress = stepProgress;
    }

    public x7sAdventureNavigationWrapperItem(X7S_Adventure_Module__c module, Integer tasksRemaining, Double stepProgress) {
        if (module != null) {
            title = module.Title__c;
            id = module.Id;
        }

        userRemainingTaskCount = tasksRemaining;
        progress = stepProgress;
    }

    //for test, delete later
    public x7sAdventureNavigationWrapperItem() {
        title = 'Just a test module';
        id = 'a043h000001V2WfAAK';
        userRemainingTaskCount = 1;
        progress = .50;
    }
}