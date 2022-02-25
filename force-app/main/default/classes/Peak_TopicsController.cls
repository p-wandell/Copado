/* Copyright © 2016-2017 7Summits, Inc. All rights reserved. */

public without sharing class Peak_TopicsController {

    @AuraEnabled
    public static List<String> getTopicNames(String topics) {

        System.debug(topics);

        List<String> topicNames = new List<String>();

        if (topics != '') {
            List<String> topicIds = (List<String>) System.JSON.deserialize(topics, List<String>.Class);

            //System.debug('#####' + ConnectApi.Communities.getCommunities());

            String networkId = System.Network.getNetworkId();

            for (String topicId : topicIds) {
                String topicName;
                if (topicId != '') {
                    topicName = ConnectApi.Topics.getTopic(networkId, topicId).name;
                } else {
                    topicName = '';
                }
                topicNames.add(topicName);
            }
        }
        return topicNames;
    }
}