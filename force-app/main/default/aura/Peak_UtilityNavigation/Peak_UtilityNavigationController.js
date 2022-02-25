({
    // Determine if guest
    initUtilityNavigation: function(component, event, helper) {
        helper.doCallout(component,"c.isGuestUser",null).then(function(response){
            component.set("v.isGuest", response);
            component.set("v.isUtilNavInit",true);
        });
    },
    handleMobileUtilNav: function(component, event, helper) {
        helper.toggleMobileNav(component);
    }
})