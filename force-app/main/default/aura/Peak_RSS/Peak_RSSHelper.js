/**
 * Created by kentheberling on 4/24/18.
 */
({
    getFeed: function (component,event,helper) {
        var feedUrlEndpoint = component.get("v.feedUrlEndpoint");

        if(feedUrlEndpoint == null || feedUrlEndpoint === "" || feedUrlEndpoint === "0"){
            this.handleEmptyList(component);
        } else {
            var queryLimit = component.get("v.recordsToShow");
            var action;

            action = component.get("c.getRSSFeedList");
            var params = {
                "rssFeedEndpoint": feedUrlEndpoint,
                "recordsToShow": queryLimit
            };

            helper.doCallout(component,"c.getRSSFeedList",params).then(function(response){
                component.set("v.feed", response);
                if(component.get("v.feed") != null && component.get("v.feed").length > 0){
                    component.set("v.isListEmpty", false);
                } else {
                    helper.handleEmptyList(component);
                }
            }).catch(function(error){
                console.log("Failed with state: " + error);
                helper.handleError(component);
            });
        }
    },

    handleEmptyList: function(component){
        this.setResponseText(component, component.get("v.emptyListText"));
    },

    handleError: function(component){
        this.setResponseText(component, component.get("v.errorListText"));
    },

    setResponseText : function(component, responseText){
        component.set("v.responseText", responseText);
    }
})