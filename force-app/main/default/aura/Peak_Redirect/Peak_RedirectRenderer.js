/**
 * Created by kentheberling on 3/28/18.
 */
({
    afterRender : function(component, helper) {
        this.superAfterRender();

        // If not in builder mode, fire redirect
        if(!helper.isInBuilder()){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": component.get("v.redirectURL")
            });
            urlEvent.fire();
        }
    }
})