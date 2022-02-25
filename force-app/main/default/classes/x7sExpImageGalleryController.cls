/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpImageGalleryController {
    public class ExpeditionException extends Exception {}

    @AuraEnabled
    public static x7sExpResponse getImageGallery(String imageGalleryIDString) {
        try {
            List<X7S_Image_Gallery__c> imageGalleries;
            x7sExpResponse response = new x7sExpResponse();

            if (!String.isEmpty(imageGalleryIDString)) {
                imageGalleries = [
                        SELECT Id, Default_Image__c, Description__c,
                            (SELECT Image_URL__c, Sort_Order__c, Image_Description__c
                             FROM Gallery_Entries__r
                             ORDER BY Sort_Order__c ASC)
                        FROM X7S_Image_Gallery__c
                        WHERE Id = :imageGalleryIDString
                        WITH SECURITY_ENFORCED ];
            }

            response.results = imageGalleries;
            return response;
        }
        catch (System.QueryException ex)
        {
            System.debug('getImageGallery()-- EXCEPTION:  ' + ex);
            throw new ExpeditionException(System.Label.x7sExpCRUDAccessDenied);
        }
    }
}