/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class VersionConfigService {
    global static void deleteVersionConfigDetails(List<Id> configIds) {

    }
    global static pse__Version_Config__c getActiveVersionConfig() {
        return null;
    }
    global static List<pse.VersionConfigService.VersionConfigDetails> getAllVersionConfigDetails() {
        return null;
    }
    global static pse__Version_Config__c getConfigById(Id configId) {
        return null;
    }
    global static pse.VersionConfigService.VersionCaptureConfig getVersionCaptureConfigById(Id configId) {
        return null;
    }
    global static pse.VersionConfigService.VersionCaptureConfig saveCaptureConfig(Id configId, pse.VersionConfigService.VersionCaptureConfig toSave) {
        return null;
    }
    global static List<pse.VersionConfigService.VersionConfigDetails> saveVersionConfigDetails(List<pse.VersionConfigService.VersionConfigDetails> details) {
        return null;
    }
    global static List<pse.VersionConfigService.ValidationResult> validateCaptureConfig(List<Id> configIds) {
        return null;
    }
    global static List<pse.VersionConfigService.ValidationResult> validateCaptureConfig(List<pse.VersionConfigService.VersionCaptureConfig> captureConfigs) {
        return null;
    }
global class ValidationFailure {
    global String DestinationLabel;
    global String DestinationName;
    global String ErrorMessage;
    global String FieldLabel;
    global String FieldName;
    global String OriginatorLabel;
    global String OriginatorName;
    global ValidationFailure() {

    }
}
global class ValidationResult {
    global List<pse.VersionConfigService.ValidationFailure> FailedRecords;
    global Boolean HasFailed {
        get;
    }
    global ValidationResult() {

    }
}
global class VersionCaptureConfig {
    global List<pse.VersionConfigService.VersionCaptureObject> VersionedObjects;
    global VersionCaptureConfig() {

    }
}
global class VersionCaptureField {
    global String DestinationFieldAPIName;
    global String OriginatorFieldAPIName;
    global VersionCaptureField() {

    }
}
global class VersionCaptureObject {
    global String DestinationAPIName;
    global String DestinationVersionLookupFieldAPIName;
    global String OriginalIdField;
    global String OriginatorAPIName;
    global String OriginatorProjectLookupFieldAPIName;
    global List<pse.VersionConfigService.VersionCaptureField> VersionedFields;
    global VersionCaptureObject() {

    }
}
global class VersionConfigDetails {
    global Id ConfigId;
    global Boolean IsDefault;
    global Datetime LastModifiedDate;
    global String Name;
    global String Summary;
    global VersionConfigDetails() {

    }
}
}
