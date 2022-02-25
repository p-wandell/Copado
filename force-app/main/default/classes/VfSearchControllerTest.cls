@isTest (SeeAllData=true) 
private class VfSearchControllerTest {
  User testCompanyCommunityUser;
  PageReference pageRef;
  VfSearchController cont; 
  
  private void setUp(){
    pageRef = Page.Knowledge;
    Test.setCurrentPage(pageRef);
    cont = new  VfSearchController();
  }

  private void setUpWithParams(){
    pageRef = Page.Knowledge;
    Test.setCurrentPage(pageRef);
    DataCategoryGroupInfo[] categoryGroups = DataCategoryUtil.getInstance().getAllCategoryGroups(); 

    // This needs to be set to a Category that actually exists!
    System.currentPageReference().getParameters().put('categoryType_'+categoryGroups[0].getName(), 'FAQs');
    Test.setCurrentPage(pageRef);
    cont = new  VfSearchController();
  }
  
   @isTest static void test_VfSearchController() {
        VfSearchControllerTest thisTest = new VfSearchControllerTest();
       
        thisTest.testCompanyCommunityUser = createUsers(1, 'System Administrator')[0];

        System.runAs(thisTest.testCompanyCommunityUser){
            thisTest.setUp();
            thisTest.cont.searchstring = null;
            // Happy path get category keyword
            String x = thisTest.cont.getCategoryKeyword();
            System.assert(x<>null);

            // 
            DataCategoryGroupInfo[] catgroup = thisTest.cont.getDataCategoryGroupInfo();

            // Test properties
            PageReference pageref = thisTest.cont.refreshSearchResult();
            boolean prevRequired = thisTest.cont.getPrevRequired();
            boolean nextRequired = thisTest.cont.getNextRequired();
            Decimal getCurrentPageNumber = thisTest.cont.getCurrentPageNumber();
            // Next and previous (and test for finding next and not finding next... and same with previous)
            PageReference next = thisTest.cont.next();
            PageReference previous = thisTest.cont.previous();
            
            thisTest.cont.currentPage = 2;
            previous = thisTest.cont.previous();
            thisTest.cont.maxSize = 50;
            next = thisTest.cont.next();     
            
        }
    }  

    @isTest static void test_VfSearchControllerWithParams() {
        VfSearchControllerTest thisTest = new VfSearchControllerTest();
       
        thisTest.testCompanyCommunityUser = createUsers(1, 'System Administrator')[0];

        System.runAs(thisTest.testCompanyCommunityUser){
            thisTest.setUpWithParams();
            thisTest.cont.searchstring = 'Test String';

            // Happy path get category keyword
            String x = thisTest.cont.getCategoryKeyword();
            System.assert(x<>null);

            // 
            DataCategoryGroupInfo[] catgroup = thisTest.cont.getDataCategoryGroupInfo();

            // Test properties
            PageReference pageref = thisTest.cont.refreshSearchResult();
            boolean prevRequired = thisTest.cont.getPrevRequired();
            boolean nextRequired = thisTest.cont.getNextRequired();
            Decimal getCurrentPageNumber = thisTest.cont.getCurrentPageNumber();
            // Next and previous (and test for finding next and not finding next... and same with previous)
            PageReference next = thisTest.cont.next();
            PageReference previous = thisTest.cont.previous();
            
            thisTest.cont.currentPage = 2;
            previous = thisTest.cont.previous();
            thisTest.cont.maxSize = 50;
            next = thisTest.cont.next();     
            
        }
    }  
  
    public static List<User> createUsers(Integer howMany,String profileName){
        Id profileId;
        String type; 
        if(profileName == 'System Administrator'){
            profileId = COMPANY_COMMUNITY_PROFILE_Id;
            type = 'com';
        } 
        List<User> listOfUsers = new List<User>();
        for (Integer i = 0; i < howMany; i++){
            User u = new User(alias = 'u' + type +i , email='testtest@test.com', emailencodingkey='UTF-8', lastname='Test' + type +i, languagelocalekey='en_US', localesidkey='en_US', profileid = profileId, timezonesidkey='America/Los_Angeles', username='test@testtest.com.' + type + i);
            listOfUsers.add(u);
        }
        insert listOfUsers;
        return listOfUsers;
    }

    static public Id COMPANY_COMMUNITY_PROFILE_Id {
        get{
          if(COMPANY_COMMUNITY_PROFILE_Id  == null){  
            List<Profile> profiles = [select Id from Profile where Name = 'System Administrator'];
            COMPANY_COMMUNITY_PROFILE_Id = profiles[0].id;           
          }
          return COMPANY_COMMUNITY_PROFILE_Id;
        }
        set;
    }
}