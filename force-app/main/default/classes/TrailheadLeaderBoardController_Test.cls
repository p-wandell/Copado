@istest
global with sharing class TrailheadLeaderBoardController_Test{

    @testsetup static void testdata(){
    
        Account a = new Account(Name='Test', Lead_Source__c='Referral');
        insert a;
        
        Contact c = new contact();
        c.LastName = 'test';
        c.Trails__c = 0;
        c.Total_Points__c = 1000;
        c.Active_Upload__c = 200;
        c.Points_check_in__c = 500;
        c.Active__c = true;
        c.AccountId=a.id;
        insert c;
        
        // No active upload
        Contact c2 = new contact();
        c2.LastName = 'test';
        c2.Total_Points__c = 1000;
        c2.Points_check_in__c = 500;
        c2.Badges_Upload__c = 1;
        c2.Retired_Upload__c = 1;
        c2.Trails__c = 0;
        c2.Active__c = true;
        c2.AccountId=a.id;
        insert c2;
        
        Trailhead_Leaderboard_Settings__c ts = new Trailhead_Leaderboard_Settings__c();
        ts.name = 'test';
        ts.Finish_Message__c = 'test';
        ts.Header_Message__c = 'test';
        ts.Target_time__c = '07/26/2015 1:00 PM UTC-0630';
        insert ts;  
    }
    
    @istest static void testController(){
    
        PageReference pageRef = Page.trailheadLeaderboard;
        Test.setCurrentPage(pageRef);

        trailheadLeaderboardController tl = new trailheadleaderboardcontroller();   
    }
}