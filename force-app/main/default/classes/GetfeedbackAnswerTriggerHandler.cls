public class GetfeedbackAnswerTriggerHandler {
    public static boolean m_isExecuting = false; 
    private static Map<Id, List<GetFeedback_Aut__Response__c>> accountMap;
    private static Map<Id, List<GetFeedback_Aut__Response__c>> contactMap;
    private static Map<Id, List<GetFeedback_Aut__Response__c>> projectMap;
    
    //-------------------------------------------------------------------------
    // On after insert trigger method
    //-------------------------------------------------------------------------
    public static void OnAfterInsert(Map<Id, GetFeedback_Aut__Answer__c> newMap) {
        System.debug('-------- newMap: ' + newMap);
        System.debug('-------- newMap.size(): ' + newMap.size());
        calculateCSAT(newMap.values());
    }
    
    //-------------------------------------------------------------------------
    // On after delete trigger method
    //-------------------------------------------------------------------------
    public static void OnAfterDelete(Map<Id, GetFeedback_Aut__Answer__c> oldMap) {    
        calculateCSAT(oldMap.values());
    }
    
    //-------------------------------------------------------------------------
    // Build maps of the responses by Account, Contact and Project
    //-------------------------------------------------------------------------    
    private static void calculateCSAT(List<GetFeedback_Aut__Answer__c> answers) {
        Map<Id, GetFeedback_Aut__Answer__c> responseToCSATMap = new Map<Id, GetFeedback_Aut__Answer__c>();
        Map<Id, GetFeedback_Aut__Response__c> mainResponseMap = new Map<Id, GetFeedback_Aut__Response__c>();
        for(GetFeedback_Aut__Answer__c answer : answers) {
            if(!responseToCSATMap.containsKey(answer.GetFeedback_Aut__Response__c)) { 
                responseToCSATMap.put(answer.GetFeedback_Aut__Response__c , answer); 
            }
        }
        
        List<GetFeedback_Aut__Response__c> responseRecords = [SELECT Id, Getfeedback_Aut__Account__c, Getfeedback_Aut__Contact__c, ProjectId__c, CSAT__c
                                                              FROM GetFeedback_Aut__Response__c WHERE Id IN : responseToCSATMap.keySet()];
        
        System.debug('-------- responseRecords: ' + responseRecords);
        for(GetFeedback_Aut__Response__c response : responseRecords) {
            if(responseToCSATMap.containsKey(response.Id)) { response.CSAT__c=responseToCSATMap.get(response.Id).GetFeedback_Aut__Number__c; }
            if(!mainResponseMap.containsKey(response.Id)) { mainResponseMap.put(response.Id, response); }
        }
        
        System.debug('-------- mainResponseMap: ' + mainResponseMap);
        
        List<GetFeedback_Aut__Response__c> responses = mainResponseMap.values();
        
        accountMap = new Map<Id, List<GetFeedback_Aut__Response__c>>();
        contactMap = new Map<Id, List<GetFeedback_Aut__Response__c>>();
        projectMap = new Map<Id, List<GetFeedback_Aut__Response__c>>();
        
        for(GetFeedback_Aut__Response__c response : responses) {
            System.debug('-------- response.Getfeedback_Aut__Account__c: ' + response.Getfeedback_Aut__Account__c);
            System.debug('-------- response.Getfeedback_Aut__Contact__c: ' + response.Getfeedback_Aut__Contact__c);
            System.debug('-------- response.ProjectId__c: ' + response.ProjectId__c);            
            
            if(!accountMap.containsKey(response.Getfeedback_Aut__Account__c)) { accountMap.put(response.Getfeedback_Aut__Account__c, new List<Getfeedback_Aut__Response__c>()); }
            if(!contactMap.containsKey(response.Getfeedback_Aut__Contact__c)) { contactMap.put(response.Getfeedback_Aut__Contact__c, new List<Getfeedback_Aut__Response__c>()); }
            if(!projectMap.containsKey(response.ProjectId__c)) { projectMap.put(response.ProjectId__c, new List<Getfeedback_Aut__Response__c>()); }
            
            if(accountMap.containsKey(response.Getfeedback_Aut__Account__c)) { accountMap.get(response.Getfeedback_Aut__Account__c).add(response); }
            if(contactMap.containsKey(response.Getfeedback_Aut__Contact__c)) { contactMap.get(response.Getfeedback_Aut__Contact__c).add(response); }
            if(projectMap.containsKey(response.ProjectId__c)) { projectMap.get(response.ProjectId__c).add(response); }
        }
        
        System.debug('-------- accountMap: ' + accountMap);
        
        System.debug('******** calculating account CSAT ********');
        calculateAccountCSATs(accountMap);
        System.debug('******** calculating contact CSAT ********');
        calculateContactCSATs(contactMap);
        System.debug('******** calculating project CSAT ********');
        calculateProjectCSATs(projectMap);
        System.debug('******** calculating project contact CSAT ********');
        calculateProjectContactCSATs(contactMap.keySet());
        
        if(!responseRecords.isEmpty()) { update responseRecords; }
        
    }
    
    //--------------------------------------------------------------------------
    // Calculate the CSAT for the Account based on ALL responses for the Account
    //--------------------------------------------------------------------------     
    private static void calculateAccountCSATs(Map<Id, List<GetFeedback_Aut__Response__c>> accountMap) {
        Set<Id> responseIds = new Set<Id>();
        List<GetFeedback_Aut__Response__c> accountResponseList = [SELECT Id, Getfeedback_Aut__Account__c, CSAT__c FROM GetFeedback_Aut__Response__c WHERE GetFeedback_Aut__Account__c IN : accountMap.keySet()];
        
        for(GetFeedback_Aut__Response__c response : accountResponseList) {
            if(!accountMap.containsKey(response.Getfeedback_Aut__Account__c)) { accountMap.put(response.Getfeedback_Aut__Account__c, new List<Getfeedback_Aut__Response__c>()); }
            if(accountMap.containsKey(response.Getfeedback_Aut__Account__c)) { accountMap.get(response.Getfeedback_Aut__Account__c).add(response); }
        }
        
        List<Account> accountList = new List<Account>();
        
        for(Id accountId : accountMap.keySet()) {
            Decimal totalCSAT = 0.0;
            Decimal recCount = 0.0;
            for(GetFeedback_Aut__Response__c response : accountMap.get(accountId)) {
                System.debug('-------- response: ' + response);
                try {
                    totalCSAT += response.CSAT__c;
                    recCount ++;
                } catch (Exception e) {
                    
                }
            }
            
            Decimal csatScore = 0.0;
            try {
                csatScore = totalCSAT/recCount;
            } catch (Exception e) {
                csatScore = 0.0;
            }
            
            System.debug('-------- csatScore: ' + csatScore);
            accountList.add(new Account(Id=accountId, CSAT_Score__c=csatScore));
        }
        
        System.debug('-------- accountList: ' + accountList);
        if(!accountList.isEmpty()) { update accountList; }
    }
    
    //--------------------------------------------------------------------------
    // Calculate the CSAT for the Contact based on ALL responses for the Contact
    //--------------------------------------------------------------------------     
    private static void calculateContactCSATs(Map<Id, List<GetFeedback_Aut__Response__c>> contactMap) {
        List<GetFeedback_Aut__Response__c> contactResponseList = [SELECT Id, Getfeedback_Aut__Contact__c, CSAT__c FROM GetFeedback_Aut__Response__c WHERE GetFeedback_Aut__Contact__c IN : contactMap.keySet()];
        
        for(GetFeedback_Aut__Response__c response : contactResponseList) {
            if(!contactMap.containsKey(response.Getfeedback_Aut__Contact__c)) { contactMap.put(response.Getfeedback_Aut__Contact__c, new List<Getfeedback_Aut__Response__c>()); }
            if(contactMap.containsKey(response.Getfeedback_Aut__Contact__c)) { contactMap.get(response.Getfeedback_Aut__Contact__c).add(response); }
        }
        
        List<Contact> contactList = new List<Contact>();
        
        for(Id contactId : contactMap.keySet()) {
            Decimal totalCSAT = 0.0;
            Decimal recCount = 0.0;
            
            for(GetFeedback_Aut__Response__c response : contactMap.get(contactId)) {
                System.debug('-------- response: ' + response);
                try {
                    totalCSAT += response.CSAT__c;
                    recCount ++;
                } catch (Exception e) {
                    
                }
            }
            
            Decimal csatScore = 0.0;
            try {
                csatScore = totalCSAT/recCount;
            } catch (Exception e) {
                csatScore = 0.0;
            }
            
            System.debug('-------- csatScore: ' + csatScore);
            contactList.add(new Contact(Id=contactId, CSAT_Score__c=csatScore));
        }
        
        System.debug('-------- contactList: ' + contactList);
        if(!contactList.isEmpty()) { update contactList; }
        
    }
    
    //--------------------------------------------------------------------------
    // Calculate the CSAT for the Project based on ALL responses for the Project
    //--------------------------------------------------------------------------         
    private static void calculateProjectCSATs(Map<Id, List<GetFeedback_Aut__Response__c>> projectMap) {
        List<GetFeedback_Aut__Response__c> projectResponseList = [SELECT Id, ProjectId__c, CSAT__c FROM GetFeedback_Aut__Response__c WHERE ProjectId__c IN : projectMap.keySet()];
        
        for(GetFeedback_Aut__Response__c response : projectResponseList) {
            if(!projectMap.containsKey(response.ProjectId__c)) { projectMap.put(response.ProjectId__c, new List<Getfeedback_Aut__Response__c>()); }
            if(projectMap.containsKey(response.ProjectId__c)) { projectMap.get(response.ProjectId__c).add(response); }
        }
        
        
        List<pse__Proj__c> projectList = new List<pse__Proj__c>();
        
        for(Id projectId : projectMap.keySet()) {
            Decimal totalCSAT = 0.0;
            Decimal recCount = 0.0;
            for(GetFeedback_Aut__Response__c response : projectMap.get(projectId)) {
                System.debug('-------- response: ' + response);
                try {
                    totalCSAT += response.CSAT__c;
                    recCount ++;
                } catch (Exception e) {
                    
                }
            }
            
            Decimal csatScore = 0.0;
            try {
                csatScore = totalCSAT/recCount;
            } catch (Exception e) {
                csatScore = 0.0;
            }
            
            System.debug('-------- csatScore: ' + csatScore);
            
            String csatStatus='';
            Decimal csatGreen = Decimal.valueOf(System.Label.CSATGreen);
            Decimal csatYellow = Decimal.valueOf(System.Label.CSATYellow);
            
            if(csatScore>=csatGreen) { csatStatus='Green'; }
            else If(csatScore>=csatYellow && csatScore<csatGreen) { csatStatus='Yellow'; }
            else { csatStatus='Red'; }
            projectList.add(new pse__Proj__c(Id=projectId, CSAT_Score__c=csatScore, CSAT_Status__c=csatStatus));
        }
        
        System.debug('-------- projectList: ' + projectList);
        if(!projectList.isEmpty()) { update projectList; }
    }
    
    //----------------------------------------------------------------------------------
    // Calculate the Contact CSAT for the Project based on ALL responses for the Project
    //----------------------------------------------------------------------------------  
    private static void calculateProjectContactCSATs(Set<Id> contactIds) {
        List<GetFeedback_Aut__Answer__c> answers = [select Id, GetFeedback_Aut__Response__r.ProjectId__c, GetFeedback_Aut__Response__r.GetFeedback_Aut__Contact__c, 
                                                    GetFeedback_Aut__Number__c, GetFeedback_Aut__QuestionType__c, 
                                                    GetFeedback_Aut__IsDetractor__c, GetFeedback_Aut__IsPromoter__c 
                                                    FROM GetFeedback_Aut__Answer__c
                                                    WHERE GetFeedback_Aut__QuestionType__c IN('NetPromoter', 'CustomerSatisfaction') AND GetFeedback_Aut__Response__r.GetFeedback_Aut__Contact__c IN : contactIds];
        
        Map<Id, Map<Id, List<GetFeedback_Aut__Answer__c>>> contactProjectMap = new Map<Id, Map<Id, List<GetFeedback_Aut__Answer__c>>>();
        for(GetFeedback_Aut__Answer__c answer : answers) {
            if(!contactProjectMap.containsKey(answer.GetFeedback_Aut__Response__r.GetFeedback_Aut__Contact__c)) {
                contactProjectMap.put(answer.GetFeedback_Aut__Response__r.GetFeedback_Aut__Contact__c, new Map<Id, List<GetFeedback_Aut__Answer__c>>());
            }
            if(!contactProjectMap.get(answer.GetFeedback_Aut__Response__r.GetFeedback_Aut__Contact__c).containsKey(answer.GetFeedback_Aut__Response__r.ProjectId__c)){
                contactProjectMap.get(answer.GetFeedback_Aut__Response__r.GetFeedback_Aut__Contact__c).put(answer.GetFeedback_Aut__Response__r.ProjectId__c, new List<GetFeedback_Aut__Answer__c>());
            }
            contactProjectMap.get(answer.GetFeedback_Aut__Response__r.GetFeedback_Aut__Contact__c).get(answer.GetFeedback_Aut__Response__r.ProjectId__c).add(answer);
        }
        
        Map<String, ProjectSurveyContact__c> projectSurveyContactMap = new Map<String, ProjectSurveyContact__c>();
        List<ProjectSurveyContact__c> surveyContacts = [SELECT Id, Project__c, Contact__c, CSAT_Score__c, Promoter__c, Detractor__c, Neutral__c 
                                                        FROM ProjectSurveyContact__c WHERE Contact__c IN : contactIds];
        System.debug('-------- surveyContacts: ' + surveyContacts);
        
        for(ProjectSurveyContact__c surveyContact : surveyContacts) {
            String key=''+surveyContact.Contact__c+surveyContact.Project__c;
            projectSurveyContactMap.put(key, surveyContact);
        }
        System.debug('-------- projectSurveyContactMap: ' + projectSurveyContactMap);
        System.debug('-------- contactProjectMap: ' + contactProjectMap);
        
        List<ProjectSurveyContact__c> updatedProjectSurveyContacts = new List<ProjectSurveyContact__c>();
        for(Id contactId : contactProjectMap.keySet()) {
            System.debug('contactId: ' + contactId);
            for(Id projectId : contactProjectMap.get(contactId).keySet()) {
                Decimal recCount=0.0;
                Decimal totalCSAT=0.0;
                Decimal promoter=0.0;
                Decimal detractor=0.0;
                Decimal neutral=0.0;
                for(GetFeedback_Aut__Answer__c answer : contactProjectMap.get(contactId).get(projectId)) {
                    totalCSAT += answer.GetFeedback_Aut__Number__c;
                    recCount ++;
                    try {
                        if(answer.GetFeedback_Aut__IsPromoter__c) { promoter ++; }
                        else if(answer.GetFeedback_Aut__IsDetractor__c) { detractor ++; }
                        else { neutral ++; }
                    } catch (Exception e){
                        
                    }
                }
                Decimal csatScore = 0.0;
                try {
                    System.debug('totalCSAT: ' + totalCSAT + '   recCount: ' + recCount);
                    csatScore = totalCSAT/recCount;
                } catch (Exception e) {
                    csatScore = 0.0;
                }
                
                String key=''+contactId+projectId;
                ProjectSurveyContact__c p = projectSurveyContactMap.get(key);
                p.CSAT_Score__c=csatScore;
                p.Promoter__c=promoter;
                p.Detractor__c=detractor;
                p.Neutral__c=neutral;
                updatedProjectSurveyContacts.add(p);
            }
        }
        
        System.debug('-------- updatedProjectSurveyContacts: ' + updatedProjectSurveyContacts);
        if(!updatedProjectSurveyContacts.isEmpty()) { update updatedProjectSurveyContacts; }
    }    
    
}