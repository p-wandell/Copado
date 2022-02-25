({
    initPopover: function(component, event, helper) {
        var popover = component.find(helper.returnPopoverId());
        $A.util.addClass(popover,'slds-nubbin_'+component.get('v.nubbinLocation'));
    },
    iconEnter : function(component, event, helper) {
    	helper.show(component, event, helper);
    },
    iconLeave  : function(component, event, helper) {
        helper.setHoverTimeout(component, event, helper);
    },
    contentsEnter : function(component, event, helper) {
        helper.clearHoverTimeout(component, event, helper); // if we mouse on contents, clearly it's already showing, so need to show, but DO clear the hover-off intent interval
    },
    contentsLeave  : function(component, event, helper) {
        helper.setHoverTimeout(component, event, helper);
    },
    doClick: function (component,event,helper) {
        // Get action we want to run
        helper.doAction(component,event,helper);
    }
})