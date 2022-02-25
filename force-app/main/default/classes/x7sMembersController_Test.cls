/*
 * Copyright (c) 2020. 7Summits Inc.
 */

/**
 * @Class Name		  : x7sMembersController_Test
 * @Description		 : Apex Test class for x7sMembersController
*/

@IsTest
private class x7sMembersController_Test {

    User objTestUser;
    
    @testSetup static void createData() {
        insert new TriggerSettings__c(Name='FeedItem', ObjectName__c='FeedItem', IsTestMode__c=false);
    }

    @IsTest
    private static void testAllMethods() {
        x7sMembersWrapper testWrapper = new x7sMembersWrapper();
        System.assertNotEquals(null, testWrapper);

        x7sMembersController_Test test1 = new x7sMembersController_Test();
        List<User> testUsers = x7sMembersTestUtil.createUsers(8, x7sMembersTestConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        System.assertEquals(8, testUsers.size());

        test1.objTestUser = testUsers[0];

        System.runAs(test1.objTestUser) {

            Test.startTest();

            x7sMembersController.networkId = x7sMembersTestUtil.NETWORK_ID;
            System.assertNotEquals(x7sMembersController.networkId, null);

            //To test the methods in members controller class
            //on load default values & to check only the test records.
            x7sMembersWrapper membrs = x7sMembersController.getMembers(8, 'Sort by First Name', '', 'Test');
            System.assertNotEquals(membrs.membersList, null);
            System.assertEquals(membrs.listSizeValue, 8);

            x7sMembersWrapper nxtmembrs = x7sMembersController.nextPage(4, 1, 'Sort by First Name', '', 'Test');
            System.assertEquals(2, nxtmembrs.pageNumber);
            System.assertEquals(4, nxtmembrs.listSizeValue);
            System.assert(nxtmembrs.totalResults > 0);

            x7sMembersWrapper prevmembrs = x7sMembersController.previousPage(4, 2, 'Sort by First Name', '', 'Test');
            System.assertEquals(1, prevmembrs.pageNumber);
            System.assertEquals(4, prevmembrs.listSizeValue);
            System.assert(prevmembrs.totalResults > 0);

            x7sMembersController.getSitePrefix();

            x7sMembersWrapper membrs1 = x7sMembersController.getMembers(7, 'Sort by Last Name', 'Members I Follow', 'Test');
            System.assertEquals(membrs1.membersList[6].Name, '7Test 7Test');

            x7sMembersWrapper membrs2 = x7sMembersController.getMembers(8, 'Sort by First Name', '', 'Test');
            System.assertNotEquals(membrs2.membersList[0].Name, null);

            x7sMembersWrapper membrs3 = x7sMembersController.getMembers(8, 'Sort by Last Name', '', 'Test');
            System.assertEquals(8, membrs3.membersList.size());

            Test.stopTest();
        }
    }

    @IsTest
    private static void testCount() {
        x7sMembersController_Test test1 = new x7sMembersController_Test();
        x7sMembersController.networkId = x7sMembersTestUtil.NETWORK_ID;
        System.assertNotEquals(x7sMembersController.networkId, null);

        List<User> testUsers = x7sMembersTestUtil.createUsers(8, x7sMembersTestConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        System.assertEquals(8, testUsers.size());

        test1.objTestUser = testUsers[0];

        System.runAs(test1.objTestUser) {
            Test.startTest();

            // total count
            Decimal memberCount = x7sMembersController.getMemberCount();
            System.debug('Member count = ' + memberCount);
            System.assert(memberCount > 0);

            Test.stopTest();
        }
    }

    @IsTest
    private static void testExcludedMembers() {
        x7sMembersController_Test test1 = new x7sMembersController_Test();
        x7sMembersController.networkId = x7sMembersTestUtil.NETWORK_ID;
        System.assertNotEquals(x7sMembersController.networkId, null);

        List<User> testUsers = x7sMembersTestUtil.createUsers(8, x7sMembersTestConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        System.assertEquals(8, testUsers.size());

        test1.objTestUser = testUsers[0];

        System.runAs(test1.objTestUser) {
            Decimal memberCount = x7sMembersController.getMemberCount();

            List<String> excluded = new List<String>();
            // test with excluded IDs
            x7sMembersWrapper members = x7sMembersController.getMembers(8, 'Sort by Last Name', '', 'Test');

            excluded.add(members.membersList[0].Id);
            excluded.add(members.membersList[1].Id);
            x7sMembersWrapper membersSortByLastName = x7sMembersController.getMembersEx(6, 'Sort by Last Name', '', 'Test', excluded);
            System.assertEquals(6, membersSortByLastName.membersList.size());
            System.assertEquals(membersSortByLastName.membersList[0].Name, '2Test 2Test');

            x7sMembersWrapper membersNextPage = x7sMembersController.nextPageEx(4, 1, 'Sort by Last Name', 'Members I Follow', 'Test', excluded);
            System.assertNotEquals(null, membersNextPage);

            x7sMembersWrapper membersPreviousPage = x7sMembersController.previousPageEx(4, 2, 'Sort by Last Name', 'Members I Follow', 'Test', excluded);
            System.assertNotEquals(null, membersPreviousPage);

            // total excluding Ids
            Decimal exMemberCount = x7sMembersController.getMemberCountEx(excluded);
            System.debug('Member count (Ex) = ' + exMemberCount);
            System.assert(memberCount > exMemberCount);
        }
    }

    @IsTest
    private static void testGetMembersList() {
        x7sMembersController_Test test1 = new x7sMembersController_Test();
        x7sMembersController.networkId = x7sMembersTestUtil.NETWORK_ID;
        System.assertNotEquals(x7sMembersController.networkId, null);

        //TestSetupData
        List<User> testUsers = x7sMembersTestUtil.createUsers(8, x7sMembersTestConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        System.assertEquals(8, testUsers.size());

        test1.objTestUser = testUsers[0];

        System.runAs(test1.objTestUser) {
            Test.startTest();

            x7sMembersWrapper members = x7sMembersController.getMemberList(
                    100,
                    1,
                    'Sort by Last Name',
                    '',
                    'Test',
                    null,
                    null);
            System.assert(members.membersList.size() > 0);
            System.debug('testGetMembersList - total found ' + members.membersList.size());

            // next page
            x7sMembersWrapper membersPage2 = x7sMembersController.getMemberList(
                    6,
                    2,
                    'Sort by Last Name',
                    '',
                    'Test',
                    '',
                    false,
                    null,
                    null);
            System.assert(membersPage2.membersList.size() > 0);

            // text excluded members
            List<String> excluded = new List<String>();

            excluded.add(members.membersList[0].Id);
            excluded.add(members.membersList[1].Id);

            x7sMembersWrapper members1 = x7sMembersController.getMemberList(
                    100,
                    1,
                    'Sort by Last Name',
                    '',
                    'Test',
                    '',
                    excluded,
                    null
            );
            System.debug('testGetMembersList - total excluded found ' + members1.membersList.size());
            System.assertEquals(2, members.membersList.size() - members1.membersList.size());

            Test.stopTest();
        }
    }

    @IsTest
    private static void testFeaturedMembersLwc() {
        x7sMembersController_Test test1 = new x7sMembersController_Test();
        x7sMembersController.networkId = x7sMembersTestUtil.NETWORK_ID;
        System.assertNotEquals(x7sMembersController.networkId, null);

        //TestSetupData
        List<User> testUsers = x7sMembersTestUtil.createUsers(8, x7sMembersTestConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        System.assertEquals(8, testUsers.size());

        test1.objTestUser = testUsers[0];

        System.runAs(test1.objTestUser) {
            Test.startTest();
            x7sMembersWrapper members = x7sMembersController.getMemberListC(
                    100,
                    1,
                    'Sort by Last Name',
                    '',
                    '',
                    '',
                    false,
                    null,
                    null,
                    null);

            System.assert(members.membersList.size() > 0);
            List<String> listNickNames = new List<String>{
                    members.membersList[0].CommunityNickname,
                    members.membersList[1].CommunityNickname,
                    members.membersList[2].CommunityNickname,
                    members.membersList[3].CommunityNickname
            };

            x7sMembersWrapper featuredMembers = x7sMembersController.getFeaturedMembersLwc(
                    listNickNames, false);
            System.assert(featuredMembers != null);

            x7sMembersWrapper featuredMembers1 = x7sMembersController.getFeaturedMembersLwc(
                    null, true);
            System.assert(featuredMembers1 != null);

            Test.stopTest();
        }
    }


    @IsTest
    private static void searchMembersTest() {
        x7sMembersController_Test test1 = new x7sMembersController_Test();
        x7sMembersController.networkId = x7sMembersTestUtil.NETWORK_ID;
        System.assertNotEquals(x7sMembersController.networkId, null);

        //TestSetupData
        List<User> testUsers = x7sMembersTestUtil.createUsers(8, x7sMembersTestConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        System.assertEquals(8, testUsers.size());

        test1.objTestUser = testUsers[0];

        System.runAs(test1.objTestUser) {
            Test.startTest();

            String searchString = '0Test';

            x7sMembersWrapper members = x7sMembersController.getMemberListC(
                    100,
                    1,
                    'Sort by Last Name',
                    '',
                    searchString,
                    '',
                    false,
                    null,
                    null,
                    null);

            System.assert(members.membersList.size() > 0);

            searchString = '54:phone;';
            members = x7sMembersController.getMemberListC(
                    100,
                    1,
                    'Sort by First Name',
                    '',
                    searchString,
                    '',
                    false,
                    null,
                    null,
                    null);
            System.assert(members.membersList.size() > 0);

            Test.stopTest();
        }
    }

    @IsTest
    private static void testGetFilterMemberPickLists() {
        Test.startTest();

        x7sMembersController_Test test1 = new x7sMembersController_Test();
        System.assertNotEquals(null, test1);

        x7sMembersController.networkId = x7sMembersTestUtil.NETWORK_ID;
        System.assertNotEquals(x7sMembersController.networkId, null);

        //TestSetupData
        List<User> testUsers = x7sMembersTestUtil.createUsers(8, x7sMembersTestConstants.COMPANY_COMMUNITY_PROFILE_NAME);
        System.assertEquals(8, testUsers.size());

        List<String> countries = x7sMembersController.getMemberPicklist('Contact.MailingCountry', '');
        System.debug('Countries ' + countries);
        System.assertNotEquals(null, countries);

        List<String> cities = x7sMembersController.getMemberPicklist('Contact.MailingCity', '');
        System.debug('Cities:   ' + cities);
        System.assertNotEquals(null, cities);

        List<String> states = x7sMembersController.getMemberPicklist('Contact.MailingState', '');
        System.debug('States:   ' + states);
        System.assertNotEquals(null, states);

        Test.stopTest();
    }

    @IsTest
    private static void testWhereClause() {
        // No database involved
        String search = 'apple';
        String result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);

        search = 'apple:;';
        result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);

        search = 'apple:phone,email;Contact.MailingCountry:US';
        result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);

        search = 'apple:phone,email;Contact.MailingCountry:US;Contact.MailingCity:Lawrence';
        result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);

        search = ':;Contact.MailingCountry:US;Contact.MailingCity:Lawrence';
        result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);

        search = 'apple:;Contact.MailingCountry:US;Contact.MailingCity:Lawrence';
        result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);
    }

    @IsTest
    private static void testWhereCustomField() {
        String search = 'apple';
        String result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);

        search = ':;Contact.Level__c:Primary';
        result = x7sMembersController.getWhereClause(search, null);
        System.debug('Search: ' + search);
        System.debug('Result: ' + result);
        System.assertNotEquals('', result);
    }

    @IsTest
    private static void testGetTopicValues() {
        Test.startTest();

        Map<String, String> topics = x7sMembersController.getTopicValues();
        System.assertNotEquals(null, topics);

        Test.stopTest();
    }

    @IsTest
    private static void testGetMemberIdList() {
        Set<String> testItems = new Set<String>{
                '1', '2', '3'
        };

        String testString = x7sMembersController.getMemberIdList(testItems);
        System.assertNotEquals(null, testString);
    }

    @IsTest
    private static void testSetCustomFields() {
        List<String> customFieldList = new List<String>{
                'field1', 'field2', 'field3'
        };
        x7sMembersController.setCustomFields(customFieldList);
        System.assertNotEquals(null, x7sMembersController.customFieldList);
    }
}