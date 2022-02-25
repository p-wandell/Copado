@isTest class x7S_CopadoFileCleanup_Test {

    @isTest static void testCleanup() {
        Test.startTest();
        x7S_CopadoFileCleanup schd = new x7S_CopadoFileCleanup();
        String sch = '0 0 23 * * ?';
        String jobId = System.schedule('testing', sch, schd);
        Test.stopTest();
    }
}