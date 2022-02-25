/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PluggableTriggerApi {
global virtual class Context {
    global Context() {

    }
}
global interface Plugin {
    void onAfterDelete();
    void onAfterInsert();
    void onAfterUndelete();
    void onAfterUpdate(Map<Id,SObject> param0);
    void onBeforeDelete();
    void onBeforeInsert();
    void onBeforeUpdate(Map<Id,SObject> param0);
}
global interface PluginConstructor {
    fferpcore.PluggableTriggerApi.Plugin construct(List<SObject> param0, fferpcore.PluggableTriggerApi.Context param1);
    Schema.SObjectType sObjectType();
}
}
