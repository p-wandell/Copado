public without sharing class x7S_ContactTriggerHelper {
    public static void handleContactInsertUpdate(Map<Id, Contact> newValues, Map<Id, Contact> oldValues) {
        Map<Id,List<String>> changedIdMap = new Map<Id,List<String>>();
        List<User> updatedUsers = new List<User>();
        for(Id key : newValues.keySet()){
            if(newValues.get(key).pse__Salesforce_User__c != null){
                List<String> updatedValues = new List<String>();
                Contact newContact = newValues.get(key);
                Contact oldContact = oldValues != null && !oldValues.isEmpty() ? oldValues.get(key) : new Contact();
                if(newContact.ReportsToId != oldContact.ReportsToId){
                    updatedValues.add('reports');
                }
                if(newContact.FirstName != oldContact.FirstName || newContact.LastName != oldContact.LastName){
                    updatedValues.add('name');
                }
                if(newContact.Email != oldContact.Email){
                    updatedValues.add('email');
                }
                if(newContact.Competency_Group__c != oldContact.Competency_Group__c){
                    updatedValues.add('competency');
                }
                if(newContact.pse__Start_Date__c != oldContact.pse__Start_Date__c){
                    updatedValues.add('start');
                }
                if(newContact.AccountId != oldContact.AccountId){
                    updatedValues.add('company');
                }
                if(!updatedValues.isEmpty()){
                    changedIdMap.put(newContact.Id, updatedValues);
                }
            }
        }
        for(Contact reportsContact : [SELECT Id, FirstName, LastName, Email, ReportsTo.pse__Salesforce_User__c, pse__Salesforce_User__c, Competency_Group__c, pse__Start_Date__c, Account.Name FROM Contact WHERE Id IN :changedIdMap.keySet()]){
            User newUserData = new User(Id=reportsContact.pse__Salesforce_User__c, Apex_Processing__c=true);
            for(String updatedValue : changedIdMap.get(reportsContact.Id)){
                switch on updatedValue {
                    when 'reports' {
                        newUserData.ManagerId = reportsContact.ReportsTo.pse__Salesforce_User__c;
                    }
                    when 'name' {
                        newUserData.FirstName = reportsContact.FirstName;
                        newUserData.LastName = reportsContact.LastName;
                    }
                    when 'email' {
                        newUserData.Email = reportsContact.Email;
                    }
                    when 'competency' {
                        newUserData.Competency_Group__c = reportsContact.Competency_Group__c;
                    }
                    when 'start' {
                        newUserData.Start_Date__c = reportsContact.pse__Start_Date__c;
                    }
                    when 'company' {
                        newUserData.CompanyName = reportsContact.Account.Name;
                    }
                }
            }
            System.debug('handleContactInsertUpdate UPDATED USER ==== ' + newUserData);
            updatedUsers.add(newUserData);
        }
        update updatedUsers;
    }
    
    public static void insertInternalAssignments(Map<Id, Contact> contactMap) {
        List<pse__Permission_Control__c> psaPermissions = [SELECT Id, pse__Region__c, pse__Resource__c, pse__Practice__c 
                                                           FROM pse__Permission_Control__c 
                                                           WHERE pse__User__c =: UserInfo.getUserId() AND pse__Staffing__c=true];
        
        List<pse__Proj__c> projects = [SELECT Id FROM pse__Proj__c WHERE pse__Is_Active__c=true AND AutomaticallyCreateAssignment__c=true];
        List<pse__Assignment__c> newAssignments = new List<pse__Assignment__c>();
        List<pse__Schedule__c> newSchedules = new List<pse__Schedule__c>();
        
        if(!psaPermissions.isEmpty()) {
            Map<Id,Set<Id>> existingAssignments = getExistingAssignmentsForContacts(contactMap.values(), projects);
            System.debug('------ AssignmentMap: ' + existingAssignments);
            System.debug('------ projects: ' + projects);
            for(Contact c : contactMap.values()) {
                boolean assignmentCreated=false;
                for(pse__Permission_Control__c psaPermission : psaPermissions) {
                    if(psaPermission.pse__Region__c == c.pse__Region__c || psaPermission.pse__Practice__c == c.pse__Practice__c) {
                        System.debug('------------ Permissions for Staffing --------------');
                        if(c.pse__Is_Resource_Active__c && c.pse__Is_Resource__c) {
                            for(pse__Proj__c project : projects) {
                                if(!existingAssignments.containsKey(project.Id) || (existingAssignments.containsKey(project.Id) && !existingAssignments.get(project.Id).contains(c.Id))) {
                                    pse__Schedule__c s = new pse__Schedule__c(pse__Start_Date__c=Date.newInstance(2018, 01, 01), 
                                                                              pse__End_Date__c=Date.newInstance(2022, 01, 01),
                                                                              pse__Monday_Hours__c=0,
                                                                              pse__Tuesday_Hours__c=0,
                                                                              pse__Wednesday_Hours__c=0,
                                                                              pse__Thursday_Hours__c=0,
                                                                              pse__Friday_Hours__c=0);
                                    pse__Assignment__c a = new pse__Assignment__c(pse__Project__c=project.Id, pse__Resource__c=c.Id, pse__Use_Resource_Default_Cost_Rate__c	=true,
                                                                                  pse__Bill_Rate__c=0.0);
                                    
                                    newSchedules.add(s);
                                    newAssignments.add(a);
                                    assignmentCreated=true;
                                    
                                }
                            }
                        }
                    }
                    if(assignmentCreated) { break; }
                }
            }            
        }
        
        if(!newSchedules.isEmpty()) {
            System.debug('================= assignments: ' + newAssignments);
            insert newSchedules;
            integer x=0;
            for(pse__Schedule__c s : newSchedules) {
                newAssignments[x].pse__Schedule__c=s.Id;
                x++;
            }
            insert newAssignments;
        }
    }
    
    private static Map<Id, Set<Id>> getExistingAssignmentsForContacts(List<Contact> contacts, List<pse__Proj__c> projects) {
        Map<Id, Set<Id>> existingAssignmentMap = new Map<Id, Set<Id>>();
        Set<Id> resourceIds = new Set<Id>();
        Set<Id> projectIds = new Set<Id>();
        
        for(Contact c : contacts) {
            resourceIds.add(c.Id);
        }
        
        for(pse__Proj__c p : projects) {
            projectIds.add(p.Id);
        }
        
        List<pse__Assignment__c> assignments = [SELECT pse__Project__c, pse__Resource__c 
                                                FROM pse__Assignment__c 
                                                WHERE pse__Project__c IN : projectIds AND pse__Resource__c IN : resourceIds];
        for(pse__Assignment__c assignment : assignments) {
            if(!existingAssignmentMap.containsKey(assignment.pse__Project__c)) { existingAssignmentMap.put(assignment.pse__Project__c, new Set<Id>()); }
            existingAssignmentMap.get(assignment.pse__Project__c).add(assignment.pse__Resource__c);
        }
        
        return existingAssignmentMap;
    }
}