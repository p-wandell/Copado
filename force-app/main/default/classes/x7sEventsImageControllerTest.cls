/*
* Copyright (c) 2021. 7Summits Inc. All rights reserved.
*/

@IsTest
public class x7sEventsImageControllerTest {
    
    private static final String RELATED_FILES = 'Related File';
    private static final String STATIC_RESOURCE = 'Static Resource';
    private static final String CMS_CONTENT = 'CMS Content';
    private static final String EXTERNAL_URL = 'External URL';
    
    @IsTest
    static void testGetImageTypes() {
        User communityUser = x7sEventsUtility.createCommunityUsers(x7sEventsTestConstants.CUSTOMER_COMMUNITY_USER_CLONE);
        
        System.runAs(communityUser) {
            Test.startTest();
            Map<String,String> imageTypes = x7sEventsImageController.getImageTypes();
            System.assertEquals(false, imageTypes.isEmpty());
            
            Test.stopTest();
        }
    }
    
    @isTest(SeeAllData=true)
    static void testGetCMSImageForCommunity() 
    {
        String contentId1  = '20Y4x000TY04icCEAQ';
        String contentId2  = '20Y4x000TY04icCEAQ';
        
        Test.startTest();
        List<String> contentIds = new List<String>();
        contentIds.add(contentId1);
        contentIds.add(contentId2);
        Map<Id,String> eventsWithCMSImage = new Map<Id,String>();
        eventsWithCMSImage.put((Id) '20Y4x0007804icCEAQ', contentId1);
        eventsWithCMSImage.put((Id) '20Y4x0007804i78EAQ', contentId2);
        Map<String,String> imageURLMap = x7sEventsImageController.getCMSImageURL(eventsWithCMSImage, contentIds);
        System.assertEquals(true, imageURLMap.isEmpty());
        
        Map<String,String> imageURLMap2 = x7sEventsImageController.getCMSImageURLForCommunity(contentIds);
        System.assertEquals(true, imageURLMap2.isEmpty());
        
        List<String> contentIds1 = new List<String>();
        Map<Id,String> eventsWithCMSImage1 = new Map<Id,String>();
        
        Map<String,String> imageURLMap1 = x7sEventsImageController.getCMSImageURL(eventsWithCMSImage1, contentIds1);
        System.assertEquals(true, imageURLMap1.isEmpty());
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetImageURLStaticResource() 
    {
        Test.startTest();
        
        List<Topic> topics = x7sEventsUtility.createTopic(1);
        System.assertEquals(topics.size(), 1);
        
        X7S_Event__c objEvent = new X7S_Event__c();
        
        objEvent.Name = 'UnitTestEvent';
        objEvent.Start_DateTime__c = System.today();
        objEvent.End_DateTime__c = System.today().addDays(5);
        objEvent.Details__c = 'Event Details is here.';
        objEvent.Location_Name__c = 'Test Location';
        objEvent.Enable_RSVP__c = false;
        objEvent.Image_Type__c = STATIC_RESOURCE;
        
        x7sEventsListController.saveEvents(objEvent, topics[0].Id, '', '','');
        System.assertNotEquals(objEvent.Id, null);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = objEvent.Id;
        cdl.ShareType = 'V';
        insert cdl; 
                
        objEvent.Image_Reference__c = cdl.Id;
        update objEvent;
        
        List<X7S_Event__c> eventList = [SELECT Id,Image_Type__c,Image_Reference__c FROM X7S_Event__c WHERE Id =: objEvent.Id];
        
        Map<Id,String> eventToImageURLMap = x7sEventsImageController.getImageURL(eventList);
        System.assertEquals(1, eventToImageURLMap.size());
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetImageURLRelatedFiles() 
    {
        Test.startTest();
        
        List<Topic> topics = x7sEventsUtility.createTopic(1);
        System.assertEquals(topics.size(), 1);
        
        X7S_Event__c objEvent = new X7S_Event__c();
        
        objEvent.Name = 'UnitTestEvent';
        objEvent.Start_DateTime__c = System.today();
        objEvent.End_DateTime__c = System.today().addDays(5);
        objEvent.Details__c = 'Event Details is here.';
        objEvent.Location_Name__c = 'Test Location';
        objEvent.Enable_RSVP__c = false;
        objEvent.Image_Type__c = RELATED_FILES;
        
        x7sEventsListController.saveEvents(objEvent, topics[0].Id, '', '','');
        System.assertNotEquals(objEvent.Id, null);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = objEvent.Id;
        cdl.ShareType = 'V';
        insert cdl; 
        
        objEvent.Image_Reference__c = cdl.Id;
        update objEvent;
        
        List<X7S_Event__c> eventList = [SELECT Id,Image_Type__c,Image_Reference__c FROM X7S_Event__c WHERE Id =: objEvent.Id];
        
        Map<Id,String> eventToImageURLMap = x7sEventsImageController.getImageURL(eventList);
        System.assertEquals(1, eventToImageURLMap.size());
        
        Test.stopTest();
    }

    @isTest
    static void testGetImageURLExternalURL() 
    {
        Test.startTest();
        
        List<Topic> topics = x7sEventsUtility.createTopic(1);
        System.assertEquals(topics.size(), 1);
        
        X7S_Event__c objEvent = new X7S_Event__c();
        
        objEvent.Name = 'UnitTestEvent';
        objEvent.Start_DateTime__c = System.today();
        objEvent.End_DateTime__c = System.today().addDays(5);
        objEvent.Details__c = 'Event Details is here.';
        objEvent.Location_Name__c = 'Test Location';
        objEvent.Enable_RSVP__c = false;
        objEvent.Image_Type__c = EXTERNAL_URL;
        
        x7sEventsListController.saveEvents(objEvent, topics[0].Id, '', '','');
        System.assertNotEquals(objEvent.Id, null);
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = objEvent.Id;
        cdl.ShareType = 'V';
        insert cdl;
        
        objEvent.Image_Reference__c = cdl.Id;
        update objEvent;
        
        List<X7S_Event__c> eventList = [SELECT Id,Image_Type__c,Image_Reference__c FROM X7S_Event__c WHERE Id =: objEvent.Id];
        
        Map<Id,String> eventToImageURLMap = x7sEventsImageController.getImageURL(eventList);
        System.assertEquals(1, eventToImageURLMap.size());
        
        Test.stopTest();
    }    
}