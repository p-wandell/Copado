trigger CreateContactRole on Opportunity (after insert, after update) {
 
    //get the id of all involved accounts
    Set<ID> accountIds = new Set<ID>();
    for(Opportunity opt:Trigger.New){
        accountIds.add(opt.AccountId);
    }
     
    //get all contacts for those accounts
    list<Contact> contacts = new list<Contact>();
    contacts = [select id, AccountId from Contact where AccountId in: accountIds order by createddate Limit 5000];
     
    //organize these contacts by account
    Map<Id,List<Contact>> contactsByAccount = new Map<ID,List<Contact>>();
    for(Contact c:contacts){
        if(contactsByAccount.get(c.AccountId) == null){
            contactsByAccount.put(c.AccountId,new List<Contact>());
        }
        contactsByAccount.get(c.AccountId).add(c);
    }
     
    // check to see if the Opportunity already has a contact role.  If it does, add to a set of Ids to exclude
    List<OpportunityContactRole> existingOCR = new List<OpportunityContactRole>();
    Map<Id, Set<Id>> contactIdsByOpportunityIdMap = new Map<Id, Set<Id>>();
    Set<Id> existingOCRIds = new Set<Id>();
    existingOCR = [select OpportunityId, ContactId from OpportunityContactRole where OpportunityId in:Trigger.newMap.keySet() limit 5000];
    for(OpportunityContactRole ocr:existingOCR){
        if(!existingOCRIds.contains(ocr.ContactId))
        {
            existingOCRIds.add(ocr.ContactId);
            Set<Id> contactIds = contactIdsByOpportunityIdMap.get(ocr.OpportunityId);
            if(contactIds == null){
                contactIds = new Set<Id>();
            }
            contactIds.add(ocr.ContactId);
            contactIdsByOpportunityIdMap.put(ocr.OpportunityId, contactIds);
        }
    }
    //create the OpportunityContactRole objects
    list<OpportunityContactRole> lstOCR = new list<OpportunityContactRole>();
    for(Opportunity opt:Trigger.New){
        if(contactsByAccount.get(opt.AccountId) != null){
            for(Contact c: contactsByAccount.get(opt.AccountId)){
                Set<Id> contactIdsForOpp = contactIdsByOpportunityIdMap.get(opt.Id);
                if(contactIdsForOpp == null || !contactIdsForOpp.contains(c.Id)){
                    OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=opt.id,ContactId=c.id);
                    lstOCR.add(ocr);
                }
            }
        }
    }
    insert lstOCR;
}