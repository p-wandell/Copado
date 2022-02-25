public class TimecardRollupHelper {
    public static boolean isRunning=false;
    
    public static void calculate(Set<Id> projectIds) {
        List<pse__Timecard_Header__c> timecards = [SELECT Id, pse__Assignment__c, pse__Total_Hours__c, pse__Project__r.pse__Stage__c, pse__Total_Billable_Amount__c, pse__billable__c
                                                   FROM pse__Timecard_Header__c
                                                   WHERE pse__Project__c IN : projectIds AND
                                                   pse__approved__c = TRUE AND 
                                                   pse__project__r.pse__project_type__c = 'Customer Project'];
        
        Map<Id, pse__Proj__c> projectMap = updateProjects(timecards);
        Map<Id, pse__Assignment__c> assignmentMap = updateAssignments(timecards);
        
        if(!assignmentMap.isEmpty()) {
            List<Database.SaveResult> sr = Database.update(assignmentMap.values(), false);
        }
        if(!projectMap.isEmpty()) {
            List<Database.SaveResult> sr = Database.update(projectMap.values(), false);
        }
    }
    
    
    private static Map<Id, pse__Assignment__c> updateAssignments(List<pse__Timecard_Header__c> timecards) {
        
        Map<Id, pse__Assignment__c> assignmentMap = new Map<Id, pse__Assignment__c>();
        
        for(pse__Timecard_Header__c timecard : timecards) {
            
            switch on timecard.pse__Project__r.pse__Stage__c {
                when 'Completed', 'Cancelled' {
                    if(!assignmentMap.containsKey(timecard.pse__Assignment__c)) { assignmentMap.put(timecard.pse__Assignment__c, new pse__Assignment__c(Id=timecard.pse__Assignment__c, CLOSED_Job_To_Date_Hours__c=0)); }
                    try { assignmentMap.get(timecard.pse__Assignment__c).CLOSED_Job_To_Date_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                    if(!assignmentMap.containsKey(timecard.pse__Assignment__c)) { 
                        assignmentMap.put(timecard.pse__Assignment__c, new pse__Assignment__c(Id=timecard.pse__Assignment__c, ACTIVE_Job_to_Date_Hours__c=0)); 
                    }
                    try { assignmentMap.get(timecard.pse__Assignment__c).ACTIVE_Job_to_Date_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                }
            }
        }
        
        return assignmentMap;
    }
    
    private static Map<Id, pse__Proj__c> updateProjects(List<pse__Timecard_Header__c> timecards) {
        
        Map<Id, pse__Proj__c> projectMap = new Map<Id, pse__Proj__c>();
        
        for(pse__Timecard_Header__c timecard : timecards) {
            
            switch on timecard.pse__Project__r.pse__Stage__c {
                when 'Completed', 'Cancelled' {
                    if(!projectMap.containsKey(timecard.pse__Project__c)) { 
                        projectMap.put(timecard.pse__Project__c, new pse__Proj__c(Id=timecard.pse__Project__c, CLOSED_JTD_Billable__c=0, CLOSED_JTD_Billable_Hours__c=0,
                                                                                  CLOSED_JTD_Nonbill_Hours__c=0, CLOSED_JTD_Billable_NB_Hours__c=0));
                    }
                    try { projectMap.get(timecard.pse__Project__c).CLOSED_JTD_Billable__c += timecard.pse__Total_Billable_Amount__c; } catch (Exception e) {}
                    try { projectMap.get(timecard.pse__Project__c).CLOSED_JTD_Billable_NB_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                    if(timecard.pse__billable__c) {
                        try { projectMap.get(timecard.pse__Project__c).CLOSED_JTD_Billable_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                    } else {
                        try { projectMap.get(timecard.pse__Project__c).CLOSED_JTD_Nonbill_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                    }
                } when 'Planned' , 'Prepare' , 'Define' , 'Design' , 'Build' , 'Verify' , 'Launch' , 'Close-Out' {
                    if(!projectMap.containsKey(timecard.pse__Project__c)) { 
                        projectMap.put(timecard.pse__Project__c, new pse__Proj__c(Id=timecard.pse__Project__c, ACTIVE_JTD_Billable_NB_Hours__c=0, ACTIVE_JTD_Nonbill_Hours__c=0,
                                                                                  ACTIVE_JTD_Billable__c=0, ACTIVE_JTD_Billable_Hours__c=0)); 
                    }
                    try { projectMap.get(timecard.pse__Project__c).ACTIVE_JTD_Billable__c += timecard.pse__Total_Billable_Amount__c; } catch (Exception e) {}
                    try { projectMap.get(timecard.pse__Project__c).ACTIVE_JTD_Billable_NB_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                    if(timecard.pse__billable__c) {
                        try { projectMap.get(timecard.pse__Project__c).ACTIVE_JTD_Billable_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                    } else {
                        try { projectMap.get(timecard.pse__Project__c).ACTIVE_JTD_Nonbill_Hours__c += timecard.pse__Total_Hours__c; } catch (Exception e) {}
                    }
                }
            }
        }
        
        return projectMap;
    }
}