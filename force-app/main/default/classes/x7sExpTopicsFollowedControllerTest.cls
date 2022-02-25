/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public class x7sExpTopicsFollowedControllerTest {

    public static User testUser;

    @IsTest
    public static void testGetMyFollowedTopics() {
        setupData();

        Topic newTopic = new Topic(Name = 'Test Topic');
        insert newTopic;

        Test.startTest();

        List<Topic> followedTopics = new List<Topic>();
        System.runAs(testUser) {
            followedTopics = x7sExpTopicsFollowedController.getMyFollowedTopics(null);
            System.assertEquals(0, followedTopics.size());
        }

        EntitySubscription newSub = new EntitySubscription(
                ParentId = newTopic.Id,
                SubscriberId = testUser.Id
        );
        insert newSub;

        System.runAs(testUser) {
            followedTopics = x7sExpTopicsFollowedController.getMyFollowedTopics(null);
            System.assertEquals(1, followedTopics.size());
        }

        Test.stopTest();
    }

    public static void setupData() {
        testUser = x7sExpTestUtils.createGuestUser();
        insert testUser;
    }

}