/**
 * Created by brianpoulsen on 7/20/18.
 */
({
    doInit:function(component, event, helper) {
        helper.getTopics(component, event, helper);
        helper.mapCardColors(component, event, helper);
    }
});