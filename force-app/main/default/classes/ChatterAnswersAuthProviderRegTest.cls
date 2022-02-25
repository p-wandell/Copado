@isTest
private class ChatterAnswersAuthProviderRegTest {

   static testMethod void validateCreateUpdateUser() {
   
       User thisUser = [ select Id from User where Id =    :UserInfo.getUserId() ];
       
        System.runAs ( thisUser ) {
        
        ChatterAnswersAuthProviderRegistration reg = new ChatterAnswersAuthProviderRegistration();
        
        User newUser = SS_TestUtils.initCommunityUser();
            
            System.assert(newUser != null, 'A new user should have been created');
            System.assertEquals(newUser.Firstname, 'Test', 'First name should have been same');
            System.assertEquals(newUser.Lastname, 'Person', 'Last name should have been same');

            Account a = new Account();
            a.Name = 'Test Account';
            insert(a);

            System.assert(a != null, 'Account should have been created');
            
            Contact c = new Contact();
            c.AccountId = a.Id;
            c.LastName = 'contactLast';
            insert(c);
            
            newUser.Alias = 'firstusr';
            newUser.TimeZoneSidKey = 'America/Los_Angeles';
            newUser.LocaleSidKey = 'en_US';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.LanguageLocaleKey = 'en_US';
            newUser.ContactId = c.Id;
            
            insert(newUser);
            
            
            Auth.UserData updateUserData = new Auth.UserData('testId', 'updatedFirst', 'updatedLast',
            'updatedFirst updatedLast', 'no-reply@new.salesforce.com', null, 'testuserlong', 'en_US', 'facebook',
            null, new Map<String, String>{'language' => 'en_US'});
            reg.updateUser(newUser.Id, null, updateUserData);
            
            User dbUser = [SELECT Id, Firstname, Lastname, Email FROM User WHERE Id = :newUser.Id];
            System.assertNotEquals(null, dbUser);
            //System.assertEquals(dbUser.Firstname, 'updatedFirst', 'First name should have been updated');
            //System.assertEquals(dbUser.Lastname, 'updatedLast', 'Last name should have been updated');
            //System.assertEquals(dbUser.Email, 'no-reply@new.salesforce.com', 'Email should have been updated');
       }
    }
}