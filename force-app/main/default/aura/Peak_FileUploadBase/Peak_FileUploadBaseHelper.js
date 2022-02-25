/*
 * Copyright (c) 2018. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 3/21/18.
*/
({
    saveFiles: function(component, event, helper, parentId, curList, index, files) {
        var self = this;
        var base64 = 'base64,';
        if(index === undefined){
            index = 0;
        }
        if(files === undefined){
            files = [];
        }
        if (curList.length > 0 && index < curList.length) {
            getBase64(curList[index], index, files);
        }else if(index === curList.length){
            var uploadMessage = component.get('v.uploadMessage');
            if($A.util.isUndefinedOrNull(uploadMessage) && $A.util.isEmpty(uploadMessage)){
                helper.showMessage('success', (curList.length > 1 ? 'Files uploaded successfully' : 'File uploaded successfully'));
            }else{
                helper.showMessage('success', uploadMessage);
            }
            component.set('v.isLoading', false);
            component.set('v.showList', true);
            // this.uploadFiles(component, files);
        }
        function getBase64(file, index, files) {
            var reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = $A.getCallback(function () {
                var fileContents = reader.result;
                var dataStart = fileContents.indexOf(base64) + base64.length;
                var chunkSize = component.get('v.chunkSize');
                fileContents = fileContents.substring(dataStart);
                // set a default size or startpostiton as 0
                var startPosition = 0;
                // calculate the end size or endPostion using Math.min() function which is return the min. value

                var endPosition = Math.min(fileContents.length, startPosition + chunkSize);
                self.uploadInChunk(component, event, helper, parentId, file, fileContents, startPosition, endPosition, files, curList, index, '');

            });
            reader.onerror = function (error) {
                helper.showMessage('error', error);
                console.log('Error: ', error);
            };
        }
    },
    uploadInChunk: function(component, event, helper, parentId, file, fileContents, startPosition, endPosition, files, curList, index, attachId) {
        var self = this;
        // This information could be used to create a file upload progress tracker
        // console.log('File Name ===== ' + file.name);
        // console.log('File Size ===== ' + fileContents.length);
        // console.log('File Progress Byte ===== ' + startPosition);
        // console.log('File Progress ===== ' + Math.round(startPosition/fileContents.length*100) + '%');
        var getchunk = fileContents.substring(startPosition, endPosition);
        var params = {
            parentId: parentId,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId
        };
        helper.doCallout(component,'c.saveChunk',params).then(function(response){
            if (response.success){
                attachId = response.peakResults[0].contentID;
                // update the start position with end position
                startPosition = endPosition;
                var chunkSize = component.get('v.chunkSize');
                endPosition = Math.min(fileContents.length, startPosition + chunkSize);
                // check if the start postion is still less then end postion
                // then call again 'uploadInChunk' method ,
                // else, display alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    self.uploadInChunk(component, event, helper, parentId, file, fileContents, startPosition, endPosition, files,  curList, index, attachId);
                } else {
                    // This information could be used to create a file upload progress tracker
                    // console.log('File Name ===== ' + file.name);
                    // console.log('File Size ===== ' + fileContents.length);
                    // console.log('File Progress Byte ===== ' + endPosition);
                    // console.log('File Progress ===== ' + '100%');
                    index++;
                    self.saveFiles(component, event, helper, parentId, curList, index, files);
                }
            } else {
                console.log('Error: ', response.messages[0]);
                helper.showMessage('error', response.messages[0]);
            }
        });
    },
    deleteAttachment: function(component, event, helper, name, parentId, isLoading) {
        var params = {
            fileName: name,
            parentId: parentId
        };
        helper.doCallout(component,'c.deleteAttachment',params).then(function(response){
            if (response.success){
                helper.showMessage('success',response.messages[0]);
            } else {
                helper.showMessage('error',response.messages[0]);
                console.log('Error: ', response.messages[0]);
            }
            if(isLoading){
                component.set('v.isLoading', false);
            }
        });
    },
})