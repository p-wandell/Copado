public with sharing class SS_CommunitySiteUtil {
	
	/**
		If the page is not authenticated navigates to custom login
	*/
	public static PageReference forwardToCustomAuthPage(String startURL) {

        //if authenticated stay at current page
        if(isPageAuthenticated()){
                return null;
        }else{
                return new PageReference('/Login?startURL=' + startURL);
        }

                
    }

	/**
		Check if a page is authenticated
	*/

	public static Boolean isPageAuthenticated(){
		if(UserInfo.getUserType() == 'Guest'){
			return false;
		} else {
			return true;
		}
	}
}