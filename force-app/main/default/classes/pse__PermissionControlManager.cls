/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PermissionControlManager {
    global PermissionControlManager() {

    }
    webService static List<Contact> getDelegatedTimeCardEntryResources(String userId, List<String> columnsToProject) {
        return null;
    }
    webService static List<pse__Permission_Control__c> getPermissionControlsForAnyPermission(String userId, List<pse.PermissionControlManager.Permission> forPermissions) {
        return null;
    }
    webService static List<pse__Permission_Control__c> getPermissionControlsWithExtraColumns(String userId, List<pse.PermissionControlManager.Permission> forPermissions, List<String> columnsToProject, Boolean matchAnyPermission) {
        return null;
    }
    webService static List<pse__Permission_Control__c> getPermissionControls(String userId, List<pse.PermissionControlManager.Permission> forPermissions) {
        return null;
    }
    webService static pse.PermissionControlManager.RPGCollection getRPGCollectionForCreateTeam(String userId) {
        return null;
    }
    webService static pse.PermissionControlManager.RPGCollection getRPGCollectionForStaffing(String userId) {
        return null;
    }
    webService static List<pse__Resource_Request__c> getResourceRequestsWithExtraColumns(String userId, List<pse.PermissionControlManager.Permission> forPermissions, List<String> columnsToProject) {
        return null;
    }
    webService static List<pse__Resource_Request__c> getResourceRequests(String userId, List<pse.PermissionControlManager.Permission> forPermissions) {
        return null;
    }
    webService static List<Contact> getResourcesWithExtraColumns(String userId, List<pse.PermissionControlManager.Permission> forPermissions, List<String> columnsToProject) {
        return null;
    }
    webService static List<Contact> getResources(String userId, List<pse.PermissionControlManager.Permission> forPermissions) {
        return null;
    }
global enum Permission {Billing, ExpenseEntry, ExpenseOpsEdit, Invoicing, ProjectVersionCompare, ProjectVersionCreate, ResourceRequestEntry, SkillAndCertificationsEntry, SkillAndCertificationsView, Staffing, TeamCreate, TeamEdit, TeamView, TimeCardEntry, TimecardOpsEdit}
global class RPGCollection {
    webService List<Id> groups {
        get;
        set;
    }
    webService List<Id> practices {
        get;
        set;
    }
    webService List<Id> regions {
        get;
        set;
    }
    global RPGCollection() {

    }
}
}
