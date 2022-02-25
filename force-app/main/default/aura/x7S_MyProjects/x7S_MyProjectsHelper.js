/* Copyright © 2016-2017 7Summits, Inc. All rights reserved. */

({
    getProfileInfo: function(component) {

        var isProfile = false;
        var profileId;

        var currentPage = window.location.pathname;
        if (currentPage.indexOf("profile") !== -1) {
            isProfile = true;
        }

        console.log(isProfile);

        if (isProfile) {
            profileId = currentPage.split("/").pop();
            component.set('v.profilePageId',profileId);
        }

        console.log(profileId);
    },
    getMyProjects : function(component) {
        this.getProfileInfo(component);
        var action = component.get("c.getMyProjects");
        action.setParams({
            "userId": component.get("v.profilePageId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                component.set("v.myProjects",response.getReturnValue());
                console.log('getMyProjects', response.getReturnValue());
                component.set("v.isInit",true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
});