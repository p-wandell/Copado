/*
 * Copyright (c) 2020. 7Summits Inc.
 */

global with sharing class x7sMembersTopicsController {

    private static Id netwrkId = System.Network.getNetworkId();

    // Set of fields used for checking access to Topic fields
    private static String [] TopicAccessFields = new String []{
            'Id',
            'Name'
    };

    /**
     * @description get topics list
     * @return Map of topics
     */
    @AuraEnabled
    global static Map<String, String> getTopics() {
        Map<String, String> topics = new Map<String, String>();
        List<Topic> topicList = new List<Topic>();
        Map<String, Schema.SObjectField> topicFldMap = Schema.SObjectType.Topic.fields.getMap();

        for (String fieldToCheck : TopicAccessFields) {
            if (!topicFldMap.get(fieldToCheck).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
            }
        }

        topicList = netwrkId != null ? [SELECT Id, Name FROM Topic WHERE NetworkId = :netwrkId ORDER BY Name LIMIT 2000] : [SELECT Id, Name FROM Topic ORDER BY Name LIMIT 2000];

        for (Topic t : topicList) {
            topics.put(t.Id, t.Name);
        }

        return topics;
    }
}