/**
 * Created by jonbalza on 12/8/18.
 */
({
    handleInit: function(component, event, helper) {
        // Set up vertical alignment
        helper.setVerticalAlignment(component, event, helper);
        helper.setHorizontalAlignment(component, event, helper);
        helper.setRowWidths(component, event, helper);

        helper.doCallout(component,"c.getFeaturedTopics",{}).then(function(response){
            // console.log('getFeaturedTopics', response.managedTopics);
            if(response.managedTopics) {
                component.set("v.topics", response.managedTopics);
                component.set("v.displayedTopics", helper.filterTopics(response.managedTopics, component.get("v.topicFilterList")));
                if(helper.isInBuilder()) {
                    console.log('Available featured topics are:', helper.listFeaturedTopics(component, event, helper));
                }
            }

            component.set("v.isInBuilder", helper.isInBuilder());
            component.set("v.isInit", true);
        }).catch(function(error){
            console.log('Error:', error);
        });
    },

    handleClick: function(component, event, helper) {
        var id = event.getParam("Id");

        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id,
        });
        navEvt.fire();
    }
})