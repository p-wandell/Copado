/*
 * Copyright (c) 2020. 7Summits Inc.
 */


public with sharing class x7sAdventureMyModuleTaskWrapperHelper {


    public static x7sAdventureMyModuleTaskWrapper createWrapper(List<X7S_Adventure_Task__c> tasksList) {

        x7sAdventureMyModuleTaskWrapper stepModule = new x7sAdventureMyModuleTaskWrapper();

        Decimal NumberOfCompletedTasks = 0;
        Decimal totalTaskAssigned = 0;
        Decimal taskProgress = 0 ;
        Boolean ModuleCompleted = false;

        if (tasksList.size() > 0) {
            for (X7S_Adventure_Task__c myTask : tasksList) {
                totalTaskAssigned = totalTaskAssigned + 1;
                if (myTask.Completed__c == true) {
                    NumberOfCompletedTasks = NumberOfCompletedTasks + 1;
                }
            }
            taskProgress = (NumberOfCompletedTasks / totalTaskAssigned) * 100;
            if (tasksList.size() == NumberOfCompletedTasks) {
                ModuleCompleted = true;
            }
            stepModule.TaskProgress = taskProgress.setScale(0);
            stepModule.Completed = ModuleCompleted;
        }
        return stepModule;
    }
}