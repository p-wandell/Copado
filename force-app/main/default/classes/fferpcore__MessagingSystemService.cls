/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MessagingSystemService {
    global MessagingSystemService() {

    }
    global static Map<fferpcore.MessagingSystemService.MessageTypeSpecifier,Boolean> canDeliver(fferpcore.MessagingSystemService.Sender sender, Set<fferpcore.MessagingSystemService.MessageTypeSpecifier> specifiers) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverLaterResult deliverLater(fferpcore.MessagingSystemService.Sender sender, fferpcore.MessagingSystemService.MessageTypeSpecifier messageTypeSpecifier, fferpcore.DataSource dataSource) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverLaterResult deliverLater(String productDeveloperName, String messageTypeDeveloperName, fferpcore.DataSource dataSource) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverLaterResult deliverLaterUsingBatch(fferpcore.MessagingSystemService.Sender sender, fferpcore.MessagingSystemService.MessageTypeSpecifier specifier, Schema.SObjectType objectType, String queryCondition, Integer scopeSize) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverLaterResult deliverLater(String sendingProductDeveloperName, List<fferpcore.MessagingSystemService.MessageRequest> requests) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverLaterResult deliverLater(fferpcore.MessagingSystemService.Sender sender, List<fferpcore.MessagingSystemService.MessageRequest> requests) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverNowResult deliverNow(fferpcore.MessagingSystemService.Sender sender, fferpcore.MessagingSystemService.MessageTypeSpecifier messageTypeSpecifier, fferpcore.DataSource dataSource) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverNowResult deliverNow(String productDeveloperName, String messageTypeDeveloperName, fferpcore.DataSource dataSource) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverNowResult deliverNow(String sendingProductDeveloperName, List<fferpcore.MessagingSystemService.MessageRequest> requests) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverNowResult deliverNow(fferpcore.MessagingSystemService.Sender sender, List<fferpcore.MessagingSystemService.MessageRequest> requests) {
        return null;
    }
    global static Boolean isDormant() {
        return null;
    }
    global static Boolean isInBatchDelivery() {
        return null;
    }
    global static Boolean isInDelivery() {
        return null;
    }
    global static fferpcore.Disposable newResponseCapturingScope(fferpcore.MessagingSystemService.ResponseCapturingRequest request) {
        return null;
    }
    global static fferpcore.MessagingSystemService.DeliverNowResult pushVirtualRecordEvent(fferpcore.MessagingSystemService.VirtualRecordEventRequest request) {
        return null;
    }
global class DeliverLaterResult {
    global DeliverLaterResult() {

    }
}
global class DeliverNowResult {
    global DeliverNowResult() {

    }
    global DeliverNowResult(List<fferpcore.MessagingSystemService.SynchronousMessageResult> results) {

    }
    global Map<String,fferpcore.MessagingSystemService.SynchronousMessageResult> getResultsByCorrelation() {
        return null;
    }
}
global virtual class MessageRequest {
    global MessageRequest(fferpcore.MessagingSystemService.MessageTypeSpecifier messageTypeSpecifier, String correlationId, String body) {

    }
    global MessageRequest(String messageTypeDeveloperName, String correlationId, String body) {

    }
    global Boolean equals(Object obj) {
        return null;
    }
    global virtual String getBody() {
        return null;
    }
    global String getCorrelationId() {
        return null;
    }
    global String getMessageTypeDeveloperName() {
        return null;
    }
    global virtual fferpcore.MessagingSystemService.MessageTypeSpecifier getMessageTypeSpecifier() {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class MessageTypeSpecifier {
    global MessageTypeSpecifier(String messageTypeDeveloperName) {

    }
    global MessageTypeSpecifier(String messageTypeDeveloperName, String identifier) {

    }
    global String getIdentifier() {
        return null;
    }
    global String getMessageTypeDeveloperName() {
        return null;
    }
}
global class ResponseCapturingRequest {
    global ResponseCapturingRequest() {

    }
    global fferpcore.Disposable createScope() {
        return null;
    }
    global fferpcore.MessagingSystemService.ResponseCapturingRequest forSubscription(fferpcore.EndpointKey endpoint) {
        return null;
    }
    global fferpcore.MessagingSystemService.ResponseCapturingRequest forSubscription(fferpcore.EndpointKey endpoint, fferpcore.MessageHandler handler) {
        return null;
    }
    global fferpcore.MessagingSystemService.ResponseCapturingRequest forSubscription(fferpcore.MessagingSystemService.Sender sender, fferpcore.MessagingSystemService.MessageTypeSpecifier messageType) {
        return null;
    }
    global fferpcore.MessagingSystemService.ResponseCapturingRequest forSubscription(fferpcore.MessagingSystemService.Sender sender, fferpcore.MessagingSystemService.MessageTypeSpecifier messageType, fferpcore.MessageHandler handler) {
        return null;
    }
}
global class Sender {
    global Sender(String productDeveloperName) {

    }
    global Sender(String productDeveloperName, String productProxyDeveloperName) {

    }
    global Boolean getForceSend() {
        return null;
    }
    global String getProductDeveloperName() {
        return null;
    }
    global String getProductProxyDeveloperName() {
        return null;
    }
    global fferpcore.MessagingSystemService.Sender withForceSend(Boolean forceSend) {
        return null;
    }
}
global interface SynchronousMessageResult {
    String getCorrelationId();
    Integer getDeferredCount();
    Integer getErrorCount();
    Integer getRecipientCount();
}
global class VirtualRecordEventRequest {
    global VirtualRecordEventRequest(fferpcore.MessagingSystemService.Sender sender, fferpcore.MessagingSystemService.MessageTypeSpecifier messageType, Set<String> virtualRecordIds) {

    }
    global fferpcore.MessagingSystemService.MessageTypeSpecifier getMessageTypeSpecifier() {
        return null;
    }
    global fferpcore.MessagingSystemService.Sender getSender() {
        return null;
    }
    global fferpcore.SharingModel getSharingModel() {
        return null;
    }
    global List<fferpcore.VirtualDataObject.ErrorListener> getSourceObjectErrorListeners() {
        return null;
    }
    global Set<String> getVirtualRecordIds() {
        return null;
    }
    global fferpcore.MessagingSystemService.VirtualRecordEventRequest withSharingModel(fferpcore.SharingModel sharingModel) {
        return null;
    }
    global fferpcore.MessagingSystemService.VirtualRecordEventRequest withSourceObjectErrorListener(fferpcore.VirtualDataObject.ErrorListener errorListener) {
        return null;
    }
}
}
