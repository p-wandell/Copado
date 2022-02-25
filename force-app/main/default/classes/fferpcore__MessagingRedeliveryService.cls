/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MessagingRedeliveryService {
    global MessagingRedeliveryService() {

    }
    global static List<fferpcore.MessagingRedeliveryService.CanRedeliverResult> canRedeliver(List<Id> deliveryIds) {
        return null;
    }
    global static fferpcore.MessagingRedeliveryService.RedeliverNowResult redeliverNow(List<Id> deliveryIds) {
        return null;
    }
global class CanRedeliverResult {
    global CanRedeliverResult(Id deliveryId, Boolean isRedeliverable) {

    }
    global Id getDeliveryId() {
        return null;
    }
    global Boolean isRedeliverable() {
        return null;
    }
}
global class RedeliverNowResult {
    global RedeliverNowResult(Integer success, Integer errors) {

    }
    global Integer getErrorCount() {
        return null;
    }
    global Integer getNotTriedCount() {
        return null;
    }
    global Integer getSuccessCount() {
        return null;
    }
}
}
