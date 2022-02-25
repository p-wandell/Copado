/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class InquiryTemplateService {
    global static ffr.InquiryTemplateService.InquiryTemplateBag exportBag(Set<Id> templatesToExport) {
        return null;
    }
    global static List<ffr.InquiryTemplateService.InquiryTemplateBaggage> getAvailableForExport() {
        return null;
    }
    global static List<ffr.InquiryTemplateService.InquiryTemplateAvailableRCP> getAvailableRCPs(ffr.DataViewService.DataView dataview) {
        return null;
    }
    global static ffr.InquiryTemplateService.InquiryTemplateImportsIgnored importBag(ffr.InquiryTemplateService.InquiryTemplateBag bag) {
        return null;
    }
    global static List<ffr.InquiryTemplateService.InquiryTemplate> load(Set<Id> ids) {
        return null;
    }
    global static List<ffr.InquiryTemplateService.InquiryTemplate> save(List<ffr.InquiryTemplateService.InquiryTemplate> templates) {
        return null;
    }
global class BasisDateType {
    global String id {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global BasisDateType() {

    }
    global BasisDateType(String id, String name) {

    }
}
global class InquiryTemplate {
    global Decimal AxisAMaximum {
        get;
        set;
    }
    global Integer AxisARotate {
        get;
        set;
    }
    global String AxisASort {
        get;
        set;
    }
    global Decimal AxisBMaximum {
        get;
        set;
    }
    global Integer AxisBRotate {
        get;
        set;
    }
    global String AxisBSort {
        get;
        set;
    }
    global String BasePeriod {
        get;
        set;
    }
    global String ChartAxisA {
        get;
        set;
    }
    global String ChartAxisB {
        get;
        set;
    }
    global String ChartAxisC {
        get;
        set;
    }
    global String ChartLabelType {
        get;
        set;
    }
    global String ChartMode {
        get;
        set;
    }
    global String ChartScaling {
        get;
        set;
    }
    global String ChartType {
        get;
        set;
    }
    global Boolean ChartView {
        get;
        set;
    }
    global Boolean ColumnFilterDrill {
        get;
        set;
    }
    global ffr.CommonService.Identity Dataview {
        get;
        set;
    }
    global Boolean IncludeRowFilterWhenDrillDestination {
        get;
        set;
    }
    global Boolean PromptBasePeriod {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateRCP> RelatedContentPanes {
        get;
        set;
    }
    global Boolean ShowDocumentCount {
        get;
        set;
    }
    global Id SummarizationTemplateId {
        get;
        set;
    }
    global String SummarizationTemplateName {
        get;
        set;
    }
    global Boolean SummarizeDuplicateRows {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateColumn> TemplateColumns {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateCommonName> TemplateCommonNames {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateExcludedAction> TemplateExcludedActions {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateFilter> TemplateFilters {
        get;
        set;
    }
    global Id TemplateId {
        get;
        set;
    }
    global String TemplateName {
        get;
        set;
    }
    global Boolean TemplateSignFilterCosmetic {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateSignFilter> TemplateSignFilters {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateSortItem> TemplateSortItems {
        get;
        set;
    }
    global Boolean UseCurrentPeriod {
        get;
        set;
    }
    global InquiryTemplate() {

    }
    global InquiryTemplate(ffr__InquiryTemplate__c sObj, ffr.CommonService.Identity view) {

    }
    global ffr__InquiryTemplate__c createSObject() {
        return null;
    }
}
global class InquiryTemplateAvailableRCP {
    global String DrivingEntity {
        get;
        set;
    }
    global ffr.CommonService.Identity Rcp {
        get;
        set;
    }
    global InquiryTemplateAvailableRCP() {

    }
    global InquiryTemplateAvailableRCP(ffr__RelatedContentPane__c pane) {

    }
}
global class InquiryTemplateBag {
    global List<ffr.DataViewService.DataView> Dataviews {
        get;
        set;
    }
    global Decimal FFRVersion {
        get;
    }
    global List<ffr.RelatedContentPaneService.Pane> Rcps {
        get;
        set;
    }
    global List<String> Selected {
        get;
        set;
    }
    global List<ffr.SummarizationService.SummarizationTemplate> SummarizationTemplates {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplate> Templates {
        get;
        set;
    }
    global InquiryTemplateBag() {

    }
}
global class InquiryTemplateBaggage {
    global ffr.CommonService.Identity Dataview {
        get;
        set;
    }
    global List<ffr.CommonService.Identity> DependantRcps {
        get;
        set;
    }
    global List<ffr.CommonService.Identity> DependantTemplates {
        get;
        set;
    }
    global ffr.CommonService.Identity SummarizationTemplate {
        get;
        set;
    }
    global ffr.CommonService.Identity SummarizationTemplateDataview {
        get;
        set;
    }
    global ffr.CommonService.Identity Template {
        get;
        set;
    }
    global InquiryTemplateBaggage() {

    }
}
global class InquiryTemplateColumn {
    global Boolean CalculateFormulaOnSummary {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateColumnFilter> ColumnFilters {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateColumnFormula> ColumnFormula {
        get;
        set;
    }
    global Id ColumnId {
        get;
        set;
    }
    global Decimal ColumnWidth {
        get;
        set;
    }
    global String Condition {
        get;
        set;
    }
    global String ConditionFalseFillColor {
        get;
        set;
    }
    global String ConditionFalseTextColor {
        get;
        set;
    }
    global String ConditionToValue {
        get;
        set;
    }
    global String ConditionTrueFillColor {
        get;
        set;
    }
    global String ConditionTrueTextColor {
        get;
        set;
    }
    global String ConditionValue {
        get;
        set;
    }
    global Decimal DecimalPlaces {
        get;
        set;
    }
    global String DisplayName {
        get;
        set;
    }
    global Decimal DisplayOrder {
        get;
        set;
    }
    global ffr.CommonService.Identity Drill {
        get;
        set;
    }
    global ffr.CommonService.Identity Field {
        get;
        set;
    }
    global Decimal FormulaDp {
        get;
        set;
    }
    global Boolean Hidden {
        get;
        set;
    }
    global String Mode {
        get;
        set;
    }
    global String NegativeFillColor {
        get;
        set;
    }
    global String NegativeNumberFormat {
        get;
        set;
    }
    global String NegativeTextColor {
        get;
        set;
    }
    global String PositiveFillColor {
        get;
        set;
    }
    global String PositiveTextColor {
        get;
        set;
    }
    global String Scaling {
        get;
        set;
    }
    global Boolean ShowNumberSeparators {
        get;
        set;
    }
    global List<ffr.InquiryTemplateService.InquiryTemplateTransposeDrill> TransposeDrills {
        get;
        set;
    }
    global Id TransposeSwitchFieldId {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
    global String ValueType {
        get;
        set;
    }
    global InquiryTemplateColumn() {

    }
    global InquiryTemplateColumn(ffr__InquiryTemplateColumn__c sObj, ffr.CommonService.Identity aField, ffr.CommonService.Identity aDrill) {

    }
    global ffr__InquiryTemplateColumn__c createSObject() {
        return null;
    }
}
global class InquiryTemplateColumnFilter {
    global Decimal ClosingBrackets {
        get;
        set;
    }
    global String CombineType {
        get;
        set;
    }
    global String Field {
        get;
        set;
    }
    global String FieldId {
        get;
        set;
    }
    global Id FilterId {
        get;
        set;
    }
    global String FromValue {
        get;
        set;
    }
    global String Name {
        get;
    }
    global Decimal OpeningBrackets {
        get;
        set;
    }
    global String Operator {
        get;
        set;
    }
    global Boolean Prompt {
        get;
        set;
    }
    global String ToValue {
        get;
        set;
    }
    global InquiryTemplateColumnFilter() {

    }
    global InquiryTemplateColumnFilter(ffr__InquiryTemplateColumnFilter__c sObj, ffr.CommonService.Identity theField) {

    }
    global ffr__InquiryTemplateColumnFilter__c createSObject(Id fieldId) {
        return null;
    }
}
global class InquiryTemplateColumnFormula {
    global Decimal ClosingBrackets {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global Decimal LiteralValue {
        get;
        set;
    }
    global Decimal OpeningBrackets {
        get;
        set;
    }
    global String Operator {
        get;
        set;
    }
    global String SourceColumn {
        get;
        set;
    }
    global Id SourceColumnId {
        get;
        set;
    }
    global String SourceField {
        get;
        set;
    }
    global Id SourceFieldId {
        get;
        set;
    }
    global InquiryTemplateColumnFormula() {

    }
    global InquiryTemplateColumnFormula(ffr__InquiryTemplateColumnFormula__c sObj) {

    }
    global ffr__InquiryTemplateColumnFormula__c createSObject() {
        return null;
    }
}
global class InquiryTemplateCommonName {
    global ffr.CommonService.Identity Field {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global InquiryTemplateCommonName() {

    }
    global InquiryTemplateCommonName(ffr__InquiryTemplateCommonName__c sObj) {

    }
    global ffr__InquiryTemplateCommonName__c createSObject() {
        return null;
    }
}
global class InquiryTemplateExcludedAction {
    global Id DataViewActionId {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global InquiryTemplateExcludedAction() {

    }
    global InquiryTemplateExcludedAction(ffr__InquiryTemplateExcludedAction__c sObj) {

    }
    global ffr__InquiryTemplateExcludedAction__c createSObject(Id DataViewActionId) {
        return null;
    }
}
global class InquiryTemplateFilter {
    global Decimal ClosingBrackets {
        get;
        set;
    }
    global String CombineType {
        get;
        set;
    }
    global String Field {
        get;
        set;
    }
    global Id FilterId {
        get;
        set;
    }
    global String FromValue {
        get;
        set;
    }
    global String Name {
        get;
    }
    global Decimal OpeningBrackets {
        get;
        set;
    }
    global String Operator {
        get;
        set;
    }
    global Boolean Prompt {
        get;
        set;
    }
    global String ToValue {
        get;
        set;
    }
    global InquiryTemplateFilter() {

    }
    global InquiryTemplateFilter(ffr__InquiryTemplateFilter__c sObj, ffr.CommonService.Identity theField) {

    }
    global ffr__InquiryTemplateFilter__c createSObject(Id fieldId) {
        return null;
    }
}
global class InquiryTemplateImportsIgnored {
    global List<ffr.CommonService.Identity> Dataview {
        get;
        set;
    }
    global List<ffr.CommonService.Identity> RelatedContentPane {
        get;
        set;
    }
    global List<ffr.CommonService.Identity> SummarizationTemplate {
        get;
        set;
    }
    global List<ffr.CommonService.Identity> Template {
        get;
        set;
    }
    global InquiryTemplateImportsIgnored() {

    }
}
global class InquiryTemplateRCP {
    global ffr.CommonService.Identity DataviewField {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global Boolean IsDefault {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global ffr.CommonService.Identity Rcp {
        get;
        set;
    }
    global InquiryTemplateRCP() {

    }
    global InquiryTemplateRCP(ffr__InquiryTemplateRCP__c sObj) {

    }
    global ffr__InquiryTemplateRCP__c createSObject() {
        return null;
    }
}
global class InquiryTemplateSignFilter {
    global Decimal ClosingBrackets {
        get;
        set;
    }
    global String CombineType {
        get;
        set;
    }
    global String Field {
        get;
        set;
    }
    global String FieldId {
        get;
        set;
    }
    global Id FilterId {
        get;
        set;
    }
    global String FromValue {
        get;
        set;
    }
    global String Name {
        get;
    }
    global Decimal OpeningBrackets {
        get;
        set;
    }
    global String Operator {
        get;
        set;
    }
    global Boolean Prompt {
        get;
        set;
    }
    global String ToValue {
        get;
        set;
    }
    global InquiryTemplateSignFilter() {

    }
    global InquiryTemplateSignFilter(ffr__InquiryTemplateSignFilter__c sObj, ffr.CommonService.Identity theField) {

    }
    global ffr__InquiryTemplateSignFilter__c createSObject(Id fieldId) {
        return null;
    }
}
global class InquiryTemplateSortItem {
    global String Column {
        get;
        set;
    }
    global Id ColumnId {
        get;
        set;
    }
    global Boolean GroupBy {
        get;
        set;
    }
    global Boolean HideDetails {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global String Order {
        get;
        set;
    }
    global Boolean UsePicklistOrder {
        get;
        set;
    }
    global InquiryTemplateSortItem() {

    }
    global InquiryTemplateSortItem(ffr__InquiryTemplateSortItem__c sObj) {

    }
    global ffr__InquiryTemplateSortItem__c createSObject() {
        return null;
    }
}
global class InquiryTemplateTransposeDrill {
    global ffr.CommonService.Identity DrillTemplate {
        get;
        set;
    }
    global ffr.CommonService.Identity Field {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global String TransposeItemValue {
        get;
        set;
    }
    global InquiryTemplateTransposeDrill() {

    }
    global InquiryTemplateTransposeDrill(ffr__InquiryTemplateTransposeDrill__c sObj, ffr.CommonService.Identity fieldIdentity, ffr.CommonService.Identity drillTemplateIdentity) {

    }
    global ffr__InquiryTemplateTransposeDrill__c createSObject() {
        return null;
    }
}
}
