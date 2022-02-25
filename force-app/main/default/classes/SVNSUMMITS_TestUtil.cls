/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/*
    Name : SVNSUMMITS_TestUtil
    Description: Utility class for creating the test records.
*/
@IsTest
global with sharing class SVNSUMMITS_TestUtil {

    // Profiles - moved to Test COnstants but cannot be removed from managed pkg
    static final global String COMPANY_COMMUNITY_PROFILE_NAME = 'Customer Community User';
    static final global String PARTNER_COMMUNITY_PROFILE_NAME = 'Partner Community User';

    /**
    date        5/17/2016
    description: create list of test users
    */

    // MyId
    static final global Id userId = UserInfo.getUserId();


    static global Id COMPANY_COMMUNITY_PROFILE_Id {
        get {
            if (COMPANY_COMMUNITY_PROFILE_Id == null) {
                List<Profile> profiles = [
                        SELECT Id
                        FROM Profile
                        WHERE Name = :SVNSUMMITS_Members_TestConstants.COMPANY_COMMUNITY_PROFILE_NAME
                        OR Name = :SVNSUMMITS_Members_TestConstants.PARTNER_COMMUNITY_PROFILE_NAME
                ];
                COMPANY_COMMUNITY_PROFILE_Id = profiles[0].id;
            }
            system.assertNotEquals(null, COMPANY_COMMUNITY_PROFILE_Id);
            return COMPANY_COMMUNITY_PROFILE_Id;
        }
        set {
            COMPANY_COMMUNITY_PROFILE_Id = value;
            system.assertEquals(value, COMPANY_COMMUNITY_PROFILE_Id);
        }
    }

    //by sachin kadian to get profile name from custom metadata
    static global String DEFAULT_PROFILE_NAME {
        get {
            if (DEFAULT_PROFILE_NAME == null) {
                List<Members_Filter_Settings__mdt> memberSetting = [select id,Applied_Test_Profile__c from Members_Filter_Settings__mdt where DeveloperName = 'Default'];
                if (memberSetting != null && memberSetting.size() > 0) {
                    DEFAULT_PROFILE_NAME = memberSetting[0].Applied_Test_Profile__c;
                }
            }
            return DEFAULT_PROFILE_NAME;
        }
    }

    static global String THIS_COMMUNITY_NAME {
        get {
            String commName = '';
            commName = [SELECT Id, Name FROM Network][0].Name;
            system.assertNotEquals(null, commName);
            return commName;
        }
    }

    // this is for standard user to know
    static global String NETWORK_ID {
        get {
            if (NETWORK_ID == null) {

                NETWORK_ID = [SELECT Id FROM Network WHERE Name = :THIS_COMMUNITY_NAME][0].Id;
            }
            system.assertNotEquals(null, NETWORK_ID);
            return NETWORK_ID;

        }
        set {
            NETWORK_ID = value;
            system.assertEquals(value, NETWORK_ID);
        }
    }


    global static List<User> createUsers(Integer howMany, String profileName) {

        List<User> listOfUsers = new List<User>();
        Map<Integer, User> mapUser = new Map<Integer, User>();

        //create account
        Account a = new Account(name = 'TestAccount123', Lead_Source__c='Referral', Industry_Type__c='Retail') ;
        insert a;

        //change by  sachin kadian. if profile name exist in custom metadata, create standard users
        //otherwise create community users
        if (DEFAULT_PROFILE_NAME != null) {
            Profile profile = [SELECT Id, Name FROM Profile WHERE Name = :DEFAULT_PROFILE_NAME];
            for (Integer key = 0; key < howMany; key++) {
                User u = new User(alias = 'com' + key,
                        email = key + 'testtest@test.com',
                        emailencodingkey = 'UTF-8',
                        firstname = key + 'Test',
                        lastname = key + 'Test',
                        languagelocalekey = 'en_US',
                        localesidkey = 'en_US',
                        profileid = profile.Id,
                        timezonesidkey = 'America/Los_Angeles',
                        username = key + 'com' + '@test.com',
                        Department = key < (howMany / 2) ? 'abc' : 'def',
                        Phone = '(5' + key + '5) 555-555 ' + (key * key),
                        IsActive = true);
                mapUser.put(key, u);
                listOfUsers.add(u);
            }
        } else {


            //create contacts
            List<Contact> listOfContacts = new List<Contact>();
            Map<Integer, Contact> mapCont = new Map<Integer, Contact>();

            for (Integer i = 0; i < howMany; i++) {
                Contact c = new Contact(
                        LastName = i + 'Test',
                        Phone = '(5' + i + '5) 555-555 ' + (i * i),
                        AccountId = a.Id);
                listOfContacts.add(c);
                mapCont.put(i, c);
            }
            system.assertNotEquals(null, listOfContacts);
            system.assertEquals(howMany, listOfContacts.size());
            insert listOfContacts;

            // by default bidders
            Id profileId;
            // to make user unique
            String type;
            if (profileName == SVNSUMMITS_Members_TestConstants.COMPANY_COMMUNITY_PROFILE_NAME) {
                profileId = COMPANY_COMMUNITY_PROFILE_Id;
                type = 'com';
            }


            for (Integer key : mapCont.keySet()) {
                User u = new User(alias = type + key,
                        email = key + 'testtest@test.com',
                        communitynickname = key + mapCont.get(key).LastName,
                        emailencodingkey = 'UTF-8',
                        firstname = key + 'Test',
                        lastname = key + 'Test',
                        phone = mapCont.get(key).Phone,
                        languagelocalekey = 'en_US',
                        localesidkey = 'en_US',
                        profileid = profileId,
                        ContactId = mapCont.get(key).Id,
                        timezonesidkey = 'America/Los_Angeles',
                        username = key + type + '@test.com',
                        Department = key < (howMany / 2) ? 'abc' : 'def',
                        IsActive = true);
                mapUser.put(key, u);
                listOfUsers.add(u);
            }

            system.assertNotEquals(null, listOfUsers);

        }

        insert listOfUsers;
        //To create the Members I follow
        List<EntitySubscription> subscriptions = new List<EntitySubscription>();

        for (Integer i = 1; i < howMany; i++) {
            EntitySubscription e = new EntitySubscription(PARENTID = listOfUsers[i].Id, SUBSCRIBERID = listOfUsers[0].Id, NetworkId = NETWORK_ID);
            System.debug(e);
            subscriptions.add(e);
        }
        system.assertNotEquals(null, subscriptions);
        insert subscriptions;

        //To create the likes
        List<FeedItem> feedItems = new List<FeedItem>();
        Map<Integer, FeedItem> mapFeedItem = new Map<Integer, FeedItem>();
        for (Integer key : mapUser.keySet()) {
            FeedItem fi = new FeedItem(Body = 'Test' + mapUser.get(key).communitynickname, Type = 'ContentPost', ParentId = a.Id, Visibility = 'AllUsers');

            mapFeedItem.put(key, fi);
            feedItems.add(fi);
        }
        system.assertNotEquals(null, feedItems);
        insert feedItems;


        List<FeedLike> feedLikes = new List<FeedLike>();
        for (Integer key : mapFeedItem.keySet()) {
            FeedLike fl = new FeedLike(FeedItemId = mapFeedItem.get(key).Id);
            feedLikes.add(fl);
        }
        system.assertNotEquals(null, feedLikes);
        insert feedLikes;

        system.debug('Created ' + listOfUsers.size() + ' users');
        //system.debug('Users:  ' + listOfUsers);

        return listOfUsers;
    }

    global static void createTestTopics() {
        List<Topic> testTopics = new List<Topic>();

        // TODO add network ID
        for (Integer i = 0; i < 3; i++) {
            testTopics.add(new Topic(Name = 'Topic' + i, NetworkId = NETWORK_ID));
        }

        insert testTopics;
    }
}