/**
* @description CoverageAssignmentHandler
* Author: Randy Wandell
* Date: 05/06/2020
*/
public class CoverageAssignmentHandler {
    
    private static Map<String, List<pse__Assignment__c>> assignmentMap;
    private static Map<String, List<pse__Assignment__c>> coverageAssignmentMap;
    private static Map<String, Set<String>> competencyGroupMap;
    
    public static boolean isFirstTime=true;
    
    public static void makeAssignments(List<Id> projectIds) {
        
        assignmentMap = new Map<String, List<pse__Assignment__c>>();
        coverageAssignmentMap = new Map<String, List<pse__Assignment__c>>();
        Integer assignmentThreshold = Integer.valueOf(System.Label.Coverage_Assignment_Threshold);
        List<String> thresholdCompentencies = ((String)System.Label.Coverage_Assignment_Threshold_Compentencies).split(';');
        Integer thresholdCount=0;
        
        // Get the project
        List<pse__Proj__c> projects = [SELECT Id, pse__Start_Date__c, pse__End_Date__c, Opp_Project_Type__c, InitiateCoverage__c FROM pse__Proj__c WHERE Id IN: projectIds];
        
        // Get a list of resources for each competency group
        List<Contact> coverageResources = [SELECT Id, Name, Competency_Group__c, ReportsToId, 
                                           (SELECT CreatedDate FROM pse__Assignments__r WHERE pse__Role__c='Coverage' ORDER BY CreatedDate DESC LIMIT 1) 
                                           FROM Contact 
                                           WHERE Coverage_Participant__c=true
                                           ORDER BY Competency_Group__c];
        
        // Build out the maps for the projects
        getAssociatedRecords(projectIds);
        
        
        System.debug('assignmentMap: ' + assignmentMap);
        System.debug('coverageAssignmentMap: ' + coverageAssignmentMap);
        
        Integer coverageHours = 0;
        try{
            coverageHours = Integer.valueOf(System.Label.Coverage_Assignment_Default_Hours);
        } catch (Exception converionException) {
            
        }
        
        
        // Loop through the projects and get the lists for each project
        for(pse__Proj__c project : projects) {
            
            // Get assignments for the project
            Set<Id> assignmentIds = new Set<Id>();
            Set<String> competencyGroupSet = new Set<String>();
            
            List<pse__Assignment__c> assignments = assignmentMap.get(project.Id);
            System.debug(assignments);
            
            if(assignments != null) {
                for(pse__Assignment__c assignment : assignments) {
                    if(!assignmentIds.contains(assignment.pse__Resource__c)) {
                        assignmentIds.add(assignment.pse__Resource__c);
                    }
                    if(!competencyGroupSet.contains(assignment.pse__Resource__r.Competency_Group__c)) {
                        competencyGroupSet.add(assignment.pse__Resource__r.Competency_Group__c);
                    }
                }
                
                // Sping through the assignment map and get the total number of assignments for the competencies in the threshold competencies
                for(String compGroup : thresholdCompentencies) {
                    if(assignmentMap.containsKey(compGroup)) { thresholdCount += assignmentMap.get(compGroup).size(); }
                }
                
                // Get current coverage assignments for the project
                Map<String, pse__Assignment__c> currentCoverageAssignmentMap = new Map<String, pse__Assignment__c>();
                
                
                List<pse__Assignment__c> currentCoverageAssignments;
                if(coverageAssignmentMap.containsKey(project.Id)) {
                    currentCoverageAssignments = coverageAssignmentMap.get(project.Id);
                } else {
                    currentCoverageAssignments = new List<pse__Assignment__c>();
                }
                
                
                for(pse__Assignment__c a : currentCoverageAssignments) {
                    if(!currentCoverageAssignmentMap.containsKey(a.pse__Resource__r.Competency_Group__c)) {
                        currentCoverageAssignmentMap.put(a.pse__Resource__r.Competency_Group__c, a);
                    }
                }
                
                Map<String, pse__Assignment__c> coverageAssignmentMap = new Map<String, pse__Assignment__c>();
                Map<String, pse__Schedule__c> coverageScheduleMap = new Map<String, pse__Schedule__c>();
                String compGroup;
                DateTime lastAssignmentDate;
                pse__Assignment__c coverageAssignment = new pse__Assignment__c(pse__Project__c=project.Id, pse__Role__c='Coverage', pse__Status__c='Scheduled', pse__Bill_Rate__c=0, pse__Is_Billable__c=false, pse__Exclude_from_Planners__c=true);
                pse__Schedule__c coverageSchedule = new pse__Schedule__c(pse__Start_Date__c=project.pse__Start_Date__c, pse__End_Date__c=project.pse__End_Date__c, pse__Friday_Hours__c=coverageHours);
                
                for(Contact coverageResource : coverageResources) {
                    if(!currentCoverageAssignmentMap.containsKey(coverageResource.Competency_Group__c)) {
                        if(compGroup==null || compGroup!=coverageResource.Competency_Group__c) { // Check to see if the competency group is null or different from the current contact
                            if(compGroup!=null) { // Add assignment and schedule for competency group
                                System.debug('Competency Group: ' + compGroup);
                                coverageAssignmentMap.put(compGroup, coverageAssignment);
                                coverageScheduleMap.put(compGroup, coverageSchedule);
                            }
                            compGroup=coverageResource.Competency_Group__c;
                            lastAssignmentDate = null;
                            coverageAssignment = new pse__Assignment__c(pse__Project__c=project.Id, pse__Role__c='Coverage', pse__Status__c='Scheduled', pse__Bill_Rate__c=0, pse__Is_Billable__c=false, pse__Exclude_from_Planners__c=true);
                            coverageSchedule = new pse__Schedule__c(pse__Start_Date__c=project.pse__Start_Date__c, pse__End_Date__c=project.pse__End_Date__c, pse__Friday_Hours__c=coverageHours);
                        }
                        if(!coverageAssignmentMap.containsKey(coverageResource.Competency_Group__c)) {
                            compGroup=coverageResource.Competency_Group__c;
                            if(coverageResource.Competency_Group__c=='Delivery Operations') { // Delivery operations uses the manager for coverage
                                coverageAssignment.pse__Resource__c=coverageResource.Id;
                                coverageAssignmentMap.put(compGroup, coverageAssignment);
                            } else {
                                if(!assignmentIds.contains(coverageResource.Id)) { // Coverage participant has an assignment
                                    if(!coverageAssignmentMap.containsKey(compGroup)) {
                                        if(coverageResource.pse__Assignments__r.isEmpty()) { // Coverage participant has not been assigned yet
                                            coverageAssignment.pse__Resource__c=coverageResource.Id;
                                            coverageAssignmentMap.put(compGroup, coverageAssignment);
                                        } else {
                                            if(lastAssignmentDate==null) { // Last assignment date not set and coverage participant not set yet 
                                                coverageAssignment.pse__Resource__c=coverageResource.Id;
                                            } else if(lastAssignmentDate>coverageResource.pse__Assignments__r[0].CreatedDate) { //Last assignment date set and coverage participant assignment date < last assignment
                                                coverageAssignment.pse__Resource__c=coverageResource.Id;
                                                lastAssignmentDate=coverageResource.pse__Assignments__r[0].CreatedDate;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                if(compGroup!=null) {
                    coverageAssignmentMap.put(compGroup, coverageAssignment);
                    coverageScheduleMap.put(compGroup, coverageSchedule);
                }
                
                if(!coverageAssignmentMap.isEmpty() && (thresholdCount>=assignmentThreshold || project.InitiateCoverage__c==true)) { 
                    insert coverageScheduleMap.values();
                    for(String s: coverageScheduleMap.keySet()) {
                        if(coverageAssignmentMap.get(s).pse__Resource__c==null) {
                            coverageAssignmentMap.remove(s);
                        } else {
                            coverageAssignmentMap.get(s).pse__Schedule__c=coverageScheduleMap.get(s).Id;
                        }
                    }
                    insert coverageAssignmentMap.values();
                    
                    System.debug(coverageAssignmentMap);
                    
                }
            }
        }
    }
    
    
    private static void getAssociatedRecords(List<Id> projectIds) {
        List<pse__Assignment__c> assignments = [SELECT pse__Project__c, pse__Resource__c, pse__Resource__r.Competency_Group__c FROM pse__Assignment__c WHERE pse__Project__r.Id IN: projectIds AND pse__Is_Billable__c = true];
        
        for(pse__Assignment__c assignment : assignments) {
            if(!assignmentMap.containsKey(assignment.pse__Project__c)) {
                assignmentMap.put(assignment.pse__Project__c, new List<pse__Assignment__c>());
            }
            
            assignmentMap.get(assignment.pse__Project__c).add(assignment);
        }
        
        // Get current coverage assignments for the project
        List<pse__Assignment__c> currentCoverageAssignments = [SELECT pse__Project__c, pse__Resource__c, pse__Resource__r.Competency_Group__c 
                                                               FROM pse__Assignment__c 
                                                               WHERE pse__Project__c IN: projectIds AND pse__Role__c='Coverage'];
        for(pse__Assignment__c a : currentCoverageAssignments) {
            if(!coverageAssignmentMap.containsKey(a.pse__Project__c)) {
                coverageAssignmentMap.put(a.pse__Project__c, new List<pse__Assignment__c>());
            }
            coverageAssignmentMap.get(a.pse__Project__c).add(a);
        }
        
    }
}