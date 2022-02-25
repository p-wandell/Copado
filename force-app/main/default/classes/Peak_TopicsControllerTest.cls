/* Copyright © 2016-2017 7Summits, Inc. All rights reserved. */
@isTest
public with sharing class Peak_TopicsControllerTest {

    @IsTest
    public static void testGetTopicNames() {

        String topics = '["","","",""]';

        List<String> topicNames = Peak_TopicsController.getTopicNames(topics);
        System.assertEquals(topicNames.size(),4);

    }

}