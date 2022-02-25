/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class UserInformationPlugin {
    global UserInformationPlugin() {

    }
global interface Request {
    Set<Id> getAssignmentIds(Id param0, String param1);
    Map<Id,Set<String>> getDataToCreateByUserId();
    Map<Id,Set<String>> getDataToDeleteByUserId();
}
global interface Response {
    void addError(Id param0, String param1);
    List<String> getErrors(Id param0);
}
global interface Work {
    String hasAccess();
    fferpcore.UserInformationPlugin.Response process(fferpcore.UserInformationPlugin.Request param0);
}
}
