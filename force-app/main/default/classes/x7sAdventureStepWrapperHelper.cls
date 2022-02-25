/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureStepWrapperHelper {

    public static x7sAdventureStepWrapper createWrapper(X7S_Adventure_Step__c theStep, List<x7sAdventureStepModuleWrapper> theStepModuleList, String currentUserId) {

        x7sAdventureStepWrapper stepWrapper = new x7sAdventureStepWrapper();

        stepWrapper.id = theStep.Id;
        stepWrapper.stepName = theStep.Title__c;
        stepWrapper.title = theStep.Title__c;
        stepWrapper.subtitle = theStep.Subtitle__c;
        stepWrapper.description = theStep.Description__c;

        stepWrapper.order = theStep.Order__c;
        stepWrapper.contentDocumentLinks = theStep.ContentDocumentLinks;
        stepWrapper.moduleProgress = theStep.Module_Progress__c;
        stepWrapper.taskProgress = theStep.Task_Progress__c;
        stepWrapper.stepModuleWrapperList = theStepModuleList;
        stepWrapper.userRemainingTaskCount = calculateRemainingTasksForUser(theStepModuleList, currentUserId);

        return stepWrapper;
    }

    /**
     * Iterates through all tasks of each module and calculates total remaining for the current user.
     *
     * @return number of remaining steps for user.
     */
    private static Integer calculateRemainingTasksForUser(List<x7sAdventureStepModuleWrapper> theStepModuleList, String currentUserId) {
        Integer remainingStepTasksForUser = 0;

        if (theStepModuleList != null) {
            for (x7sAdventureStepModuleWrapper eachModule : theStepModuleList) {
                if (eachModule.moduleTasks != null) {
                    for (X7S_Adventure_Task__c eachTask : eachModule.moduleTasks) {
                        Integer totalModuleTasksForUser = 0;
                        Integer completedModuleTasksForUser = 0;
                        Integer remainingModuleTasksForUser = 0;

                        if (eachTask.Owner__c == currentUserId) {
                            totalModuleTasksForUser += 1;

                            if (eachTask.Completed__c) completedModuleTasksForUser += 1;
                            remainingModuleTasksForUser = totalModuleTasksForUser - completedModuleTasksForUser;
                        }

                        remainingStepTasksForUser += remainingModuleTasksForUser;
                    }
                }
            }
        }

        return remainingStepTasksForUser;
    }
}