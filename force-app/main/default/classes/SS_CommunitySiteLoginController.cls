global with sharing class SS_CommunitySiteLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global final String usernameSuffix {get; private set;}

    global Boolean showError {get; private set;}
    
    global SS_CommunitySiteLoginController () {
        usernameSuffix = SS_CommunitySiteConstants.getUsernameSuffix();

        showError = false;
    }

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        if (String.isBlank(startUrl)) {
            startUrl = '/';
        }
        PageReference pr = Site.login(username + usernameSuffix, password, startUrl);

        if (pr == null) {
            showError = true;
        } else {
            SS_CommunitySiteTermsController.deleteCookie();
        }

        return pr;
    }
}