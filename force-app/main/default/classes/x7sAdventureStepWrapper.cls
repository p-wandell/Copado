/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureStepWrapper {

    @AuraEnabled public Id id { get; set; }
    @AuraEnabled public String stepName { get; set; }
    @AuraEnabled public String title { get; set; }
    @AuraEnabled public String subtitle { get; set; }
    @AuraEnabled public String description { get; set; }
    @AuraEnabled public Decimal order { get; set; }
    @AuraEnabled public List<ContentDocumentLink> contentDocumentLinks { get; set; }
    @AuraEnabled public List<x7sAdventureStepModuleWrapper> stepModuleWrapperList {
        get {
            if (stepModuleWrapperList == null) stepModuleWrapperList = new List<x7sAdventureStepModuleWrapper>();
            return stepModuleWrapperList;
        }
        set;
    }
    @AuraEnabled public Integer userRemainingTaskCount { get; set; }
    @AuraEnabled public Double moduleProgress { get; set; }
    @AuraEnabled public Double taskProgress { get; set; }

}