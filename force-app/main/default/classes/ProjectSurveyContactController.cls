public class ProjectSurveyContactController {

    public class ProjectSurveyContact {
        public String recId { get; set; }
        public String project { get; set; }
        public String account { get; set; }
        public String contact { get; set; }
        public String contactName { get; set; }
        public boolean sendSurvey { get; set; }
    }
    public List<ProjectSurveyContact> contacts { get; set; }
    public pse__Proj__c currentProject { get; set; }
    private String projectRecordId;
    
    public ProjectSurveyContactController(ApexPages.standardController controller) {
        ProjectSurveyContact__c projectIn = (ProjectSurveyContact__c)controller.getRecord();
        projectRecordId = projectIn.Project__c;
        if(projectRecordId == null) { projectRecordId=ApexPages.currentPage().getParameters().get('projectId'); }
        System.debug('ProjectId: ' + projectRecordId);
        
        currentProject = [SELECT Id, pse__Account__c, Name, pse__Account__r.Name FROM pse__Proj__c WHERE Id =: projectRecordId];
        List<Contact> accountContacts = [SELECT Id, Name FROM Contact WHERE AccountId =: currentProject.pse__Account__c ORDER By Name];
        List<ProjectSurveyContact__c> existingContacts = [SELECT Id, Project__c, Account__c, Contact__c, SendSurvey__c 
                                                  FROM ProjectSurveyContact__c WHERE Project__c = : currentProject.Id];
        
        System.debug('accountContacts: ' + accountContacts);
        System.debug('existingContacts: ' + existingContacts);
        
        Map<Id, ProjectSurveyContact__c> contactMap = new Map<Id, ProjectSurveyContact__c>();
        for(ProjectSurveyContact__c psc : existingContacts) {
            if(!contactMap.containsKey(psc.Contact__c)) { contactMap.put(psc.Contact__c, psc); }
        }
        
		contacts = new List<ProjectSurveyContact>();
        for(Contact c : accountContacts) {
            ProjectSurveyContact newPSC = new ProjectSurveyContact();
            newPsc.project=projectRecordId;
            newPsc.account=currentProject.pse__Account__c;
            newPsc.contact=c.Id;
            newPsc.contactName=c.Name;
            if(contactMap.containsKey(c.Id)) { 
                newPsc.recId = contactMap.get(c.Id).Id;
                newPsc.sendSurvey = contactMap.get(c.Id).SendSurvey__c;
            }
            contacts.add(newPSC);
        }
        
        System.debug('contacts: ' + contacts);
        
    }
    
    public PageReference save() {
        List<ProjectSurveyContact__c> projectContacts = new List<ProjectSurveyContact__c>();
        for(ProjectSurveyContact pscContact : contacts) {
            if(pscContact.sendSurvey == true || pscContact.RecId != null) {
                projectContacts.add(new ProjectSurveyContact__c (Id=pscContact.recId,
                                                                 Project__c=pscContact.project,
                                                                 Account__c=pscContact.account,
                                                                 Contact__c=pscContact.contact,
                                                                 SendSurvey__c=pscContact.sendSurvey));
            } 
        }
        
        System.debug(projectContacts);
        upsert projectContacts;
        
        return new PageReference('/' + projectRecordId);
    }
    
    public PageReference cancel() {
        return new PageReference('/' + projectRecordId);
    }
}