public class PreFlightRisksExtension {
    public List<Risks_Issues__c> preflightRisks;
    public Id projectId { get; set; }
    public pse__Proj__c project { get; set; }
    
    public PreflightRisksExtension(ApexPages.standardController controller) {
        projectId = controller.getId();
        project = [SELECT Id, pse__Project_Manager__c, Name FROM pse__Proj__c WHERE Id =: projectId];
    }
    
    public List<Risks_Issues__c> getPreflightRisks() {
        preFlightRisks = new List<Risks_Issues__c>();
        buildPreFlightRisks();
        return preFlightRisks;
    }
    
    public PageReference save() {
		List<Risks_Issues__c> upsertRisks = new List<Risks_Issues__c>();
        System.debug('-------- preflightRisks: ' + preflightRisks);
        for(Risks_Issues__c risk : preflightRisks) {
            if(risk.Impact__c != null) { upsertRisks.add(risk); }  
        }
        
        System.debug('-------- upsertRisks: ' + preflightRisks);
        if(!upsertRisks.isEmpty()) { upsert upsertRisks; }
        return new PageReference('/' + projectId);
    }
    
    private void buildPreflightRisks() {
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType='Risks_Issues__c' AND DeveloperName='Risk'];
        List<RiskIssueTemplate__c> templates = [SELECT Name, Description__c, Type__c FROM RiskIssueTemplate__c ORDER BY Type__c, Risk_Sequence__c];
        Map<String, Risks_Issues__c> riskMap = getCurrentRisks();
        
        System.debug('-------- templates: ' + templates);
        for(RiskIssueTemplate__c template : templates) {
            Risks_Issues__c newRisk;
            if(riskMap.containsKey(template.Name)) {
                newRisk = new Risks_Issues__c(Id=riskMap.get(template.Name).Id,
                    						  Impact__c=riskMap.get(template.Name).Impact__c,
                                              Type__c=riskMap.get(template.Name).Type__c,
                                              Mitigation_Steps__c=riskMap.get(template.Name).Mitigation_Steps__c,
                                              Name__c=riskMap.get(template.Name).Name__c,
                                              TemplateId__c=riskMap.get(template.Name).TemplateId__c,
                                              Project__c=projectId);
            } else {
                newRisk = new Risks_Issues__c(Type__c=template.Type__c,
                                              Name__c=template.Description__c,
                                              TemplateId__c=template.Name,
                                              RecordTypeId=rt.Id,
                                              Project__c=projectId);
            }
            preflightRisks.add(newRisk);
        }
    }
    
    private Map<String, Risks_Issues__c> getCurrentRisks() {
        List<Risks_Issues__c> currentRisks = [SELECT Id, Impact__c, Name__c, Status__c, Type__c, TemplateId__c, Mitigation_Steps__c 
                                              FROM Risks_Issues__c 
                                              WHERE Project__c =: projectId];
        Map<String, Risks_Issues__c> riskMap = new Map<String, Risks_Issues__c>();
        
        System.debug('-------- currentRisks: ' + currentRisks);
        for(Risks_Issues__c currentRisk: currentRisks) {
            if(currentRisk.TemplateId__c != null) { riskMap.put(currentRisk.TemplateId__c, currentRisk); }
        }
        
        System.debug('-------- riskMap: ' + riskMap);
        return riskMap;
    }
}