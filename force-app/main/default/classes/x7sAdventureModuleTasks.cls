/*
 * Copyright (c) 2020. 7Summits Inc.
 */


public with sharing class x7sAdventureModuleTasks {
    // on 2/06/2020: Task complete/not complete action method (Checkbox action)
    @AuraEnabled
    public static Boolean taskCompleted(Id selectedTaskId, Boolean checkboxFlag) {
        Boolean flagStatus = null;

        if (Schema.SObjectType.X7S_Adventure_Task__c.updateable &&
                Schema.SObjectType.X7S_Adventure_Task__c.fields.Completed__c.isUpdateable()) {
            try {
                if (selectedTaskId != null) {
                    List<X7S_Adventure_Task__c> taskSelectedList = new List<X7S_Adventure_Task__c>([SELECT Id,Completed__c FROM X7S_Adventure_Task__c WHERE Id = :selectedTaskId WITH SECURITY_ENFORCED LIMIT 1]);
                    List<X7S_Adventure_Task__c> updatedTaskList = new List<X7S_Adventure_Task__c>();
                    if (taskSelectedList.size() > 0) {
                        for (X7S_Adventure_Task__c taskRecord : taskSelectedList) {
                            taskRecord.Completed__c = checkboxFlag;
                            updatedTaskList.add(taskRecord);
                        }
                        if (updatedTaskList.size() > 0) {
                            x7sAdventureUtils.throwErrorIfUpdatePermissionMissing(Schema.SObjectType.X7S_Adventure_Task__c);
                            update updatedTaskList; // NOPMD - CRUD permissions validated in previous line

                            flagStatus = checkboxFlag;
                        }
                    }
                }
            } catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            }
        }
        return flagStatus;
    }

    // 19-02-2020 : Module Task Progress (Progress Ring)
    @AuraEnabled
    public static X7S_Adventure_Module__c getModuleTaskProgress(String moduleId) {
        try {
            X7S_Adventure_Module__c queryResult;

            if (moduleId != null) {
                X7S_Adventure_Module__c updatedTaskProgress = [SELECT Number_of_Tasks__c, Task_Progress__c, Completed__c FROM X7S_Adventure_Module__c WHERE Id = :moduleId WITH SECURITY_ENFORCED LIMIT 1];
                queryResult = updatedTaskProgress;
            }
            return queryResult;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    // 26-02-2020 : My Module Task Progress "Filtered tasks" (Progress Ring)
    @AuraEnabled
    public static x7sAdventureMyModuleTaskWrapper getMyModuleTaskProgress(String moduleId, Id ownerId) {
        try {
            x7sAdventureMyModuleTaskWrapper myModule;

            if (moduleId != null && ownerId != null) {

                List<X7S_Adventure_Task__c> tasksList = [SELECT Id,Completed__c FROM X7S_Adventure_Task__c WHERE Adventure_Module__c = :moduleId AND Owner__c = :ownerId WITH SECURITY_ENFORCED];
                myModule = x7sAdventureMyModuleTaskWrapperHelper.createWrapper(tasksList);
            }

            return myModule;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    // 26-02-2020 : My Adventure Progress after "Filtered tasks"
    @AuraEnabled
    public static x7sAdventureMyProgress getMyAdventureProgress(Id adventureId, Id ownerId) {
        try {
            x7sAdventureMyProgress myAdventureProgress = new x7sAdventureMyProgress();
            Integer totalTasks = 0;
            Integer totalCompleteTasks = 0;
            Decimal adventureProgress = 0;
            List<Id> myStepIdList = new List<Id>();
            List<Id> myModuleIdList = new List<Id>();

            if (ownerId != null && adventureId != null) {
                List<X7S_Adventure_Step__c> myAdventure = new List<X7S_Adventure_Step__c>([SELECT Id FROM X7S_Adventure_Step__c WHERE Adventure__c = :adventureId]);

                if (myAdventure.size() > 0) {
                    for (X7S_Adventure_Step__c adve : myAdventure) {
                        myStepIdList.add(adve.Id);
                    }

                    String stepMyModuleQuery = 'SELECT Id FROM X7S_Adventure_Module__c WHERE Adventure_Step__c IN: myStepIdList';
                    List<X7S_Adventure_Module__c> stepModules = Database.query(stepMyModuleQuery);

                    for (X7S_Adventure_Module__c moduleId : stepModules) {
                        myModuleIdList.add(moduleId.Id);
                    }
                    //String 	taskSummary = 'SELECT id,Completed__c FROM X7S_Adventure_Task__c WHERE Adventure_Module__c IN: myModuleIdList AND Owner__c =:OwnerId';

                    String totalTaskSummary = 'SELECT count() FROM X7S_Adventure_Task__c WHERE Adventure_Module__c IN: myModuleIdList AND Owner__c =:ownerId';
                    totalTasks = Database.countQuery(totalTaskSummary);

                    String totalCompleteTaskSummary = 'SELECT count() FROM X7S_Adventure_Task__c WHERE Adventure_Module__c IN: myModuleIdList AND Owner__c =:ownerId AND Completed__c =true';
                    totalCompleteTasks = Database.countQuery(totalCompleteTaskSummary);

                    myAdventureProgress.totalTasksAssigned = totalTasks;
                    myAdventureProgress.totalCompletedTasks = totalCompleteTasks;

                    if (totalTasks > 0) {
                        adventureProgress = (Decimal.valueOf(totalCompleteTasks) / Decimal.valueOf(totalTasks)) * 100;
                    }
                    myAdventureProgress.adventureProgress = adventureProgress.setScale(0);
                }
            }
            return myAdventureProgress;
        } catch (Exception ex) {
            System.debug('Error Line: ' + ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static x7sAdventureMyProgress getAdventureProgress(Id adventureId) {
        try {
            x7sAdventureMyProgress myAdventureProgress = new x7sAdventureMyProgress();
            Integer totalTasks = 0;
            Integer totalCompleteTasks = 0;
            Decimal adventureProgress = 0;

            if (adventureId != null) {
                String getAdventure = 'SELECT Id,Number_of_Completed_Tasks__c,Task_Progress__c,Number_of_Tasks__c From X7S_Adventure__c  WHERE Id =:adventureId LIMIT 1';
                X7S_Adventure__c myAllAdventure = Database.query(getAdventure);

                if (myAllAdventure != null) {
                    totalTasks = Integer.valueOf(myAllAdventure.Number_of_Tasks__c) ;
                    totalCompleteTasks = Integer.valueOf(myAllAdventure.Number_of_Completed_Tasks__c);
                    adventureProgress = myAllAdventure.Task_Progress__c;
                }
                myAdventureProgress.totalTasksAssigned = totalTasks;
                myAdventureProgress.totalCompletedTasks = totalCompleteTasks;
                myAdventureProgress.adventureProgress = adventureProgress.setScale(0);
            }

            return myAdventureProgress;

        } catch (Exception ex) {
            System.debug('Error Line: ' + ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }
}