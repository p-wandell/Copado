/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class DataSourceBase extends fferpcore.DataSource {
    global DataSourceBase() {

    }
    global DataSourceBase(Schema.SObjectType objectType) {

    }
    global virtual fferpcore.DataSourceBase.RelatedDataSource createRelatedDataSource(Schema.SObjectField field) {
        return null;
    }
    global virtual fferpcore.DataSource.Row createRow(SObject record, Map<Schema.SObjectField,fferpcore.DataSourceBase.RelatedQueryResult> relatedResult, Map<fferpcore.DataSource.BackReference,fferpcore.DataSourceBase.OneToManyQueryResult> oneToManyResult) {
        return null;
    }
    global virtual Schema.SObjectType getSObjectType() {
        return null;
    }
    global virtual Schema.SObjectField parseFieldName(String spec) {
        return null;
    }
    global virtual Map<fferpcore.DataSource.BackReference,fferpcore.DataSourceBase.OneToManyQueryResult> queryOneToManyDataSources(fferpcore.DataSourceBase.DirectQueryResult source) {
        return null;
    }
    global abstract fferpcore.DataSourceBase.DirectQueryResult queryRecords();
    global virtual Map<Schema.SObjectField,fferpcore.DataSourceBase.RelatedQueryResult> queryRelatedDataSources(fferpcore.DataSourceBase.DirectQueryResult source) {
        return null;
    }
    global override virtual void requireField(String fieldName) {

    }
    global virtual void requireIdField() {

    }
    global override virtual fferpcore.DataSource requireLookupField(Schema.SObjectField field) {
        return null;
    }
    global override virtual fferpcore.DataSource requireLookupField(String fieldName) {
        return null;
    }
    global override virtual fferpcore.DataSource requireOneToManyField(fferpcore.DataSource.BackReference backReference) {
        return null;
    }
    global override virtual System.Iterator runQuery() {
        return null;
    }
global interface DirectQueryResult {
    Set<Id> getKeysForField(Schema.SObjectField param0);
    Set<Id> getPrimaryKeys();
    List<SObject> getRecords();
}
global interface OneToManyQueryResult {
    System.Iterator getOneToManyResult(fferpcore.DataSource.BackReference param0, fferpcore.DataSource.Row param1);
}
global interface OneToManyRelatedDataSource {
    fferpcore.DataSource asDataSource();
    fferpcore.DataSourceBase.OneToManyQueryResult runOneToManyQuery(fferpcore.DataSource.BackReference param0, fferpcore.DataSourceBase.DirectQueryResult param1);
}
global interface RelatedDataSource {
    fferpcore.DataSource asDataSource();
    fferpcore.DataSourceBase.RelatedQueryResult runLookupQuery(Schema.SObjectField param0, fferpcore.DataSourceBase.DirectQueryResult param1);
}
global interface RelatedQueryResult {
    fferpcore.DataSource.Row getRelatedRow(Schema.SObjectField param0, fferpcore.DataSource.Row param1);
}
global class Row extends fferpcore.DataSource.Row {
    global Row(SObject record, Map<Schema.SObjectField,fferpcore.DataSourceBase.RelatedQueryResult> relatedResults, Map<fferpcore.DataSource.BackReference,fferpcore.DataSourceBase.OneToManyQueryResult> oneToManyResults) {

    }
    global override Object getFieldValue(Schema.SObjectField field) {
        return null;
    }
    global override virtual Object getFieldValue(String fieldName) {
        return null;
    }
    global override System.Iterator getOneToMany(fferpcore.DataSource.BackReference backRef) {
        return null;
    }
    global override fferpcore.DataSource.Row getRelation(Schema.SObjectField field) {
        return null;
    }
    global override virtual fferpcore.DataSource.Row getRelation(String fieldName) {
        return null;
    }
    global virtual Schema.SObjectField parseFieldName(String spec) {
        return null;
    }
}
global class SimpleDirectQueryResult implements fferpcore.DataSourceBase.DirectQueryResult {
    global SimpleDirectQueryResult(List<SObject> records) {

    }
    global Set<Id> getKeysForField(Schema.SObjectField field) {
        return null;
    }
    global Set<Id> getPrimaryKeys() {
        return null;
    }
    global List<SObject> getRecords() {
        return null;
    }
}
}
