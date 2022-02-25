/**
 * Created by brianpoulsen on 11/8/17.
 * Updated by jonbalza on 11/23/18.
 */
({
    handleRender: function(component, event, helper) {
        var isOpen = component.get("v.isOpen");
        var isOpenState = component.get("v.isOpenState");
        var accordionBody = component.find("accordionBody");

        if (isOpen) {
            helper.slideDown(component, event, helper, accordionBody, $A.getCallback(function() {
                component.set("v.isOpenState", true);
            }));
        } else {
            helper.slideUp(component, event, helper, accordionBody, $A.getCallback(function() {
                component.set("v.isOpenState", false);
            }));
        }
    },

    handleClick: function(component, event, helper) {
        var isOpen = component.get("v.isOpen");
        component.set("v.isOpen", !isOpen);
    }
})