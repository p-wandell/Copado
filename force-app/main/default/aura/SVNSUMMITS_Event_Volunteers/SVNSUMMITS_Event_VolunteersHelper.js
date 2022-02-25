({
    getEventVolunteerNeeds: function (component) {
        // Needed for callback
        var self = this;

        var action = component.get("c.getEventVolunteerNeeds");
        action.setParams({
            "eventIdString": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // Set volunteer needs, and also set init now that we have User and Volunteer Needs
                var volunteerNeeds = response.getReturnValue();
                var formattedNeeds = [];

                // Format for managed package
                volunteerNeeds.forEach(function(need){
                    formattedNeeds.push(self.parseNamespace(component,need));
                });

                component.set("v.volunteerNeeds",formattedNeeds);
                component.set("v.isInit",true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    get_SitePrefix: function (component) {
        var action = component.get("c.getSitePrefix");

        action.setCallback(this, function (actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);
            component.set("v.sitePrefix", sitePath.replace("/s", ""));
        });
        $A.enqueueAction(action);
    },
    getCurrentUser: function (component) {
        var action = component.get("c.getCurrentUser");

        action.setCallback(this, function (actionResult) {
            component.set("v.currentUser", actionResult.getReturnValue());
            // Should switch to promises... but here's a manual chain
            this.getEventVolunteerNeeds(component);
        });
        $A.enqueueAction(action);
    }
})