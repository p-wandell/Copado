/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SubscriptionDescriptionService2 {
    global SubscriptionDescriptionService2() {

    }
    global static fferpcore.SubscriptionDescriptionService2.CreateDataTargetRootResult createDataTargetRoot(fferpcore.EndpointKey endpointKey) {
        return null;
    }
    global static fferpcore.SubscriptionDescriptionService2.GetDescriptionResult getDescription(fferpcore.EndpointKey endpointKey) {
        return null;
    }
    global static fferpcore.SubscriptionDescriptionService2.GetMarshallerResult getMarshaller(fferpcore.EndpointKey endpointKey) {
        return null;
    }
global interface CreateDataTargetRootResult extends fferpcore.SubscriptionDescriptionService2.ErrorResult {
    fferpcore.DataTargetRoot getDataTargetRoot();
    fferpcore.DataTargetRoot getDataTargetRootNotNull();
}
global interface ErrorResult {
    List<String> getErrors();
}
global interface GetDescriptionResult extends fferpcore.SubscriptionDescriptionService2.ErrorResult {
    fferpcore.SubscriptionDescription2 getDescription();
    fferpcore.SubscriptionDescription2 getDescriptionNotNull();
}
global interface GetMarshallerResult extends fferpcore.SubscriptionDescriptionService2.ErrorResult {
    fferpcore.LinkingMessageToTargetObjectMarshaller getMarshaller();
    fferpcore.LinkingMessageToTargetObjectMarshaller getMarshallerNotNull();
}
}
