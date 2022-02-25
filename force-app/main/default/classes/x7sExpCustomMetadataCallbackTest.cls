/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sExpCustomMetadataCallbackTest {
    @IsTest
    public static void testCustomMetadataCallback() {
        x7sExpCustomMetadataCallback testCallback = new x7sExpCustomMetadataCallback();

        // Test result
        Metadata.DeployResult testResult = new Metadata.DeployResult();
        testResult.success = false;

        testResult.details = new Metadata.DeployDetails();
        testResult.details.componentFailures = new List<Metadata.DeployMessage>();

        // Test context
        Metadata.DeployCallbackContext testContext = new Metadata.DeployCallbackContext();

        // First, test failure
        testCallback.handleResult(testResult, testContext);

        // Now, test success
        testResult.success = true;
        System.assertNotEquals(null, testResult);
        testCallback.handleResult(testResult, testContext);
    }

}