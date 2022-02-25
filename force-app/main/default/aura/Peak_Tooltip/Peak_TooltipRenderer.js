({
	// Your renderer method overrides go here
    afterRender: function (component, helper) {
        this.superAfterRender();

        // Get body height, adjust parent popover to match this height!
        var popoverBody = component.find("popover-body");

        // Set popover height
        var popover = component.find(helper.returnPopoverId()).getElement();
        popover.style.height = popoverBody.getElement().offsetHeight + 2 + 'px'; // +2 for border

        // Sigh, wish I could CSS this
        if (component.get('v.nubbinLocation') == 'bottom'){
            popover.style.top = - (popoverBody.getElement().offsetHeight + 2) + 'px'; // element also has a margin-top style from CSS
        }
    }
})