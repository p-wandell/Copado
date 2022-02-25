/*
 * Copyright (c) 2018. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 3/22/18.
*/
({
    setFileUploadList : function(component, event, helper) {
        var fileList = event.getParam('fileList');
        component.set('v.uploadList', fileList);
    }
})