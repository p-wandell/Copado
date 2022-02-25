/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

@IsTest
public with sharing class x7sFilesShareBatchScheduleTest {
	@TestSetup
	static void testSetup() {
		// setup test data
	}

	@IsTest
	public static void schedulerTest() {
		String CRON_EXP = '0 0 13 * * ?';

		Test.startTest();
		String jobId = System.schedule('x7sActivityBatchSchedule',  CRON_EXP, new x7sFilesShareBatchSchedule());
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();

	}
}