/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureDocLinkTriggerHandler {
    public static void handleBeforeInsert(List<ContentDocumentLink> newList) {
        for (ContentDocumentLink contentLink : newList) {
            Schema.SObjectType sobjectType = contentLink.LinkedEntityId.getSobjectType();
            String sobjectName = sobjectType.getDescribe().getName();
            if (sobjectName == 'X7S_Adventure__c' || sobjectName == 'X7S_Adventure_Step__c' ||
                    sobjectName == 'X7S_Adventure_Task__c' || sobjectName == 'X7S_Adventure_Module__c') {
                contentLink.Visibility = 'AllUsers';
            }
        }
    }
}