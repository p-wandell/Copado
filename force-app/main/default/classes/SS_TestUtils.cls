@isTest
public class SS_TestUtils {

    public static User initGuestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name =: SS_CommunitySiteConstants.getUnauthenticatedCommunityProfileName()];
        String userName = 'guest.user' + (Math.Random() * 10000) + '@testpkg.com';
        User u = new User(alias = 'guest', email=userName,
                         emailencodingkey='UTF-8', firstname='Test', lastname='Person', languagelocalekey='en_US',
                         localesidkey='en_US', profileid = p.id,
                         timezonesidkey='America/Los_Angeles', username=userName);
        return u;
    }

    public static User initCommunityUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name =: SS_CommunitySiteConstants.getCommunityProfileName()];
        String userName = 'community.user' + (Math.Random() * 10000) + '@testpkg.com';
        User u = new User(alias = 'portal', email=userName,
                         emailencodingkey='UTF-8', firstname='Test', lastname='Person', languagelocalekey='en_US',
                         localesidkey='en_US', profileid = p.id,
                         timezonesidkey='America/Los_Angeles', username=userName);
        return u;
    }

    public static User initAdminUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        UserRole r = [SELECT Id FROM UserRole LIMIT 1];
        String userName = 'admin' + (Math.Random() * 10000) + '@testpkg.com';
        User u = new User(alias = 'admin', email=userName,
                         emailencodingkey='UTF-8', firstname='Test', lastname='Person', languagelocalekey='en_US',
                         localesidkey='en_US', profileid = p.id, userRoleId = r.Id,
                         timezonesidkey='America/Los_Angeles', username=userName);
        return u;
    }

    public static List<Case> initCases(Integer num) {
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < num; i++) {
            cases.add(initCase());
        }
        return cases;
    }

    public static Case initCase() {
        Case c = new Case();
        return c;
    }
}