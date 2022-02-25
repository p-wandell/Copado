/* Copyright © 2016-2017 7Summits, Inc. All rights reserved. */

// Trigger to run on the feed item object
trigger x7S_FeedItemTrigger on FeedItem (after insert) {
    
    // We only want to run this trigger if the user is posting from within a community,
    // and we're creating this variable for test classes.
    public static Id community {get; set;}
    
    // grab a community if this is a test
    if(Test.isRunningTest()){
        List<Network> networkList = [SELECT Id,
                                     Name
                                     FROM Network
                                     WHERE Name = :System.Label.Hive_Community_Name
                                     LIMIT 1];
        community = networkList[0].Id;
    }
    
    if(TriggerState.isActive(trigger.new.getSObjectType())) {
        System.debug('****** Trigger is Active *******');
        x7S_FeedItemTriggerHandler handler = new x7S_FeedItemTriggerHandler();
        
        if (Trigger.isInsert) {
            if (Trigger.isAfter) {
                
                // If the community variable is null, it means we're not running a test class.
                // So, we need to set it to the current community the user is posting in.
                if (community == null) {
                    community = Network.getNetworkId();
                }
                
                if (community != null) {
                    handler.fillDefaultTopic(Trigger.new, community);
                }
            }
        }
    }
}