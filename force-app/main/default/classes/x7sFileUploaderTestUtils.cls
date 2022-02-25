/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sFileUploaderTestUtils {
    // Create an account so we can create a Contact
    public static Account createTestAccount() {
        if (Account.SObjectType.getDescribe().isCreateable()){
            Account account = new Account(Name = x7sFileUploaderTestConstants.ACCOUNT_NAME);
            insert account;

            return account;
        } else {
            System.debug('ACCESS ERROR: Unable to create account.');
            return null;
        }
    }
}