/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureStepModuleWrapperHelper {

    public static x7sAdventureStepModuleWrapper createWrapper(X7S_Adventure_Module__c theStepModule, List<X7S_Adventure_Task__c> moduleTasks) {
        System.debug('Wrapping module tasks');
        System.debug(moduleTasks);

        x7sAdventureStepModuleWrapper stepModule = new x7sAdventureStepModuleWrapper();

        stepModule.id = theStepModule.Id;
        stepModule.Adventure_Step_Id = theStepModule.Adventure_Step__c;
        stepModule.title = theStepModule.Title__c;
        stepModule.moduleTasks = moduleTasks;
        stepModule.order = (Integer) theStepModule.Order__c;
        stepModule.descriptionLabel = theStepModule.Description_Label__c;
        stepModule.descriptionLink = theStepModule.Description_URL__c;
        stepModule.tooltip = theStepModule.Tooltip_Description__c;
        //Module progress
        //stepModule.taskProgress = theStepModule.Task_Progress__c.setScale(0);
        stepModule.completedFlag = theStepModule.Completed__c;
        stepModule.noUserTasks = false;

        for (X7S_Adventure_Task__c each : moduleTasks) {
            if (stepModule.nextModuleTaskDueDate != null && (each.Task_Due_Date__c < stepModule.nextModuleTaskDueDate)) {
                stepModule.nextModuleTaskDueDate = each.Task_Due_Date__c;
                stepModule.nextModuleTaskDueId = each.Id;
            } else if (stepModule.nextModuleTaskDueDate == null) {
                stepModule.nextModuleTaskDueDate = each.Task_Due_Date__c;
                stepModule.nextModuleTaskDueId = each.Id;
            }
        }
        //Need this line to manage  null value for taskProgress
        Decimal taskProgress = 0 ;
        if (moduleTasks.size() > 0) {
            stepModule.taskProgress = theStepModule.Task_Progress__c.setScale(0);
        } else {
            stepModule.taskProgress = taskProgress.setScale(0);
        }

        return stepModule;
    }

}