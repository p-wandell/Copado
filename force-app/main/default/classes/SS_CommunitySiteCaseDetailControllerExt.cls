public with sharing class SS_CommunitySiteCaseDetailControllerExt {

    @TestVisible private String startURL = '%2FCases';

	public  Case myCase {get; set;}

    private String query;

    
    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public SS_CommunitySiteCaseDetailControllerExt(ApexPages.StandardController stdController) {
        try {
            this.myCase = (Case)stdController.getRecord();
            queryCase();
        } catch(Exception e) {
            this.myCase = new Case();
        }
    }

    @TestVisible 
    private void queryCase() {
        query = 'select Id';
        for(Schema.FieldSetMember f : SObjectType.Case.FieldSets.getMap().get('CommunityFieldset').getFields()) {
            query += ','+f.getFieldPath();
        }
        query += ' from Case where Id = \''+myCase.Id+'\'';
        this.myCase = Database.query(query);
    }

    public PageReference forwardToCustomAuthPage() {
        // this should go back to MyCases since we don't have access to Id till the user is authenticated
        PageReference pr = SS_CommunitySiteUtil.forwardToCustomAuthPage(startURL);

        if (pr == null) {
            if (this.myCase == null) {
                return Page.SSTab_CommunitySiteMyCases;
            }
        }
            
        return pr;
    }
/*
    public PageReference saveCase() {
        try {
            if(this.myCase.Id != null) {
                update this.myCase;
            } else {
                this.myCase.Origin = 'Web';
                this.myCase.Status = 'New';
                insert this.myCase;
                return new PageReference('/Cases/'+ [SELECT CaseNumber FROM Case WHERE Id =: this.myCase.Id].CaseNumber);
            }
            queryCase();
            isEditorNew = false;
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }*/


    /*private void queryCaseComments() {
        caseComments = new List<CaseComm>();
        Set<Id> userIds = new Set<Id>();
        for(CaseComment cc : [select Id, CreatedDate, LastModifiedDate, CreatedBy.Name, LastModifiedBy.Name, 
            ParentId, CommentBody, CreatedById, LastModifiedById
            from CaseComment where ParentId =: this.myCase.Id order by LastModifiedDate desc]) {
            caseComments.add(new CaseComm(cc, false));
            userIds.add(cc.CreatedById);
            userIds.add(cc.LastModifiedById);
        }
        Map<Id, User> theUsers = new  Map<Id, User>([select Id, Name, SmallPhotoUrl from User where Id in: userIds]);
        for(CaseComm caseComm : caseComments) {
            caseComm.createdBy = theUsers.get(caseComm.caseComm.CreatedById);
            caseComm.lastModifiedBy = theUsers.get(caseComm.caseComm.LastModifiedById);
        }
    }

    public PageReference setToEditComment() {
        String id = System.currentPageReference().getParameters().get('ccId');
        for(CaseComm cc : caseComments) {
            if(cc.caseComm.Id == id) {
                cc.isEditOrNew = true;
            }
        }
        return null;
    }

    public PageReference saveComment() {
        try {
            String id = System.currentPageReference().getParameters().get('ccId');
            if(id != null && id != '') {
                for(CaseComm cc : caseComments) {
                    if(cc.caseComm.Id == id) {
                        update cc.caseComm;
                        cc.isEditOrNew = false;
                    }
                }
            } else {
                insert caseComments.get(0).caseComm;
                caseComments.get(0).isEditorNew = false;
            }
            queryCaseComments();
        } catch(Exception e) {
            ApexPages.addMessages(e);
        }
        return null;
    }

    public PageReference newComment() {
        caseComments.add(0, new CaseComm(new CaseComment(ParentId = myCase.Id), true));
        return null;
    }

    public PageReference cancelComment() {
        String id = System.currentPageReference().getParameters().get('ccId');
        if(id != null && id != '') {
            for(CaseComm cc : caseComments) {
                if(cc.caseComm.Id == id) {
                    cc.isEditOrNew = false;
                }
            }
        }
        queryCaseComments();
        return null;
    }

    class CaseComm {
        public Boolean isEditOrNew {get; set;}
        public CaseComment caseComm {get; set;}
        public User createdBy {get; set;}
        public User lastModifiedBy {get; set;}

        public CaseComm(CaseComment cc, Boolean edit) {
            this.isEditorNew = edit;
            this.caseComm = cc;
        }
    }*/
}