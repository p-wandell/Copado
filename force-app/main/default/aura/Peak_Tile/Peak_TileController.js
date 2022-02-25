/**
 * Created by jonbalza on 12/9/18.
 */
({
    handleClick: function(component, event, helper) {
        var clickevent = component.getEvent('onclick');
        clickevent.setParams({
            "Id": event.currentTarget.dataset.id
        });
        clickevent.fire();
    },

    handleBlur: function(component, event, helper) {
        component.set("v.isHovering", false);
    },
    handleFocus: function(component, event, helper) {
        component.set("v.isHovering", true);
    }
})