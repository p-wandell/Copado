/*
 *  Implementation gleaned from http://salesforce.stackexchange.com/a/5995/411
 */
global virtual class CommunityRegistrationHandler implements Auth.RegistrationHandler {

    global String getUsername(Auth.UserData data) {
        // Create our custom branded username
        String username = data.username;
        if (String.isBlank(username)) {
            username = data.firstName + '.' + data.lastName;
        } 
        username = username.trim().replaceAll(' ', '.');

        if (username.contains('@')) {
            username = username.split('@')[0];
        }
        
        return username + SS_CommunitySiteConstants.getUsernameSuffix();
    }

    global virtual void updateAdditionalFields(String userId, User u, Auth.UserData data) {
        // hotspot method
    }

    global User createUser(Id portalId, Auth.UserData data){
        User u;

        List<User> users = [SELECT Id FROM User WHERE Username =: getUsername(data)];
        if (!users.isEmpty()) {
            u = users[0];
            System.debug('Found existing user record for '+data.username);

            // Update existing record
/*
            u.Email = data.email;
            u.LastName = data.lastName;
            u.FirstName = data.firstName;
*/            
            updateAdditionalFields(null, u, data);

            System.debug('Updating user record for ' + data.username + ': ' + u);

            update(u);
        } else {
            // For now hardcode our custom Account to tie contacts to by default
            Account a = [SELECT Id FROM Account WHERE Name=: SS_CommunitySiteConstants.getDefaultCommunityAccountName()];

            Contact c = new Contact();
            c.AccountId = a.Id;
            c.Email = data.email;
            c.FirstName = data.firstName;
            c.LastName = String.isNotBlank(data.lastName) ? data.lastName : data.username;
            insert(c);
            /*
            // Person Accounts implementation
            RecordType rt = SS_CommunitySiteConstants.getPersonRecordType();

            Account a = new Account();
            a.RecordTypeId = rt.Id;
            a.PersonEmail = data.email;
            a.FirstName = data.firstName;
            a.LastName = String.isNotBlank(data.lastName) ? data.lastName : data.username;
            insert(a);
            */

            u = new User();

            u.UserName = getUsername(data);
            u.Email = data.email;
            u.LastName = String.isNotBlank(data.lastName) ? data.lastName : data.username;
            u.FirstName = data.firstName;

            u.Alias = (data.username != null) ? data.username : data.identifier;
            if (u.Alias.length() > 8) {
                u.Alias = u.Alias.substring(0, 8);
            }
            u.Languagelocalekey = UserInfo.getLocale();
            u.Localesidkey = UserInfo.getLocale();
            u.EmailEncodingKey = 'UTF-8';
            u.TimeZoneSidKey = 'America/Los_Angeles';
            u.ProfileId = [SELECT Id FROM profile WHERE name=: SS_CommunitySiteConstants.getCommunityProfileName()].Id;
            u.ContactId = c.Id;
            u.UserPermissionsChatterAnswersUser = true;
            // Person Account
            //u.ContactId = [SELECT PersonContactId FROM Account WHERE Id =: a.Id].PersonContactId;
            
            updateAdditionalFields(null, u, data);

            System.debug('Returning new user record for ' + data.username + ': ' + u);
        }

        return u;
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        User u = new User(id=userId);
/*        
        u.username = getUsername(data);
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
*/
        updateAdditionalFields(userId, u, data);

        System.debug('Updating user record for '+data.username);

        update(u);
    }
}