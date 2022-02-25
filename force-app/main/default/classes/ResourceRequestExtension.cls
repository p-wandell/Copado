public class ResourceRequestExtension {
    public List<pse__Resource_Request__c> resourceRequests { get {
        if(resourceRequests==null) {
            resourceRequests=new List<pse__Resource_Request__c>();
        }
        return resourceRequests;
    } set; }
    public Id opportunityId { get; set; }
    public Opportunity opp { get; set; }
    /*
    public String scheduleHours { get; set; }
    public List<SelectOption> hours { get {
        if(hours==null) {
            hours=new List<SelectOption>();
            hours.add(new SelectOption('10', '10'));
            hours.add(new SelectOption('20', '20'));
            hours.add(new SelectOption('40', '40'));
        }
        return hours;
    } set; }
	*/
    private pse__Region__c region { get{
        if(region==null) {
            region = [SELECT Id FROM pse__Region__c WHERE Name='Global Region'];
        }
        return region;
    } set; }
    
    private String recordOwner { get{
        if(recordOwner==null) {
            try {
                Group g = [SELECT Id, Name FROM Group WHERE Type='Queue' AND Name='Resource Requests' LIMIT 1];
                recordOwner=g.Id;
            } catch (Exception e) {
                recordOwner=UserInfo.getUserId();
            }
        }
        
        return recordOwner;
    } set; }
    
    private Map<String, Contact> genericResources;
    private Decimal hoursPerDay;
    
    public ResourceRequestExtension(ApexPages.standardController controller) {
        opportunityId = controller.getId();
        initializeReqourceRequests();
        opp = [SELECT Id, Name FROM Opportunity WHERE Id =: opportunityId];
        getGenericResources();
    }
    
    public PageReference save() {
        List<pse__Schedule__c> schedules = new List<pse__Schedule__c>();
        List<pse__Resource_Request__c> newRequests = new List<pse__Resource_Request__c>();
        Integer numberOfWeeks = resourceRequests[0].pse__Start_Date__c.daysBetween(resourceRequests[0].pse__End_Date__c)/7;
        
        for(pse__Resource_Request__c resourceRequest : resourceRequests) {
            System.debug('-----------> resourceRequest: ' + resourceRequest);
            resourceRequest.pse__Notes__c=resourceRequests[0].pse__Notes__c;
            resourceRequest.pse__Start_Date__c=resourceRequests[0].pse__Start_Date__c;
            resourceRequest.pse__End_Date__c=resourceRequests[0].pse__End_Date__c;
            resourceRequest.pse__Status__c='Draft';
            if(resourceRequest.Hours_Per_Week__c!=null && resourceRequest.pse__Resource_Role__c==null) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'If hours are entered then resource role must be entered'));
            }
            if(resourceRequest.pse__Resource_Role__c!=null) {
                try {
                    resourceRequest.pse__SOW_Hours__c=Decimal.valueOf(resourceRequest.Hours_Per_Week__c)*numberOfWeeks;
                    hoursPerDay=Decimal.valueOf(resourceRequest.Hours_Per_Week__c)/5;
                } catch (Exception e) {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Hours per week must be entered if Resource Role is entered'));
                }
                schedules.add(new pse__Schedule__c(pse__Start_Date__c=resourceRequest.pse__Start_Date__c,
                                                   pse__End_Date__c=resourceRequest.pse__End_Date__c,
                                                   pse__Monday_Hours__c=hoursPerDay,
                                                   pse__Tuesday_Hours__c=hoursPerDay,
                                                   pse__Wednesday_Hours__c=hoursPerDay,
                                                   pse__Thursday_Hours__c=hoursPerDay,
                                                   pse__Friday_Hours__c=hoursPerDay));
                
                resourceRequest.pse__Region__c=region.Id;
                resourceRequest.ownerId=recordOwner;
                if(genericResources.containsKey(resourceRequest.pse__Resource_Role__c)) {
                    resourceRequest.pse__Staffer_Resource__c=genericResources.get(resourceRequest.pse__Resource_Role__c).Id;
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'A generic resource does not exist for the role'));
                }
                newRequests.add(resourceRequest);
                System.debug('-----------> resourceRequest: ' + resourceRequest);
                
            }
        }
        
        if(ApexPages.hasMessages()) {
            return null;
        } else  {  
            if(!schedules.isEMpty()) { insert schedules; }
            
            Integer x=0;
            
            for(pse__Resource_Request__c resourceRequest : newRequests) {
                if(resourceRequest.pse__Resource_Role__c!=null) {
                    resourceRequest.pse__Preferred_Schedule__c=schedules[x].Id;
                }
                x ++;
            }
            
            if(!newRequests.isEmpty()) { insert newRequests; }
            
            
            return new PageReference('/' + opportunityId);
        }
    }
    
    private void initializeReqourceRequests() {
        for(Integer x=0;x<9;x++) {
            resourceRequests.add(new pse__Resource_Request__c(pse__Opportunity__c=opportunityId));
        }
    }
    
    private void getGenericResources() {
        List<Contact> contacts = [SELECT Id, Name, pse__Resource_Role__c FROM Contact WHERE Generic_Resource__c=true];
        genericResources=new Map<String, Contact>();
        for(Contact c : contacts) {
            genericResources.put(c.pse__Resource_Role__c, c);
        }
    }
}