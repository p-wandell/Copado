/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MobileExpenseOfflineAPI {
    global MobileExpenseOfflineAPI() {

    }
    webService static void GenerateExpenseReport(List<pse.MobileExpenseOfflineAPI.ExpenseDetailInfo> expenses) {

    }
    webService static List<pse.MobileExpenseOfflineAPI.ResponseAdditionalFieldList> GetAdditionalFieldsInfo(String expAddFieldsAPINames, String repAddFieldsAPINames) {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.InitSyncResponse InitSyncAllData(pse.MobileExpenseOfflineAPI.InitSyncRequest initReq) {
        return null;
    }
    webService static List<pse.MobileExpenseOfflineAPI.SyncResponse> SyncAllData(pse.MobileExpenseOfflineAPI.SyncRequest req) {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.ExpAttach assignAttachment(Id expId, pse.MobileExpenseOfflineAPI.ExpenseAttachment expatt) {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.ExpFile assignFile(Id expId, pse.MobileExpenseOfflineAPI.ExpenseFile expFile) {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.ExpIsPhoto deleteAttachment(Id attachId) {
        return null;
    }
    webService static String deleteExpense(Id expId) {
        return null;
    }
    webService static String deleteExpenseReport(Id expRepId) {
        return null;
    }
    webService static void deleteFile(Id fileId) {

    }
    webService static List<Id> getAllDeletedExpenses() {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.AttachResponse getAttachments(pse.MobileExpenseOfflineAPI.AttachRequest req) {
        return null;
    }
    webService static List<Id> getDeletedExpensesInfo() {
        return null;
    }
    webService static List<Id> getDeletedExpenses() {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.FileResponse getExpenseFiles(Id expId) {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.AttachResponse getMoreAttachments(pse.MobileExpenseOfflineAPI.AttachRequest req) {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.InitSyncResponse saveAllRecords(pse.MobileExpenseOfflineAPI.InitSyncRequest request) {
        return null;
    }
    webService static List<pse.MobileExpenseOfflineAPI.Reports> saveExpenseReport(List<pse.MobileExpenseOfflineAPI.Reports> ExpReports) {
        return null;
    }
    webService static pse.MobileExpenseOfflineAPI.SyncResponse saveExpenses(pse.MobileExpenseOfflineAPI.SyncRequest request) {
        return null;
    }
global class AdditionalFields {
    @WebService
    webService String fieldLabel;
    @WebService
    webService String fieldName;
    @WebService
    webService String fieldType;
    @WebService
    webService String fieldValue;
    @WebService
    webService Boolean isInsertable;
    @WebService
    webService Boolean isUpdateable;
    @WebService
    webService String objectName;
    global AdditionalFields() {

    }
}
global class AssignmentInfo {
    @WebService
    webService String Account_Name;
    @WebService
    webService Id Assign_Id;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService String Nick_Name;
    @WebService
    webService Id Project_Id;
    @WebService
    webService String Project_Name;
    @WebService
    webService String Resource_Name;
    global AssignmentInfo() {

    }
}
global class AttachRequest {
    @WebService
    webService List<Id> AttachIds;
    @WebService
    webService String ExpId;
    global AttachRequest() {

    }
}
global class AttachResponse {
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseAttachment> Attachs;
    @WebService
    webService String ExpId;
    @WebService
    webService Boolean isError;
    global AttachResponse() {

    }
}
global class ERRelatedListResponse {
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.AssignmentInfo> Assignments;
    @WebService
    webService List<Id> DeletedRecords;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseDetailInfo> Expense_Lines;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.Reports> Expense_Reports;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseLimit> ExpenseLimits;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseLimitInfo> ExpenseLimitsInfo;
    @WebService
    webService String key;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.MilestoneInfo> Milestones;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.Picklist> pickLists;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ProjectInfo> Projects;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.MethodologyInfo> Projects_Methodologies;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.PhaseInfo> Projects_Phase;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ReferenceAdditional> RefAdditional;
    global ERRelatedListResponse() {

    }
}
global class ExpAttach {
    @WebService
    webService String AttachId;
    @WebService
    webService String ExpenseId;
    global ExpAttach() {

    }
}
global class ExpFile {
    @WebService
    webService String ExpenseId;
    @WebService
    webService String FileId;
    global ExpFile() {

    }
}
global class ExpIsPhoto {
    @WebService
    webService String attachId;
    @WebService
    webService String ExpeId;
    @WebService
    webService Boolean isPhoto;
    global ExpIsPhoto() {

    }
}
global class ExpenseAttachment {
    @WebService
    webService Id attachId;
    @WebService
    webService Blob body;
    @WebService
    webService String contentType;
    @WebService
    webService String Error;
    @WebService
    webService String fileName;
    @WebService
    webService Boolean isError;
    @WebService
    webService Id parentId;
    global ExpenseAttachment() {

    }
}
global class ExpenseDetail {
    @WebService
    webService String account;
    @WebService
    webService Id accountId;
    @WebService
    webService String CurrencyIsoCode;
    @WebService
    webService List<Id> DeletedAttachs;
    @WebService
    webService String description;
    @WebService
    webService Double distance;
    @WebService
    webService String Error;
    @WebService
    webService Decimal expenseAmount;
    @WebService
    webService Date expenseDate;
    @WebService
    webService Id expenseId;
    @WebService
    webService String expenseNumber;
    @WebService
    webService Id expenseReport;
    @WebService
    webService String expenseType;
    @WebService
    webService String expRepName;
    @WebService
    webService String ExpStatus;
    @WebService
    webService String ExternalId;
    @WebService
    webService Boolean isAutoMileage;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService Boolean isError;
    @WebService
    webService Boolean isPhotoAttached;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseAttachment> list_attach;
    @WebService
    webService String notes;
    @WebService
    webService Id ProjectId;
    @WebService
    webService String rateUnit;
    global ExpenseDetail() {

    }
}
global class ExpenseDetailInfo {
    @WebService
    webService String account;
    @WebService
    webService Id accountId;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.AdditionalFields> AdditionalFields;
    @WebService
    webService Id AssignmentId;
    @WebService
    webService String AssignmentName;
    @WebService
    webService String CurrencyIsoCode;
    @WebService
    webService List<Id> DeletedAttachs;
    @WebService
    webService String description;
    @WebService
    webService Double distance;
    @WebService
    webService String Error;
    @WebService
    webService Decimal expenseAmount;
    @WebService
    webService Date expenseDate;
    @WebService
    webService Id expenseId;
    @WebService
    webService String expenseNumber;
    @WebService
    webService String expenseReport;
    @WebService
    webService String expenseType;
    @WebService
    webService String expRepName;
    @WebService
    webService String ExpStatus;
    @WebService
    webService String ExternalId;
    @WebService
    webService Boolean isAutoMileage;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService Boolean isError;
    @WebService
    webService Boolean isPhotoAttached;
    @WebService
    webService Datetime LastModifiedDate;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseAttachment> list_attach;
    @WebService
    webService String notes;
    @WebService
    webService Id ProjectId;
    @WebService
    webService String ProjectName;
    @WebService
    webService String rateUnit;
    global ExpenseDetailInfo() {

    }
}
global class ExpenseFile {
    @WebService
    webService Blob Body;
    @WebService
    webService String ContentType;
    @WebService
    webService Id FileId;
    @WebService
    webService String FileName;
    @WebService
    webService Id ParentId;
    global ExpenseFile() {

    }
}
global class ExpenseLimit {
    @WebService
    webService Id ExpLimId;
    @WebService
    webService String ExpType;
    @WebService
    webService Id ProjectId;
    @WebService
    webService Boolean Rate;
    global ExpenseLimit() {

    }
}
global class ExpenseLimitInfo {
    @WebService
    webService Boolean Cascading;
    @WebService
    webService Id ExpLimId;
    @WebService
    webService String ExpType;
    @WebService
    webService Id Lim_Group;
    @WebService
    webService Id Lim_Practice;
    @WebService
    webService Id Lim_Region;
    @WebService
    webService Id ProjectId;
    @WebService
    webService Boolean Rate;
    @WebService
    webService String RateUnit;
    global ExpenseLimitInfo() {

    }
}
global class ExpenseReport {
    @WebService
    webService String accountName;
    @WebService
    webService String assignmentName;
    @WebService
    webService Decimal billableAmount;
    @WebService
    webService Id exp_Id;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService Decimal nonBillableAmount;
    @WebService
    webService String projectName;
    @WebService
    webService Id ProjId;
    @WebService
    webService String reportName;
    @WebService
    webService String resourceName;
    @WebService
    webService String status;
    global ExpenseReport() {

    }
}
global class FileResponse {
    @WebService
    webService String ExpId;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseFile> Files;
    global FileResponse() {

    }
}
global class InitSyncRequest {
    @WebService
    webService List<Id> DeletedExpenses;
    @WebService
    webService List<Id> DeletedReports;
    @WebService
    webService String ExpAdditionalFieldsAPIs;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseDetailInfo> expenses;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseDetailInfo> GenerateERExpenses;
    @WebService
    webService Boolean isManualSync;
    @WebService
    webService String LastSyncTime;
    @WebService
    webService List<Id> ProjIdsForMilestones;
    @WebService
    webService String RepAdditionalFieldsAPIs;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.Reports> reports;
    global InitSyncRequest() {

    }
}
global class InitSyncResponse {
    @WebService
    webService String CurrentSyncTime;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ERRelatedListResponse> ERRelatedList;
    @WebService
    webService Boolean isCallBack;
    @WebService
    webService Boolean isConfigChanged;
    @WebService
    webService Boolean isFieldSets;
    @WebService
    webService String UserLocale;
    global InitSyncResponse() {

    }
}
global class MethodologyInfo {
    @WebService
    webService Id methodologyId;
    @WebService
    webService String methodologyName;
    @WebService
    webService Id Proj_Id;
    global MethodologyInfo() {

    }
}
global class MilestoneInfo {
    @WebService
    webService Id milestoneId;
    @WebService
    webService String milestoneName;
    @WebService
    webService Id Proj_Id;
    global MilestoneInfo() {

    }
}
global class PhaseInfo {
    @WebService
    webService Id phaseId;
    @WebService
    webService String phaseName;
    @WebService
    webService Id Proj_Id;
    global PhaseInfo() {

    }
}
global class Picklist {
    @WebService
    webService String key;
    @WebService
    webService List<String> values;
    global Picklist() {

    }
}
global class ProjectInfo {
    @WebService
    webService String Account_Name;
    @WebService
    webService Boolean isAllowedForExpense;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService String proj_Currency;
    @WebService
    webService Id Proj_Group;
    @WebService
    webService String proj_Group_Chain;
    @WebService
    webService String proj_Id_Chain;
    @WebService
    webService Id Proj_Practice;
    @WebService
    webService String proj_Practice_Chain;
    @WebService
    webService Id Proj_Region;
    @WebService
    webService String proj_Region_Chain;
    @WebService
    webService Id Project_Id;
    @WebService
    webService String Project_Name;
    @WebService
    webService String Resource_Name;
    global ProjectInfo() {

    }
}
global class ReferenceAdditional {
    @WebService
    webService Id recId;
    @WebService
    webService String recName;
    global ReferenceAdditional() {

    }
}
global class Reports {
    @WebService
    webService String accountName;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.AdditionalFields> AdditionalFields;
    @WebService
    webService Boolean Approved;
    @WebService
    webService String assignmentId;
    @WebService
    webService Datetime CreatedDate;
    @WebService
    webService String Description;
    @WebService
    webService String Error;
    @WebService
    webService String ExternalId;
    @WebService
    webService Boolean IncludeFinancials;
    @WebService
    webService Boolean isBillable;
    @WebService
    webService Boolean isError;
    @WebService
    webService Datetime LastModifiedDate;
    @WebService
    webService Id Milestone_Id;
    @WebService
    webService Id Proj_Methodology_Id;
    @WebService
    webService Id Proj_Phase_Id;
    @WebService
    webService Id ProjId;
    @WebService
    webService Decimal Reimbursement_Amount;
    @WebService
    webService String Reimbursement_Currency;
    @WebService
    webService Id Rep_Id;
    @WebService
    webService String reportName;
    @WebService
    webService String resourceName;
    @WebService
    webService String status;
    @WebService
    webService Boolean Submitted;
    @WebService
    webService Decimal Total_Bill_Amount;
    global Reports() {

    }
}
global class ResponseAdditionalFieldList {
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.AdditionalFields> additionalFieldList;
    @WebService
    webService String fieldsAPIs;
    @WebService
    webService String ObjectNameKey;
    global ResponseAdditionalFieldList() {

    }
}
global class SyncRequest {
    @WebService
    webService Id contactId;
    @WebService
    webService List<Id> DeletedRecords;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseDetail> Expense;
    @WebService
    webService String LastSyncTime;
    @WebService
    webService List<Id> ProjectIds;
    global SyncRequest() {

    }
}
global class SyncResponse {
    @WebService
    webService String CurrentSyncTime;
    @WebService
    webService List<Id> DeletedRecords;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseDetail> Expense;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseLimit> ExpenseLimits;
    @WebService
    webService String key;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.Picklist> pickLists;
    @WebService
    webService List<pse.MobileExpenseOfflineAPI.ExpenseReport> reports;
    global SyncResponse() {

    }
}
}
