/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MobileExpenseAPI {
    global MobileExpenseAPI() {

    }
    webService static pse.MobileExpenseAPI.ExpenseDetail assignAttachment(Id expId, pse.MobileExpenseAPI.ExpenseAttachment expatt) {
        return null;
    }
    webService static String deleteAttachment(Id attachId) {
        return null;
    }
    webService static String deleteExpense(Id expId) {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.ExpenseReport> getAllExpenseReport() {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.ExpenseAttachment> getAttachmentsForExpense(Id expid) {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.RateUnit> getDistanceRateUnits() {
        return null;
    }
    webService static pse.MobileExpenseAPI.ExpenseDetail getExpenseDetail(Id expenseId) {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.ExpenseInfo> getExpensesList(pse.MobileExpenseAPI.GetExpenseWrapper gew) {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.CurrencyCode> getListOfCurrencyCode() {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.ExpenseType> getListOfExpenseType() {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.ExpenseInfo> saveExpense(pse.MobileExpenseAPI.ExpenseDetail exp) {
        return null;
    }
    webService static List<pse.MobileExpenseAPI.ExpenseInfo> sendClientUpdatedExpenseList(pse.MobileExpenseAPI.GetExpenseWrapper gew) {
        return null;
    }
global class CurrencyCode {
    @WebService
    webService String currencyCode;
    global CurrencyCode() {

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
    webService String fileName;
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
    webService String description;
    @WebService
    webService Double distance;
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
    webService Boolean isBillable;
    @WebService
    webService List<pse.MobileExpenseAPI.ExpenseAttachment> list_attach;
    @WebService
    webService String notes;
    @WebService
    webService String rateUnit;
    global ExpenseDetail() {

    }
}
global class ExpenseInfo {
    @WebService
    webService String account;
    @WebService
    webService Id accountId;
    @WebService
    webService String CurrencyIsoCode;
    @WebService
    webService String description;
    @WebService
    webService Double distance;
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
    webService Boolean isPhotoAttached;
    @WebService
    webService String rateUnit;
    global ExpenseInfo() {

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
    webService String reportName;
    @WebService
    webService String resourceName;
    @WebService
    webService String status;
    global ExpenseReport() {

    }
}
global class ExpenseType {
    @WebService
    webService String expensetype;
    global ExpenseType() {

    }
}
global class GetExpenseWrapper {
    @WebService
    webService Id contactId;
    @WebService
    webService List<Id> listExistingId;
    global GetExpenseWrapper() {

    }
}
global class RateUnit {
    @WebService
    webService String rateUnit;
    global RateUnit() {

    }
}
}
