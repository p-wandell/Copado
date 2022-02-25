/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class UserManager {
    global static Boolean TEST_MODE;
    global UserManager() {

    }
    global static appirio_core.UserManager.SessionInfo authenticate(String email, String plaintextPin) {
        return null;
    }
    global static Id authorize(Map<String,String> parameters) {
        return null;
    }
    global static Id authorize(Map<String,String> parameters, String feature) {
        return null;
    }
    global static Id getContactId() {
        return null;
    }
    global static String getUrlParameters() {
        return null;
    }
    global static System.PageReference redirectLogin() {
        return null;
    }
    global static void requestPINReset(String email, Boolean isNewUser) {

    }
    global static void requestPINReset(List<Id> contactIds, List<Boolean> isNewUser) {

    }
    global static Boolean setPIN(Contact contact, String newPIN) {
        return null;
    }
    global static Boolean verifyPINResetURL(String sig, String contactId, Long generationTime) {
        return null;
    }
global class SessionInfo {
    global Contact contact;
    global String sessionId;
    global SessionInfo() {

    }
    global String toUrlParameters() {
        return null;
    }
}
}
