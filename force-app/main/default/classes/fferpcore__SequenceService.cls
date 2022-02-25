/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SequenceService {
    global SequenceService() {

    }
    global static fferpcore.SequenceService.GetSequenceFieldsResponse getSequenceFields(Set<Schema.SObjectType> sObjectTypes) {
        return null;
    }
    global static void updateSequencesAsync(fferpcore.SequenceService.UpdateSequencesRequest request) {

    }
global interface GetSequenceFieldsResponse {
    List<Schema.SObjectField> getDisabledSequenceFields(Schema.SObjectType param0);
    List<Schema.SObjectField> getEnabledSequenceFields(Schema.SObjectType param0);
}
global class UpdateSequencesRequest {
    global Boolean AllowChunking {
        get;
        set;
    }
    global Boolean IsOverflow {
        get;
        set;
    }
    global Set<Id> RecordIds {
        get;
    }
    global UpdateSequencesRequest(Set<Id> recordIds) {

    }
}
}
