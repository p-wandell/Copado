/**
 * Created by jasonmiletta on 2/28/17.
 */

@IsTest
private class JiveDashboardUpdateJobTest {

    static testMethod void testJob(){
        setupData();

        Test.startTest();
        JiveDashboardUpdateJobScheduler.schedule(null);
        Test.stopTest();

        List<Jive_Dashboard__c> dashboards = [
                SELECT Bookings_Closed_MTD__c, Bookings_Committed_MTD__c, Bookings_Bestcase_MTD__c,
                        Bookings_Pipeline_MTD__c, Deals_over_200k_MTD_Closed__c, Deals_over_200k_MTD_Pipeline__c,
                        Deals_over_200k_YTD_Closed__c, Deals_over_200k_YTD_Pipeline__c,
                        New_Logos_MTD__c, New_Logos_YTD__c, New_Logos_YTD_Pipeline__c, New_Logos_QTD_Pipeline__c
                FROM Jive_Dashboard__c
        ];
        Jive_Dashboard__c board = dashboards[0];
        /*System.assertEquals(1500000, board.Bookings_Closed_MTD__c);
        System.assertEquals(0, board.Bookings_Committed_MTD__c);
        System.assertEquals(0, board.Bookings_Bestcase_MTD__c);
        System.assertEquals(500000, board.Bookings_Pipeline_MTD__c);
        System.assertEquals(3, board.Deals_over_200k_MTD_Closed__c);
        System.assertEquals(1, board.Deals_over_200k_MTD_Pipeline__c);
        System.assertEquals(5, board.Deals_over_200k_YTD_Closed__c);
        System.assertEquals(2, board.Deals_over_200k_YTD_Pipeline__c);
        System.assertEquals(3, board.New_Logos_QTD_Pipeline__c);
        System.assertEquals(1, board.New_Logos_MTD__c);
        System.assertEquals(3, board.New_Logos_YTD__c);
        System.assertEquals(3, board.New_Logos_YTD_Pipeline__c);*/
    }

    static void setupData() {
        Jive_Dashboard__c dashboard = new Jive_Dashboard__c();
        insert dashboard;

        Account account = new Account(Name='Test Account');
        Account account2 = new Account(Name='Test Account2');
        Account account3 = new Account(Name='Test Account3');
        insert new List<Account>{account, account2, account3};

        Date thisYear = Date.newInstance(System.today().year(), 1, 1);
        Date thisMonth = Date.newInstance(System.today().year(), System.today().month(), 1);
        Date thisQuarter;
        if(Math.mod(System.today().month() + 2, 3) == 2){
            thisQuarter = Date.newInstance(System.today().year(), (System.today().month() - 1), 1);
        } else {
            thisQuarter = Date.newInstance(System.today().year(), System.today().month(), 1);
        }

        Opportunity oppYTD1 = new Opportunity(Name='oppYTD1', AccountId=account.Id, CloseDate=thisYear, StageName='7 Closed Won', amount=500000, Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        Opportunity oppYTD2 = new Opportunity(Name='oppYTD2', AccountId=account.Id, CloseDate=thisYear, StageName='Pipeline', amount=500000, ForecastCategoryName='Stretch ', Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        Opportunity oppMTD1 = new Opportunity(Name='oppMTD1', AccountId=account.Id, CloseDate=thisMonth, StageName='7 Closed Won', amount=500000, Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        Opportunity oppMTD2 = new Opportunity(Name='oppMTD2', AccountId=account.Id, CloseDate=thisMonth, StageName='Pipeline', amount=500000, ForecastCategoryName='Stretch ', Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        Opportunity oppMTD3 = new Opportunity(Name='oppMTD3', AccountId=account.Id, CloseDate=thisMonth, StageName='Pipeline', ForecastCategoryName='Commit', Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        Opportunity oppMTD4 = new Opportunity(Name='oppMTD4', AccountId=account.Id, CloseDate=thisMonth, StageName='Pipeline', ForecastCategoryName='Best Case', Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');

        Opportunity logoOpp1 = new Opportunity(Name='logoOpp1', AccountId=account2.Id, CloseDate=thisQuarter, StageName='7 Closed Won', amount=500000, Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        Opportunity logoOpp2 = new Opportunity(Name='logoOpp2', AccountId=account3.Id, CloseDate=thisMonth, StageName='7 Closed Won', amount=500000, Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        Opportunity logoOpp3 = new Opportunity(Name='logoOpp3', AccountId=account3.Id, CloseDate=thisMonth, StageName='7 Closed Won', amount=500000, Description='test', Link_to_Final_Executed_SOW_PDF__c='https://www.google.com', Solution_Primary_Audience__c='Customer');
        insert new List<Opportunity>{oppYTD1, oppYTD2, oppMTD1, oppMTD2, oppMTD3, oppMTD4, logoOpp1, logoOpp2, logoOpp3};
    }
}