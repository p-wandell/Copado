/**
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

 @isTest
public class x7sMediaControllerTest {
    @isTest
    static void testValidAudioFields() {

        Account a = new Account(Name='Test Account', Industry_Type__c = 'Retail');
        insert a;
        
        Contact c = new Contact(LastName = 'Test Contact', AccountId = a.Id);

        try {
            insert c;
            System.assert(c.Id != null);
            x7sMediaController.getAudioData(c.Id, 
                                            'LastName',
                                            'FirstName',
                                            'Phone',
                                            'Description',
                                            'MailingStreet',
                                            'MailingCity');
        } catch(Exception e) {
            System.debug('Error::'+e.getMessage());    
        }
    }

    @isTest
    static void  testInValidAudioFields(){

        Account a = new Account(Name='Test Account', Industry_Type__c = 'Retail');
        insert a;
        
        Contact c = new Contact(LastName = 'Test Contact', AccountId = a.Id);

        try {
            insert c;
            sObject obj = x7sMediaController.getAudioData(c.Id, 
                                            'LastNames',
                                            'FirstName',
                                            'Phone',
                                            'Description',
                                            'MailingStreet',
                                            'MailingCity');
            System.assert(obj == null);
        } catch (Exception e) {
            System.debug('Error::'+e.getMessage()); 
        }
    }
}