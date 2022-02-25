/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public without sharing class x7sFileUploaderController {
    /**
     * Get the file restrictions set by the community.
     * If not set it will take the restrictions from Salesforce.
     * @return x7sFileUploaderResponse
     */
    @AuraEnabled
    public static x7sFileUploaderResponse getFileRestrictions() {
        x7sFileUploaderResponse response = new x7sFileUploaderResponse();
        try {
            String networkId = Network.getNetworkId();
            Network curNetwork;
            List<Network> networkList;
            if (Test.isRunningTest()) {
                networkId = [SELECT Id FROM Network LIMIT 1][0].Id;
            }
            networkList = [SELECT Id, MaxFileSizeKb, AllowedExtensions FROM Network WHERE Id = :networkId];
            if (networkList != null && networkList.size() > 0) {
                curNetwork = networkList[0];
            }
            // If max file size of the community exceeds ~4.2mb set it to that. This is a apex heap limit.
            if (curNetwork.MaxFileSizeKb == null || curNetwork.MaxFileSizeKb == 0 || curNetwork.MaxFileSizeKb > 4248) {
                curNetwork.MaxFileSizeKb = 4248;
                // If the heap issue ever gets fixed then set the max size to the Salesforce max file size of 2GB.
                // curNetwork.MaxFileSizeKb = 2097152;
            }
            response.results.add(curNetwork);
            response.success = true;
        } catch (Exception e) {
            response.success = false; response.messages.add(e.getMessage());
        }

        return response;
    }

    /**
     * Save the file chunk that is passed from the front end.
     * @param parentId
     * @param fileName
     * @param base64Data
     * @param contentType
     * @param fileId
     *
     * @return x7sFileUploaderResponse
     */
    @AuraEnabled
    public static x7sFileUploaderResponse saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        x7sFileUploaderResponse response = new x7sFileUploaderResponse();
        try {
            Attachment uploadedFile;
            x7sFileUploaderContentObject x7sObject = new x7sFileUploaderContentObject();
            if (fileId == '' || fileId == null) {
                // If this is a new file chunk create a new file attachment
                uploadedFile = saveTheFile(parentId, fileName, base64Data, contentType);
            } else {
                // If this the chunk is associated with an already existing file attachment then append the chunk to the existing chunk
                uploadedFile = appendToFile(fileId, base64Data);
            }

            if (uploadedFile != null) {
                x7sObject.contentID = uploadedFile.Id;
                response.x7sResults.add(x7sObject);
                response.success = true;
            } else {
                response.success = false;
                response.messages.add('Unable to upload file.');
            }

        } catch (Exception e) {
            response.success = false; response.messages.add(e.getMessage());
        }

        return response;
    }

    /**
     * Create the file attachment.
     * @param parentId
     * @param fileName
     * @param base64Data
     * @param contentType
     *
     * @return Attachment
     */
    public static Attachment saveTheFile(String parentId, String fileName, String base64Data, String contentType) {
        if (!Attachment.SObjectType.getDescribe().isCreateable()){
            System.debug('ACCESS ERROR: Attachment not creatable');
            return null;
        }

        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        Attachment fileAttachment = new Attachment();
        fileAttachment.ParentId = parentId;

        fileAttachment.Body = EncodingUtil.base64Decode(base64Data);
        fileAttachment.Name = fileName;
        fileAttachment.ContentType = contentType;

        insert fileAttachment;

        return fileAttachment;
    }

    // Append the file chunk to the previously added chunk
    public static Attachment appendToFile(String fileId, String base64Data) {
        if (!Attachment.SObjectType.getDescribe().isUpdateable()){
            System.debug('ACCESS ERROR: Attachment not updateable');
            return null;
        }

        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        Attachment existingAttachment = [SELECT Id, Body, Name, ContentType FROM Attachment WHERE Id = :fileId];

        String existingBody = EncodingUtil.base64Encode(existingAttachment.Body);

        existingAttachment.Body = EncodingUtil.base64Decode(existingBody + base64Data);

        update existingAttachment;

        return existingAttachment;
    }

    /**
     * Delete the file attachment
     * @param fileName
     * @param parentId
     *
     * @return x7sFileUploaderResponse
     */
    @AuraEnabled
    public static x7sFileUploaderResponse deleteAttachment(String fileName, String parentId) {
        x7sFileUploaderResponse response = new x7sFileUploaderResponse();
        try {
            if (!Attachment.SObjectType.getDescribe().isDeletable()){
                System.debug('ACCESS ERROR: Attachment not updateable');
                response.success = false;
                response.messages.add('Unable to delete attachment.');
            } else {
                Attachment deleteAttachment;
                List<Attachment> attachmentList = [SELECT Id, Name, ParentId FROM Attachment WHERE ParentId = :parentId AND Name = :fileName];
                if (attachmentList != null && attachmentList.size() > 0) {
                    deleteAttachment = attachmentList[0];
                }

                delete deleteAttachment;

                response.success = true;
                response.messages.add('File deleted successfully');
            }
        } catch (Exception e) {
            response.success = false;response.messages.add(e.getMessage());
        }

        return response;
    }
}