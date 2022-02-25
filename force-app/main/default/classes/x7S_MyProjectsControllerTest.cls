/* Copyright © 2016-2017 7Summits, Inc. All rights reserved. */
@IsTest
public class x7S_MyProjectsControllerTest {

    public static Id testUserId = [SELECT Id FROM User WHERE Name LIKE '%Soddy%' AND IsActive = TRUE AND CompanyName = '7Summits'].Id;

    @IsTest(SeeAllData=true)
    static void getContactIdTest() {
        String contactId = x7S_MyProjectsController.getContactId(testUserId);
        System.assert(contactId != null);
    }

    @IsTest(SeeAllData=true)
    static void getMyProjectsTest() {
        List<SObject> myProjectsList = x7S_MyProjectsController.getMyProjects(testUserId);
        System.assert(myProjectsList.size() > 0);
    }
}