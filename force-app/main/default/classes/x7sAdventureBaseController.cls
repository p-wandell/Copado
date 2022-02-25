/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureBaseController {

    public class x7sAdventureException extends Exception {
    }

    // Current community ID
    private static Id communityId {
        get {
            return System.Network.getNetworkId();
        }
    }

    @AuraEnabled
    public static x7sAdventureResponse getAdventure(String recordId, String objectName, Boolean byOwnerId, String setupName) {

        String ownerId;
        String adventureId;

        if (byOwnerId) {
            ownerId = UserInfo.getUserId();
        }

        x7sAdventureResponse response = new x7sAdventureResponse();
        X7S_Adventure_Setting__mdt defaultSetup = new X7S_Adventure_Setting__mdt();
        x7sAdventureMyProgress myAdventureProgress = new x7sAdventureMyProgress();
        List<X7S_Adventure__c> theAdventures = new List<X7S_Adventure__c>();
        List<X7S_Adventure_Step__c> adventureSteps = new List<X7S_Adventure_Step__c>();
        Map<Id, List<x7sAdventureStepModuleWrapper>> stepModuleMap = new Map<Id, List<x7sAdventureStepModuleWrapper>>();
        List<x7sAdventureStepWrapper> stepWrapperList = new List<x7sAdventureStepWrapper>();

        try {
            if (objectName == 'X7S_Adventure__c') {
                adventureId = getAdventureId(recordId);

                theAdventures = queryAdventures(adventureId);

                if (ownerId != null && !String.isBlank(ownerId)) {
                    myAdventureProgress = getMyAdventureProgress(adventureId, ownerId);
                }

            } else {
                adventureId = recordId;
            }

            adventureSteps = queryAdventureSteps(adventureId, objectName);

            System.debug('Adventure Steps: ' + adventureSteps);

            if (!x7sAdventureUtils.isNullOrEmpty(adventureSteps)) {

                stepModuleMap = mapRelatedStepModules(adventureSteps, byOwnerId, adventureId, objectName);
                String currentUser = UserInfo.getUserId();

                //For each Adventure step, create a wrapper using fields from query and map values for step modules and module tasks
                for (X7S_Adventure_Step__c theStep : adventureSteps) {
                    if (theStep != null) {
                        x7sAdventureStepWrapper stepWrapper = x7sAdventureStepWrapperHelper.createWrapper(theStep, stepModuleMap.get(theStep.Id), currentUser);
                        stepWrapperList.add(stepWrapper);
                        System.debug('Step Wrapper: ' + stepWrapper);
                    }
                }
            }

            if (setupName != null && !String.isBlank(setupName)) {
                defaultSetup = getConfiguration(setupName);
            }

            //Create Content Object to return Adventure, Adventure_Steps, Step_Modules, Module_Tasks and Topics
            x7sAdventureContentObject contentObject;
            if (objectName == 'X7S_Adventure__c') {

                //Get Topics related to Adventure if Feed Tracking is enabled
                Map<String, String> topics = new Map<String, String>();
                Schema.SObjectType objInfo = Schema.getGlobalDescribe().get('X7S_Adventure__c');
                Schema.DescribeSobjectResult objResult = objInfo.getDescribe();

                if (objResult.isFeedEnabled()) {
                    String topicQuery = 'SELECT Id,EntityId,Topic.Id,Topic.Name FROM TopicAssignment WHERE EntityId = :adventureId';
                    topicQuery += communityId != null ? ' AND NetworkId = :communityId' : ' AND NetworkId = null';

                    List<TopicAssignment> assignments = Database.query(String.escapeSingleQuotes(topicQuery));
                    for (TopicAssignment topicAssign : assignments) {
                        topics.put(topicAssign.Topic.Id, topicAssign.Topic.Name);
                    }
                }
                contentObject = x7sAdventureContentObjectHelper.formatContentObject(theAdventures[0], stepWrapperList, topics);
            } else {
                contentObject = x7sAdventureContentObjectHelper.formatContentObject(null, stepWrapperList, null);
            }

            response.adventureResults.add(contentObject);
            response.success = true;
            response.globalSetting = defaultSetup;
            response.adventureProgress = myAdventureProgress;
        } catch (Exception e) {
            response.success = false; response.messages.add(e.getMessage());
            System.debug('getAdventure Error Message: ' + e.getMessage() + ' , Error Line Number: ' + e.getLineNumber());
            System.debug('Stack trace: ' + e.getStackTraceString());
        }

        return response;
    }

    private static String getAdventureId(String recordId) {
        String adventureId;

        if (String.isNotBlank(recordId)) {
            Id recordIdValue = Id.valueOf(String.escapeSingleQuotes(String.valueOf(recordId)));

            if (recordIdValue != null) {
                String recordType = String.valueOf(recordIdValue.getSobjectType());

                if (recordIdValue.getSobjectType() == X7S_Adventure__c.SObjectType) {
                    // If the id is already an X7S_Adventure__c type record, we are done.
                    return recordId;
                }

                String query = 'SELECT Id, X7S_Adventure_Id__c FROM ' + String.escapeSingleQuotes(recordType) + ' WHERE Id = :recordIdValue LIMIT 1';
                SObject record = (SObject) Database.query(query);

                if (record != null) {
                    adventureId = (String) record.get('X7S_Adventure_Id__c');
                }
            }
        }

        if (String.isBlank(adventureId)) {
            throw new x7sAdventureException('Adventure not found.');
        }

        return adventureId;
    }

    private static List<X7S_Adventure__c> queryAdventures(String adventureId) {
        String adventureQuery =
                'SELECT Id, Name, Owner.Name, Source_Template__r.Name, Start_Date__c, title__c, Subtitle__c, Description__c, Show_Checkboxes__c,Task_Progress__c,Number_of_Tasks__c,Number_of_Completed_Tasks__c, ' +
                        '(SELECT Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId, ContentDocument.title, ContentDocument.FileExtension ' +
                        'FROM ContentDocumentLinks) ' +
                        'FROM X7S_Adventure__c WHERE Id =: adventureId';

        return Database.query(String.escapeSingleQuotes(adventureQuery));
    }

    private static List<X7S_Adventure_Step__c> queryAdventureSteps(String adventureId, String objectName) {
        String adventureStepQuery = 'SELECT Id, Name, Module_Progress__c, Task_Progress__c, title__c, subtitle__c, Order__c, description__c, (SELECT Id, ContentDocumentId, ' +
                'ContentDocument.LatestPublishedVersionId, ContentDocument.title, ContentDocument.FileExtension ' +
                'FROM ContentDocumentLinks) FROM X7S_Adventure_Step__c' ;

        if (objectName == 'X7S_Adventure__c') {
            adventureStepQuery += ' WHERE Adventure__r.Id =: adventureId ORDER BY Order__c';
        } else if (objectName == 'X7S_Adventure_Step__c') {
            adventureStepQuery += ' WHERE Id =: adventureId';
        } else if (objectName == 'X7S_Adventure_Module__c') {
            adventureStepQuery += ' WHERE Id in (SELECT Adventure_Step__c FROM X7S_Adventure_Module__c WHERE Id =: adventureId)';
        }

        return Database.query(String.escapeSingleQuotes(adventureStepQuery));
    }

    /* Method to Map Adventure_Step Id's to their related Step Modules */
    @AuraEnabled
    public static Map<Id, List<x7sAdventureStepModuleWrapper>> mapRelatedStepModules(List<X7S_Adventure_Step__c> adventureSteps, Boolean byOwnerId, String recordId, String objectName) {
        Id ownerId;
        if (byOwnerId) ownerId = UserInfo.getUserId();

        Map<Id, List<x7sAdventureStepModuleWrapper>> adventureStepModuleWrapperMap = new Map<Id, List<x7sAdventureStepModuleWrapper>>();

        String moduleTaskQuery = 'SELECT Id, Task_Content__c, Title__c, Name, Task_Due_Date__c, Content_URL__c, Icon_Name__c, Adventure_Module__c, isNew__c,Completed__c,Owner__c, Owner__r.SmallPhotoUrl, Restrict_to_User__c, (SELECT Id, ContentDocumentId, ' +
                'ContentDocument.LatestPublishedVersionId, ContentDocument.title, ContentDocument.FileExtension ' +
                'FROM ContentDocumentLinks), (select Id, Text_Display__c, Response_Input__c from Adventure_Subtasks__r) FROM X7S_Adventure_Task__c WHERE Adventure_Module__c IN: stepModuleIds';

        //Get a list of Adventure Step Ids
        List<String> adventureStepIds = new List<String>();
        for (X7S_Adventure_Step__c theAdventureStep : adventureSteps) {
            adventureStepIds.add(theAdventureStep.Id);
        }

        //If this is an adventure or step we need all of them. If this is a module we only need that specific Id
        String stepModuleQuery = 'SELECT Id, Name, Adventure_Step__c, Title__c, Order__c, Tooltip_Description__c, Description_URL__c, Description_Label__c, Task_Progress__c, Completed__c FROM X7S_Adventure_Module__c WHERE Adventure_Step__c IN: adventureStepIds';
        if (objectName.toLowerCase() == 'X7S_Adventure_Module__c'.toLowerCase()) {
            stepModuleQuery += ' and Id =: recordId ORDER BY Order__c';
        } else {
            stepModuleQuery += ' ORDER BY Order__c';
        }
        // Filter My Task

        if (byOwnerId == true) {
            System.debug('By ownerId');
            System.debug(byOwnerId);
            moduleTaskQuery += ' AND Owner__c =: ownerId ORDER BY Order__c ';
        } else {

            moduleTaskQuery += ' ORDER BY Order__c';
        }

        if (!x7sAdventureUtils.isNullOrEmpty(adventureStepIds)) {
            try {
                System.debug('moduleTask Query');
                System.debug(moduleTaskQuery);

                //Query Step Modules and Module Tasks
                List<X7S_Adventure_Module__c> stepModules = Database.query(stepModuleQuery);
                Set<Id> stepModuleIds = (new Map<Id, SObject>(stepModules)).keySet();
                List<X7S_Adventure_Task__c> moduleTasks = Database.query(String.escapeSingleQuotes(moduleTaskQuery));

                //Create a Map of Step Modules and related Module Tasks
                Map<Id, List<X7S_Adventure_Task__c>> stepTaskMap = new Map<Id, List<X7S_Adventure_Task__c>>();

                for (X7S_Adventure_Task__c theModuleTask : moduleTasks) {

                    if (!stepTaskMap.containsKey(theModuleTask.Adventure_Module__c)) {
                        List<X7S_Adventure_Task__c> moduleTaskList = new List<X7S_Adventure_Task__c>();
                        moduleTaskList.add(theModuleTask);
                        stepTaskMap.put(theModuleTask.Adventure_Module__c, moduleTaskList);
                    } else {
                        stepTaskMap.get(theModuleTask.Adventure_Module__c).add(theModuleTask);
                    }
                }

                //Wrap the Step Modules with their related Module Tasks
                //Checking the filter is option
                List<x7sAdventureStepModuleWrapper> moduleWrappers = new List<x7sAdventureStepModuleWrapper>();
                if (!String.isBlank(ownerId)) {
                    //My Module tasks only
                    for (X7S_Adventure_Module__c theStepModule : stepModules) {
                        if (theStepModule != null) {
                            if (stepTaskMap.containsKey(theStepModule.Id)) {
                                moduleWrappers.add(x7sAdventureMyStepModuleWrapperHelper.createWrapper(theStepModule, stepTaskMap.get(theStepModule.Id)));
                            } else {
                                moduleWrappers.add(x7sAdventureMyStepModuleWrapperHelper.createWrapper(theStepModule, new List<X7S_Adventure_Task__c>()));
                            }
                        }
                    }
                } else {
                    //All Module tasks
                    for (X7S_Adventure_Module__c theStepModule : stepModules) {
                        if (theStepModule != null) {
                            if (stepTaskMap.containsKey(theStepModule.Id)) {
                                moduleWrappers.add(x7sAdventureStepModuleWrapperHelper.createWrapper(theStepModule, stepTaskMap.get(theStepModule.Id)));
                            } else {
                                moduleWrappers.add(x7sAdventureStepModuleWrapperHelper.createWrapper(theStepModule, new List<X7S_Adventure_Task__c>()));
                            }

                        }
                    }
                }

                //Build the Map <Adventure ID, List of Step Modules>
                for (x7sAdventureStepModuleWrapper theWrapper : moduleWrappers) {

                    //If the Map doesn't yet have the Key
                    if (!adventureStepModuleWrapperMap.containsKey(theWrapper.Adventure_Step_Id)) {

                        //Create the Step Module Wrapper List
                        List<x7sAdventureStepModuleWrapper> newValueList = new List<x7sAdventureStepModuleWrapper>();
                        newValueList.add(theWrapper);

                        //and Map it to the Adventure Step Id
                        adventureStepModuleWrapperMap.put(theWrapper.Adventure_Step_Id, newValueList);

                        //If Map does contain the key, add the value
                    } else {
                        adventureStepModuleWrapperMap.get(theWrapper.Adventure_Step_Id).add(theWrapper);
                    }
                }

            } catch (Exception e) {
                System.debug('mapRelatedStepModules Error Message: ' + e.getMessage() + ' , Error Line Number: ' + e.getLineNumber());
                System.debug('ERROR ==' + e.getMessage());
            }
        }
        System.debug('adventureStepModuleWrapperMap');
        System.debug(adventureStepModuleWrapperMap);
        System.debug(JSON.serialize(adventureStepModuleWrapperMap));
        return adventureStepModuleWrapperMap;
    }

    //adventure default configuration
    @AuraEnabled
    public static X7S_Adventure_Setting__mdt getConfiguration(String metadataName) {

        try {
            X7S_Adventure_Setting__mdt adventureSetupList = [//NOPMD
                    SELECT Enable_Checkbox_Display__c,Enable_New_Task_Flag__c,No_Assigned_Tasks_Text__c
                            ,Override_Action_Color__c,Override_Link_Color__c,Task_Completion_Checked_Text__c,Task_Completion_Unchecked_Text__c,
                            Tasks_Completed_Text__c,No_Module_Tasks__c
                    FROM X7S_Adventure_Setting__mdt
                    WHERE DeveloperName = :metadataName
                    LIMIT 1
            ];

            return adventureSetupList;
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    @AuraEnabled
    public static x7sAdventureMyProgress getMyAdventureProgress(Id adventureId, String ownerId) {

        try {
            x7sAdventureMyProgress myAdventureProgress = new x7sAdventureMyProgress();
            Integer totalTasks = 0;
            Integer totalCompleteTasks = 0;
            Decimal adventureProgress = 0;
            List<Id> myStepIdList = new List<Id>();
            List<Id> myModuleIdList = new List<Id>();

            List<X7S_Adventure_Step__c> myAdventure = new List<X7S_Adventure_Step__c>([SELECT Id FROM X7S_Adventure_Step__c WHERE Adventure__c = :adventureId]);

            if (myAdventure.size() > 0) {

                for (X7S_Adventure_Step__c adventureStep : myAdventure) {
                    myStepIdList.add(adventureStep.Id);
                }

                String stepMyModuleQuery = 'SELECT Id FROM X7S_Adventure_Module__c WHERE Adventure_Step__c IN: myStepIdList';

                List<X7S_Adventure_Module__c> stepModules = Database.query(stepMyModuleQuery);

                for (X7S_Adventure_Module__c moduleId : stepModules) {
                    myModuleIdList.add(moduleId.Id);
                }
                //String 	taskSummary = 'SELECT id,Completed__c FROM X7S_Adventure_Task__c WHERE Adventure_Module__c IN: myModuleIdList AND Owner__c =:ownerId';

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

            return myAdventureProgress;

        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
     * Takes a recordId from a step or module and returns all breadcrumb information, including
     * Adventure Id & title, next and previous step or module, as well as tasks remaining and
     * completion percentage.
     *
     * @param recordId target record id
     * @param recordType target record type
     *
     * @return Adventure wrapper
     */
    @AuraEnabled(Cacheable=true)
    public static x7sAdventureNavigationWrapper getAdventureNavigation(String recordId, String recordType) {
        X7S_Adventure__c adventure = getParentAdventure(recordId, recordType);
        Map<String, X7S_Adventure_Step__c> steps = getApplicableSteps(recordId, recordType, adventure.Id);
        Map<Id, List<X7S_Adventure_Module__c>> modulesByStepId = getApplicableModules(steps.values());

        x7sAdventureNavigationWrapperItem previous;
        x7sAdventureNavigationWrapperItem next;
        X7S_Adventure_Step__c adventureStep;

        if (recordType == 'X7S_Adventure_Step__c') {
            if (steps.get('previous') != null) {
                previous = calculateTasksForStep(modulesByStepId.get(steps.get('previous').Id), steps.get('previous'));
            }
            if (steps.get('next') != null) {
                next = calculateTasksForStep(modulesByStepId.get(steps.get('next').Id), steps.get('next'));
            }
        } else if (recordType == 'X7S_Adventure_Module__c') {
            adventureStep = steps.get('current');
            Map<String, X7S_Adventure_Module__c> modules = getPreviousAndNextModules(modulesByStepId.get(steps.get('current').Id), recordId);
            previous = calculateTasksForModule(modules.get('previous'));
            next = calculateTasksForModule(modules.get('next'));
        }

        return new x7sAdventureNavigationWrapper(adventure, adventureStep, next, previous);
    }

    /**
     * Gets the Adventure that the step or module is a part of. Need Id and Title.
     *
     * @param recordId target record id
     * @param recordType target record type
     *
     * @return Adventure
     */
    private static X7S_Adventure__c getParentAdventure(String recordId, String recordType) {
        X7S_Adventure__c adventure = new X7S_Adventure__c();

        if (recordType == 'X7S_Adventure_Step__c') {
            X7S_Adventure_Step__c step = [SELECT Id, Adventure__c, Adventure__r.Title__c, Adventure__r.Show_Checkboxes__c FROM X7S_Adventure_Step__c WHERE Id = :recordId WITH SECURITY_ENFORCED];
            adventure.Id = step.Adventure__c;
            adventure.Title__c = step.Adventure__r.Title__c;
            adventure.Show_Checkboxes__c = step.Adventure__r.Show_Checkboxes__c;
        } else if (recordType == 'X7S_Adventure_Module__c') {
            X7S_Adventure_Module__c module = [SELECT Id, Adventure_Step__r.Adventure__c, Adventure_Step__r.Adventure__r.Title__c, Adventure_Step__r.Adventure__r.Show_Checkboxes__c FROM X7S_Adventure_Module__c WHERE Id = :recordId WITH SECURITY_ENFORCED];
            adventure.Id = module.Adventure_Step__r.Adventure__c;
            adventure.Title__c = module.Adventure_Step__r.Adventure__r.Title__c;
            adventure.Show_Checkboxes__c = module.Adventure_Step__r.Adventure__r.Show_Checkboxes__c;
        }

        return adventure;
    }

    /**
     * Gets steps that need to be return. If recordType is X7S_Adventure_Step__c, we need the previous and next steps
     * If this is a X7S_Adventure_Module__c we only need the parent step.
     *
     * @param recordId target record if
     * @param recordType target record type
     * @param adventureId target adventure
     *
     * @return Adventure step map
     */
    private static Map<String, X7S_Adventure_Step__c> getApplicableSteps(String recordId, String recordType, String adventureId) {
        Map<String, X7S_Adventure_Step__c> steps = new Map<String, X7S_Adventure_Step__c>();

        if (recordType == 'X7S_Adventure_Step__c') {
            List<X7S_Adventure_Step__c> siblingSteps = [SELECT Id, Title__c, Order__c FROM X7S_Adventure_Step__c WHERE Adventure__c = :adventureId WITH SECURITY_ENFORCED];
            steps = filterForPreviousAndNext(siblingSteps, recordId);
        } else if (recordType == 'X7S_Adventure_Module__c') {
            X7S_Adventure_Step__c currentStep = [SELECT Id, Title__c, Order__c FROM X7S_Adventure_Step__c WHERE Id IN (SELECT Adventure_Step__c FROM X7S_Adventure_Module__c WHERE Id = :recordId) WITH SECURITY_ENFORCED];
            steps.put('current', currentStep);
        }

        return steps;
    }


    /**
     * Filters for the current, previous, and next steps
     *
     * @param steps List of steps
     * @param currentStepId current step
     *
     * @return Adventure step map
     */
    private static Map<String, X7S_Adventure_Step__c> filterForPreviousAndNext(List<X7S_Adventure_Step__c> steps, String currentStepId) {
        Map<Id, X7S_Adventure_Step__c> adventureStepMap = new Map<Id, X7S_Adventure_Step__c>(steps);
        X7S_Adventure_Step__c currentStep = adventureStepMap.get(currentStepId);
        Decimal placeInOrder = currentStep.Order__c;

        Map<String, X7S_Adventure_Step__c> applicableSteps = new Map<String, X7S_Adventure_Step__c>();
        applicableSteps.put('current', currentStep);

        for (X7S_Adventure_Step__c each : steps) {
            if (each.Order__c == (placeInOrder + 1)) {
                applicableSteps.put('next', each);
            } else if (each.Order__c == (placeInOrder - 1)) {
                applicableSteps.put('previous', each);
            }
        }
        return applicableSteps;
    }

    /**
     * Gets all modules that belong to the given steps AND have tasks that are owned by the current user
     *
     * @param steps step list
     *
     * @return Step module map
     */
    private static Map<Id, List<X7S_Adventure_Module__c>> getApplicableModules(List<X7S_Adventure_Step__c> steps) {
        String currentUser = UserInfo.getUserId();
        Set<Id> stepIds = (new Map<Id, SObject>(steps)).keySet();

        List<X7S_Adventure_Module__c> applicableModulesAndTasks = [SELECT Id, Title__c, Order__c, Adventure_Step__c, (SELECT Id, Completed__c, Order__c, Task_Due_Date__c FROM X7S_Adventure_Modules__r WHERE Owner__c = :currentUser) FROM X7S_Adventure_Module__c WHERE Adventure_Step__c IN :stepIds WITH SECURITY_ENFORCED];

        Map<Id, List<X7S_Adventure_Module__c>> modulesByStepId = new Map<Id, List<X7S_Adventure_Module__c>>();
        for (X7S_Adventure_Module__c each : applicableModulesAndTasks) {
            if (modulesByStepId.containsKey(each.Adventure_Step__c)) {
                modulesByStepId.get(each.Adventure_Step__c).add(each);
            } else {
                modulesByStepId.put(each.Adventure_Step__c, new List<X7S_Adventure_Module__c>{
                        each
                });
            }
        }
        return modulesByStepId;
    }

    /**
     * Calculates how many tasks are completed and what percentage of progress that is for a step.
     *
     * @param modules module list
     * @param step target step
     *
     * @return Adventure wrapper
     */
    private static x7sAdventureNavigationWrapperItem calculateTasksForStep(List<X7S_Adventure_Module__c> modules, X7S_Adventure_Step__c step) {
        Integer tasksRemainingStep = 0;
        Integer totalTasksStep = 0;

        for (X7S_Adventure_Module__c eachModule : modules) {
            for (X7S_Adventure_Task__c eachTask : eachModule.X7S_Adventure_Modules__r) {
                if (!eachTask.Completed__c) {
                    tasksRemainingStep++;
                }
                totalTasksStep++;
            }
        }

        Double stepProgress = 0;

        if (tasksRemainingStep != 0) stepProgress = totalTasksStep / tasksRemainingStep;

        return new x7sAdventureNavigationWrapperItem(step, tasksRemainingStep, stepProgress);
    }

    /**
     * Gets the previous and next modules in the order from a list of modules.
     *
     * @param modules
     * @param currentModuleId
     *
     * @return
     */
    private static Map<String, X7S_Adventure_Module__c> getPreviousAndNextModules(List<X7S_Adventure_Module__c> modules, String currentModuleId) {
        Map<Id, X7S_Adventure_Module__c> modulesById = new Map<Id, X7S_Adventure_Module__c>(modules);
        X7S_Adventure_Module__c currentModule = modulesById.get(currentModuleId);
        Map<String, X7S_Adventure_Module__c> modulesByOrder = new Map<String, X7S_Adventure_Module__c>();

        for (X7S_Adventure_Module__c each : modules) {
            if (each.Order__c == (currentModule.Order__c + 1)) {
                modulesByOrder.put('next', each);
            } else if (each.Order__c == (currentModule.Order__c - 1)) {
                modulesByOrder.put('previous', each);
            }
        }

        return modulesByOrder;
    }

    /**
     * Calculates how many tasks are completed and what percentage of progress that is for a module.
     *
     * @param module
     *
     * @return
     */
    private static x7sAdventureNavigationWrapperItem calculateTasksForModule(X7S_Adventure_Module__c module) {
        Integer taskRemainingModule = 0;
        Integer totalTasksModule = 0;

        if (module != null && module.X7S_Adventure_Modules__r != null) {
            for (X7S_Adventure_Task__c eachTask : module.X7S_Adventure_Modules__r) {
                if (!eachTask.Completed__c) {
                    taskRemainingModule++;
                }
                totalTasksModule++;
            }
        }

        Double stepProgress = 0;

        if (taskRemainingModule != 0) stepProgress = taskRemainingModule / totalTasksModule;

        return new x7sAdventureNavigationWrapperItem(module, taskRemainingModule, stepProgress);
    }

    @AuraEnabled
    public static x7sAdventureResponse saveUserResponseSubTask(String subtaskId, String userResponse) {
        x7sAdventureResponse response = new x7sAdventureResponse();

        if (X7S_Adventure_Subtask__c.SObjectType.getDescribe().isUpdateable()) {

            try {
                X7S_Adventure_Subtask__c userSubTask = [SELECT Id, Response_Input__c FROM X7S_Adventure_Subtask__c WHERE Id = :subtaskId WITH SECURITY_ENFORCED];
                userSubTask.Response_Input__c = userResponse;
                update userSubTask;
                response.success = true;
            } catch (Exception e) {
                response.success = false; response.messages.add(e.getMessage());
            }
        }

        return response;
    }

    /* ****************************************
     * Commented out as we do not use Sub-Tasks

    @AuraEnabled
    public static x7sAdventureResponse saveUserResponseSubTasks(Map<String, String> subTaskIdToResponseMap) {

        x7sAdventureResponse response = new x7sAdventureResponse();

        try {
            Map<Id, X7S_Adventure_Subtask__c> allSubTasks = new Map<Id, X7S_Adventure_Subtask__c>([SELECT Id, Response_Input__c FROM X7S_Adventure_Subtask__c WHERE Id = :subTaskIdToResponseMap.keySet() WITH SECURITY_ENFORCED]);

            List<X7S_Adventure_Subtask__c> subTasksToUpdate = new List<X7S_Adventure_Subtask__c>();

            for (String theSubTaskId : subTaskIdToResponseMap.keySet()) {
                X7S_Adventure_Subtask__c theSubTaskToUpdate = allSubTasks.get(theSubTaskId);
                theSubTaskToUpdate.Response_Input__c = subTaskIdToResponseMap.get(theSubTaskId);
                subTasksToUpdate.add(theSubTaskToUpdate);
            }

            update subTasksToUpdate;
            response.success = true;
        } catch (Exception e) { response.success = false;response.messages.add(e.getMessage()); }
        return response;
    }
    ******************************************
    */

    @AuraEnabled(Cacheable=true)
    public static x7sAdventureResponse getActiveAdventures() {
        x7sAdventureResponse response = new x7sAdventureResponse();
        String accountId;

        String userId = UserInfo.getUserId();

        List<User> user = [SELECT Id, Contact.Account.Id FROM User WHERE Id = :userId WITH SECURITY_ENFORCED LIMIT 1];
        System.debug('user: ' + user);

        if (user.size() > 0) accountId = user[0].Contact.Account.Id;

        System.debug('account: ' + accountId);

        if (accountId != null) {
            List<X7S_Adventure__c> adventure = [
                    SELECT Id, Name, Title__c, Task_Progress__c, Show_Checkboxes__c
                    FROM X7S_Adventure__c
                    WHERE Account__c = :accountId
                    AND Completed__c = FALSE
                    AND Completed_Formula__c = FALSE
                    AND Active__c = TRUE
                    WITH SECURITY_ENFORCED
                    LIMIT 1
            ];

            if (adventure != null && adventure.size() > 0) {
                x7sAdventureMyProgress adventureProgress = getMyAdventureProgress(adventure[0].Id, userId);

                List<x7sAdventureContentObject> wrappedAdventures = new List<x7sAdventureContentObject>();
                x7sAdventureContentObject wrappedAdventure = new x7sAdventureContentObject();
                wrappedAdventures.add(wrappedAdventure);

                wrappedAdventure.adventure = adventure[0];
                response.adventureProgress = adventureProgress;
                response.adventureResults = wrappedAdventures;
            } else {
                response.success = false; response.messages.add('No active adventures found for user.');
            }
        } else {
            response.success = false;
            response.messages.add('User does not appear to be associated with an account.');
        }

        return response;
    }

    @TestVisible
    private class LeaderboardData {
        @AuraEnabled public List<x7sAdventureContentObject> adventureWrapper;
        @AuraEnabled public String sitePrefix = '';
    }

    /**
     * Get Adventure List based on source filter
     *
     * @param sourceAdventureId - Source Adventure Id
     * @param numberOfRecords - Number of Adventures to be returned
     * @param showInactiveAdventures - Show Inactive adventure Flag
     * @return List<x7sAdventureContentObject> - list of adventure content wrapper
     */
    @AuraEnabled
    public static LeaderboardData getLeaderboardData(String sourceAdventureId, String numberOfRecords, Boolean showInactiveAdventures, String sortBy) {
        LeaderboardData leaderBoardData = new LeaderboardData();
        List<X7S_Adventure__c> adventureList = new List<X7S_Adventure__c>();
        List<x7sAdventureContentObject> adventureWrapper = new List<x7sAdventureContentObject>();
        Integer recordLimit = Integer.valueOf(numberOfRecords);

        try {
            String adventurequery = 'SELECT Id, Name, Owner.Name, Source_Template__c, Source_Template__r.Name, Start_Date__c, title__c, LastModifiedDate, Show_Checkboxes__c,Task_Progress__c,Active__c,Module_Progress__c,Number_of_Completed_Tasks__c,Number_of_Completed_Modules__c FROM X7S_Adventure__c';
            String whereClause = '';

            if (sourceAdventureId != null && sourceAdventureId != '') {
                whereClause += ' AND Source_Template__c =:sourceAdventureId';
            }

            if (!showInactiveAdventures) {
                whereClause += ' AND Active__c = true';
            }

            if (String.isNotBlank(whereClause)) {
                whereClause = whereClause.removeStart(' AND ') ;
                adventurequery += ' WHERE ' + whereClause;
            }

            adventurequery += sortBy == 'Module Percent Complete Descending' ? ' ORDER BY Module_Progress__c DESC NULLS LAST' : sortBy == 'Task Percent Complete Descending' ? ' ORDER BY Task_Progress__c DESC NULLS LAST' : '';

            if (recordLimit > 0 && recordLimit <= 100) {
                adventurequery += ' LIMIT :recordLimit';
            } else {
                adventurequery += ' LIMIT 100';
            }

            adventureList = Database.query(String.escapeSingleQuotes(adventurequery));

            if (adventureList.size() > 0) {
                Set<Id> userIdList = new Set<Id>();

                for (X7S_Adventure__c adventure : adventureList) {
                    userIdList.add(adventure.Owner.Id);
                }

                Map<Id, User> userIdToPhotoURL = new Map<Id, User> ([SELECT Id,SmallPhotoUrl FROM User WHERE Id IN :userIdList WITH SECURITY_ENFORCED]);

                for (X7S_Adventure__c adventure : adventureList) {
                    x7sAdventureContentObject tempAdventure = new x7sAdventureContentObject();
                    tempAdventure.adventure = adventure;

                    if (userIdToPhotoURL.containsKey(adventure.Owner.Id)) {
                        tempAdventure.ownerSmallPhotoURL = userIdToPhotoURL.get(adventure.Owner.Id).SmallPhotoUrl;
                    }
                    adventureWrapper.add(tempAdventure);
                }
            }

            leaderBoardData.adventureWrapper = adventureWrapper;
            leaderBoardData.sitePrefix = System.Site.getPathPrefix();
        } catch (Exception e) {
            System.debug('getLeaderboardData Error Message: ' + e.getMessage() + ' , Error Line Number: ' + e.getLineNumber());
        }

        return leaderBoardData;
    }

    /**
     * Get Adventure List based on source filter
     *
     * @param adventureId - Adventure Id
     * @param activeUserId - Current User Id
     * @return List<x7sAdventureContentObject> - list of adventure content wrapper
     */
    @AuraEnabled
    public static String getAdventureToLaunch(String adventureId, String activeUserId) {
        
        String sourceAdventureId = String.escapeSingleQuotes(adventureId);
        String userId = String.escapeSingleQuotes(activeUserId);

        if(!String.isBlank(sourceAdventureId)) {
            try {

                //Check for Active Cloned Adventures
                List<X7S_Adventure__c> adventureList = new List<X7S_Adventure__c>();
                adventureList = [SELECT Id, Name, OwnerId 
                                FROM X7S_Adventure__c 
                                WHERE Source_Template__c =:sourceAdventureId AND OwnerId =:userId AND Active__c = true
                                WITH SECURITY_ENFORCED
                                ORDER BY LastModifiedDate DESC
                                LIMIT 100];
                if(adventureList.size() > 0) {
                    return adventureList[0].Id;
                } else {

                    //If Cloned Adventure not found for the user, return Parent adventure
                    return [SELECT Id, Name, OwnerId 
                                FROM X7S_Adventure__c 
                                WHERE Id =:sourceAdventureId AND Active__c = true
                                WITH SECURITY_ENFORCED]?.Id;
                }
            } catch (Exception e) {
                System.debug('getAdventureToLaunch() - Error Message: ' + e.getMessage() + ' , Error Line Number: ' + e.getLineNumber());
            }
        }
        return '';
    }
}