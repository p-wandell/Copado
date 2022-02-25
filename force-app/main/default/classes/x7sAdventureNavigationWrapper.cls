/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureNavigationWrapper {

    @AuraEnabled public X7S_Adventure__c adventure{get;set;}
    @AuraEnabled public X7S_Adventure_Step__c step{get;set;}
    @AuraEnabled public x7sAdventureNavigationWrapperItem next{get;set;}
    @AuraEnabled public x7sAdventureNavigationWrapperItem previous{get;set;}

    public x7sAdventureNavigationWrapper(X7S_Adventure__c adv, X7S_Adventure_Step__c advStep,
                                           x7sAdventureNavigationWrapperItem nextItem,
                                           x7sAdventureNavigationWrapperItem previousItem) {
        adventure = adv;
        step = advStep;
        next = nextItem;
        previous = previousItem;
    }
}