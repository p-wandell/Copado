/*
 * Copyright (c) 2018. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 3/17/18.
*/
({
    initUploader: function(component, event, helper) {
        helper.setLabels(component, component.get('v.attributesToConvert'));
        helper.doCallout(component,'c.getFileRestrictions', null).then(function(response){
            if (response.success){
                var fileInfo = response.results[0];
                if(fileInfo.AllowedExtensions !== undefined){
                    /*
                        When getting the allowed extensions the are returned as png,jpg,txt etc
                        Not that pretty so we make it so it adds a space so it is easier to read
                        We all translate png to PNG so we can accept both forms into the uploader
                    */
                    var extensions = fileInfo.AllowedExtensions.split(',');
                    var fullExtensionList = [];
                    for(var i = 0; i < extensions.length; i++){
                        fullExtensionList.push(extensions[i]);
                        fullExtensionList.push(extensions[i].toUpperCase());
                        extensions[i] = '.' + extensions[i];
                    }
                    fileInfo.extensions = extensions.join(',');
                    fileInfo.fullExtensionList = fullExtensionList;
                    fileInfo.prettyExtensions = extensions.join(', ');
                }else{
                    fileInfo.prettyExtensions = component.get('v.allTypesText');
                    fileInfo.extensions = [];
                    fileInfo.fullExtensionList = [];
                }
                /*
                    Here we have to do all the conversions for the bytes.
                    Javascript deals with bytes, while the community deals with KB.
                    When we display the max size we want if to look pretty so we convert to MB and GB as well.
                    GB just in case Salesforce ever lets us upload the full file size.
                */
                var maxBytes = fileInfo.MaxFileSizeKb;
                var count = 0;
                do {
                    maxBytes = maxBytes / 1024;
                    count += 1;
                }
                while (maxBytes > 1024);
                fileInfo.maxFileSize = Math.round(10*maxBytes)/10 + ' ' + component.get('v.sizeAbbr')[count];
                fileInfo.maxSize = fileInfo.MaxFileSizeKb * 1024;
                component.set('v.fileInfo', fileInfo);
                component.set('v.isInit', true);
            } else {
                helper.showMessage('error',response.messages[0]);
                console.log('Error: ', response.messages[0]);
            }
        });
    },
    //Setting the file list aka finding out which ones will be uploaded and which ones will be rejected due to an error
    setFileList: function(component, event, helper) {
        component.set('v.isLoading', true);
        var parentId = component.get('v.parentId');
        var fileInput = event.getSource().get('v.files');
        var validList = component.get('v.validList');
        var invalidList = component.get('v.invalidList');
        var fileInfo = component.get('v.fileInfo');
        var inForm = component.get('v.inForm');
        var uploadList = component.get('v.uploadList');
        var curList = [];
        //Walking through the files that were uploaded from the file uploader
        for (var i = 0; i < fileInput.length; i++) {
            var curFile = fileInput[i];
            var filename = curFile.name;
            curFile.ext = filename.substr((~-filename.lastIndexOf('.') >>> 0) + 2);
            var curSize = curFile.size;
            var count = -1;
            //Getting the current uploaded file size and converting so a 2MB doesn't display as 2097152 bytes on the component
            do {
                curSize = curSize / 1024;
                count += 1;
            }
            while (curSize > 1024);
            curFile.formattedSize = Math.round(10*curSize)/10 + ' ' + component.get('v.sizeAbbr')[count];
            //Checking if the current file is an accepted file type. If not we are setting an error and adding it to the rejected file list
            if(fileInfo.fullExtensionList.indexOf(curFile.ext) === -1 && !$A.util.isEmpty(fileInfo.extensions)){
                curFile.errorMessage = ' ' + fileInfo.prettyExtensions;
                curFile.errorType = 'extension';
                curFile.valid = false;
                invalidList.push(curFile);
            //Checking if the current file size less then the allowed max file size. If not we are setting an error and adding it to the rejected file list
            }else if(curFile.size > fileInfo.maxSize){
                curFile.errorMessage = ' ' + fileInfo.maxFileSize;
                curFile.errorType = 'size';
                curFile.valid = false;
                invalidList.push(curFile);
            }else{
                //If no error add the to the accepted file list
                curFile.errorType = null;
                curFile.valid = true;
                validList.push(curFile);
                //File uploader in a form add the file to the upload list to be uploaded later, else will add it to the file list to be uploaded right away
                if(inForm){
                    uploadList.push(curFile);
                }else{
                    curList.push(curFile);
                }
            }
        }

        if(uploadList.length > 0){
            this.fireSetFileListEvent(component, uploadList);
        }
        component.set('v.validList', validList);
        component.set('v.invalidList', invalidList);
        if(curList.length > 0){
            helper.saveFiles(component, event, helper, parentId, curList);
        }else{
            component.set('v.isLoading', false);
            component.set('v.showList', true);
        }
    },
    //This will remove the file from the file list that is displayed on the component
    removeFromList: function(component, event, name, valid) {
        var inForm = component.get('v.inForm');
        var listName = valid === 'true' ? 'valid' : 'invalid';
        var list = component.get('v.' + listName + 'List');
        if($A.util.isUndefinedOrNull(name)){
            name = event.currentTarget.dataset.name;
        }
        for(var i = 0; i < list.length; i++){
            if(list[i].name === name){
                list.splice(i, 1);
            }
        }
        if(inForm){
            var uploadList = component.get('v.uploadList');
            for(var u = 0; u < uploadList.length; u++){
                if(uploadList[u].name === name){
                    uploadList.splice(u, 1);
                }
            }
            this.fireSetFileListEvent(component, uploadList);
        }
        component.set('v.' + listName + 'List', list);


    },
    fireSetFileListEvent : function(component, fileList) {
        var setFileList = component.getEvent('setFileList');
        setFileList.setParams({
            fileList : fileList
        });
        setFileList.fire();
    }
})