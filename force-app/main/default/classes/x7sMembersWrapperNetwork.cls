/*
 * Copyright (c) 2020. 7Summits Inc.
 */

global class x7sMembersWrapperNetwork {

    @AuraEnabled
    global String userId { get; set; }

    @AuraEnabled
    global Boolean isFollowing { get; set; }  // Am I following this User

    @AuraEnabled
    global Integer intLikeReceived { get; set; }  // number of likes associated with user

    @AuraEnabled
    global Integer intPostsMade { get; set; }  // number of posts made by the user

    @AuraEnabled
    global Integer intNumberOfFollowers { get; set; }  // number of followers associated with user

    @AuraEnabled
    global String strKnowledgeTopics { get; set; }  // topics associated with record

    @AuraEnabled
    global String strKnowledgeTopics1 { get; set; }  // topics associated with record

    @AuraEnabled
    global String strKnowledgeTopics2 { get; set; }  // topics associated with record

    @AuraEnabled
    global Id strKnowledgeTopicId { get; set; }  // topicsId associated with record

    @AuraEnabled
    global Id strKnowledgeTopicId1 { get; set; }  //  topicsId associated with record

    @AuraEnabled
    global Id strKnowledgeTopicId2 { get; set; }  // topicsId associated with record

    @AuraEnabled
    global User objUser { get; set; }  // data associated with user

    global x7sMembersWrapperNetwork(User objUser) {
        this.objUser = objUser;
        this.userId = objUser.Id;
        this.isFollowing = isFollowing;
        this.intLikeReceived = intLikeReceived;
        this.intPostsMade = intPostsMade;
        this.intNumberOfFollowers = intNumberOfFollowers;
        this.strKnowledgeTopics = strKnowledgeTopics;
        this.strKnowledgeTopics1 = strKnowledgeTopics1;
        this.strKnowledgeTopics2 = strKnowledgeTopics2;
        this.strKnowledgeTopicId = strKnowledgeTopicId;
        this.strKnowledgeTopicId1 = strKnowledgeTopicId1;
        this.strKnowledgeTopicId2 = strKnowledgeTopicId2;
    }
}