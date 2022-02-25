public class x7S_MyProjectsController {

    @AuraEnabled
    public static String getContactId(String userId) {
        String contactId = null;

        if (userId == '') {
            userId = UserInfo.getUserId();
        }
        
        contactId = [SELECT ID FROM Contact WHERE pse__Salesforce_User__c = :userId].Id;
        
        return contactId;
    }
    
    @AuraEnabled
    public static List<SObject> getMyProjects(String userId) {

        List<SObject> myProjectsList = new List<SObject>();
        
        String contactId = x7S_MyProjectsController.getContactId(userId);

        
        if (contactId != null) {
        myProjectsList = [SELECT    pse__Project__r.pse__Project_Status__c,
                                    pse__Project__r.Id,
                                    pse__Project__r.Name,
                                    pse__Project__r.pse__Stage__c,
                pse__Project__r.pse__Project_Manager__c,
                pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c,
                                    pse__Project__r.pse__Project_Manager__r.FirstName,
                                    pse__Project__r.pse__Project_Manager__r.LastName
                          FROM pse__Assignment__c
                          WHERE pse__Resource__c = :contactId
                            AND Project_Stage__c != 'Closed'
                            AND Project_Stage__c != 'Completed'
                            AND pse__Start_Date__c <= NEXT_N_WEEKS:2
                            AND pse__End_Date__c >= NEXT_N_WEEKS:2
                            AND (pse__Time_Credited__c = TRUE
                                    OR pse__Is_Billable__c = TRUE)
                            AND pse__Closed_for_Time_Entry__c = FALSE
        GROUP BY    pse__Project__r.pse__Project_Status__c,
                                    pse__Project__r.Id,
                                    pse__Project__r.Name,
                                    pse__Project__r.pse__Stage__c,
                                  pse__Project__r.pse__Project_Manager__c,
                                  pse__Project__r.pse__Project_Manager__r.pse__Salesforce_User__c,
                                  pse__Project__r.pse__Project_Manager__r.FirstName,
                                  pse__Project__r.pse__Project_Manager__r.LastName,
                pse__Start_Date__c
        ORDER BY pse__Start_Date__c];
        }

        System.debug(myProjectsList);
        return myProjectsList;
    }
    
}