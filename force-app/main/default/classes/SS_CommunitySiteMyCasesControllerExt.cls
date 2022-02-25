public with sharing class SS_CommunitySiteMyCasesControllerExt {

    @TestVisible private String startURL = '%2FCases';

    public SS_CommunitySiteMyCasesControllerExt(ApexPages.StandardSetController controller) {
        this.myCase = new Case();
    }
    
    // for passing id to goToDetail()
    public String CaseNumber{
        get;set;
    }

    public  Case myCase {get; set;}

    public PageReference saveCase() {
        try {
            this.myCase.Origin = 'Web';
            this.myCase.Status = 'New';
            insert this.myCase;
            return new PageReference('/Cases/'+ [SELECT CaseNumber FROM Case WHERE Id =: this.myCase.Id].CaseNumber);
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }


    public PageReference goToDetail() {

        return new PageReference('/Cases/'+ CaseNumber );
    }
    

    public PageReference forwardToCustomAuthPage() {
         return SS_CommunitySiteUtil.forwardToCustomAuthPage(startURL);
                
    }

    public PageReference newCasePage() {
        return new PageReference('/SS_CommunitySiteNewCase');
    }
}