public class MilestoneRollupHelper {
    public static boolean isRunning=false;
    public static void calculate(Set<Id> projectIds) {
        System.debug('******** EXECUTING MilestoneRollupHelper ********');
        List<pse__Proj__c> projects = [SELECT Id, Name, pse__Stage__c, (SELECT pse__Milestone_Amount__c, pse__target_date__c FROM pse__Milestones__r)
                                       FROM pse__Proj__c WHERE Id IN : projectIds AND opp_project_type__c = 'Customer Success' ];
        
        List<pse__Proj__c> updatedProjects = new List<pse__Proj__c>();
        for(pse__Proj__c project : projects) {
            Decimal closedBaselineBudget = 0.0;
            Decimal closedJTDBillable = 0.0;
            Decimal activeBaselineBudget = 0.0;
            Decimal	activeJTDBillable = 0.0;
            Decimal etcBillable = 0.0;
            for(pse__Milestone__c milestone : project.pse__Milestones__r) {
                
                if(milestone.pse__Target_Date__c<System.today()) {
                    switch on project.pse__Stage__c {
                        when 'Completed', 'Cancelled' {
                            try { closedBaselineBudget += milestone.pse__Milestone_Amount__c; } catch (Exception e) {}
                            try { closedJTDBillable += milestone.pse__Milestone_Amount__c; } catch (Exception e) {}
                        } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                            try { activeJTDBillable += milestone.pse__Milestone_Amount__c; } catch (Exception e) {}
                        }
                    }
                }
                
                try { activeBaselineBudget += milestone.pse__Milestone_Amount__c; } catch (Exception e) {}
                if(milestone.pse__Target_Date__c>=System.today()) {
                    try { etcBillable += milestone.pse__Milestone_Amount__c; } catch (Exception e) {}
                }
                
            }
            switch on project.pse__Stage__c {
                when 'Completed', 'Cancelled' {
                    updatedProjects.add(new pse__Proj__c(Id=project.Id, CLOSED_Baseline_Budget_CS__c=closedBaselineBudget,
                                                         CLOSED_JTD_Billable_CS__c=closedJTDBillable, ETC_Billable_CS__c=etcBillable));
                } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                    updatedProjects.add(new pse__Proj__c(Id=project.Id, ACTIVE_Baseline_Budget_CS__c=activeBaselineBudget,
                                                         ACTIVE_JTD_Billable_CS__c=activeJTDBillable, ETC_Billable_CS__c=etcBillable));
                }
            }
        }
        
        if(!updatedProjects.isEmpty()) { 
            List<Database.SaveResult> sr = Database.update(updatedProjects);
        }
        System.debug('******** EXITING MilestoneRollupHelper ********');
    }
}