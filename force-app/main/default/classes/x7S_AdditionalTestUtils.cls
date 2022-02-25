@IsTest
public class x7S_AdditionalTestUtils {
    public static List<User> createManyUserNoContact(Integer amount, List<String> lastNames){
        List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name = :Peak_TestConstants.COMMUNITY_PROFILE];
        List<User> testUsers = new List<User>();
        if (!Peak_Utils.isNullOrEmpty(standardProfileList)) {
            Profile standardProfile = standardProfileList[0];
            for(Integer i = 1; i <= amount; i++){
                String lastName = lastNames[i-1] != null ? lastNames[i-1] : Peak_TestConstants.LASTNAME + i;
                testUsers.add(new User(Alias = Peak_TestConstants.STANDARD_ALIAS + i, Email=Peak_TestConstants.STANDARD_EMAIL + i, EmailEncodingKey=Peak_TestConstants.ENCODING, FirstName=Peak_TestConstants.FIRSTNAME, LastName=lastName, LanguageLocaleKey=Peak_TestConstants.LOCALE,LocaleSidKey=Peak_TestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey=Peak_TestConstants.TIMEZONE, Username=Peak_TestConstants.STANDARD_USERNAME + i,Apex_Processing__c=true));
            }
        }
        return testUsers;
    }
    // Create a contact associated with an account
    public static List<Contact> createManyTestContacts(Integer amount, List<String> lastNames){
		return createManyTestContacts(amount, lastNames, null);
    }
        // Create a contact associated with an account
    public static List<Contact> createManyTestContacts(Integer amount, List<String> lastNames, Id regionId){
        List<Contact> testContacts = new List<Contact>();
        RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType='Contact' AND Name='PSA Resource' LIMIT 1];
        System.debug('rt ==== ' + rt);
        Account account = Peak_TestUtils.createTestAccount();
        for(Integer i = 1; i <= amount; i++){
            String lastName = lastNames[i-1] != null ? lastNames[i-1] : Peak_TestConstants.LASTNAME + i;
            testContacts.add(new Contact(FirstName=Peak_TestConstants.FIRSTNAME + i, LastName=lastName, Email=Peak_TestConstants.STANDARD_EMAIL + i, 
                                         AccountId = account.Id, pse__Is_Resource__c=true, pse__Is_Resource_Active__c=true, RecordtypeId=rt.Id,
                                         pse__Region__c=regionId));
        }
        insert testContacts;

        return testContacts;
    }
}