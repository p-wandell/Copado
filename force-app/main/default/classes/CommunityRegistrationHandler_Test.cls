@isTest
private class CommunityRegistrationHandler_Test {
    
    private static User testUser;
    private static Auth.UserData data;
    private static String userName;
    
    private static void setupData() {             
        userName = 'TestUser' + (Math.Random() * 10000) + '@example.org';
        data = new Auth.UserData('testId', 'testFirst', 'testLast', 'testFirst testLast', userName, null, 
                                 'testuserlong', 'en_US', 'google', null, new Map<String, String>{'language' => 'en_US'});
    }
    
    @isTest
    private static void test_getUsername_hasUsername() {
        setupData();
        
        CommunityRegistrationHandler handler = new CommunityRegistrationHandler();
        
        Account a = new Account();
        a.Name = SS_CommunitySiteConstants.getDefaultCommunityAccountName();
        insert a;  
        
        Test.startTest();
        
        String result = handler.getUsername(data);
        
        Test.stopTest();
        
        System.assertEquals(data.username + SS_CommunitySiteConstants.getUsernameSuffix(), result);
    }
    
    @isTest
    private static void test_getUsername_noUsername() {
        setupData();
        
        CommunityRegistrationHandler handler = new CommunityRegistrationHandler();
        
        Account a = new Account();
        a.Name = SS_CommunitySiteConstants.getDefaultCommunityAccountName();
        insert a; 
        
        Test.startTest();
        
        data.username = '';
        String result = handler.getUsername(data);
        
        Test.stopTest();
        
        System.assertEquals(data.firstName + '.' + data.lastName + SS_CommunitySiteConstants.getUsernameSuffix(), result);
    }
    
    @isTest
    private static void test_getUsername_isEmail() {
        setupData();
        
        CommunityRegistrationHandler handler = new CommunityRegistrationHandler();
        
        Account a = new Account();
        a.Name = SS_CommunitySiteConstants.getDefaultCommunityAccountName();
        insert a; 
        
        Test.startTest();
        
        String result = handler.getUsername(data);
        
        Test.stopTest();
    }
    
    @isTest
    private static void test_createUser() {
        // Create & Update User
        setupData();
        
        CommunityRegistrationHandler handler = new CommunityRegistrationHandler();
        
        Account a = new Account();
        a.Name = SS_CommunitySiteConstants.getDefaultCommunityAccountName();
        insert a; 
        
        // Create
        User u;
        
        u = handler.createUser(null, data);
        System.assertEquals('testLast', u.lastName);
        System.assertEquals('testFirst', u.firstName);
        System.assertEquals('testuser', u.alias);
        insert(u);
        
        String uid = u.id;
        
        // Update
        
        // same username, different other metadata
        data = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                 'testNewFirst testNewLast', userName, null, 'testuserlong', 'en_US', 'facebook',
                                 null, new Map<String, String>{});
        
        
//        u = handler.createUser(null, data);

        System.assertEquals(uid, u.id);
    }
    
    @isTest
    private static void test_updateUser() {
        // Create & Update User
        setupData();
        
        CommunityRegistrationHandler handler = new CommunityRegistrationHandler();
        
        Account a = new Account();
        a.Name = SS_CommunitySiteConstants.getDefaultCommunityAccountName();
        insert a; 
        
        User u;
        
        u = handler.createUser(null, data);
//        insert(u);
        
        String uid = u.id;
        
        Test.startTest();
        
        data = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast',
                                 'testNewFirst testNewLast', userName, null, 'testnewuserlong', 'en_US', 'facebook',
                                 null, new Map<String, String>{});
        
        
//        handler.updateUser(uid, null, data);
        
        
        Test.stopTest();
        
    }
}