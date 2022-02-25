/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
private class x7sFileUploaderControllerTest {
    public static Account testAccount = new Account();
    public static Attachment testAttachment = new Attachment();

    static void testSetup() {
        testAccount = x7sFileUploaderTestUtils.createTestAccount();


        String base64Data = EncodingUtil.urlDecode(x7sFileUploaderTestConstants.BASE64FILE, 'UTF-8');
        testAttachment.ParentId = testAccount.Id;

        testAttachment.Body = EncodingUtil.base64Decode(base64Data);
        testAttachment.Name = x7sFileUploaderTestConstants.FILENAME;
        testAttachment.ContentType = x7sFileUploaderTestConstants.FILETYPE;

        insert testAttachment;
    }

    @IsTest
    public static void testGetFileRestrictions() {
        Network testNetwork;
        List<Network> testNetworkList = [SELECT Id, MaxFileSizeKb, AllowedExtensions FROM Network];
        System.debug('testNetworkList ======  ' + testNetworkList);
        if (testNetworkList != null && testNetworkList.size() > 0) {
            testNetwork = testNetworkList[0];
            if (testNetwork.MaxFileSizeKb == null || testNetwork.MaxFileSizeKb == 0 || testNetwork.MaxFileSizeKb > 4248) {
                testNetwork.MaxFileSizeKb = 4248;
                //If the heap issue ever gets fixed then set the max size to the Salesforce max file size of 2GB.
                //curNetwork.MaxFileSizeKb = 2097152;
            }
        }
        Network testResults = (Network) x7sFileUploaderController.getFileRestrictions().results[0];
        String testString = testResults.AllowedExtensions + testResults.MaxFileSizeKb;
        String assertString = testNetwork.AllowedExtensions + testNetwork.MaxFileSizeKb;

        System.assertEquals(assertString, testString);
    }

    @IsTest
    public static void saveChunkSaveTest() {
        testSetup();
        x7sFileUploaderResponse testResults = x7sFileUploaderController.saveChunk(testAccount.Id, x7sFileUploaderTestConstants.FILENAME, x7sFileUploaderTestConstants.BASE64FILE, x7sFileUploaderTestConstants.FILETYPE, null);
        x7sFileUploaderContentObject testx7sResults = (x7sFileUploaderContentObject) testResults.x7sResults[0];
        System.assertEquals(testResults.success, true);
        System.assertNotEquals(testx7sResults.contentID, null);
    }

    @IsTest
    public static void saveChunkAppendTest() {
        testSetup();
        x7sFileUploaderResponse testResults = x7sFileUploaderController.saveChunk(testAccount.Id, x7sFileUploaderTestConstants.FILENAME, x7sFileUploaderTestConstants.BASE64FILE, x7sFileUploaderTestConstants.FILETYPE, testAttachment.Id);
        x7sFileUploaderContentObject testx7sResults = (x7sFileUploaderContentObject) testResults.x7sResults[0];

        System.assertEquals(testResults.success, true);
        System.assertNotEquals(testx7sResults.contentID, null);
    }

    @IsTest
    public static void saveTheFileTest() {
        testSetup();

        Attachment testAttachment = x7sFileUploaderController.saveTheFile(testAccount.Id, x7sFileUploaderTestConstants.FILENAME, x7sFileUploaderTestConstants.BASE64FILE, x7sFileUploaderTestConstants.FILETYPE);
        String testString = testAttachment.Name + testAttachment.ContentType;
        String assertString = x7sFileUploaderTestConstants.FILENAME + x7sFileUploaderTestConstants.FILETYPE;

        System.assertEquals(assertString, testString);
        System.assertNotEquals(null, testAttachment.Id);
    }

    @IsTest
    public static void appendToFileTest() {
        testSetup();

        Attachment testResults = x7sFileUploaderController.appendToFile(testAttachment.Id, x7sFileUploaderTestConstants.BASE64FILE);
        String testString = testResults.Id + testResults.Name + testResults.ContentType;
        String assertString = testAttachment.Id + x7sFileUploaderTestConstants.FILENAME + x7sFileUploaderTestConstants.FILETYPE;

        System.assertEquals(assertString, testString);
    }

    @IsTest
    public static void deleteAttachmentTest() {
        testSetup();

        x7sFileUploaderResponse testResults = x7sFileUploaderController.deleteAttachment(testAttachment.Name, testAttachment.ParentId);
        Attachment deletedAttachment = [SELECT Id, IsDeleted FROM Attachment WHERE Id = :testAttachment.Id ALL ROWS];

        System.assertEquals(true, testResults.success);
        System.assertEquals(true, deletedAttachment.IsDeleted);
    }
}