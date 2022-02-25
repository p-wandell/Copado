/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MessageDescription {
    global MessageDescription(fferpcore.Context.Source correlation, fferpcore.MessageDescription.Node body, fferpcore.Context rootContext) {

    }
    global fferpcore.MessageDescription.Node getBody() {
        return null;
    }
    global fferpcore.Context.Source getCorrelation() {
        return null;
    }
global class DeclarativeMergeRequest {
    global fferpcore.MessageDescription.DeclarativeMergeResult build(fferpcore.Context context) {
        return null;
    }
}
global class DeclarativeMergeResult {
    global DeclarativeMergeResult(Boolean passed, fferpcore.MessageDescription.Node node) {

    }
    global DeclarativeMergeResult(Boolean passed, String message) {

    }
    global String getMessage() {
        return null;
    }
    global fferpcore.MessageDescription.Node getNode() {
        return null;
    }
    global Boolean hasPassed() {
        return null;
    }
}
global class ListNode extends fferpcore.MessageDescription.Node implements fferpcore.MessageDescription.ContainerNode {
    global ListNode(fferpcore.Context.Source source) {

    }
    global ListNode(Schema.SObjectType childType, Schema.SObjectField childLookupField) {

    }
    global override Object accept(fferpcore.MessageDescriptionVisitor visitor, Object memento) {
        return null;
    }
    global override virtual void build(System.JSONGenerator generator, fferpcore.DataSource.Row parentRow) {

    }
    global List<fferpcore.MessageDescription.NamedNode> getChildren() {
        return null;
    }
    global override fferpcore.MessageDescription.NodeType getType() {
        return null;
    }
    global override fferpcore.MessageDescription.DeclarativeMergeResult mergeNode(List<String> path, fferpcore.MessageDescription.DeclarativeMergeRequest request) {
        return null;
    }
    global override virtual void prepare(fferpcore.DataSource dataSource) {

    }
    global override void setInputContext(fferpcore.Context ctx) {

    }
    global fferpcore.MessageDescription.ListNode withChild(String name, fferpcore.MessageDescription.Node child) {
        return null;
    }
    global fferpcore.MessageDescription.ListNode withScalarChild(String name, Schema.SObjectField field) {
        return null;
    }
    global fferpcore.MessageDescription.ListNode withScalarChild(String name, fferpcore.Context.Source source) {
        return null;
    }
}
global virtual class MapNode extends fferpcore.MessageDescription.Node implements fferpcore.MessageDescription.ContainerNode {
    global MapNode() {

    }
    global MapNode(Schema.SObjectField field) {

    }
    global MapNode(fferpcore.Context.Source source) {

    }
    global override Object accept(fferpcore.MessageDescriptionVisitor visitor, Object memento) {
        return null;
    }
    global override virtual void build(System.JSONGenerator generator, fferpcore.DataSource.Row parentRow) {

    }
    global virtual List<fferpcore.MessageDescription.NamedNode> getChildren() {
        return null;
    }
    global override fferpcore.MessageDescription.NodeType getType() {
        return null;
    }
    global override fferpcore.MessageDescription.DeclarativeMergeResult mergeNode(List<String> path, fferpcore.MessageDescription.DeclarativeMergeRequest request) {
        return null;
    }
    global override virtual void prepare(fferpcore.DataSource dataSource) {

    }
    global override void setInputContext(fferpcore.Context ctx) {

    }
    global fferpcore.MessageDescription.MapNode withChild(String name, fferpcore.MessageDescription.Node child) {
        return null;
    }
    global fferpcore.MessageDescription.MapNode withScalarChild(String name, Schema.SObjectField field) {
        return null;
    }
    global fferpcore.MessageDescription.MapNode withScalarChild(String name, fferpcore.Context.Source source) {
        return null;
    }
}
global class NamedNode {
    global NamedNode(String name, fferpcore.MessageDescription.Node node) {

    }
    global Boolean equals(Object obj) {
        return null;
    }
    global String getName() {
        return null;
    }
    global fferpcore.MessageDescription.Node getNode() {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global abstract class Node {
    global abstract Object accept(fferpcore.MessageDescriptionVisitor param0, Object param1);
    global abstract void build(System.JSONGenerator param0, fferpcore.DataSource.Row param1);
    global fferpcore.Context getOutputContext() {
        return null;
    }
    global fferpcore.Context.Source getSource() {
        return null;
    }
    global abstract fferpcore.MessageDescription.NodeType getType();
    global Boolean isDeclarative() {
        return null;
    }
    global abstract fferpcore.MessageDescription.DeclarativeMergeResult mergeNode(List<String> param0, fferpcore.MessageDescription.DeclarativeMergeRequest param1);
    global abstract void prepare(fferpcore.DataSource param0);
    global virtual void setInputContext(fferpcore.Context context) {

    }
    global virtual void setSupportsDeclarative(Boolean supportsDeclarative) {

    }
    global Boolean supportsDeclarative() {
        return null;
    }
}
global enum NodeType {LIST_NODE, MAP_NODE, SCALAR_NODE}
global virtual class ScalarNode extends fferpcore.MessageDescription.Node {
    global ScalarNode(fferpcore.Context.Source source) {

    }
    global override virtual Object accept(fferpcore.MessageDescriptionVisitor visitor, Object memento) {
        return null;
    }
    global override virtual void build(System.JSONGenerator generator, fferpcore.DataSource.Row row) {

    }
    global override fferpcore.MessageDescription.NodeType getType() {
        return null;
    }
    global override virtual fferpcore.MessageDescription.DeclarativeMergeResult mergeNode(List<String> path, fferpcore.MessageDescription.DeclarativeMergeRequest request) {
        return null;
    }
    global override virtual void prepare(fferpcore.DataSource dataSource) {

    }
}
}
