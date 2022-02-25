public class AssignmentRollupHelper {
    public static boolean isRunning=false;
    public static void calculate(Set<Id> projectIds) {
        System.debug('******** EXECUTING AssignmentRollupHelper ********');
        List<pse__Proj__c> projects = [SELECT Id, Name, pse__Stage__c,
                                       (SELECT Job_to_Date_Cost__c, Estimate_to_Complete_Cost__c, Baseline_Budget__c, pse__Planned_Hours__c,pse__is_billable__c 
                                        FROM pse__Assignments__r)
                                       FROM pse__Proj__c WHERE Id IN : projectIds AND pse__Project_Type__c='Customer Project'];
        
        List<pse__Proj__c> updatedProjects = new List<pse__Proj__c>();
        for(pse__Proj__c project : projects) {
            System.debug('------ project: ' + project.Id + '    -------- stage: ' + project.pse__Stage__c);
            Decimal closedBaselineBudget = 0.0;
            Decimal closedBaselineBudgetHours = 0.0;
            Decimal closedJTDBillableNBCost = 0.0;
            Decimal closedBaselineBudgetNBHours = 0.0;
            Decimal activeBaselineBudget = 0.0;
            Decimal activeBaselineBudgetHours = 0.0;
            Decimal activeBaselineBudgetNBHours = 0.0;
            Decimal etcBillableNBCost = 0.0;
            Decimal activeJTDBillableNBCost = 0.0;
            for(pse__Assignment__c assignment : project.pse__Assignments__r) {
                
                switch on project.pse__Stage__c {
                    when 'Completed', 'Cancelled' {
                        if(assignment.pse__is_billable__c) {
                            try { closedBaselineBudget += assignment.Baseline_Budget__c; } catch (Exception e) {}
                            try { closedBaselineBudgetHours += assignment.pse__Planned_Hours__c; } catch (Exception e) {}
                        } else {
                            try { closedJTDBillableNBCost += assignment.Job_to_Date_Cost__c; } catch (Exception e) {}
                            try { closedBaselineBudgetNBHours += assignment.pse__Planned_Hours__c; } catch (Exception e) {}
                        }
                    } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                        if(assignment.pse__is_billable__c) {
                            try { activeBaselineBudgetHours += assignment.pse__Planned_Hours__c; } catch (Exception e) {}
                            try { activeBaselineBudget += assignment.Baseline_Budget__c; } catch (Exception e) {}
                        } else {
                            try { activeBaselineBudgetNBHours += assignment.pse__Planned_Hours__c; } catch (Exception e) {}
                        }
                        try { activeJTDBillableNBCost += assignment.Job_to_Date_Cost__c; } catch (Exception e) {}
                        try { etcBillableNBCost += assignment.Estimate_to_Complete_Cost__c; } catch (Exception e) {}
                    }
                }
                
            }
//            switch on project.pse__Stage__c {
//                when 'Completed', 'Cancelled' {
//                    updatedProjects.add(new pse__Proj__c(Id=project.Id, CLOSED_Baseline_Budget__c=closedBaselineBudget,
//                                                         CLOSED_Baseline_Budget_Hours__c=closedBaselineBudgetHours,
//                                                         CLOSED_JTD_Billable_NB_Cost__c=closedJTDBillableNBCost,
//                                                         CLOSED_Baseline_Budget_NB_Hours__c=closedBaselineBudgetNBHours));
//                } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
//                    updatedProjects.add(new pse__Proj__c(Id=project.Id, ACTIVE_JTD_Billable_NB_Cost__c=activeJTDBillableNBCost,
//                                                         ACTIVE_Baseline_Budget_Hours__c=activeBaselineBudgetHours,
//                                                         ETC_Billable_NB_Cost_del__c=etcBillableNBCost,
//                                                         ACTIVE_Baseline_Budget__c=activeBaselineBudget,
//                                                         ACTIVE_Baseline_Budget_NB_Hours__c=activeBaselineBudgetNBHours));
//                }
//            }
                    updatedProjects.add(new pse__Proj__c(Id=project.Id, CLOSED_Baseline_Budget__c=closedBaselineBudget,
                                                         CLOSED_Baseline_Budget_Hours__c=closedBaselineBudgetHours,
                                                         CLOSED_JTD_Billable_NB_Cost__c=closedJTDBillableNBCost,
                                                         CLOSED_Baseline_Budget_NB_Hours__c=closedBaselineBudgetNBHours,
                                                         ACTIVE_JTD_Billable_NB_Cost__c=activeJTDBillableNBCost,
                                                         ACTIVE_Baseline_Budget_Hours__c=activeBaselineBudgetHours,
                                                         ETC_Billable_NB_Cost_del__c=etcBillableNBCost,
                                                         ACTIVE_Baseline_Budget__c=activeBaselineBudget,
                                                         ACTIVE_Baseline_Budget_NB_Hours__c=activeBaselineBudgetNBHours));            
        }
        
        if(!updatedProjects.isEmpty()) { 
            List<Database.SaveResult> sr = Database.update(updatedProjects);
        }
        System.debug('******** EXITING AssignmentRollupHelper ********');
    }
}