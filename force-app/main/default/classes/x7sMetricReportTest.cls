/*
 * Copyright (c) 2020. 7Summits Inc.
 */
@IsTest
public class x7sMetricReportTest {
	private static final String testReportName = 'flow_screen_prebuilt_report';

	@IsTest(SeeAllData=true)
	public static void singleReportTest() {
		List <Report> reportList = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = :testReportName LIMIT 1];
		String reportValue;

		if (reportList.size() > 0) {
			List<x7sMetricReportController.reportEntry> entries = new List<x7sMetricReportController.reportEntry>();

			entries.add(new x7sMetricReportController.reportEntry(reportList[0].DeveloperName, null, false));
			entries.add(new x7sMetricReportController.reportEntry(reportList[0].DeveloperName, null, false));
			entries.add(new x7sMetricReportController.reportEntry(reportList[0].DeveloperName, null, false));
			entries.add(new x7sMetricReportController.reportEntry(reportList[0].DeveloperName, null, false));

			reportValue = x7sMetricReportController.reportData(entries);

		}
		System.assertNotEquals(null, reportValue);
	}
}