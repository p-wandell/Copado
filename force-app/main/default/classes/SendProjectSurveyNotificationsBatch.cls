global class SendProjectSurveyNotificationsBatch implements Database.batchable<sObject>, Database.Stateful {

    private String projectType;
    
    global SendProjectSurveyNotificationsBatch () {
        this.projectType='New Project';
    }
    
    global SendProjectSurveyNotificationsBatch (String projectType) {
        this.projectType = projectType;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        GetFeedback_Setting__mdt gfSetting = [SELECT ProjectStages__c FROM GetFeedback_Setting__mdt WHERE DeveloperName='Project_Survey'];
        
        System.debug('--------> projectType: ' + projectType);
        
        List<String> stages = gfSetting.ProjectStages__c.split(',');
        String query = 'SELECT Id, Project__c, Account__c, Contact__c, Contact__r.Email, Contact__r.FirstName, Project__r.pse__Project_Manager__r.Title, ' +

            'Contact__r.Lastname, Project__r.pse__Project_Manager__r.Name, Project__r.Name, Project__r.pse__Project_Manager__c, Project__r.pse__Project_Manager__r.Email ' +

            'FROM ProjectSurveyContact__c WHERE SendSurvey__c = true AND Project__r.pse__Stage__c IN : stages AND Project__r.Opp_Project_Type__c =: projectType';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<ProjectSurveyContact__c> contacts) {
        List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
        GetFeedback_Setting__mdt gfSetting = [SELECT EmailTemplateName__c, SurveyLink__c, EmailFromAddress__c, SurveyLinkText__c, SurveyLinkHTML__c, SubjectPrefix__c 
                                              FROM GetFeedback_Setting__mdt WHERE DeveloperName='Project_Survey'];
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: gfSetting.EmailFromAddress__c];
        
        EmailTemplate et = [SELECT Id, Subject, Body, HTMLValue FROM EmailTemplate WHERE DeveloperName =: gfSetting.EmailTemplateName__c];
        
        for(ProjectSurveyContact__c contact : contacts) {
            List<string> toAddress = new List<string>();
            toAddress.add(contact.Contact__r.Email);
            
            String surveyLink = gfSetting.SurveyLink__c.replace('###ACCOUNT###', contact.Account__c);
            surveyLink = surveyLink.replace('###CONTACT###', contact.Contact__c);
            surveyLink = surveyLink.replace('###PROJECT###', contact.Project__c);
            
            String body = et.Body;

            body = body.replace('###SURVEYLINK###', surveyLink);
            body = body.replace('###FIRSTNAME###', contact.Contact__r.FirstName);
            body = body.replace('###PROJECTMANAGER###', contact.Project__r.pse__Project_Manager__r.Name);
            body = body.replace('###PMCONTACTID###', contact.Project__r.pse__Project_Manager__c);
            
            String htmlBody = et.HTMLValue;

            htmlBody = et.HTMLValue.replace('###SURVEYLINKTEXT###', '<a href=\'' + surveyLink + '\'>' + gfSetting.SurveyLinkText__c + '</a>');
            
            htmlBody = htmlBody.replace('###SURVEYBUTTONIMAGE###', '<a href=\'' + surveyLink + '\'>' + gfSetting.SurveyLinkHTML__c + '</a>');
			htmlBody = htmlBody.replace('###FIRSTNAME###', contact.Contact__r.FirstName);            
            htmlBody = htmlBody.replace('###PROJECTMANAGER###', contact.Project__r.pse__Project_Manager__r.Name);
            htmlBody = htmlBody.replace('###PMTITLE###', contact.Project__r.pse__Project_Manager__r.Title);
            htmlBody = htmlBody.replace('###PMCONTACTID###', contact.Project__r.pse__Project_Manager__c);
            htmlBody = htmlBody.replace('<![CDATA[','');
            htmlBody = htmlBody.replace(']]>','');
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setTemplateId(et.Id);
            mail.setToAddresses(toAddress);

            mail.setReplyTo(contact.Project__r.pse__Project_Manager__r.Email);

            mail.setHtmlBody(htmlBody);
            mail.setPlainTextBody(body);
            mail.setSubject(gfSetting.SubjectPrefix__c + contact.Project__r.Name.replace('-Pr',''));
            mail.setTargetObjectId(contact.Contact__c);
            mail.setWhatId(contact.Contact__c);
            mail.setSaveAsActivity(false);
            mail.setUseSignature(false);
            
            allMsg.add(mail);
        }
        
        if(!allMsg.isEmpty()) { Messaging.sendEmail(allMsg); }
    }
    
    global void finish(Database.BatchableContext BC) {
    }
}