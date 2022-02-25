/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TaxCalculationService {
    global TaxCalculationService() {

    }
    global static fferpcore.TaxCalculationService.ReversalResponse calculateReversal(fferpcore.TaxCalculationService.CreditDocument document) {
        return null;
    }
    global static fferpcore.TaxCalculationService.TaxResponse calculateTax(fferpcore.TaxCalculationService.TaxDocument document) {
        return null;
    }
    global static fferpcore.TaxCalculationService.ReversalResponse commitReversal(fferpcore.TaxCalculationService.CreditDocument document) {
        return null;
    }
    global static fferpcore.TaxCalculationService.TaxResponse commitTax(fferpcore.TaxCalculationService.TaxDocument document) {
        return null;
    }
    global static fferpcore.Disposable createWorkScope() {
        return null;
    }
    global static fferpcore.TaxCalculationService.Settings getSettings() {
        return null;
    }
    global static Boolean isEnabled() {
        return null;
    }
    global static fferpcore.TaxCalculationService.SaveSettingsResponse saveSettings(fferpcore.TaxCalculationService.Settings settings) {
        return null;
    }
    global static fferpcore.TaxCalculationService.TestConnectionResponse testConnection(fferpcore.TaxCalculationService.Settings settings) {
        return null;
    }
    global static fferpcore.TaxCalculationService.ValidateAddressResponse validateAddress(fferpcore.TaxCalculationService.Address address) {
        return null;
    }
    global static fferpcore.TaxCalculationService.VoidResponse voidReversal(fferpcore.TaxCalculationService.VoidRequest request) {
        return null;
    }
    global static fferpcore.TaxCalculationService.VoidResponse voidTax(fferpcore.TaxCalculationService.VoidRequest request) {
        return null;
    }
global virtual class Address {
    global String City {
        get;
        set;
    }
    global String Country {
        get;
        set;
    }
    global String Line1 {
        get;
        set;
    }
    global String Line2 {
        get;
        set;
    }
    global String Line3 {
        get;
        set;
    }
    global String PostalCode {
        get;
        set;
    }
    global String Region {
        get;
        set;
    }
    global Address() {

    }
}
global class CreditDocument extends fferpcore.TaxCalculationService.TaxDocument {
    global String ReferenceCode {
        get;
        set;
    }
    global CreditDocument() {

    }
}
global virtual class DocumentIdentity {
    global String CompanyCode {
        get;
        set;
    }
    global String DocumentCode {
        get;
        set;
    }
    global DocumentIdentity() {

    }
    global DocumentIdentity(String companyCode, String documentCode) {

    }
}
global virtual class Response {
    global List<fferpcore.Message> Messages {
        get;
        set;
    }
    global Boolean Success {
        get;
        set;
    }
}
global class ReversalResponse extends fferpcore.TaxCalculationService.TaxResponse {
    global ReversalResponse() {

    }
}
global class SaveSettingsResponse extends fferpcore.TaxCalculationService.Response {
    global Boolean Validated {
        get;
        set;
    }
    global SaveSettingsResponse() {

    }
    global SaveSettingsResponse(fferpcore.TaxCalculationService.TestConnectionResponse response) {

    }
}
global class Settings {
    global Boolean DisableCommit {
        get;
        set;
    }
    global Boolean Enabled {
        get;
        set;
    }
    global String General {
        get;
        set;
    }
    global String Provider {
        get;
        set;
    }
    global String Secret {
        get;
        set;
    }
    global Boolean SecretSpecified {
        get;
    }
    global Settings() {

    }
}
global virtual class TaxDocument extends fferpcore.TaxCalculationService.DocumentIdentity {
    global String BusinessIdentifier {
        get;
        set;
    }
    global String ClientName {
        get;
        set;
    }
    global System.Version ClientVersion {
        get;
        set;
    }
    global String CurrencyISOCode {
        get;
        set;
    }
    global String CustomerCode {
        get;
        set;
    }
    global String CustomerUsageType {
        get;
        set;
    }
    global Decimal Discount {
        get;
        set;
    }
    global Date DocumentDate {
        get;
        set;
    }
    global String ExemptionNumber {
        get;
        set;
    }
    global List<fferpcore.TaxCalculationService.TaxRequestLine> Lines {
        get;
        set;
    }
    global String LocationCode {
        get;
        set;
    }
    global String PurchaseOrderNumber {
        get;
        set;
    }
    global fferpcore.TaxCalculationService.Address ShipFromAddress {
        get;
        set;
    }
    global fferpcore.TaxCalculationService.Address ShipToAddress {
        get;
        set;
    }
    global Date TaxDate {
        get;
        set;
    }
    global TaxDocument() {

    }
}
global class TaxRequestLine {
    global Decimal Amount {
        get;
        set;
    }
    global String Description {
        get;
        set;
    }
    global Boolean Discounted {
        get;
        set;
    }
    global String ItemCode {
        get;
        set;
    }
    global String LineNo {
        get;
        set;
    }
    global Decimal Qty {
        get;
        set;
    }
    global String TaxCode {
        get;
        set;
    }
    global TaxRequestLine() {

    }
}
global virtual class TaxResponse extends fferpcore.TaxCalculationService.Response {
    global Boolean Committed {
        get;
        set;
    }
    global List<fferpcore.TaxCalculationService.TaxResponseLine> TaxLines {
        get;
        set;
    }
    global TaxResponse() {

    }
}
global class TaxResponseLine {
    global Decimal Discount {
        get;
        set;
    }
    global Decimal Exemption {
        get;
        set;
    }
    global String LineNo {
        get;
        set;
    }
    global Decimal Rate {
        get;
        set;
    }
    global Decimal Tax {
        get;
        set;
    }
    global Decimal Taxable {
        get;
        set;
    }
    global TaxResponseLine() {

    }
}
global class TestConnectionResponse extends fferpcore.TaxCalculationService.Response {
}
global class ValidateAddressResponse extends fferpcore.TaxCalculationService.Response {
    global fferpcore.TaxCalculationService.ValidatedAddress Address {
        get;
        set;
    }
}
global class ValidatedAddress extends fferpcore.TaxCalculationService.Address {
    global String AddressType {
        get;
        set;
    }
    global String CarrierRoute {
        get;
        set;
    }
    global String County {
        get;
        set;
    }
    global String FipsCode {
        get;
        set;
    }
    global String PostNet {
        get;
        set;
    }
    global String TaxRegionId {
        get;
        set;
    }
    global ValidatedAddress() {

    }
}
global class VoidRequest {
    global fferpcore.TaxCalculationService.DocumentIdentity Document {
        get;
        set;
    }
    global fferpcore.TaxCalculationService.VoidRequestReason Reason {
        get;
        set;
    }
    global VoidRequest(fferpcore.TaxCalculationService.DocumentIdentity document, fferpcore.TaxCalculationService.VoidRequestReason reason) {

    }
    global VoidRequest(String companyCode, String documentCode, fferpcore.TaxCalculationService.VoidRequestReason reason) {

    }
}
global enum VoidRequestReason {ADJUSTMENT_CANCELLED, DOCUMENT_DELETED, DOCUMENT_VOIDED, POST_FAILED, UNSPECIFIED}
global class VoidResponse extends fferpcore.TaxCalculationService.Response {
    global VoidResponse() {

    }
}
}
