/*
 * Copyright (c) 2020. 7Summits Inc.
 */

// ===================
// x7sExp Utility Navigation controller
// ===================
public with sharing class x7sExpUtilityNavigationController {

    // Determine if guest or logged in
    @AuraEnabled
    public static Boolean isGuestUser() {
        return x7sExpUtils.isGuestUser();
    }
}