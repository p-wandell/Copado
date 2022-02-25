({
    hoverTimeMax: 250,
    hoverTimeout: null,
    showClass: 'peak-show',
    hideClass: 'peak-hide',
    returnPopoverId : function(component) {
		return 'popoverid';
	},
	show : function(component, event, helper) {
        clearTimeout(this.hoverTimeout);
        var popover = component.find(helper.returnPopoverId());

        // So $A.util.removeClass(popover,thisHelper.showClass); totally does not work with setTimeout, fun
        popover.getElement().classList.add(helper.showClass);
        popover.getElement().classList.remove(helper.hideClass);
    },
    hide  : function(component, event, helper) {
        var popover = component.find(helper.returnPopoverId());
        popover.getElement().classList.remove(helper.showClass);
        popover.getElement().classList.add(helper.hideClass);
    },
    // On mouse-out, start a timeout to indicate hover intent (ie, don't IMMEDIATELY hide the tooltip)
    setHoverTimeout: function(component, event, helper) {
        var thisHelper = helper;
        var thisComponent = component;
        var thisEvent = event;

        this.hoverTimeout = setTimeout(function() {
            helper.hide(thisComponent, thisEvent, thisHelper);
        }, this.hoverTimeMax);

    },
    clearHoverTimeout: function(component, event, helper) {
        clearTimeout(this.hoverTimeout);
    },
    testTooltipFunction: function(component, event, helper) {
        console.log('do testTooltipFunction');
    }
})