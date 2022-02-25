/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_NewsLikeControllerTest
@Created by          :
@Description         : Apex Test class for SVNSUMMITS_NewsLikeController
*/
@IsTest
private class SVNSUMMITS_NewsLikeControllerTest {

    //Hardcoded Network Id as we can't able to get get Network Id in Test classes.
    //Packaging org
    //public Static String strNetId = '0DB36000000PB5MGAW';

    public static String strNetId {
        get {
            return [SELECT Id FROM Network LIMIT 1][0].Id;
        }
    }

    // Fran Summer 17 org
    //public Static String strNetId = '0DBB0000000CayaOAC';

    @IsTest
    static void test_LikeUnlikeNews(){
        //create News Records
        News__c newsObj = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
        News__c newsObj1 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
        News__c newsObj2 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
        News__c newsObj3 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);
        News__c newsObj4 = SVNSUMMITS_NewsUtilityTest.createNews(strNetId);

        Test.startTest();
        SVNSUMMITS_NewsLikeController.likeNews(newsObj.Id);
        SVNSUMMITS_NewsLikeController.likeNews(newsObj1.Id);
        SVNSUMMITS_NewsLikeController.likeNews(newsObj2.Id);
        SVNSUMMITS_NewsLikeController.likeNews(newsObj3.Id);
        SVNSUMMITS_NewsLikeController.likeNews(newsObj4.Id);
        System.assert(SVNSUMMITS_NewsLikeController.likeNews(null) == false);

        List<News_Like__c> newsLikes = [
                SELECT Id
                FROM News_Like__c
                WHERE User__c = :UserInfo.getUserId()
        ];
        System.assert(newsLikes.size() == 5);
        System.assert(SVNSUMMITS_NewsLikeController.isLiking(newsObj.Id));

        SVNSUMMITS_NewsLikeController.unLikeNews(newsObj.Id);
        SVNSUMMITS_NewsLikeController.unLikeNews(newsObj1.Id);
        SVNSUMMITS_NewsLikeController.unLikeNews(newsObj2.Id);
        SVNSUMMITS_NewsLikeController.unLikeNews(newsObj3.Id);
        SVNSUMMITS_NewsLikeController.unLikeNews(newsObj4.Id);
        System.assert(SVNSUMMITS_NewsLikeController.unLikeNews(null) == false);

        newsLikes = [
                SELECT Id
                FROM News_Like__c
                WHERE User__c = :UserInfo.getUserId()
        ];
        System.assert(newsLikes.size() == 0);

        Test.stopTest();
    }

    @TestSetup
    static void setupData() {

    }
}