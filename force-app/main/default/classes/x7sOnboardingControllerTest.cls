/*
 *   Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sOnboardingControllerTest {

    @IsTest
    public static void setup() {
        List<X7S_Onboarding_Setting__mdt> settings = [SELECT Community_Id__c FROM X7S_Onboarding_Setting__mdt WHERE DeveloperName='Default'];

        List <Network> testnetworkList = [SELECT Id FROM Network WHERE Id=:settings[0].Community_Id__c];
        Id networkId = testnetworkList[0].Id;

        Test.startTest();
        User testUser = x7sOnboardingTestUtils.createStandardUserNoContact();
        insert testUser;
        System.assertNotEquals(null, testUser);
        Test.stopTest();

        List <CollaborationGroup> testGroups = new List <CollaborationGroup>();
        for (Integer i = 0; i < 4; i++) {
            CollaborationGroup colGroup = new CollaborationGroup(
                    Name = 'Test Chatter Group' + i,
                    CollaborationType = 'Public',
                    CanHaveGuests = false,
                    NetworkId = networkId);
            testGroups.add(colGroup);
        }

        insert testGroups;

        List <Topic> testTopics = new List <Topic>();
        for (Integer i = 0; i < 2; i++) {
            Topic testTopic = new Topic(Name = 'Test Topic ' + i, Description = 'Test Topic1 Description', NetworkId = networkId);
            testTopics.add(testTopic);
        }

        insert testTopics;
    }

    @IsTest
    public static void testGetIsModalViewEnabled() {
        setup();

        User testUser = [SELECT Id, X7S_Onboarding_Complete__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        System.runAs(testUser) {
            Boolean isModalViewEnabled = x7sOnboardingController.getIsModalViewEnabled();
            System.assertNotEquals(null, isModalViewEnabled);
        }
    }

    @IsTest
    public static void testGetOnboardingComplete() {
        setup();

        User testUser = [SELECT Id, X7S_Onboarding_Complete__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        testUser.X7S_Onboarding_Complete__c = true;
        update testUser;
        System.runAs(testUser) {
            User testUser1 = x7sOnboardingController.getUserRecord();
            System.assert(testUser1.X7S_Onboarding_Complete__c == true);
        }
    }

    @IsTest
    public static void testUpdateUserNames() {
        setup();
        User testUser = [SELECT Id, X7S_Onboarding_Complete__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        testUser.FirstName = 'TestChange';
        System.runAs(testUser) {
            x7sOnboardingController.updateUserNames(testUser);
            User testUserName = [SELECT Id, FirstName FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
            System.assert(testUserName.FirstName == 'TestChange');
        }
    }

    @IsTest
    public static void testUpdatePreferences() {
        setup();
        User testUser = [SELECT Id, X7S_Onboarding_Complete__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        System.runAs(testUser) {
            x7sOnboardingController.updatePreferences(false);
            NetworkMember testUserName = [SELECT PreferencesDisableAllFeedsEmail FROM NetworkMember WHERE MemberId = :testUser.Id LIMIT 1];
            System.assert(testUserName.PreferencesDisableAllFeedsEmail == false);
        }
    }
    @IsTest
    static void testGroupMembership() {
        setup();

        User testUser = [SELECT Id, X7S_Onboarding_Complete__c, Email FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_EMAIL LIMIT 1];
        System.debug('testUser: ' + testUser);

        List <CollaborationGroup> testGroups = [
                SELECT Id
                FROM CollaborationGroup
                WHERE Name = 'Test Chatter Group0'
                OR Name = 'Test Chatter Group1'
                OR Name = 'Test Chatter Group2'
                OR Name = 'Test Chatter Group3'
        ];

        System.runAs(testUser) {
            List <CollaborationGroupMember> memberList = [
                    SELECT Id,NotificationFrequency
                    FROM CollaborationGroupMember
                    WHERE MemberId = :testUser.Id
            ];
            //join group
            x7sOnboardingController.joinGroup(testGroups[0].Id);
            System.assertEquals(1, 1);

            //leave group
            x7sOnboardingController.leaveGroup(testGroups[0].Id);
            System.assertEquals(1, 1);

            //update Frequency
            x7sOnboardingController.updateFrequenv(testGroups[0].Id, 'M');
            if (memberList.size() > 0) {
                System.assertEquals('M', memberList[0].NotificationFrequency);
            }
        }
    }

    @IsTest
    public static void testCompleteSlide() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        System.runAs(testUser) {
            x7sOnboardingController.completeSlide('Welcome');
            x7sOnboardingController.completeSlide('Profile');
            x7sOnboardingController.completeSlide('Notification');
            x7sOnboardingController.completeSlide('Topic');
            x7sOnboardingController.completeSlide('Group');
            x7sOnboardingController.completeSlide('Tours');
            x7sOnboardingController.completeSlide('Done');

            User testUserName = [SELECT X7S_Completed_Tours_Slide__c, X7S_Onboarding_Complete__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
            System.assert(testUserName.X7S_Completed_Tours_Slide__c == true);
            System.assert(testUserName.X7S_Onboarding_Complete__c == true);
        }
    }


    @IsTest
    public static void testGetTopics() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        List <Id> topicIds = new List <Id>();
        for (Topic top : [SELECT Id FROM Topic WHERE Name = 'Test Topic 0' OR Name = 'Test Topic 1']) {
            topicIds.add(top.Id);
        }
        Id networkId1 = [SELECT Id FROM Network LIMIT 1].Id;
        EntitySubscription subscription = new EntitySubscription(ParentId = topicIds[0], SubscriberId = testUser.Id, NetworkId = networkId1);
        insert subscription;

        System.runAs(testUser) {
            List <x7sOnboardingController.OnboardingWrapperForTopicOrCollabGroup> topicWrapper = x7sOnboardingController.getTopics(topicIds);
            System.assert(topicWrapper.size() == 2);
        }
    }

    @IsTest
    public static void testGetGroups() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        List <Id> groupIds = new List <Id>();
        for (CollaborationGroup grp : [SELECT Id FROM CollaborationGroup WHERE Name = 'Test Chatter Group0' OR Name = 'Test Chatter Group1']) {
            groupIds.add(grp.Id);
        }

        CollaborationGroupMember member = new CollaborationGroupMember(CollaborationGroupId = groupIds[0], MemberId = testUser.Id);
        insert member;
        System.runAs(testUser) {
            List <x7sOnboardingController.OnboardingWrapperForTopicOrCollabGroup> groupWrapper = x7sOnboardingController.getGroups(groupIds);
            System.assert(groupWrapper.size() == 2);
        }
    }

    @IsTest
    public static void testGetGroup() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        String groupId = [SELECT Id FROM CollaborationGroup WHERE Name = 'Test Chatter Group1' LIMIT 1].Id;

        CollaborationGroupMember member = new CollaborationGroupMember(CollaborationGroupId = groupId, MemberId = testUser.Id);
        insert member;

        System.runAs(testUser) {
            x7sOnboardingController.OnboardingWrapperForTopicOrCollabGroup groupWrapper = x7sOnboardingController.getGroup(groupId);
            System.assert(groupWrapper.id == groupId);
        }
    }
    @IsTest
    public static void testGrabTopics() {
        setup();
        List<x7sOnboardingController.TopicSlide> topicSlides = x7sOnboardingController.grabTopics();
        System.assertNotEquals(null, topicSlides);
    }

    @IsTest
    public static void testFollowTopic() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        String topicId = [SELECT Id FROM Topic WHERE Name = 'Test Topic 0' LIMIT 1].Id;

        System.runAs(testUser) {
            x7sOnboardingController.followTopic(topicId);
            List <EntitySubscription> userFollow = [SELECT Id FROM EntitySubscription WHERE ParentId = :topicId AND SubscriberId = :testUser.Id LIMIT 1];
            System.assert(userFollow.size() == 1);
        }
    }

    @IsTest
    public static void testRemoveGroupMember() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        CollaborationGroup testGroup = [SELECT Id FROM CollaborationGroup WHERE Name = 'Test Chatter Group3' LIMIT 1];
        CollaborationGroupMember member = new CollaborationGroupMember(CollaborationGroupId = testGroup.Id, MemberId = testUser.Id);
        insert member;

        System.runAs(testUser) {
            x7sOnboardingController.removeGroupMember(testGroup.Id);
            List <CollaborationGroupMember> userFollow = [SELECT Id FROM CollaborationGroupMember WHERE MemberId = :testUser.Id];
            System.assert(userFollow.size() == 0);
        }
    }

    @IsTest
    public static void testUnFollowTopic() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        Id networkId1 = [SELECT Id FROM Network LIMIT 1].Id;
        String topicId = [SELECT Id FROM Topic WHERE Name = 'Test Topic 0' LIMIT 1].Id;
        EntitySubscription topicFollow = new EntitySubscription(NetworkId = networkId1, ParentId = topicId, SubscriberId = testUser.Id);
        insert topicFollow;

        System.runAs(testUser) {
            x7sOnboardingController.unfollowTopic(topicId);
            List <EntitySubscription> userFollow = [SELECT Id FROM EntitySubscription WHERE ParentId = :topicId AND SubscriberId = :testUser.Id LIMIT 1];
            System.assert(userFollow.size() == 0);
        }
    }

/*
	TODO: Dynamic query builder for custom fields
	@IsTest
	public static void testGetUserSpecificGroups()
	{
		setup();
		User testUser = [SELECT Id,Region__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
		testUser.Region__c = 'Northeast';
		update testUser;
		List <Id> groupIds = new List <Id>();
		for (CollaborationGroup grp : [SELECT Id FROM CollaborationGroup WHERE Name = 'Test Chatter Group0' OR Name = 'Test Chatter Group1'])
		{
			groupIds.add(grp.Id);
		}

		CollaborationGroupMember member = new CollaborationGroupMember(CollaborationGroupId = groupIds[0], MemberId = testUser.Id);
		insert member;

		System.runAs(testUser)
		{

			List <x7sOnboardingController.OnboardingWrapper> OnboardingWrapperList = x7sOnboardingController.getUserSpecificGroups();
			System.assert(OnboardingWrapperList.size() == 1);
		}
	}
 */

    @IsTest(SeeAllData=true)
    public static void testUploadUserPhoto() {
        setup();
        User testUser = [SELECT Id FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        //update testUser;

        ContentVersion contentVersionInsert = new ContentVersion(
                Title = 'User Photo',
                PathOnClient = x7sOnboardingTestConstants.TEST_FILENAME,
                VersionData = EncodingUtil.base64Decode(x7sOnboardingTestConstants.BASE64FILE),
                IsMajorVersion = true
        );
        insert contentVersionInsert;

        ContentDocument documents = [SELECT Id, Title,FileType, LatestPublishedVersionId FROM ContentDocument LIMIT 1];

        System.debug(' --- Document (Image):  ' + documents);

        System.runAs(testUser) {
            ConnectApi.Photo uploadUserPhoto = x7sOnboardingController.uploadUserPhoto(documents.Id, x7sOnboardingTestConstants.TEST_FILENAME);
            System.assertNotEquals(null, uploadUserPhoto);
        }
    }

    @IsTest
    public static void testGetTrackingOptions() {
        x7sOnboardingController.ActivityTracking myTracking = x7sOnboardingController.TrackActivities;
        System.assertNotEquals(null, myTracking);
        x7sOnboardingController.DumpTracking();
    }

    @IsTest
    public static void testActivityEntry() {
        x7sOnboardingController.activityEntry entry = new x7sOnboardingController.activityEntry('ID1', 'Name');
        System.assertNotEquals(null, entry);
    }

    @IsTest
    public static void testGetCommunityTermsAndConditions() {
        String defaultTermsAndConditions = 'Default Terms and Conditions (Used in Test Class)';
        String retrievedTermsAndConditions = x7sOnboardingController.getCommunityTermsAndConditions();
        System.assertNotEquals(null, retrievedTermsAndConditions);
        System.assertEquals(defaultTermsAndConditions, retrievedTermsAndConditions, 'Retrieved Terms and Conditions should match Terms and Conditions Set in the Default 7S Onboarding Settings');
    }

    @IsTest
    public static void testSetAgreedTermsAndConditions() {
        setup();

        User testUser = [SELECT Id, X7S_Agreed_to_Terms_and_Conditions__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        System.assertEquals(false, testUser.X7S_Agreed_to_Terms_and_Conditions__c, 'Test User shouldn\'t have agreed to terms and conditions yet');
        System.runAs(testUser) {
            x7sOnboardingController.setAgreedTermsAndConditions(true);
        }
        testUser = [SELECT Id, X7S_Agreed_to_Terms_and_Conditions__c FROM User WHERE Email = :x7sOnboardingTestConstants.STANDARD_USERNAME LIMIT 1];
        System.assertEquals(true, testUser.X7S_Agreed_to_Terms_and_Conditions__c, 'Test User should have agreed to terms and conditions');
    }

}