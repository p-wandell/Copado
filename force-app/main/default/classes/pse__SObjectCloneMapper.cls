/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class SObjectCloneMapper {
    global Set<pse.SObjectCloneMapper.Field> SObjectFieldsToClone {
        get;
    }
    global Set<Id> SObjectRecordIdsToClone;
    global Schema.SObjectType SObjectTypeToClone {
        get;
        set;
    }
    global SObjectCloneMapper(Schema.SObjectType sObjectTypeToClone, Set<pse.SObjectCloneMapper.Field> sObjectFieldsToClone) {

    }
global class Field {
    global Object DefaultValue;
    global Field(Schema.SObjectField field) {

    }
}
global class NullFieldValue {
    global NullFieldValue() {

    }
}
}
