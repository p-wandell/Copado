/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MessagingAction {
    global MessagingAction() {

    }
global enum DeliveryType {ASYNCHRONOUS, SYNCHRONOUS}
global class Request {
    @InvocableVariable(label='Publication' description='Identifier given to the custom Publication' required=true)
    global String publicationIdentifier;
    @InvocableVariable(label='Record ID' description='Salesforce Id of the record that is the subject of the message' required=true)
    global Id recordId;
    global Request() {

    }
}
}
