/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ProcessMessage {
    global static String CONTEXT_KEY_DATA;
    global static String CONTEXT_KEY_MESSAGE;
    global static String CONTEXT_KEY_STATUS;
    global static String CONTEXT_KEY_TOKEN;
    global static String MESSAGE_KEY_DATA;
    global static String MESSAGE_KEY_ID;
    global static String MESSAGE_KEY_MESSAGE;
    global static String MESSAGE_KEY_MESSAGE_VERSION;
    global static String MESSAGE_KEY_REPLY_TO;
    global static String MESSAGE_KEY_STATUS;
    global static String MESSAGE_KEY_TOKEN;
    global static String PROCESS_STATE_COMPLETE;
    global static String PROCESS_STATE_FAILIRE;
    global static String PROCESS_STATE_PENDING;
    global static String PROCESS_STATE_PREPARING;
    global fferpcore.ProcessMessage createReply(String responseState, String message) {
        return null;
    }
    global static String createToken() {
        return null;
    }
    global static fferpcore.ProcessMessage forNewProcess(Id recordId, String processToken, String replyTo) {
        return null;
    }
    global static fferpcore.ProcessMessage fromMessage(Map<String,Object> messageBody) {
        return null;
    }
    global Map<String,Object> getData() {
        return null;
    }
    global String getMessage() {
        return null;
    }
    global Integer getMessageVersion() {
        return null;
    }
    global String getProcessToken() {
        return null;
    }
    global String getReplyTo() {
        return null;
    }
    global String getStatus() {
        return null;
    }
    global Id getSubjectId() {
        return null;
    }
    global Boolean isComplete() {
        return null;
    }
    global Boolean isPending() {
        return null;
    }
    global static fferpcore.ProcessMessage newCompleteMessage(Id recordId, String processToken, Map<String,Object> userData) {
        return null;
    }
    global String serialize() {
        return null;
    }
    global void setMessage(String message) {

    }
    global void setStatus(String status) {

    }
global class ExistingProcessMessageDataSource extends fferpcore.SObjectByIdDataSource {
    global ExistingProcessMessageDataSource(Schema.SObjectType objectType, Map<Id,fferpcore.ProcessMessage> messages) {

    }
    global override void requireField(String key) {

    }
    global override System.Iterator runQuery() {
        return null;
    }
}
global class MessageDescriptionBuilder {
    global MessageDescriptionBuilder(Schema.SObjectType objectType, Schema.SObjectField correlationField) {

    }
    global fferpcore.MessageDescription build() {
        return null;
    }
    global fferpcore.ProcessMessage.MessageDescriptionBuilder withDataFields(Map<String,fferpcore.MessageDescription.Node> fields) {
        return null;
    }
    global fferpcore.ProcessMessage.MessageDescriptionBuilder withHeaderFields(Map<String,fferpcore.MessageDescription.Node> fields) {
        return null;
    }
    global fferpcore.ProcessMessage.MessageDescriptionBuilder withMessageVersion(Integer version) {
        return null;
    }
    global fferpcore.ProcessMessage.MessageDescriptionBuilder withReplyToMessageType(String replyTo) {
        return null;
    }
}
global class NewProcessMessageDataSource extends fferpcore.SObjectByIdDataSource {
    global NewProcessMessageDataSource(Schema.SObjectType objectType, Set<Id> recordIds, String processToken) {

    }
    global override void requireField(String key) {

    }
    global override System.Iterator runQuery() {
        return null;
    }
}
global class ProcessMessageContext extends fferpcore.Context.SObjectContext {
    global ProcessMessageContext() {

    }
    global ProcessMessageContext(Schema.SObjectType subjectType) {

    }
    global override virtual System.Type getClass() {
        return null;
    }
    global override virtual List<fferpcore.Context.Source> getPotentialChildren() {
        return null;
    }
    global override virtual fferpcore.Context.Source getSource(String key) {
        return null;
    }
}
}
