/**
* @description RiskAndIssuesStatusHandler
* Author: Randy Wandell
* Date: 05/22/2020
*/
public with sharing class RiskAndIssuesStatusHandler {
    public static List<pse__Proj__c> setProjectRecordStatus(List<Risks_Issues__c> risks) {
        Set<Id> projectIds = new Set<Id>();
        List<pse__Proj__c> projects = new List<pse__Proj__c>();
        
        for(Risks_Issues__c risk : risks) {
            if(!projectIds.contains(risk.Project__c)) { projectIds.add(risk.Project__c); }
        }
        
        for(Id projectId : projectIds) {
            projects.add(setStatusFieldsForProject(projectId));
        }
        
        System.debug(projects);
        if(!projects.isEmpty()) { update projects; }
        
        return projects;
    }
    
    public static pse__Proj__c setStatusFieldsForProject(Id projectId) {
        String sponsorStatus='Green';
        String coverageStatus='Green';
        String devOpsStatus='Green';
        String riskLevelStatus='Green';
        String forecastStatus='Green';
        String qualityStatus='Green';
        String resourceStatus='Green';
        String scopeStatus='Green';
        String timelineStatus='Green';
        
        List<Risks_Issues__c> projectRisks = [SELECT Id, Type__c, Impact__c, Status__c, Mitigation_Steps__c, Closed_Date__c, Probability__c 
                                              FROM Risks_Issues__c 
                                              WHERE Project__c =: projectId AND RecordType.Name IN('Risk', 'Issue')];
        
        for(Risks_Issues__c projectRisk : projectRisks) {
            if(projectRisk.Type__c=='Exec Sponsor') { sponsorStatus=getRiskStatus(sponsorStatus, projectRisk); }
            else if(projectRisk.Type__c=='Timeline') { timelineStatus=getRiskStatus(timelineStatus, projectRisk); }
            else if(projectRisk.Type__c=='Resource') { resourceStatus=getRiskStatus(resourceStatus, projectRisk); }
            else if(projectRisk.Type__c=='Quality') { qualityStatus=getRiskStatus(qualityStatus, projectRisk); }
            else if(projectRisk.Type__c=='Budget') { forecastStatus=getRiskStatus(forecastStatus, projectRisk); }
            else if(projectRisk.Type__c=='DevOps') { devOpsStatus=getRiskStatus(devOpsStatus, projectRisk); }
            else if(projectRisk.Type__c=='Scope') { scopeStatus=getRiskStatus(scopeStatus, projectRisk); }
            
            System.debug('scopeStatus:  ' + scopeStatus);
            riskLevelStatus=getRiskStatus(riskLevelStatus, projectRisk);
        }
        
        return new pse__Proj__c(Id=projectId, Sponsor_Engaged_Status__c=sponsorStatus, TimeLine_Status__c=timelineStatus, DevOps_Status__c=devOpsStatus, Scope_Status__c=scopeStatus,
                                Risk_Level_Status__c=riskLevelStatus, Forecast_Status__c=forecastStatus, Quality_Status__c=qualityStatus, Resourcing_Status__c=resourceStatus,
                                pse__Project_Status__c=riskLevelStatus);
    }
    
    public static String getRiskStatus(String riskStatus, Risks_Issues__c projectRisk) {
        String thisRiskStatus= 'Green';
        System.debug('----------- projectRisk: ' + projectRisk);
        if(projectRisk.Mitigation_Steps__c=='') { projectRisk.Mitigation_Steps__c=null; }
        
        if(projectRisk.Impact__c == 'High')  {
            if(projectRisk.Probability__c == 'High' || projectRisk.Probability__c == null) {
                if(projectRisk.Status__c == 'Draft' || projectRisk.Status__c == 'In Progress') {
                    thisRiskStatus='Red';
                } else if(projectRisk.Status__c == 'Mitigated') {
                    thisRiskStatus='Yellow';
                } else if(projectRisk.Status__c == 'Eradicated') {
                    thisRiskStatus='Green';
                }
                
            } else if(projectRisk.Probability__c == 'Medium') {
                if(projectRisk.Status__c == 'Draft' || projectRisk.Status__c == 'In Progress') {
                    thisRiskStatus='Red';
                } else if(projectRisk.Status__c == 'Mitigated') {
                    thisRiskStatus='Yellow';
                } else if(projectRisk.Status__c == 'Eradicated') {
                    thisRiskStatus='Green';
                }
            } else if(projectRisk.Probability__c == 'Low') {
                if(projectRisk.Status__c != 'Eradicated') {
                    thisRiskStatus='Yellow';
                } else if(projectRisk.Status__c == 'Eradicated') {
                    thisRiskStatus='Green';
                }
            }
        } else if(projectRisk.Impact__c == 'Medium') {
            if(projectRisk.Probability__c == 'High' || projectRisk.Probability__c == null) {
                if(projectRisk.Status__c == 'Draft' || projectRisk.Status__c == 'In Progress') {
                    thisRiskStatus='Yellow';
                } else if(projectRisk.Status__c == 'Mitigated' || projectRisk.Status__c == 'Eradicated') {
                    thisRiskStatus='Green';
                }
            } else if(projectRisk.Probability__c == 'Medium') {
                if(projectRisk.Status__c == 'Draft' || projectRisk.Status__c == 'In Progress') {
                    thisRiskStatus='Yellow';
                } else if(projectRisk.Status__c == 'Mitigated' || projectRisk.Status__c == 'Eradicated') {
                    thisRiskStatus='Green';
                }
            } else if(projectRisk.Probability__c == 'Low') {
                thisRiskStatus='Green';
            }
        } else if(projectRisk.Impact__c =='Low') {
            thisRiskStatus = 'Green';
        }
        
        System.debug('riskStatus: ' + riskStatus + '       thisRiskStatus: ' + thisRiskStatus);
        if(riskStatus=='Red') { return riskStatus; }
        else if(riskStatus=='Yellow' && thisRiskStatus=='Red') { return thisRiskStatus; }
        else if(riskStatus=='Green' && thisRiskStatus=='Yellow') { return thisRiskStatus; }
        else if(riskStatus=='Green' && thisRiskStatus=='Red') { return thisRiskStatus; }
        else { return riskStatus; }
    }
}