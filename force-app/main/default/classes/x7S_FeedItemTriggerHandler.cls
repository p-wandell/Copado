/* Copyright © 2016-2017 7Summits, Inc. All rights reserved. */

public with sharing class x7S_FeedItemTriggerHandler {

        public final String OBJECT_TYPE_FEED_ITEM = 'FeedItem';
        public final String OBJECT_TYPE_QUESTION_POST = 'QuestionPost';


        public void fillDefaultTopic(List<FeedItem> newFeedItemList, Id community) {
            // Get the Network id for the current community
            List<Network> networkList = [SELECT Id,
                    Name
            FROM Network
            WHERE Name = :System.Label.Hive_Community_Name];

            Id defaultNetworkId;
            if (!Peak_Utils.isNullOrEmpty(networkList)) {
                defaultNetworkId = networkList[0].Id;
            }

            // Grab the default topic record based on the name in the custom label.
            List<Topic> topicList = [SELECT Id,
                    Name,
                    NetworkId
            FROM Topic
            WHERE Name = : System.Label.Hive_Default_Topic
            AND NetworkId = : defaultNetworkId
            LIMIT 1000];

            Id defaultTopicId;
            if (!Peak_Utils.isNullOrEmpty(topicList)) {
                defaultTopicId = topicList[0].Id;
            }

            // get topic assignments that match topicid, networkid, entitytype, also get id and entityid
            List<TopicAssignment> topicAssignmentList = [SELECT Id,
                    EntityId,
                    TopicId,
                    NetworkId,
                    EntityType
            FROM TopicAssignment
            WHERE TopicId != null
            AND NetworkId = : defaultNetworkId
            AND Topic.ManagedTopicType LIKE '%Navigational%'
            AND (EntityType = : OBJECT_TYPE_FEED_ITEM
            OR EntityType = : OBJECT_TYPE_QUESTION_POST)
            LIMIT 1000];

            // put topic assignments in a map with a key of entity id
            Map<String, TopicAssignment> entityIdToTopicAssignmentMap = new Map<String, TopicAssignment>();
            for (TopicAssignment currentTopicAssignment : topicAssignmentList) {
                entityIdToTopicAssignmentMap.put(currentTopicAssignment.EntityId, currentTopicAssignment);
            }

            // get collaboration groups
            List<CollaborationGroup> collaborationGroupList = [SELECT Id FROM CollaborationGroup WHERE CollaborationType = 'Unlisted'];
            // convert to set
            Set<Id> unlistedGroupIds = new Set<Id>();
            for (CollaborationGroup theGroup : collaborationGroupList) {
                unlistedGroupIds.add(theGroup.Id);
            }

            List<TopicAssignment> newTopicAssignmentList = new List<TopicAssignment>();

            for (FeedItem currentFeedItem : newFeedItemList) {

                String objectTypeString = currentFeedItem.ParentId.getSObjectType().getDescribe().getName();

                if (!unlistedGroupIds.contains(currentFeedItem.ParentId) && objectTypeString != 'pse__Proj__c' && community != null && community == defaultNetworkId) {
                    // when going through feed items, check to see if a match comes out of the map
                    TopicAssignment currentTopicAssignment = entityIdToTopicAssignmentMap.get(currentFeedItem.Id);

                    if (currentTopicAssignment == null) {
                        // if not, create a new one and put it in the new list of topic assignments.
                        currentTopicAssignment = new TopicAssignment();
                        currentTopicAssignment.EntityId = currentFeedItem.Id;
                        currentTopicAssignment.NetworkId = defaultNetworkId;
                        currentTopicAssignment.TopicId = defaultTopicId;

                        newTopicAssignmentList.add(currentTopicAssignment);
                    }
                }
            }

            // when through all of the new feed items, insert the new list of topic assignments
            insert newTopicAssignmentList;
        }
    }