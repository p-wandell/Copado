/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class SObjectByIdDataSource extends fferpcore.DataSourceBase implements fferpcore.DataSourceBase.OneToManyRelatedDataSource, fferpcore.DataSourceBase.RelatedDataSource {
    global SObjectByIdDataSource(Schema.SObjectType objectType) {

    }
    global SObjectByIdDataSource(Schema.SObjectType objectType, Set<Id> objectIds) {

    }
    global fferpcore.DataSource asDataSource() {
        return null;
    }
    global virtual fferpcore.DataSourceBase.OneToManyQueryResult createOneToManyQueryResult(Schema.SObjectField foreignKeyField, fferpcore.DataSourceBase.DirectQueryResult directResult, Map<Schema.SObjectField,fferpcore.DataSourceBase.RelatedQueryResult> relatedResult, Map<fferpcore.DataSource.BackReference,fferpcore.DataSourceBase.OneToManyQueryResult> oneToManyResult) {
        return null;
    }
    global override virtual fferpcore.DataSourceBase.RelatedDataSource createRelatedDataSource(Schema.SObjectField field) {
        return null;
    }
    global virtual fferpcore.DataSourceBase.RelatedQueryResult createRelatedQueryResult(fferpcore.DataSourceBase.DirectQueryResult directResult, Map<Schema.SObjectField,fferpcore.DataSourceBase.RelatedQueryResult> relatedResult, Map<fferpcore.DataSource.BackReference,fferpcore.DataSourceBase.OneToManyQueryResult> oneToManyResult) {
        return null;
    }
    global Schema.SObjectField getIdField() {
        return null;
    }
    global override virtual fferpcore.DataSourceBase.DirectQueryResult queryRecords() {
        return null;
    }
    global virtual List<SObject> queryRecordsByIds(Schema.SObjectField keyField, Set<Id> ids) {
        return null;
    }
    global override virtual void requireField(Schema.SObjectField field) {

    }
    global virtual fferpcore.DataSourceBase.RelatedQueryResult runLookupQuery(Schema.SObjectField lookupField, fferpcore.DataSourceBase.DirectQueryResult source) {
        return null;
    }
    global virtual fferpcore.DataSourceBase.OneToManyQueryResult runOneToManyQuery(fferpcore.DataSource.BackReference backReference, fferpcore.DataSourceBase.DirectQueryResult parentSource) {
        return null;
    }
    global virtual fferpcore.SObjectByIdDataSource withRequireSharingReadOnRoot() {
        return null;
    }
}
