/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class KeyManager {
    global static String FEATURE_EXPENSES_ONLY;
    global static String FEATURE_OPEN_ENROLLMENT;
    global static String FEATURE_PROJECT_MANAGEMENT;
    global static String FEATURE_RESOURCE;
    global static String FEATURE_TIMECARD_ONLY;
    global KeyManager() {

    }
    global static List<String> getLicensedFeatures(Id contactId) {
        return null;
    }
    global static Boolean isLicensed(Id contactId, String feature) {
        return null;
    }
    global static Boolean isLicensed(Contact contact, String feature) {
        return null;
    }
}
