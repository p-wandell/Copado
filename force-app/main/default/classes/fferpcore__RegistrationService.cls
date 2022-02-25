/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class RegistrationService {
    global RegistrationService() {

    }
    global static void registerProduct(fferpcore.RegistrationService.RegistrationRequest request) {

    }
    global static void unregisterProduct(String developerName) {

    }
global class PublicationRequest {
    global PublicationRequest(String messageTypeDeveloperName) {

    }
    global System.Type getDescriber() {
        return null;
    }
    global String getDescription() {
        return null;
    }
    global String getDocumentationUrl() {
        return null;
    }
    global String getIdentifier() {
        return null;
    }
    global String getMessageTypeDescription() {
        return null;
    }
    global String getMessageTypeDeveloperName() {
        return null;
    }
    global String getReplacedIdentifier() {
        return null;
    }
    global System.Type getSendingHook() {
        return null;
    }
    global String getSourceObject() {
        return null;
    }
    global String getVirtualObject() {
        return null;
    }
    global String getVirtualObjectProvider() {
        return null;
    }
    global Boolean isReplacement() {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withDescriber(System.Type describer) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withDescription(String value) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withDocumentationUrl(String value) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withIdentifier(String identifier) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withMessageTypeDescription(String description) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withReplacedIdentifier(String identifier) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withSendingHook(System.Type sendingHook) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withSourceObject(String sourceObject) {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest withVirtualObject(String virtualObject, String provider) {
        return null;
    }
}
global class RegistrationRequest {
    global RegistrationRequest(String developerName, String name, System.Version version) {

    }
    global fferpcore.RegistrationService.PublicationRequest addPublication(String messageTypeDeveloperName) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest addSubscription(String messageTypeDeveloperName, System.Type messageHandler) {
        return null;
    }
    global String getDeveloperName() {
        return null;
    }
    global String getName() {
        return null;
    }
    global String getProductProxy() {
        return null;
    }
    global List<fferpcore.RegistrationService.PublicationRequest> getPublicationRequests() {
        return null;
    }
    global List<fferpcore.RegistrationService.SubscriptionRequest> getSubscriptionRequests() {
        return null;
    }
    global System.Version getVersion() {
        return null;
    }
    global fferpcore.RegistrationService.RegistrationRequest withProductProxy(String productProxy) {
        return null;
    }
}
global class SubscriptionRequest {
    global SubscriptionRequest(String messageTypeDeveloperName, System.Type messageHandler) {

    }
    global Integer getBulkCapacity() {
        return null;
    }
    global Integer getDeliveryOrder() {
        return null;
    }
    global System.Type getDescriber() {
        return null;
    }
    global String getDescription() {
        return null;
    }
    global String getDocumentationUrl() {
        return null;
    }
    global String getErrorLinkDeveloperName() {
        return null;
    }
    global fferpcore.RegistrationService.PublicationRequest getErrorPublication() {
        return null;
    }
    global String getHandlerData() {
        return null;
    }
    global String getIdentifier() {
        return null;
    }
    global System.Type getMessageHandler() {
        return null;
    }
    global String getMessageTypeDescription() {
        return null;
    }
    global String getMessageTypeDeveloperName() {
        return null;
    }
    global Integer getSynchronousCapacity() {
        return null;
    }
    global String getTargetObject() {
        return null;
    }
    global String getVirtualObjectConsumer() {
        return null;
    }
    global Boolean isExcludeFromSelf() {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withAutomaticLinkControlOnException(String errorLinkDeveloperName, fferpcore.RegistrationService.PublicationRequest errorPublication) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withBulkCapacity(Integer value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withDeliveryOrder(Integer value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withDescriber(System.Type value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withDescription(String value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withDocumentationUrl(String value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withExcludeFromSelf(Boolean value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withHandlerData(String value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withIdentifier(String identifier) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withMessageTypeDescription(String description) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withSynchronousCapacity(Integer value) {
        return null;
    }
    global fferpcore.RegistrationService.SubscriptionRequest withVirtualObject(String targetObject, String consumer) {
        return null;
    }
}
}
