/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class FeatureConsoleService {
    global FeatureConsoleService() {

    }
    global static fferpcore.FeatureConsoleService.ActivationResponse disable(Id recordId) {
        return null;
    }
    global static fferpcore.FeatureConsoleService.ActivationResponse disable(Id recordId, String options) {
        return null;
    }
    global static fferpcore.FeatureConsoleService.ActivationResponse enable(Id recordId) {
        return null;
    }
    global static fferpcore.FeatureConsoleService.ActivationResponse enable(Id recordId, String options) {
        return null;
    }
    global static List<fferpcore.FeatureConsoleService.LogLine> getLogLines(Set<String> qualifiedFeatureNames) {
        return null;
    }
    global static Map<String,Boolean> isFeatureEnabled(Set<String> qualifiedFeatureNames) {
        return null;
    }
    global static void log(fferpcore.FeatureConsoleService.LogRequest request) {

    }
    global static void markAsError(Boolean isEnable, Id recordId, Exception e) {

    }
    global static void markAsError(Boolean isEnable, Id recordId, System.LoggingLevel severity, String error) {

    }
    global static void markAsPerformed(Boolean isEnable, Id recordId, System.LoggingLevel severity) {

    }
    global static void markAsPerformed(Boolean isEnable, Id recordId, System.LoggingLevel severity, String memento) {

    }
    global static void markAsSuccess(Boolean isEnable, Id recordId) {

    }
    global static List<fferpcore.FeatureConsoleService.Step> readFeatureSteps(Set<String> qualifiedFeatureNames) {
        return null;
    }
    global static List<fferpcore.FeatureConsoleService.Step> readFeatureSteps(Set<String> qualifiedFeatureNames, fferpcore.FeatureConsoleService.ReadFeatureStepsOptions options) {
        return null;
    }
    global static List<fferpcore.FeatureConsoleService.Feature> readFeatures() {
        return null;
    }
    global static List<fferpcore.FeatureConsoleService.Feature> readFeatures(Set<String> qualifiedFeatureNames) {
        return null;
    }
    global static fferpcore.FeatureConsoleService.ActivationResponse revertSkip(Id recordId) {
        return null;
    }
    global static fferpcore.FeatureConsoleService.ActivationResponse skip(Id recordId) {
        return null;
    }
global class ActivationResponse {
    global List<String> Messages {
        get;
        set;
    }
    global Boolean PleaseResubmit {
        get;
        set;
    }
    global Boolean Success {
        get;
        set;
    }
    global ActivationResponse() {

    }
}
global class Feature {
    global Boolean IsActive {
        get;
        set;
    }
    global fferpcore__FeatureConsoleFeature__mdt Record {
        get;
        set;
    }
    global Feature() {

    }
    @Deprecated
    global Boolean getCanToggle() {
        return null;
    }
}
global class LogLine {
    global Integer ActivationNumber {
        get;
        set;
    }
    global String Feature {
        get;
        set;
    }
    global String Message {
        get;
        set;
    }
    global String Severity {
        get;
        set;
    }
    global String Step {
        get;
        set;
    }
    global LogLine() {

    }
}
global class LogRequest {
    global String Detail {
        get;
        set;
    }
    global Boolean IsEnable {
        get;
        set;
    }
    global Id RecordId {
        get;
        set;
    }
    global System.LoggingLevel Severity {
        get;
        set;
    }
    global LogRequest() {

    }
}
global class ReadFeatureStepsOptions {
    global Boolean ResolveLabels {
        get;
        set;
    }
    global ReadFeatureStepsOptions() {

    }
}
global class Step {
    global Boolean IsActive {
        get;
        set;
    }
    global fferpcore__FeatureConsoleFeatureStep__mdt Record {
        get;
        set;
    }
    global Step() {

    }
}
global class StepDescriptionLine {
}
global class StepRunnerConfig {
    global String Configuration {
        get;
        set;
    }
    global Boolean IsEnable {
        get;
        set;
    }
    global Boolean IsOptional {
        get;
        set;
    }
    global Boolean IsRevertDisabled {
        get;
        set;
    }
    global String Memento {
        get;
        set;
    }
    global Map<String,List<fferpcore__FeatureConsoleFeatureParameter__mdt>> ParamsByType {
        get;
        set;
    }
    global Id StepRecordId {
        get;
        set;
    }
    global String UserData {
        get;
        set;
    }
    global StepRunnerConfig() {

    }
    global Map<String,Object> getMementoDeserializedUntyped() {
        return null;
    }
}
}
