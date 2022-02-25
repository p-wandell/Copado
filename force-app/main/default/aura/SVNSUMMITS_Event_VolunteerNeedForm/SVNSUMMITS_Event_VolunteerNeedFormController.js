({
    doInit: function (component, event, helper) {
        helper.get_SitePrefix(component);
        helper.initRecord(component);
    },
    removeLineItem: function (component, event, helper) {
        var targetID = event.target.id;
        helper.removeLineItem(component, parseInt(targetID));
    },

    addLineItem: function (component, event, helper) {
        helper.addVolunteerNeed(component);
    },

    saveAction: function (component, event, helper) {
        helper.formValidation(component, event, helper);
    }
})