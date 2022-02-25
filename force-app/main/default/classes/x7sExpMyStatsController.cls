/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpMyStatsController {

    @AuraEnabled
    public static x7sExpStat getMyNewOpps() {
        x7sExpStat stat = new x7sExpStat();
        Decimal numOfNewOpps = 0;
        Decimal oppAmount = 0;

        // Lookup the current User's open Opportunities. Example code only
        /*for(Opportunity opp: [select Amount from Opportunity where OwnerId =: UserInfo.getUserId() and ForecastCategoryName != 'Closed' and ForecastCategoryName != 'Omitted']){
            numOfNewOpps++;

            if(opp.Amount != null){
                oppAmount += opp.Amount;
            }
        }
        */

        stat.figure1 = numOfNewOpps;
        stat.figure2 = oppAmount;

        return stat;
    }

    @AuraEnabled
    public static x7sExpStat getMyClosedWonOpps() {
        x7sExpStat stat = new x7sExpStat();
        Decimal numOfClosedWonOpps = 0;
        Decimal oppAmount = 0;

        // Lookup the current User's open Opportunities. Example code only
        /*for(Opportunity opp: [select Amount from Opportunity where OwnerId =: UserInfo.getUserId() and ForecastCategoryName = 'Closed']){
            numOfClosedWonOpps++;

            if(opp.Amount != null){
                oppAmount += opp.Amount;
            }
        }
        */

        stat.figure1 = numOfClosedWonOpps;
        stat.figure2 = oppAmount;

        return stat;
    }

    @AuraEnabled
    public static x7sExpStat getSampleStatApex() {
        x7sExpStat stat = new x7sExpStat();
        Decimal stat1 = 2;
        Decimal stat2 = 3;
        stat.figure1 = stat1;
        stat.figure2 = stat2;

        return stat;
    }


}