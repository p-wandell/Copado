public class EstVsActualsRollupHelper {
    public static boolean isRunning=false;
    
    public static void calculate(Set<Id> projectIds) {
        System.debug('******** EXECUTING EstVsActualsRollupHelper ********');
        List<pse__Proj__c> projects = [SELECT Id, Name, pse__Stage__c,
                                       (SELECT pse__Assignment__c, Total_Scheduled_Hours__c, Scheduled_Nonbill_Hours__c, Scheduled_Hours__c, Scheduled_Billable_Hours__c 
                                        FROM pse__Est_vs_Actuals__r WHERE pse__Time_Period_Type__c='Week')
                                       FROM pse__Proj__c WHERE Id IN : projectIds AND pse__Project_Type__c='Customer Project'];
        
        List<pse__Proj__c> updatedProjects = new List<pse__Proj__c>();
        for(pse__Proj__c project : projects) {
            Decimal etcBillableNBHours = 0.0;
            Decimal etcNonbillHours = 0.0;
            Decimal etcBillableTM = 0.0;
            Decimal etcBillableHours = 0.0;
            for(pse__Est_vs_Actuals__c est : project.pse__Est_vs_Actuals__r) {
                
                switch on project.pse__Stage__c {
                    when 'Completed', 'Cancelled' {

                    } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                        try { etcBillableNBHours += est.Total_Scheduled_Hours__c; } catch (Exception e) {}
                        try { etcNonbillHours += est.Scheduled_Nonbill_Hours__c; } catch (Exception e) {}
                        try { etcBillableTM += est.Scheduled_Hours__c; } catch (Exception e) {}
                        try { etcBillableHours += est.Scheduled_Billable_Hours__c; } catch (Exception e) {}
                    }
                }
                
            }
            switch on project.pse__Stage__c {
                when 'Completed', 'Cancelled' {

                } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
					updatedProjects.add(new pse__Proj__c(Id=project.Id, ETC_Billable_NB_Hours__c=etcBillableNBHours,
                                                         ETC_Nonbill_Hours__c=etcNonbillHours,
                                                         ETC_Billable_TM__c=etcBillableTM,
                                                         ETC_Billable_Hours__c=etcBillableHours));
                }
            }
        }
        
        if(!updatedProjects.isEmpty()) { update updatedProjects; }
        updateAssignments(projectIds);
        System.debug('******** EXITING EstVsActualsRollupHelper ********');
    }
    
    @future
    private static void updateAssignments(Set<Id> projectIds) {
        System.debug('******** EXECUTING EstVsActualsRollupHelper-future method ********');
        EstVsActualsRollupHelper.isRunning=true;
        List<pse__Proj__c> projects = [SELECT Id, Name, pse__Stage__c,
                                       (SELECT pse__Assignment__c, Total_Scheduled_Hours__c, Scheduled_Nonbill_Hours__c, Scheduled_Hours__c, Scheduled_Billable_Hours__c 
                                        FROM pse__Est_vs_Actuals__r WHERE pse__Time_Period_Type__c='Week')
                                       FROM pse__Proj__c WHERE Id IN : projectIds AND pse__Project_Type__c='Customer Project'];
        
        Map<Id, pse__Assignment__c> assignmentMap = new Map<Id, pse__Assignment__c>();
        for(pse__Proj__c project : projects) {

            for(pse__Est_vs_Actuals__c est : project.pse__Est_vs_Actuals__r) {
                
                switch on project.pse__Stage__c {
                    when 'Completed', 'Cancelled' {

                    } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                        if(est.pse__Assignment__c != null) {
                            if(!assignmentMap.containsKey(est.pse__Assignment__c)) { 
                                assignmentMap.put(est.pse__Assignment__c, new pse__Assignment__c(Id=est.pse__Assignment__c, Estimate_to_Complete_Hours__c=0.0)); 
                            }
                            try { assignmentMap.get(est.pse__Assignment__c).Estimate_to_Complete_Hours__c += est.Total_Scheduled_Hours__c; } catch (Exception e) {}
                        }
                    }
                }
                
            }

        }
        
        if(!assignmentMap.isEmpty()) { 
            List<Database.SaveResult> sr = Database.update(assignmentMap.values(), false); 
        }
        System.debug('******** EXITING EstVsActualsRollupHelper ********');        
    }
}