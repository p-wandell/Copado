/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

@isTest
public with sharing class x7sVideoListControllerTest {
    @isTest
    static void test_getYouTubeVideosByUsername() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new x7sVideoListMockWebService());
        String channelId = x7sVideoListController.getYouTubeUsername('username', 'key');
        
        String data = x7sVideoListController.getYouTubeVideosByUsername('results', 'username', 'key', 'order');
        System.assertNotEquals(null, data);
        Test.stopTest();
    }

    @isTest
    static void test_getYouTubeVideosByChannel() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new x7sVideoListMockWebService());
        String data = x7sVideoListController.getYouTubeVideosByChannel('results', 'channel', 'key', 'order');
        System.assertNotEquals(null, data);
        Test.stopTest();
    }

    @isTest
    static void test_getYouTubeVideosByPlaylist() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new x7sVideoListMockWebService());
        String data = x7sVideoListController.getYouTubeVideosByPlaylist('results', 'playlistId', 'key', 'order');
        System.assertNotEquals(null, data);
        Test.stopTest();
    }

    @isTest
    static void test_getYouTubeUsername() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new x7sVideoListMockWebService());
        String data = x7sVideoListController.getYouTubeUsername('username', 'key');
        System.assertNotEquals(null, data);
        Test.stopTest();
    }

    @isTest
    static void test_getVimeoVideos() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new x7sVideoListMockWebService());
        String data = x7sVideoListController.getVimeoVideos('channel');
        System.assertNotEquals(null, data);
        Test.stopTest();
    }
    @isTest
    static void test_getBrightcoveVideos() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new x7sVideoListMockWebService());
        String data = x7sVideoListController.getBrightcoveVideos('accountId','policyKey','playlistId');
        System.assertNotEquals(null, data);
        Test.stopTest();
    }
    @isTest
    static void test_getWistiaVideos() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new x7sVideoListMockWebService());
        String data = x7sVideoListController.getWistiaVideos('projectId','key');
        System.assertNotEquals(null, data);
        Test.stopTest();
    }
}