/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpFeaturedTopicsController {

    // Get a list of featured topics for the active community
    @AuraEnabled (Cacheable=true)
    public static ConnectApi.ManagedTopicCollection getFeaturedTopics() {
        String networkId = Network.getNetworkId();

        if (Test.isRunningTest()) {
            List<Network> networks = [SELECT Id FROM Network];
            networkId = networks[0].Id;
        }

        ConnectApi.ManagedTopicCollection featuredTopics = ConnectAPI.ManagedTopics.getManagedTopics(networkId, ConnectApi.ManagedTopicType.Featured);

        return featuredTopics;
    }

}