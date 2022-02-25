/**
 * Created by brianpoulsen on 3/20/17.
 * Edited by Joe Callin on 8/12/2017.
 */
({
    buildParagraph : function(component) {
        var paragraph = {};
        var paragraphType = component.get('v.paragraphType');
        var isLead = paragraphType.match(/lead/i);
        component.set('v.isLead', isLead);
    },
    fireLabelUtilEvent: function (component, text, attribute) {
        var labelUtilEvent = component.getEvent('labelUtilEvent');
        labelUtilEvent.setParams({
            'labelText': text,
            'attribute': attribute
        });
        labelUtilEvent.fire();
    }
})