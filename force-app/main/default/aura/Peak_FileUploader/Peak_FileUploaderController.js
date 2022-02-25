/*
 * Copyright (c) 2018. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 3/17/18.
*/

({
    initUploader: function(component, event, helper) {
        helper.initUploader(component, event, helper);
    },
    handleFilesChange: function (component, event, helper) {
        helper.setFileList(component, event, helper);
    },
    deleteFile: function(component, event, helper) {
        component.set('v.isLoading', true);
        var name = event.currentTarget.dataset.name;
        var parentId = component.get('v.parentId');
        var valid = event.currentTarget.dataset.valid;
        helper.deleteAttachment(component, event, helper, name, parentId, true);
        helper.removeFromList(component, event, name, valid);

    },
    removeFile: function(component, event, helper) {
        var valid = event.currentTarget.dataset.valid;
        helper.removeFromList(component, event, null, valid);
    }
})