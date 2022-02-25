/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BillingDocumentService {
    global static String MESSAGE_TYPE_COMPLETION_COMPLETE;
    global static String MESSAGE_TYPE_COMPLETION_PROCESS;
    global static String MESSAGE_TYPE_COMPLETION_RESPONSE;
    global BillingDocumentService() {

    }
    global static fferpcore.BillingDocumentService.CalculateTaxResponse calculateTax(fferpcore.BillingDocumentService.CalculateTaxRequest request) {
        return null;
    }
    global static fferpcore.BillingDocumentService.CalculateTaxAsyncResponse calculateTaxAsync(fferpcore.BillingDocumentService.CalculateTaxAsyncRequest request) {
        return null;
    }
    global static Map<Id,fferpcore.BillingDocumentService.ProcessResult> completeDocuments(Set<Id> billingDocumentIds) {
        return null;
    }
    global static List<fferpcore.BillingDocumentService.DeriveDueDateResponse> deriveDueDate(List<fferpcore.BillingDocumentService.DeriveDueDateRequest> requests) {
        return null;
    }
    global static fferpcore.BillingDocumentService.GetTaxResponse getTax(fferpcore.BillingDocumentService.GetTaxRequest request) {
        return null;
    }
    global static fferpcore.BillingDocumentService.CalculateTaxValidationResponse validateForCalculateTax(fferpcore.BillingDocumentService.CalculateTaxValidationDocument request) {
        return null;
    }
    global static fferpcore.BillingDocumentService.CalculateTaxAsyncPermissionResponse verifyAsyncPermissionsForCalculateTax() {
        return null;
    }
    global static fferpcore.BillingDocumentService.CalculateTaxPermissionResponse verifyPermissionsForCalculateTax() {
        return null;
    }
global abstract class AbstractCalculateTaxPermissionResponse {
    global List<String> Errors {
        get;
    }
}
global abstract class AbstractCalculateTaxRequest {
    global Set<Id> BillingDocumentIds {
        get;
        set;
    }
}
global class CalculateTaxAsyncPermissionResponse extends fferpcore.BillingDocumentService.AbstractCalculateTaxPermissionResponse {
}
global class CalculateTaxAsyncRequest extends fferpcore.BillingDocumentService.AbstractCalculateTaxRequest {
    global CalculateTaxAsyncRequest() {

    }
}
global class CalculateTaxAsyncResponse {
    global Id BatchControlId {
        get;
    }
}
global class CalculateTaxPermissionResponse extends fferpcore.BillingDocumentService.AbstractCalculateTaxPermissionResponse {
}
global class CalculateTaxRequest extends fferpcore.BillingDocumentService.AbstractCalculateTaxRequest {
    global CalculateTaxRequest() {

    }
}
global class CalculateTaxResponse {
    global List<fferpcore.BillingDocumentService.CalculateTaxResult> Results {
        get;
    }
}
global class CalculateTaxResult {
    global Id DocumentId {
        get;
    }
    global List<String> Errors {
        get;
    }
}
global class CalculateTaxValidationDocument {
    global Id AccountId {
        get;
        set;
    }
    global Id CompanyId {
        get;
        set;
    }
    global Id CompanyTaxInformationId {
        get;
        set;
    }
    global Date DocumentDate {
        get;
        set;
    }
    global String Status {
        get;
        set;
    }
    global CalculateTaxValidationDocument() {

    }
}
global class CalculateTaxValidationResponse {
    global List<String> Errors {
        get;
    }
}
global class DeriveDueDateRequest {
    global Id AccountId {
        get;
        set;
    }
    global Id CompanyId {
        get;
        set;
    }
    global Date DocumentDate {
        get;
        set;
    }
    global fferpcore.BillingDocumentService.Type DocumentType {
        get;
        set;
    }
    global DeriveDueDateRequest() {

    }
}
global class DeriveDueDateResponse {
    global Date DueDate {
        get;
    }
    global Boolean IsSuccessful {
        get;
    }
    global DeriveDueDateResponse() {

    }
}
global class GetTaxLineResult {
    global String LineNo {
        get;
    }
    global Id TaxCode1Id {
        get;
    }
    global Id TaxCode2Id {
        get;
    }
    global Id TaxCode3Id {
        get;
    }
    global Decimal TaxRate1 {
        get;
    }
    global Decimal TaxRate2 {
        get;
    }
    global Decimal TaxRate3 {
        get;
    }
    global Decimal TaxValue1 {
        get;
    }
    global Decimal TaxValue2 {
        get;
    }
    global Decimal TaxValue3 {
        get;
    }
}
global class GetTaxRequest {
    global List<fferpcore.BillingDocumentService.TaxDocument> Documents {
        get;
        set;
    }
    global GetTaxRequest() {

    }
}
global class GetTaxResponse {
    global List<fferpcore.BillingDocumentService.GetTaxResult> Results {
        get;
    }
}
global class GetTaxResult {
    global List<String> Errors {
        get;
    }
    global List<fferpcore.BillingDocumentService.GetTaxLineResult> Lines {
        get;
    }
}
global class ProcessResult {
    global Id DocumentId {
        get;
    }
    global List<String> Messages {
        get;
    }
    global fferpcore.BillingDocumentService.ProcessState State {
        get;
    }
    global ProcessResult(Id documentId, fferpcore.BillingDocumentService.ProcessState state, List<String> messages) {

    }
}
global enum ProcessState {COMPLETE, FAILED, PENDING}
global class TaxAccount {
    global Id OutputTaxCodeId {
        get;
        set;
    }
    global fferpcore.AccountSalesTaxStatus.Status SalesTaxStatus {
        get;
        set;
    }
    global Id TaxCode1Id {
        get;
        set;
    }
    global Id TaxCode2Id {
        get;
        set;
    }
    global Id TaxCode3Id {
        get;
        set;
    }
    global String TaxCountryCode {
        get;
        set;
    }
    global String VatRegistrationNumber {
        get;
        set;
    }
    global fferpcore.AccountVatStatus.Status VatStatus {
        get;
        set;
    }
    global TaxAccount() {

    }
}
global class TaxCompany {
    global Id OutputTaxCodeId {
        get;
        set;
    }
    global String TaxCountryCode {
        get;
        set;
    }
    global Boolean VatGstGroup {
        get;
        set;
    }
    global String VatRegistrationNumber {
        get;
        set;
    }
    global TaxCompany() {

    }
}
global class TaxDocument {
    global fferpcore.BillingDocumentService.TaxAccount Account {
        get;
        set;
    }
    global fferpcore.BillingDocumentService.TaxCompany Company {
        get;
        set;
    }
    global Date DocumentDate {
        get;
        set;
    }
    global List<fferpcore.BillingDocumentService.TaxDocumentLine> Lines {
        get;
        set;
    }
    global String TaxType {
        get;
        set;
    }
    global TaxDocument() {

    }
}
global class TaxDocumentLine {
    global String LineNo {
        get;
        set;
    }
    global Decimal NetValue {
        get;
        set;
    }
    global fferpcore.BillingDocumentService.TaxProduct Product {
        get;
        set;
    }
    global Integer TaxValue1DecimalPrecision {
        get;
        set;
    }
    global Integer TaxValue2DecimalPrecision {
        get;
        set;
    }
    global Integer TaxValue3DecimalPrecision {
        get;
        set;
    }
    global TaxDocumentLine() {

    }
}
global class TaxProduct {
    global Id OutputTaxCodeId {
        get;
        set;
    }
    global fferpcore.ProductSalesTaxStatus.Status SalesTaxStatus {
        get;
        set;
    }
    global TaxProduct() {

    }
}
global enum Type {CreditNote, Invoice}
}
