/**
 * Created by brianpoulsen on 3/20/17.
 * Edited by Joe Callin on 8/12/2017.
 */
({
    getLabel : function(component, event, helper) {
        var headingText = component.get('v.headingText');
        helper.setLabel(component, headingText, 'headingText');
    },
    buildHeading : function(component, event, helper) {
        var headingTag = component.get('v.headingTag').substring(0,2).toLowerCase();
        component.set('v.headingTag', headingTag);
        var headingAlignment = component.get('v.headingAlignment');
        component.set('v.headingClass', 'slds-text-align_' + headingAlignment);
        component.set('v.isInit', true);
    }
})