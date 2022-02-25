/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-05-15.
*/
({
    init: function (component, event, helper) {
        component.set('v.isInit', true);
        component.set('v.showHeader', component.get('v.header').length > 0);
        component.set('v.showFooter', component.get('v.footer').length > 0);
        console.log();
    },
    handleClose: function(component, event, helper) {
        console.log('close modal');
        var closeModal = component.getEvent('closeModal');
        closeModal.fire();
    },
})