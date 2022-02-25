/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sExpBaseController {

    // Get the site prefix (for displaying links/assets)
    @AuraEnabled
    public static String getSitePrefix() {
        return x7sExpUtils.getSitePrefix();
    }

    // Determine if guest or logged in
    @AuraEnabled
    public static Boolean isGuestUser() {
        return x7sExpUtils.isGuestUser();
    }
}