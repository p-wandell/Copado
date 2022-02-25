/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureMyModuleTaskWrapper {
   
    @AuraEnabled public Decimal TaskProgress{get;set;}
    @AuraEnabled public Boolean Completed{get;set;}
        
}