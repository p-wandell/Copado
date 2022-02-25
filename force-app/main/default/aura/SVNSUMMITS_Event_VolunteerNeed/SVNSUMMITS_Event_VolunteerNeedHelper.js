({
    currentUserRegistrationRecord: {}, // track this so that we can pop it in and out of list as needed if user removes registrations
    removeVolunteer: function(component) {
        var wrapper = component.get("v.wrapper");
        var volunteersNeeded = component.get("v.volunteersNeeded");

        var action = component.get("c.removeVolunteerSingle");
        action.setParams({
            "needId": wrapper.volunteerNeed.Id
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // If response is true, it worked!
                if (response.getReturnValue()){
                    // Sorry to see you go. Splice you out!
                    wrapper.currentUserRegistered = false;
                    wrapper.volunteerNeed.Volunteer_Registrations__r.splice(0,1);
                    component.set("v.wrapper",wrapper);

                    this.calculateVolunteersNeeded(component);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    registerVolunteer: function(component) {
        var helper = this;
        var wrapper = component.get("v.wrapper");
        var volunteersNeeded = component.get("v.volunteersNeeded");

        var action = component.get("c.registerVolunteerSingle");
        action.setParams({
            "needId": wrapper.volunteerNeed.Id
        });


        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // If response is true, it worked!
                if (response.getReturnValue()){
                    // Mark current user as registered and splice to front of pack
                    wrapper.currentUserRegistered = true;
                    wrapper.volunteerNeed.Volunteer_Registrations__r.splice(0,0,helper.currentUserRegistrationRecord);
                    component.set("v.wrapper",wrapper);

                    // Calculate outstanding need
                    this.calculateVolunteersNeeded(component);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    calculateVolunteersNeeded: function(component) {
        var wrapper = component.get("v.wrapper");
        var volunteersNeeded = wrapper.volunteerNeed.Volunteers_Needed__c;
        var effectiveVolunteersNeeded = volunteersNeeded;

        // if volunteersNeeded = 999999, this is a no-limit task
        if (volunteersNeeded == 999999) {
            effectiveVolunteersNeeded = volunteersNeeded;
        } else if (typeof wrapper.volunteerNeed.Volunteer_Registrations__r !== 'undefined') {
            effectiveVolunteersNeeded = volunteersNeeded - wrapper.volunteerNeed.Volunteer_Registrations__r.length;
        }
        component.set("v.volunteersNeeded", effectiveVolunteersNeeded);

    },
    showToggle: function(component, event) {
        // Toggle value of showing more
        component.set("v.showingMore",!component.get("v.showingMore"));
    },
    sortCurrentUserToFront: function(component){
        var wrapper = component.get("v.wrapper");
        var currentUser = component.get("v.currentUser");
        var reordedArray = [];

        // For all registrants... loop
        if (wrapper.currentUserRegistered){
            for (var x = 0;x<wrapper.volunteerNeed.Volunteer_Registrations__r.length;x++){
                // If current registrant equals current user (and isn't already first user)
                if ( wrapper.volunteerNeed.Volunteer_Registrations__r[x].User__r.Id == currentUser.Id && x>0){
                    // Add  into the first slot!
                    reordedArray.splice(0,0,wrapper.volunteerNeed.Volunteer_Registrations__r[x]);
                } else {
                    reordedArray.push(wrapper.volunteerNeed.Volunteer_Registrations__r[x]);
                }
            }
            wrapper.volunteerNeed.Volunteer_Registrations__r = reordedArray;
            component.set("v.wrapper",wrapper);
        }
    },
    // Create ghost registration record for user. This is easier to use when the user adds / removes registrations
    establishCurrentUserRecord: function(component){
        var currentUser = component.get("v.currentUser");

        this.currentUserRegistrationRecord.User__r = {
            Id : currentUser.Id,
            Name: '' ,
            SmallPhotoUrl: currentUser.SmallPhotoUrl
        };


    }
})