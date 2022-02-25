/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class BillingDocServiceActionCreateBDSync {
    global BillingDocServiceActionCreateBDSync() {

    }
    @InvocableMethod(label='Create Billing Documents Synchronously' description='Create billing documents from billing events synchronously')
    global static void createBillingDocumentSync(List<pse.BillingDocServiceActionCreateBDSync.BillingDocumentCreationRequest> billingDocumentCreationRequests) {

    }
global class BillingDocumentCreationRequest {
    @InvocableVariable(label='ID' description='Billing Event ID for Billing Event which is released, not already invoiced, have a project with an account and do not have an original billing document.' required=true)
    global Id billingEventId;
    global BillingDocumentCreationRequest() {

    }
}
}
