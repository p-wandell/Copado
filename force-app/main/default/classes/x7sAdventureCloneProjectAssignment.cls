/*
 * Copyright (c) 2020. 7Summits Inc.
 */
public with sharing class x7sAdventureCloneProjectAssignment {

    /**
     * This constant is based on a Limit of 200 SOQL queries for a Async request using the future method
     * and that the clone adventure method uses 6 SOQL queries per clone operation.
     */
    private final static Integer USER_BATCH_SIZE = 33;
    private final static String CLONE_SETTING_NAME = 'Default';
    private static final Integer MAX_CLONE_TOPICS_LIMIT = 1000;

    // Current community ID
    private static Id communityId {
        get { return System.Network.getNetworkId();}
    }

    // Set of fields used for inserting TopicAssignment fields
    private static String [] TopicAssignmentInsertFields = new String []{
            'EntityId',
            'TopicId'
    };

    /**
     * @param userIdList    A string containing one or more user Id's separated by commas
     *
     * @return              A list of users with Id, First Name, and Last Name.
     */
    private static List<User> LoadUsersFromList(String userIdList) {
        if (String.isEmpty(userIdList)) {
            System.debug('Error: Empty user id list.');
            return null;
        } else if (User.SObjectType.getDescribe().isAccessible()) {
            List<String> userIds = new List<String>(userIdList.trim().split('\\s*,\\s*'));
            return [SELECT Id, FirstName, LastName FROM User WHERE Id IN :userIds AND IsActive = TRUE];
        } else {
            return null;
        }
    }

    /**
     * Close a selected adventure for a set up user id's that are passed in as a common separated list.
     * The cloned adventures will be renamed with each user First Name + Last Name and it will be owned
     * by this user.
     * @param adventureId    Selected Adventure to clone
     * @param showCheckBoxes Option to show checkboxes for tasks
     * @param userIdList     Comma separated list of user Id's to create a clone per user
     */
    @AuraEnabled
    public static void CloneUsers(String adventureId, Boolean showCheckBoxes, String userIdList) {

        if (String.isEmpty(adventureId)) {
            System.debug('Invalid Adventure Id.');
            return;
        }

        try {
            List<User> users = LoadUsersFromList(userIdList);

            if (users == null) {
                return;
            }

            Map<String, String> userBatchList = new Map<String, String>();

            for (User user : users) {
                userBatchList.put(user.Id, user.FirstName + ' ' + user.LastName);

                // Process in predefined batch size.
                if (userBatchList.size() == USER_BATCH_SIZE) {
                    x7sAdventureCloneProjectAssignment.CloneSubSet(adventureId, userBatchList, showCheckBoxes);
                    userBatchList.clear();
                }
            }

            // Process remaining users.
            if (userBatchList.size() > 0) {
                x7sAdventureCloneProjectAssignment.CloneSubSet(adventureId, userBatchList, showCheckBoxes);
            }
        } catch (Exception e) {
            System.debug('Clone Users Error: ' + e.getMessage());
        }
    }

    /**
     * Future method that will clone a batch of users.
     *
     * @param selectedAdventureId   Selected Adventure to clone
     * @param userCollection        Map of Id's along with the First Name + Last Name to assign to each clone
     * @param showCheckboxes        Option to show checkboxes for tasks
     */
    @Future
    private static void CloneSubSet(Id selectedAdventureId, Map<String, String> userCollection, Boolean showCheckboxes) {
        for (String id : userCollection.keySet()) {
            String newName = ' - ' + userCollection.get(id);

            x7sAdventureCloneProjectAssignment.cloneAdventureItem(selectedAdventureId, newName, showCheckboxes, id, true, '');
        }
    }

    /**
     * Public function that will clone a single adventure and all its children.
     * @param selectedAdventureId   Selected Adventure to clone
     * @param clonedAdventureName   Name to use for cloned adventure
     * @param showCheckboxes        Option to show checkboxes for tasks
     * @param childCloneSetting     Set option to allow the clone to be cloned
     *
     * @return Id of cloned adventure
     */
    @AuraEnabled
    public static Id cloneAdventure(Id selectedAdventureId, String clonedAdventureName, Boolean showCheckboxes, String childCloneSetting) {
        return x7sAdventureCloneProjectAssignment.cloneAdventureItem(selectedAdventureId, clonedAdventureName, showCheckboxes, '', false, childCloneSetting);
    }

    /**
     * @param selectedAdventureId   Selected Adventure to clone
     * @param clonedAdventureName   Name to use for cloned adventure.
     * @param showCheckboxes        Option to show checkboxes for tasks
     * @param ownerId               Owner of cloned adventure (Optional)
     * @param appendName            Append name to existing adventure name (Optional)
     * @param childCloneSetting     Set option to allow the clone to be cloned
     *
     * @return Id of cloned adventure
     */
    public static Id cloneAdventureItem(Id selectedAdventureId,
            String clonedAdventureName,
            Boolean showCheckboxes,
            String ownerId,
            Boolean appendName,
            String childCloneSetting) {
        Id clonedAdventureId = null;

        if (checkCanClone(selectedAdventureId)) {
            try {
                Map<String, String> docFileMap ;
                Map<Id, List<X7S_Adventure_Task__c>> moduleTasksMap = new Map<Id, List<X7S_Adventure_Task__c>>();
                List<X7S_Adventure_Step__c> clonedStepsList = new List<X7S_Adventure_Step__c>();
                List<X7S_Adventure_Module__c> clonedModuleList = new List<X7S_Adventure_Module__c>();
                List<X7S_Adventure_Task__c> clonedTasksList = new List<X7S_Adventure_Task__c>();

                Map<String, X7S_Adventure_Step__c> oldStepsMap = new Map<String, X7S_Adventure_Step__c>();
                Map<String, X7S_Adventure_Step__c> newStepsMap = new Map<String, X7S_Adventure_Step__c>();
                Map<String, List<X7S_Adventure_Module__c>> clonedStepModuleMap = new Map<String, List<X7S_Adventure_Module__c>>();

                Map<String, X7S_Adventure_Module__c> clonedModulesMap = new Map<String, X7S_Adventure_Module__c>();
                Map<String, List<X7S_Adventure_Task__c>> clonedTasksMap = new Map<String, List<X7S_Adventure_Task__c>>();
                Map<String, List<X7S_Adventure_Task__c>> masterTaskMap = new Map<String, List<X7S_Adventure_Task__c>>();

                // Adventure creation
                if (selectedAdventureId != null) {
                    X7S_Adventure__c cloneAdventure = [
                            SELECT Id,Name,Title__c,Active__c,Description__c,
                                    Source_Template__c,Subtitle__c,Completed__c,Account__c,Template__c,
                                    Show_Checkboxes__c,Allow_Cloning__c,Adventure_Clone_Settings__c
                            FROM X7S_Adventure__c
                            WHERE Id = :selectedAdventureId
                            WITH SECURITY_ENFORCED
                            LIMIT 1
                    ];

                    if (cloneAdventure != null) {

                        X7S_Adventure__c newAdventure = cloneAdventure.clone(false, true);
                        if (newAdventure != null) {

                            if (String.isEmpty(clonedAdventureName)) {
                                clonedAdventureName = cloneAdventure.Name + ' Copy';
                            } else if (appendName) {
                                clonedAdventureName = cloneAdventure.Name + ' ' + clonedAdventureName;
                            }

                            newAdventure.Source_Template__c = cloneAdventure.Id;
                            newAdventure.Account__c = null;
                            newAdventure.Template__c = false;
                            newAdventure.Completed__c = false;
                            newAdventure.Name = clonedAdventureName;
                            newAdventure.Show_Checkboxes__c = showCheckboxes;

                            if (childCloneSetting != null) {
                                switch on childCloneSetting {
                                    when 'Y' {
                                        newAdventure.Allow_Cloning__c = true;
                                    }
                                    when 'N' {
                                        newAdventure.Allow_Cloning__c = false;
                                    }
                                    when else {
                                        newAdventure.Allow_Cloning__c = false;
                                    }
                                }
                            }

                            if (String.isNotBlank(ownerId)) {
                                newAdventure.OwnerId = ownerId;
                            }

                            x7sAdventureUtils.throwErrorIfInsertPermissionMissing(Schema.SObjectType.X7S_Adventure__c);
                            insert newAdventure; // NOPMD - CRUD permissions validated in previous line

                            //Check & clone files if there is any in adventure
                            clonedAdventureId = newAdventure.Id;

                            docFileMap = new Map<String, String>();
                            docFileMap.put(selectedAdventureId, clonedAdventureId);

                            if (docFileMap.keySet().size() > 0) {
                                createContentVersionForChild(docFileMap);
                            }

                            List<X7S_Adventure_Step__c> stepList = [
                                    SELECT Adventure__c,Name,Description__c,Order__c,Subtitle__c,Title__c,Active__c, (SELECT Id,Adventure_Step__c,Name,Description_URL__c,Description_Label__c,Order__c,Title__c,Tooltip_Description__c,Active__c,Completed_Manual__c FROM X7S_Step_Modules__r)
                                    FROM X7S_Adventure_Step__c
                                    WHERE Adventure__c = :cloneAdventure.Id
                                    WITH SECURITY_ENFORCED
                            ];

                            List<X7S_Adventure_Module__c> moduleList = [
                                    SELECT Id,Adventure_Step__c,Name,Active__c,Completed_Manual__c,Description_Label__c,Description_URL__c,Order__c,Title__c,Tooltip_Description__c, (SELECT Id,Name,Adventure_Module__c,Title__c,Resource_Type__c,Content_URL__c,Order__c,Completed__c,Flow__c,Question_Response__c,Question_Text__c,Template__c,Custom_Icon_Name__c FROM X7S_Adventure_Modules__r)
                                    FROM X7S_Adventure_Module__c
                                    WHERE Adventure_Step__c IN (SELECT Id FROM X7S_Adventure_Step__c WHERE Adventure__c = :cloneAdventure.Id)
                                    WITH SECURITY_ENFORCED
                            ];

                            if (moduleList.size() > 0) {
                                for (X7S_Adventure_Module__c module : moduleList) {
                                    moduleTasksMap.put(module.Id, module.X7S_Adventure_Modules__r);
                                }
                            }

                            // Adventure->Steps creation
                            if (stepList.size() > 0) {
                                for (X7S_Adventure_Step__c step : stepList) {
                                    X7S_Adventure_Step__c clonedStep = step.clone(false, true);
                                    clonedStep.Adventure__c = newAdventure.Id;
                                    clonedStep.Source_Step_ID__c = step.Id;
                                    clonedStepsList.add(clonedStep);

                                    String uniqueId = x7sAdventureCloneProjectAssignment.generateUniqueId();

                                    oldStepsMap.put(uniqueId, step);
                                    newStepsMap.put(uniqueId, clonedStep);
                                    clonedStepModuleMap.put(uniqueId, step.X7S_Step_Modules__r);
                                }
                            }

                            if (clonedStepsList.size() > 0) {
                                x7sAdventureUtils.throwErrorIfInsertPermissionMissing(Schema.SObjectType.X7S_Adventure_Step__c);
                                insert clonedStepsList; // NOPMD - CRUD permissions validated in previous line

                                //Check & clone files if there is any in Adventure->Steps
                                docFileMap = new Map<String, String>();

                                if (oldStepsMap.size() > 0) {
                                    for (String uniqueId : oldStepsMap.keySet()) {
                                        X7S_Adventure_Step__c oldStep = oldStepsMap.get(uniqueId);
                                        X7S_Adventure_Step__c clonedStep = newStepsMap.get(uniqueId);
                                        docFileMap.put(oldStep.Id, clonedStep.Id);
                                    }

                                    if (docFileMap.keySet().size() > 0) {
                                        createContentVersionForChild(docFileMap);
                                    }
                                }
                            }

                            // Adventure->Steps->Module creation
                            if (newStepsMap.size() > 0) {
                                for (String uniqueId : newStepsMap.keySet()) {
                                    X7S_Adventure_Step__c step = newStepsMap.get(uniqueId);

                                    for (X7S_Adventure_Module__c module : clonedStepModuleMap.get(uniqueId)) {
                                        X7S_Adventure_Module__c clonedModule = module.clone(false, true);
                                        clonedModule.Adventure_Step__c = step.Id;
                                        clonedModule.Source_Module_ID__c = module.Id;
                                        clonedModuleList.add(clonedModule);

                                        String uniqueIdForTasks = x7sAdventureCloneProjectAssignment.generateUniqueId();

                                        clonedModulesMap.put(uniqueIdForTasks, clonedModule);
                                        clonedTasksMap.put(uniqueIdForTasks, moduleTasksMap.get(module.Id).deepClone(true, false, false));
                                        masterTaskMap.put(uniqueIdForTasks, moduleTasksMap.get(module.Id));
                                    }
                                }
                            }

                            if (clonedModuleList.size() > 0) {
                                x7sAdventureUtils.throwErrorIfInsertPermissionMissing(Schema.SObjectType.X7S_Adventure_Module__c);
                                insert clonedModuleList; // NOPMD - CRUD permissions validated in previous line

                                // Linking tasks with their module
                                if (clonedTasksMap.size() > 0) {
                                    for (String uniqueId : clonedModulesMap.keySet()) {
                                        X7S_Adventure_Module__c module = clonedModulesMap.get(uniqueId);

                                        for (X7S_Adventure_Task__c moduleTask : clonedTasksMap.get(uniqueId)) {
                                            moduleTask.Source_Task_ID__c = moduleTask.Id;
                                            moduleTask.Id = null;
                                            moduleTask.Adventure_Module__c = module.Id;
                                            moduleTask.Owner__c = null;
                                            moduleTask.Restrict_to_User__c = false;
                                            moduleTask.Completed__c = false;
                                            moduleTask.Cascade__c = false; // Always false
                                            clonedTasksList.add(moduleTask);
                                        }
                                    }
                                }
                            }

                            if (clonedTasksList.size() > 0) {
                                x7sAdventureUtils.throwErrorIfInsertPermissionMissing(Schema.SObjectType.X7S_Adventure_Task__c);
                                insert clonedTasksList; // NOPMD - CRUD permissions validated in previous line

                                //Check & clone files if there is any in Adventure->Steps-->Module-->Task
                                if (masterTaskMap.size() > 0) {
                                    docFileMap = new Map<String, String>();

                                    for (String uniqueId : masterTaskMap.keySet()) {
                                        List<X7S_Adventure_Task__c> originalTasks = masterTaskMap.get(uniqueId);
                                        List<X7S_Adventure_Task__c> clonedTasks = clonedTasksMap.get(uniqueId);

                                        for (Integer index = 0; index < originalTasks.size(); index++) {
                                            docFileMap.put(originalTasks[index].Id, clonedTasks[index].Id);
                                        }
                                    }

                                    if (docFileMap.keySet().size() > 0) {
                                        createContentVersionForChild(docFileMap);
                                    }
                                }
                            }

                            //Copy topics if associated with adventure
                            String cloneAdventureId = cloneAdventure.Id;
                            String topicQuery = 'SELECT Id,EntityId,TopicId FROM TopicAssignment WHERE EntityId = :cloneAdventureId';
                            topicQuery += communityId != null ? ' AND NetworkId = :communityId' : ' AND NetworkId = null';
                            topicQuery += ' LIMIT :MAX_CLONE_TOPICS_LIMIT';

                            List<TopicAssignment> assignments = Database.query(String.escapeSingleQuotes(topicQuery));

                            if (assignments.size() > 0 && TopicAssignment.SObjectType.getDescribe().isCreateable()) {
                                Map<String, Schema.SObjectField> TAFldMap = Schema.SObjectType.TopicAssignment.fields.getMap();
                                for (String fieldToCheck : TopicAssignmentInsertFields) {

                                    // Check if the user has access to view field
                                    if (!TAFldMap.get(fieldToCheck).getDescribe().isCreateable()) {
                                        throw new System.NoAccessException();
                                    } else {
                                        cloneTopics(assignments, clonedAdventureId);
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            }
        }

        return clonedAdventureId;
    }

    private static void cloneTopics(List<TopicAssignment> selectedAdventureTopics, Id clonedAdventureId) {
        List<TopicAssignment> topicAssignmentList = new List<TopicAssignment>();

        try {
            for (TopicAssignment topicAssignment : selectedAdventureTopics) {
                topicAssignmentList.add(new TopicAssignment(EntityId = clonedAdventureId, TopicId = topicAssignment.TopicId));
            }

            if (topicAssignmentList.size() > 0) {
                insert topicAssignmentList;
            }
        } catch (DmlException exp) {
            System.debug('Error - cloneTopics():' + exp.getMessage());
        }
    }

    /**
     * @return a unique id uses for mapping records from original to clone.
     */
    private static String generateUniqueId() {
        Blob generatedKey = Crypto.generateAesKey(128);
        String uniqueId = EncodingUtil.convertToHex(generatedKey);

        return uniqueId;
    }

    /**
     * Copy the files from existing records
     * @param processContentVersion : document files map
     */
    @AuraEnabled
    public static void createContentVersionForChild(Map<String, String> processContentVersion) {

        try {
            List<ContentDocumentLink> contentDocLinkList = new List<ContentDocumentLink>();

            List<ContentVersion> clonedContentVersion = new List<ContentVersion>();
            Map<String, String> filesCloneMap = new Map<String, String>();

            if (processContentVersion.size() > 0) {
                List<ContentDocumentLink> newList = new List<ContentDocumentLink>([SELECT ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN:processContentVersion.keySet() WITH SECURITY_ENFORCED]);

                if (newList.size() > 0) {
                    for (ContentDocumentLink recordContent : newList) {
                        if (processContentVersion.containsKey(recordContent.LinkedEntityId)) {
                            String clonedRecordId = processContentVersion.get(recordContent.LinkedEntityId);
                            filesCloneMap.put(recordContent.ContentDocumentId, clonedRecordId);
                        }
                    }
                }

                if (filesCloneMap.size() > 0) {
                    List<ContentVersion> oldContentVersionList = new List<ContentVersion>([SELECT Id,ContentLocation,PathOnClient,Title,ContentBodyId,ContentDocumentId,ContentUrl,VersionData FROM ContentVersion WHERE ContentDocumentId IN:filesCloneMap.keySet() WITH SECURITY_ENFORCED]);
                    if (oldContentVersionList.size() > 0) {
                        for (ContentVersion contentRecord : oldContentVersionList) {
                            ContentVersion conVer = new ContentVersion();
                            conVer.ContentLocation = contentRecord.ContentLocation;
                            conVer.PathOnClient = contentRecord.PathOnClient;
                            conVer.Title = contentRecord.Title;
                            conVer.VersionData = contentRecord.VersionData;
                            conVer.ContentUrl = contentRecord.ContentUrl;
                            conVer.X7S_Clone_Record_Id__c = filesCloneMap.get(contentRecord.ContentDocumentId);   // Custom field 'X7S_Clone_Record_Id__c' created in contentVersion object
                            clonedContentVersion.add(conVer);
                        }
                    }
                }
            }

            if (clonedContentVersion.size() > 0) {
                x7sAdventureUtils.throwErrorIfInsertPermissionMissing(Schema.SObjectType.ContentVersion);
                insert clonedContentVersion; // NOPMD - CRUD permissions validated in previous line

                //get id of newly created contentVersion records
                List<String> ContentDocumentId = new List<String>();
                for (ContentVersion contRecord : clonedContentVersion) {
                    ContentDocumentId.add(contRecord.Id);
                }
                //get the contentDocumentId & related record Id 'X7S_Clone_Record_Id__c'
                List<ContentVersion> contentVersions = new List<ContentVersion>([SELECT ContentDocumentId,X7S_Clone_Record_Id__c FROM ContentVersion WHERE Id IN:ContentDocumentId]);

                //Create ContentDocumentLink
                for (ContentVersion cloneRecord : contentVersions) {
                    ContentDocumentLink cloneFile = new ContentDocumentLink();
                    cloneFile.ContentDocumentId = cloneRecord.ContentDocumentId;
                    cloneFile.LinkedEntityId = cloneRecord.X7S_Clone_Record_Id__c;
                    cloneFile.ShareType = 'V';
                    cloneFile.Visibility = 'AllUsers';
                    contentDocLinkList.add(cloneFile);
                }
                if (contentDocLinkList.size() > 0) {
                    x7sAdventureUtils.throwErrorIfInsertPermissionMissing(Schema.SObjectType.ContentDocumentLink);
                    insert contentDocLinkList; // NOPMD - CRUD permissions validated in previous line
                }
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR, 'Error message: ' + ex.getMessage() + ', Line number: ' + ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }

    /**
     * @param selectedAdventureId Id if adventure
     *
     * @return clone settings if successful.
     */
    @AuraEnabled
    public static x7sAdventureCloneResponse getConfiguration(Id selectedAdventureId) {
        x7sAdventureCloneResponse x7sAdventureCloneResponse = new x7sAdventureCloneResponse();

        try {
            x7sAdventureCloneResponse.globalSettings = [
                    SELECT Enable_Checkbox_Display__c,Enable_New_Task_Flag__c,Override_Action_Color__c,Override_Link_Color__c,Task_Completion_Checked_Text__c,Task_Completion_Unchecked_Text__c
                    FROM X7S_Adventure_Setting__mdt
                    WHERE DeveloperName = 'Default'
                    LIMIT 1
            ];

            X7S_Adventure__c adventure = [
                    SELECT Id, Name, Adventure_Clone_Settings__c
                    FROM X7S_Adventure__c
                    WHERE Id = :selectedAdventureId
                    WITH SECURITY_ENFORCED
            ];

            if (adventure != null) {
                x7sAdventureCloneResponse.clonedAdventureName = adventure.Name + ' Copy';

                List<AggregateResult> aggregateResult = [
                        SELECT COUNT(CreatedBy.Id) EntityCount
                        FROM X7S_Adventure__c
                        WHERE Source_Template__c = :selectedAdventureId AND CreatedBy.Id = :UserInfo.getUserId()
                        WITH SECURITY_ENFORCED
                ];

                if (aggregateResult.size() > 0) {
                    x7sAdventureCloneResponse.exists = (Decimal) aggregateResult[0].get('EntityCount') > 0;
                }

                //If specified clone setting not found in CMT records, consider the default clone setting
                Boolean getDefaultSetting = false;
                List<X7S_Adventure_Clone_Setting__mdt> cloneSettings = new List<X7S_Adventure_Clone_Setting__mdt>();

                if (adventure.Adventure_Clone_Settings__c != null && (adventure.Adventure_Clone_Settings__c.trim()).length() > 0) {
                    cloneSettings = [//NOPMD
                            SELECT DeveloperName,Child_Clone_Setting__c,Full_Clone_Error_Text__c,Full_Clone_Success_Text__c
                            FROM X7S_Adventure_Clone_Setting__mdt
                            WHERE DeveloperName = :adventure.Adventure_Clone_Settings__c
                            LIMIT 1
                    ];

                    if (!(cloneSettings.size() > 0)) {
                        getDefaultSetting = true;
                    } else {
                        x7sAdventureCloneResponse.cloneSettings = cloneSettings[0];
                    }
                } else {
                    getDefaultSetting = true;
                }
                if (getDefaultSetting) {
                    cloneSettings = [//NOPMD
                            SELECT DeveloperName,Child_Clone_Setting__c,Full_Clone_Error_Text__c,Full_Clone_Success_Text__c
                            FROM X7S_Adventure_Clone_Setting__mdt
                            WHERE DeveloperName = :CLONE_SETTING_NAME
                            LIMIT 1
                    ];
                    if (cloneSettings.size() > 0) {
                        x7sAdventureCloneResponse.cloneSettings = cloneSettings[0];
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('Error: ' + ex.getMessage());

            throw new AuraHandledException(ex.getMessage());
        }

        return x7sAdventureCloneResponse;
    }

    /**
     * Check if user is having Create accesses needed to clone Adventure
     * @param selectedAdventureId : Id of the adventure
     * @return : true if user can clone adventure else false.
     */
    @AuraEnabled
    public static Boolean checkCanClone(Id selectedAdventureId) {
        if (X7S_Adventure__c.SObjectType.getDescribe().createable &&
                X7S_Adventure_Step__c.SObjectType.getDescribe().createable &&
                X7S_Adventure_Subtask__c.SObjectType.getDescribe().createable &&
                X7S_Adventure_Module__c.SObjectType.getDescribe().createable &&
                X7S_Adventure_Task__c.SObjectType.getDescribe().createable &&
                selectedAdventureId != null &&
                !x7sAdventureUtils.isGuestUser()) {

            X7S_Adventure__c cloneAdventure = [
                    SELECT Id, Allow_Cloning__c
                    FROM X7S_Adventure__c
                    WHERE Id = :selectedAdventureId
                    WITH SECURITY_ENFORCED
                    LIMIT 1
            ];

            if (cloneAdventure != null) {
                return cloneAdventure.Allow_Cloning__c;
            }
        }
        return false;
    }
}