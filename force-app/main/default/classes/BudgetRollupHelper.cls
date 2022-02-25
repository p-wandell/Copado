public class BudgetRollupHelper {
    public static void calculate(Set<Id> projectIds) {
        List<pse__Proj__c> projects = [SELECT Id, Name, pse__Stage__c,
                                       (SELECT budget_amount__c , pse__project__c FROM pse__Budgets__r)
                                       FROM pse__Proj__c 
                                       WHERE Id IN : projectIds AND pse__project_type__c = 'Customer Project'];

        List<pse__Proj__c> updatedProjects = new List<pse__Proj__c>();
        for(pse__Proj__c project : projects) {
            Decimal closedSOWBudget = 0.0;
            Decimal activeSOWBudget = 0.0;
            for(pse__Budget__c budget : project.pse__Budgets__r) {
                
                switch on project.pse__Stage__c {
                    when 'Completed', 'Cancelled' {
						closedSOWBudget += budget.Budget_Amount__c;
                    } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
						activeSOWBudget +=  budget.Budget_Amount__c;
                    }
                }
                
            }
            switch on project.pse__Stage__c {
                when 'Completed', 'Cancelled' {
                    updatedProjects.add(new pse__Proj__c(Id=project.Id, CLOSED_SOW_Budget__c=closedSOWBudget));
                } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                    updatedProjects.add(new pse__Proj__c(Id=project.Id, ACTIVE_SOW_Budget__c=activeSOWBudget));
                }
            }
        }
        
        if(!updatedProjects.isEmpty()) { update updatedProjects; }
    }
}