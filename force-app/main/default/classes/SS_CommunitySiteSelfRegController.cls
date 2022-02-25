public with sharing class SS_CommunitySiteSelfRegController {

    public String spam {get; set;}

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String username {get; set { username = value == null ? value : value.trim(); } }
    
    public final String usernameSuffix {get; private set;}

    public Boolean showAlert {get; private set;}
    public Boolean success {get; private set;}
    public String pageMessage {get; private set;}

    public SS_CommunitySiteSelfRegController() {
        usernameSuffix = SS_CommunitySiteConstants.getUsernameSuffix();

        showAlert = false;
        success = false;
        pageMessage = '';
        spam = 'notSpam';
    }
    
    private boolean isValidPassword() {
        return password == confirmPassword;
    }

    public PageReference registerUser() {
        // reset the variables
        showAlert = true;
        success = false;
        pageMessage = '';

        // Bot is modifying a hidden field
        if (spam != 'notSpam') {
            showAlert = true;
            success = false;

            pageMessage = 'Please contact an administrator, your request cannot be processed.';
            return null;
        }

        // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            showAlert = true;
            success = false;

            pageMessage = Label.site.passwords_dont_match;
            return null;
        }    

        String profileId = null; // To be filled in by customer.
        String roleEnum = null; // To be filled in by customer.
        String accountId = SS_CommunitySiteConstants.getCommunityAccountId(); // To be filled in by customer.

        User u = new User();
        u.Username = username + usernameSuffix;
        u.Email = email;
        u.FirstName = firstName;
        u.LastName = lastName;
        u.CommunityNickname = username;
        u.ProfileId = profileId;
        // Need to explicitly give access to Chatter Answers
        u.UserPermissionsChatterAnswersUser = true;

        String userId;
        try {
            userId = Site.createPortalUser(u, accountId, password);
            
            // For Person Accounts
            //userId = Site.createPersonAccountPortalUser(u, Site.getAdminId(), SS_CommunitySiteConstants.getPersonRecordType().Id, password);
        } catch (Exception e) {
            System.debug('Error: ' + e);
            pageMessage = 'Error registering your account. Please contact the site administrator.';
            return null;
        }
      
        if (userId != null) { 
            success = true;
            if (password != null && password.length() > 1) {
                return Site.login(username + usernameSuffix, password, '/');
            }
            else {
                pageMessage = Label.site.thank_you_for_registering;
                //PageReference page = new PageReference(SS_CommunitySiteUrlRewriter.SELF_REG_CONFIRM_PAGE);
                //page.setRedirect(true);
                return null;
            }
        }

        // Potential errors
        // - Nickname exists (That nickname already exists. Enter a unique nickname.)
        // - Email already in use (Your request cannot be processed at this time. The site administrator has been alerted.)

        // TODO - Check to see if username already exists for a more specific message

        if (ApexPages.hasMessages()) {
            // display the first message
            pageMessage = ApexPages.getMessages()[0].getSummary();

            if (pageMessage.equals('That nickname already exists. Enter a unique nickname.')) {
                pageMessage = 'Username already exists in the system.';
            } else if (pageMessage.equals('Your request cannot be processed at this time. The site administrator has been alerted.')) {
                pageMessage = 'Email already exists in the system.';
            }
        } else {
            // TODO - need to give an email
            pageMessage = 'Error registering your account. Please contact the site administrator.';
        }

        return null;
    }
}