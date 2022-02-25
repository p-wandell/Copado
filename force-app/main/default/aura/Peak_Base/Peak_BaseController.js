/**
 * Edited by Joe Callin on 8/12/2017.
 */
({
    initPeakBase: function(component, event, helper) {
        if(component.get('v.labelText') !== ''){
            helper.setLabel(component);
        }
    }
})