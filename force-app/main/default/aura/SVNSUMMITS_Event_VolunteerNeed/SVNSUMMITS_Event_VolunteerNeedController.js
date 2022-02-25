({
    doInit: function (component, event, helper) {
        var wrapper = component.get("v.wrapper");

        // If no volunteer need (because none exist, and because this field is not directly writeable in apex
        if (typeof wrapper.volunteerNeed.Volunteer_Registrations__r === 'undefined'){
            wrapper.volunteerNeed.Volunteer_Registrations__r = [];
        }

        // Computer current needs and sort user to front (if this user is already signed up)
        helper.calculateVolunteersNeeded(component);
        helper.sortCurrentUserToFront(component);

        // Create listing for currently logged in user (to assign to front if user wasn't already registered... that way it's easy to toggle and display without another full server call for results)
        helper.establishCurrentUserRecord(component);

    },

    removeVolunteer: function (component, event, helper) {
        helper.removeVolunteer(component);
    },

    registerVolunteer: function (component, event, helper) {
        helper.registerVolunteer(component);
    },

    showToggle: function (component, event, helper) {
        helper.showToggle(component, event);
    }

})