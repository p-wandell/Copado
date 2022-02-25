/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class Context {
    global Context() {

    }
    global abstract System.Type getClass();
    global abstract fferpcore.Context.DisplayDescription getDisplayDescription();
    global abstract String getInitMemento();
    global abstract List<fferpcore.Context.Source> getPotentialChildren();
    global abstract fferpcore.Context.Source getSource(String param0);
    global abstract void initialise(String param0);
global class CompositeSource extends fferpcore.Context.Source {
    global CompositeSource(List<Schema.SObjectField> fields) {

    }
    global CompositeSource(List<fferpcore.Context.Source> sources) {

    }
    global override Boolean canGetComplexData() {
        return null;
    }
    global override Boolean canGetScalarData() {
        return null;
    }
    global override fferpcore.DataSource.Row getChildRow(fferpcore.DataSource.Row inputRow) {
        return null;
    }
    global override Object getData(fferpcore.DataSource.Row row) {
        return null;
    }
    global override fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override String getKey() {
        return null;
    }
    global override fferpcore.Context getOutputContext() {
        return null;
    }
    global override fferpcore.DataType getScalarDataType() {
        return null;
    }
    global override fferpcore.Context.SourceType getType() {
        return null;
    }
    global override fferpcore.DataSource prepare(fferpcore.DataSource dataSource) {
        return null;
    }
}
global class CorrelationSource extends fferpcore.Context.Source {
    global CorrelationSource(Schema.SObjectField field, Schema.SObjectField fallbackField) {

    }
    global override Boolean canGetScalarData() {
        return null;
    }
    global override Object getData(fferpcore.DataSource.Row row) {
        return null;
    }
    global override fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override fferpcore.DataType getScalarDataType() {
        return null;
    }
    global override fferpcore.Context.SourceType getType() {
        return null;
    }
    global override fferpcore.DataSource prepare(fferpcore.DataSource dataSource) {
        return null;
    }
}
global class DisplayDescription implements fferpcore.ObjectIO.SerializableObject {
    global String description {
        get;
    }
    global String descriptionLabel {
        get;
    }
    global String elementType {
        get;
    }
    global String name {
        get;
    }
    global String nameLabel {
        get;
    }
    global DisplayDescription(String elementType, String nameLabel, String name, String descriptionLabel, String description) {

    }
}
global class FallbackSource extends fferpcore.Context.Source {
    global FallbackSource(List<fferpcore.Context.Source> sources) {

    }
}
global class ListSource extends fferpcore.Context.Source {
    global ListSource(Schema.ChildRelationship childRelationship) {

    }
    global ListSource(Schema.SObjectType childType, Schema.SObjectField childLookupField) {

    }
    global override Boolean canGetListData() {
        return null;
    }
    global override fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override String getKey() {
        return null;
    }
    global override System.Iterator getListRows(fferpcore.DataSource.Row inputRow) {
        return null;
    }
    global override fferpcore.Context getOutputContext() {
        return null;
    }
    global override fferpcore.Context.SourceType getType() {
        return null;
    }
    global override fferpcore.DataSource prepare(fferpcore.DataSource dataSource) {
        return null;
    }
    global fferpcore.Context.ListSource withFilter(fferpcore.PublicationMatcher filter) {
        return null;
    }
    global fferpcore.Context.ListSource withParentType(Schema.SObjectType parentType) {
        return null;
    }
}
global class MapSource extends fferpcore.Context.Source implements fferpcore.ObjectIO.ActivatableObject {
    global MapSource(String key, String description, fferpcore.DataType dataType) {

    }
    global override Boolean canGetScalarData() {
        return null;
    }
    global override Object getData(fferpcore.DataSource.Row row) {
        return null;
    }
    global String getDescription() {
        return null;
    }
    global override fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override String getKey() {
        return null;
    }
    global override fferpcore.DataType getScalarDataType() {
        return null;
    }
    global override fferpcore.Context.SourceType getType() {
        return null;
    }
}
global class PassthroughSource extends fferpcore.Context.Source {
    global PassthroughSource() {

    }
    global PassthroughSource(String description) {

    }
    global override Boolean canGetComplexData() {
        return null;
    }
    global override fferpcore.DataSource.Row getChildRow(fferpcore.DataSource.Row inputRow) {
        return null;
    }
    global override fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override String getKey() {
        return null;
    }
    global override fferpcore.Context getOutputContext() {
        return null;
    }
    global override fferpcore.Context.SourceType getType() {
        return null;
    }
    global override fferpcore.DataSource prepare(fferpcore.DataSource parentSource) {
        return null;
    }
    global override void setInputContext(fferpcore.Context ctx) {

    }
}
global virtual class SObjectContext extends fferpcore.Context implements fferpcore.VirtualDataObject.Accessible {
    global SObjectContext() {

    }
    global SObjectContext(Schema.SObjectType type) {

    }
    global override virtual System.Type getClass() {
        return null;
    }
    global override virtual fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override virtual String getInitMemento() {
        return null;
    }
    global override virtual List<fferpcore.Context.Source> getPotentialChildren() {
        return null;
    }
    global Schema.SObjectType getSObjectType() {
        return null;
    }
    global override virtual fferpcore.Context.Source getSource(String key) {
        return null;
    }
    global override virtual void initialise(String memento) {

    }
}
global class SObjectSource extends fferpcore.Context.Source {
    global SObjectSource(Schema.SObjectField field) {

    }
    global override Boolean canGetComplexData() {
        return null;
    }
    global override Boolean canGetScalarData() {
        return null;
    }
    global override fferpcore.DataSource.Row getChildRow(fferpcore.DataSource.Row inputRow) {
        return null;
    }
    global override Object getData(fferpcore.DataSource.Row row) {
        return null;
    }
    global override fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override String getKey() {
        return null;
    }
    global override fferpcore.Context getOutputContext() {
        return null;
    }
    global override fferpcore.DataType getScalarDataType() {
        return null;
    }
    global override fferpcore.Context.SourceType getType() {
        return null;
    }
    global override fferpcore.DataSource prepare(fferpcore.DataSource dataSource) {
        return null;
    }
}
global abstract class Source {
    global Source() {

    }
    global virtual void addError(fferpcore.DataSource.Row row, String errorMessage) {

    }
    global virtual Boolean canGetComplexData() {
        return null;
    }
    global virtual Boolean canGetListData() {
        return null;
    }
    global virtual Boolean canGetScalarData() {
        return null;
    }
    global virtual fferpcore.VirtualDataObject.Accessible getAsAccessible() {
        return null;
    }
    global virtual fferpcore.DataSource.Row getChildRow(fferpcore.DataSource.Row inputRow) {
        return null;
    }
    global virtual fferpcore.OptionalValue getChildRowOptional(fferpcore.DataSource.Row inputRow) {
        return null;
    }
    global virtual Object getData(fferpcore.DataSource.Row row) {
        return null;
    }
    global virtual fferpcore.OptionalValue getDataOptional(fferpcore.DataSource.Row row) {
        return null;
    }
    global abstract fferpcore.Context.DisplayDescription getDisplayDescription();
    global virtual String getKey() {
        return null;
    }
    global virtual System.Iterator getListRows(fferpcore.DataSource.Row inputRow) {
        return null;
    }
    global virtual fferpcore.Context getOutputContext() {
        return null;
    }
    global virtual fferpcore.DataType getScalarDataType() {
        return null;
    }
    global abstract fferpcore.Context.SourceType getType();
    global virtual Boolean hasAccess() {
        return null;
    }
    global virtual fferpcore.DataSource prepare(fferpcore.DataSource dataSource) {
        return null;
    }
    global virtual fferpcore.DataSource prepare(fferpcore.DataSource dataSource, fferpcore.Intent intent) {
        return null;
    }
    global virtual void putData(fferpcore.DataSource.Row row, Object data) {

    }
    global virtual void setInputContext(fferpcore.Context parent) {

    }
}
global enum SourceType {COMPOSITE, CORRELATION, FALLBACK, FROM_CONTEXT, LITERAL, PASSTHROUGH}
global class StaticSource extends fferpcore.Context.Source {
    global StaticSource(String description) {

    }
    global StaticSource(Object data, String description) {

    }
    global override Boolean canGetScalarData() {
        return null;
    }
    global Object getData() {
        return null;
    }
    global override Object getData(fferpcore.DataSource.Row row) {
        return null;
    }
    global String getDescription() {
        return null;
    }
    global override fferpcore.Context.DisplayDescription getDisplayDescription() {
        return null;
    }
    global override String getKey() {
        return null;
    }
    global override fferpcore.DataType getScalarDataType() {
        return null;
    }
    global override fferpcore.Context.SourceType getType() {
        return null;
    }
}
}
