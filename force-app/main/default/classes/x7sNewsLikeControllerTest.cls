/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

/*
@Class Name          : x7sNewsLikeControllerTest
@Created by          :
@Description         : Apex Test class for x7sNewsLikeController
*/
@IsTest
private class x7sNewsLikeControllerTest
{

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
        X7S_News__c newsObj = x7sNewsUtilityTest.createNews(strNetId);
        X7S_News__c newsObj1 = x7sNewsUtilityTest.createNews(strNetId);
        X7S_News__c newsObj2 = x7sNewsUtilityTest.createNews(strNetId);
        X7S_News__c newsObj3 = x7sNewsUtilityTest.createNews(strNetId);
        X7S_News__c newsObj4 = x7sNewsUtilityTest.createNews(strNetId);

        Test.startTest();
        x7sNewsLikeController.likeNews(newsObj.Id);
        x7sNewsLikeController.likeNews(newsObj1.Id);
        x7sNewsLikeController.likeNews(newsObj2.Id);
        x7sNewsLikeController.likeNews(newsObj3.Id);
        x7sNewsLikeController.likeNews(newsObj4.Id);
        System.assert(x7sNewsLikeController.likeNews(null) == false);

        List<X7S_News_Like__c> newsLikes = [
                SELECT Id
                FROM X7S_News_Like__c
                WHERE User__c = :UserInfo.getUserId()
        ];
        System.assert(newsLikes.size() == 5);
        System.assert(x7sNewsLikeController.isLiking(newsObj.Id));

        x7sNewsLikeController.unLikeNews(newsObj.Id);
        x7sNewsLikeController.unLikeNews(newsObj1.Id);
        x7sNewsLikeController.unLikeNews(newsObj2.Id);
        x7sNewsLikeController.unLikeNews(newsObj3.Id);
        x7sNewsLikeController.unLikeNews(newsObj4.Id);
        System.assert(x7sNewsLikeController.unLikeNews(null) == false);

        newsLikes = [
                SELECT Id
                FROM X7S_News_Like__c
                WHERE User__c = :UserInfo.getUserId()
        ];
        System.assert(newsLikes.size() == 0);

        Test.stopTest();
    }

}