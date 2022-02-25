public class OpportunityRollupHelper {
    public static void calculate(Set<Id> projectIds) {
        AggregateResult [] opps = [SELECT pse__Primary_Project__c Id, SUM(Svcs_Amt_for_NetSuite2__c) SvcsAmount 
                                   FROM Opportunity 
                                   WHERE pse__Primary_Project__c IN : ProjectIds 
                                   AND (
                                       (Project_Type__c IN ('New Project', 'Customer Success') AND StageName NOT IN ('9 Closed Lost' , '10 No Opportunity')) 
                                       OR 
                                       (Project_Type__c='Change Order' AND StageName='8 Closed Won')
                                   )
                                   GROUP BY pse__Primary_Project__c];
        
        System.debug('-------- opps: ' + opps);
        
        List<pse__Proj__c> updatedProjects = new List<pse__Proj__c>();
        for(AggregateResult opp : opps) {
            
            if(opp.get('Id') != null) { updatedProjects.add(new pse__Proj__c(Id=(Id)opp.get('Id'), SOW_Budget__c=(Decimal)opp.get('SvcsAmount'))); }
            
        }
        
        System.debug('-------- updatedProjects: ' + updatedProjects);
        if(!updatedProjects.isEmpty()) { update updatedProjects; }
        
    }
    
    public static void calculate(List<Opportunity> opportunities) {
        System.debug('------ IN CALCULATE FOR Accounts & Quotas -----');
        Set<Id> accountIds = new Set<Id>();
        Set<Id> childOppIds = new Set<Id>();
        Set<Id> quotaIds = new Set<Id>();
        for(Opportunity opp : opportunities) {
            if(!opp.isDeleted && opp.isWon) {
                if(!accountIds.contains(opp.AccountId)) { accountIds.add(opp.AccountId); }                
            }
            if(opp.opp_hierarchy_status__c == 'Child Opportunity') {
                if(!childOppIds.contains(opp.Id)) { childOppIds.add(opp.Id); }
            }
            if(!quotaIds.contains(opp.Quota_Name__c)) { quotaIds.add(opp.Quota_Name__c); }
        }
        
        if(!accountIds.isEmpty()) { rollupToAccounts(accountIds); }

        if(!childOppIds.isEmpty()) { rollupHierarchy(childOppIds); }
        
        if(!quotaIds.isEmpty()) { rollupQuotas(quotaIds); }
    }
    
    private static void rollupHierarchy(Set<Id> childOppIds) {
        Map<Id, Opportunity_Hierarchy__c> hierarchyMap = new Map<Id, Opportunity_Hierarchy__c>();
        List<Opportunity> childOpps = [SELECT Parent_Opportunity__c, Svcs_Amt_for_NetSuite2__c, Product_Only_Sub_Total__c, isWon
                                       FROM Opportunity WHERE Id IN : childOppIds];
        System.debug('--------- childOpps: ' + childOpps);
        for(Opportunity childOpp : childOpps) {
            if(childOpp.Parent_Opportunity__c != null) {
                if(!hierarchyMap.containsKey(childOpp.Parent_Opportunity__c)) { 
                    hierarchyMap.put(childOpp.Parent_Opportunity__c, 
                                     new Opportunity_Hierarchy__c(Id=childOpp.Parent_Opportunity__c, 
                                                                  Child_Opps_Svcs_Only_Sub_Total__c=0,
                                                                  Child_Opps_Prod_Only_SubTotal__c=0));
                }
                if(childOpp.isWon) {
                    hierarchyMap.get(childOpp.Parent_Opportunity__c).Child_Opps_Svcs_Only_Sub_Total__c += childOpp.Svcs_Amt_for_NetSuite2__c;
                    hierarchyMap.get(childOpp.Parent_Opportunity__c).Child_Opps_Prod_Only_SubTotal__c += childOpp.Product_Only_Sub_Total__c;
                }
            }
        }
        if(!hierarchyMap.isEmpty()) { update hierarchyMap.values(); }
    }
    
    private static void rollupQuotas(Set<Id> quotaIds) {
        List<Opportunity> opps = [SELECT Amount, Quota_Name__c, Month_Won__c, Quarter_Won__c FROM Opportunity WHERE Quota_Name__c IN : quotaIds];
        Map<Id, Quota_Detail__c> quotaMap = new Map<Id, Quota_Detail__c>();
        for(Opportunity opp : opps) {
            if(opp.Quota_Name__c != null) {
                System.debug('-------- Quota_Name__c: ' + opp.Quota_Name__c);
                if(!quotaMap.containsKey(opp.Quota_Name__c)) { quotaMap.put(opp.Quota_Name__c,
                                                                            new Quota_Detail__c(Id=opp.Quota_Name__c,
                                                                                                January_Attained__c=0,
                                                                                                February_Attained__c=0,
                                                                                                March_Attained__c=0,
                                                                                                April_Attained__c=0,
                                                                                                May_Attained__c=0,
                                                                                                June_Attained__c=0,
                                                                                                July_Attained__c=0,
                                                                                                August_Attained__c=0,
                                                                                                September_Attained__c=0,
                                                                                                October_Attained__c=0,
                                                                                                November_Attained__c=0,
                                                                                                December_Attained__c=0,
                                                                                                Q1_Attained__c=0,
                                                                                                Q2_Attained__c	=0,
                                                                                                Q3_Attained__c=0,
                                                                                                Q4_Attained__c=0,
                                                                                                Quota_Attained__c=0
                                                                                               )); }
                Integer monthWon = Integer.valueOf(opp.Month_Won__c);
                switch on monthWon {
                    when 1 { quotaMap.get(opp.Quota_Name__c).January_Attained__c += opp.Amount; }
                    when 2 { quotaMap.get(opp.Quota_Name__c).February_Attained__c += opp.Amount; }
                    when 3 { quotaMap.get(opp.Quota_Name__c).March_Attained__c += opp.Amount; }
                    when 4 { quotaMap.get(opp.Quota_Name__c).April_Attained__c += opp.Amount; }
                    when 5 { quotaMap.get(opp.Quota_Name__c).May_Attained__c += opp.Amount; }
                    when 6 { quotaMap.get(opp.Quota_Name__c).June_Attained__c += opp.Amount; }
                    when 7 { quotaMap.get(opp.Quota_Name__c).July_Attained__c += opp.Amount; }
                    when 8 { quotaMap.get(opp.Quota_Name__c).August_Attained__c += opp.Amount; }
                    when 9 { quotaMap.get(opp.Quota_Name__c).September_Attained__c += opp.Amount; }
                    when 10 { quotaMap.get(opp.Quota_Name__c).October_Attained__c += opp.Amount; }
                    when 11 { quotaMap.get(opp.Quota_Name__c).November_Attained__c += opp.Amount; }
                    when 12 { quotaMap.get(opp.Quota_Name__c).December_Attained__c += opp.Amount; }
                }
                
                Integer quarterWon = Integer.valueOf(opp.Quarter_Won__c);
                switch on quarterWon {
                    when 1 { quotaMap.get(opp.Quota_Name__c).Q1_Attained__c += opp.Amount; }
                    when 2 { quotaMap.get(opp.Quota_Name__c).Q2_Attained__c += opp.Amount; }
                    when 3 { quotaMap.get(opp.Quota_Name__c).Q3_Attained__c += opp.Amount; }
                    when 4 { quotaMap.get(opp.Quota_Name__c).Q4_Attained__c += opp.Amount; }
                }
                
                quotaMap.get(opp.Quota_Name__c).Quota_Attained__c += opp.Amount;
            }
        }
        
        if(!quotaMap.isEmpty()) { update quotaMap.values(); }
    }
    
    @future
    public static void rollupToAccounts(Set<Id> accountIds) {
        List<Opportunity> opps = [SELECT AccountId, Amount, Svcs_Amt_for_NetSuite2__c,Product_Only_Sub_Total__c, CloseDate 
                                  FROM Opportunity WHERE isDeleted=false and isWon=true AND AccountId IN : accountIds];
        Map<Id, Account> accountMap = new Map<Id, Account>();
        for(Opportunity opp : opps) {
            if(!accountMap.containsKey(opp.AccountId)) { accountMap.put(opp.AccountId, new Account(Id=opp.AccountId, CY_Closed_Won_Opps_Products_Only__c=0, CY_ClosedWon_Opps_Services_Only__c=0, Won_Sales_All_Time__c=0)); }
            if(opp.Amount != null) { accountMap.get(opp.AccountId).Won_Sales_All_Time__c += opp.Amount; }
            if(opp.CloseDate.year() == System.today().year()) {
                if(opp.Product_Only_Sub_Total__c != null) { accountMap.get(opp.AccountId).CY_Closed_Won_Opps_Products_Only__c += opp.Product_Only_Sub_Total__c; }
                if(opp.Svcs_Amt_for_NetSuite2__c != null) { accountMap.get(opp.AccountId).CY_ClosedWon_Opps_Services_Only__c += opp.Svcs_Amt_for_NetSuite2__c; }
            }
        }
        
        if(!accountMap.isEmpty()) { update accountMap.values(); }
    }
    
}