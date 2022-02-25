/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureStepModuleWrapper {

    @AuraEnabled public Id id { get; set; }
    @AuraEnabled public Id Adventure_Step_Id { get; set; }
    @AuraEnabled public String title { get; set; }
    @AuraEnabled public Integer order { get; set; }
    @AuraEnabled public String descriptionLabel { get; set; }
    @AuraEnabled public String descriptionLink { get; set; }
    @AuraEnabled public String tooltip { get; set; }
    @AuraEnabled public List<X7S_Adventure_Task__c> moduleTasks {
        get {
            if (moduleTasks == null) moduleTasks = new List<X7S_Adventure_Task__c>();
            return moduleTasks;
        }
        set;
    }
    @AuraEnabled public Double taskProgress { get; set; }
    @AuraEnabled public Boolean completedFlag { get; set; }
    @AuraEnabled public Boolean isLastTask { get; set; }
    @AuraEnabled public Boolean userTasksComplete { get; set; }
    @AuraEnabled public Boolean noUserTasks { get; set; }
    @AuraEnabled public Date nextModuleTaskDueDate { get; set; }
    @AuraEnabled public Id nextModuleTaskDueId { get; set; }
}