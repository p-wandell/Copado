/**
 * Created by jasonmiletta on 2/28/17.
 */

global with sharing class JiveDashboardUpdateJob {
    static Double bookingsClosedMTD = 0;
    static Double bookingsCommittedMTD = 0;
    static Double bookingsBestCaseMTD = 0;
    static Double bookingsPipelineMTD = 0;

    static Integer dealsOver200kMTDClosed = 0;
    static Integer dealsOver200kMTDPipeline = 0;
    static Integer dealsOver200kMTDCommitted = 0;
    static Integer dealsOver200kYTDClosed = 0;
    static Integer dealsOver200kYTDPipeline = 0;
    static Integer dealsOver200kYTDTotalPipeline = 0;

    static Integer newLogosQTD = 0;
    static Integer newLogosMTD = 0;
    static Integer newLogosYTD = 0;
    static Integer newLogosQTDPipeline = 0;
    static Integer newLogosYTDPipeline = 0;

    static Decimal weeklyPipelineGenerated = 0;
    static Decimal lastMonthPipelineGenerated = 0;

    global void execute() {
        updateSalesData();
    }

    global static void updateSalesData() {
        List<Jive_Dashboard__c> jiveDashboards = [
                SELECT Id, Bookings_Bestcase_MTD__c, Bookings_Committed_MTD__c, Bookings_Pipeline_MTD__c,
                        Bookings_Closed_MTD__c, Deals_over_200k_MTD_Closed__c, Deals_over_200k_MTD_Pipeline__c,
                        Deals_over_200k_YTD_Closed__c, Deals_over_200k_YTD_Pipeline__c, New_Logos_MTD__c,
                        New_Logos_YTD__c, New_Logos_YTD_Pipeline__c, New_Logos_QTD_Pipeline__c,
                        Weekly_Pipeline_Generated__c, Monthly_Pipeline_Generated__c,
                        Deals_over_200k_YTD_Total_Pipeline__c
                FROM Jive_Dashboard__c
                LIMIT 1
        ];

        if(jiveDashboards == null || jiveDashboards.size() <= 0){
            System.debug('No Jive Dashboard Record Found!!! Create at least one jive Dashboard record in the environment');
        } else {

            Set<String> accountIds = new Set<String>();

            List<Opportunity> opportunities = [
                    SELECT Id, CreatedDate, Amount, ForecastCategoryName, IsWon, IsClosed, AccountId, CloseDate
                    FROM Opportunity
                    WHERE CloseDate = THIS_YEAR
            ];

            //YTD
            processYTDOpportunities(accountIds, opportunities);

            //MTD
            processMTDOpportunities(accountIds, opportunities);

            //New Logos
            processNewLogos(accountIds);

            //Sum of amount for Any opportunities this week in open or closed/won
            processWeeklyPipelineGeneratedAmount(opportunities);

            Jive_Dashboard__c dashboard = jiveDashboards[0];
            dashboard.Bookings_Closed_MTD__c = bookingsClosedMTD;
            dashboard.Bookings_Committed_MTD__c = bookingsCommittedMTD;
            dashboard.Bookings_Bestcase_MTD__c = bookingsBestCaseMTD;
            dashboard.Bookings_Pipeline_MTD__c = bookingsPipelineMTD;

            dashboard.Deals_over_200k_MTD_Closed__c = dealsOver200kMTDClosed;
            dashboard.Deals_over_200k_MTD_Pipeline__c = dealsOver200kMTDPipeline;
            dashboard.Deals_over_200k_MTD_Committed__c = dealsOver200kMTDCommitted;
            dashboard.Deals_over_200k_YTD_Closed__c = dealsOver200kYTDClosed;
            dashboard.Deals_over_200k_YTD_Pipeline__c = dealsOver200kYTDPipeline;
            dashboard.Deals_over_200k_YTD_Total_Pipeline__c = dealsOver200kYTDTotalPipeline;

            dashboard.New_Logos_MTD__c = newLogosMTD;
            dashboard.New_Logos_YTD__c = newLogosYTD;
            dashboard.New_Logos_QTD_Pipeline__c = newLogosQTDPipeline;
            dashboard.New_Logos_YTD_Pipeline__c = newLogosYTDPipeline;

            dashboard.Weekly_Pipeline_Generated__c = weeklyPipelineGenerated;
            dashboard.Monthly_Pipeline_Generated__c = lastMonthPipelineGenerated;

            try {
                update dashboard;
            } catch (Exception ex){
                System.debug('Failure attempting to update Jive Dashboard Record! => ' + ex);
            }
        }
    }

    private static void processYTDOpportunities(Set<String> accountIds, List<Opportunity> opportunities){
        for(Opportunity opp : opportunities){
            if(opp.CloseDate >= DateTime.newInstanceGmt(System.today().year(), 1, 1) && opp.CloseDate < Datetime.newInstanceGmt(System.today().year(), 1, 1).addYears(1)){
                if (!accountIds.contains(opp.AccountId)) {
                    accountIds.add(opp.AccountId);
                }

                if (opp.Amount > 200000) {
                    if (opp.IsWon) {
                        ++dealsOver200kYTDClosed;
                    } else if (opp.ForecastCategoryName == 'Pipeline') {
                        ++dealsOver200kYTDPipeline;
                    }

                    if(!(opp.IsClosed && !opp.IsWon)){
                        ++dealsOver200kYTDTotalPipeline;
                    }
                }
            }
        }
    }

    private static void processMTDOpportunities(Set<String> accountIds, List<Opportunity> opportunities){
        for(Opportunity opp : opportunities){
            if(opp.CloseDate >= System.today().toStartOfMonth() && opp.CloseDate < Datetime.newInstanceGmt(System.today().year(), System.today().month(), 1).addMonths(1)) {
                if (!accountIds.contains(opp.AccountId)) {
                    accountIds.add(opp.AccountId);
                }

                if(opp.Amount == null){
                    opp.Amount = 0;
                }

                if (opp.IsWon) {
                    bookingsClosedMTD += opp.Amount;
                } else if (opp.ForecastCategoryName == 'Commit') {
                    bookingsCommittedMTD += opp.Amount;
                } else if (opp.ForecastCategoryName == 'Best Case') {
                    bookingsBestCaseMTD += opp.Amount;
                } else if (opp.ForecastCategoryName == 'Pipeline') {
                    bookingsPipelineMTD += opp.Amount;
                }

                if (opp.Amount > 200000) {
                    if (opp.IsWon) {
                        ++dealsOver200kMTDClosed;
                    } else if (opp.ForecastCategoryName == 'Pipeline') {
                        ++dealsOver200kMTDPipeline;
                    } else if(opp.ForecastCategoryName == 'Commit'){
                        ++dealsOver200kMTDCommitted;
                    }
                }
            }
        }
    }

    private static void processNewLogos(Set<String> accountIds) {
        DateTime thisYear = DateTime.newInstanceGmt(System.today().year(), 1, 1);
        Integer thisQuarter = (System.today().month() + 2) / 3;
        DateTime thisMonth = DateTime.newInstanceGmt(System.today().year(), System.today().month(), 1);

        Set<String> newLogoYTDSet = new Set<String>();
        Set<String> newLogoQTDSet = new Set<String>();

        for (Account acc : [
                SELECT Id, (SELECT Id, CloseDate, IsWon, IsClosed FROM Opportunities ORDER BY CloseDate ASC)
                FROM Account
                WHERE Id IN :accountIds
        ]){
            Boolean logoFound = false;
            for(Opportunity opp : acc.Opportunities) {
                if (!logoFound) {
                    if(opp.IsWon){
                        if (opp.CloseDate >= thisYear && opp.CloseDate < thisYear.addYears(1)) {
                            ++newLogosYTD;
                            newLogoYTDSet.add(acc.Id);
                            if (((opp.CloseDate.month() + 2) / 3) == thisQuarter) {
                                ++newLogosQTD;
                                newLogoQTDSet.add(acc.Id);
                            }
                            if (opp.CloseDate >= thisMonth && opp.CloseDate < Datetime.newInstanceGmt(System.today().year(), System.today().month(), 1).addMonths(1)) {
                                ++newLogosMTD;
                            }
                            logoFound = true;
                        }
                    } else if(!(opp.IsClosed && !opp.IsWon)){
                        if (opp.CloseDate >= thisYear && opp.CloseDate < thisYear.addYears(1)) {
                            newLogoYTDSet.add(acc.Id);
                            if (((opp.CloseDate.month() + 2) / 3) == thisQuarter) {
                                newLogoQTDSet.add(acc.Id);
                            }
                            logoFound = true;
                        }
                    }
                } else {
                    break;
                }
            }
        }

        newLogosYTDPipeline = newLogoYTDSet.size();
        newLogosQTDPipeline = newLogoQTDSet.size();
    }

    private static void processWeeklyPipelineGeneratedAmount(List<Opportunity> opportunities){
        for(Opportunity opp : opportunities){
            if(opp.CreatedDate >= System.today().toStartOfWeek() && opp.CreatedDate < System.today().toStartOfWeek().addDays(7)){
                weeklyPipelineGenerated += (opp.Amount != null ? opp.Amount : 0);
            }
            if(opp.CreatedDate >= System.today().toStartOfMonth().addMonths(-1) && opp.CreatedDate < System.today().toStartOfMonth()){
                lastMonthPipelineGenerated += (opp.Amount != null ? opp.Amount : 0);
            }
        }
    }
}