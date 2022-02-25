/*
 * Copyright (c) 2020. 7Summits Inc.
 */
public with sharing class x7sMetricReportController {

	@AuraEnabled
	public static String reportData(List<reportEntry> reportEntries) {
		List<wrapper> wrapperList = new List<wrapper>();
		Map<String, List<String>> reportsMap = new Map<String, List<String>>();

		for (reportEntry entry : reportEntries) {
			if (reportsMap.containsKey(entry.reportName)) {
				reportsMap.get(entry.reportName).add(entry.useAPIName + '-' + entry.fieldName);
			} else {
				reportsMap.put(entry.reportName, new List<String>{entry.useAPIName + '-' + entry.fieldName});
			}
		}

		// Get the report ID
		List <Report> reportList = [
			SELECT Id,DeveloperName
			FROM Report
			WHERE
				DeveloperName IN:reportsMap.keySet()
			WITH SECURITY_ENFORCED
		];

		for (Report reportRec : reportList) {
			String reportId = reportRec.Id;
			for (String fields : reportsMap.get(reportRec.DeveloperName)) {

				String fieldName = fields.substringAfter('-');
				Boolean useAPIName = Boolean.valueOf(fields.substringBefore('-'));

				wrapperList.add(reportDetail(reportId, fieldName, useAPIName));

			}
		}
		return JSON.serialize(wrapperList);
	}

	public static wrapper reportDetail(String reportId, String fieldName, Boolean UseApiName) {
		Map<String, Double> valueMap = new Map<String, Double>() ;
		wrapper rowcountTemp;
		wrapper aggregateTemp;

		try {
			// Run a report synchronously
			Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);

			Map<String, reports.AggregateColumn> aggregate = results.getReportExtendedMetadata().getAggregateColumnInfo();
			Map<String, reports.DetailColumn> colInfo = results.getReportExtendedMetadata().getDetailColumnInfo();
			Map<String, String> fieldsInfo = new Map<String, String>();

			//Adding all the detail column fields
			for (reports.DetailColumn col : colInfo.values()) {
				fieldsInfo.put(col.getName(), col.getLabel());
			}

			// Get the first down-grouping in the report
			Reports.Dimension dim = results.getGroupingsDown();

			// Get the report metadata
			Reports.ReportMetadata rm = results.getReportMetadata();

			//Get the custom summary fields
			Map<String, reports.ReportCsf> customSummaryInfo = rm.getCustomSummaryFormula();

			for (String col : customSummaryInfo.keySet()) {
				fieldsInfo.put(col, customSummaryInfo.get(col).getLabel());
			}

			// Get the fact map from the report results
			Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');

			Integer count = 0;
			// Get aggregates
			for (String str : rm.getAggregates()) {

				// Get the first summary amount from the fact map
				Reports.SummaryValue sumVal = factDetails.getAggregates()[count];

				count++;
				String label = sumVal.getLabel();
				String value = String.valueOf(sumVal.getValue());
				if (label == '-') { value = '0';}

				// Help for unit tests
				if (Test.isRunningTest() && valueMap.keySet().size() == 0) {
					valueMap.put(str, null);
				}

				if (valueMap.containsKey(str)) {
					value = getValue(label, value);
					valueMap.put(str, Double.valueOf(value));
				}
				else {
					value = getValue(label, value);
					valueMap.put(str, Double.valueOf(value));
				}
			}

			//Assigning Aggregate values to the Wrapper
			for (reports.AggregateColumn aggCol : aggregate.values()) {
				String Name = aggCol.getName();
				String data = String.valueOf(aggCol.getDataType());
				String label = aggCol.getLabel();

				if (!String.isBlank(fieldName) && fieldName != 'null') {
					String fieldLabel = fieldName;
					Boolean defaultVal = true;
					if (UseApiName) {
						if (fieldsInfo.containsKey(fieldName.toUpperCase())) { fieldLabel = fieldsInfo.get(fieldName.toUpperCase());}
						else { defaultVal = false;}
					}
					if (defaultVal && (Name.containsIgnoreCase(fieldLabel) || label.containsIgnoreCase(fieldLabel))) { aggregateTemp = new wrapper(label, data.substringBefore('_DATA'), Name, valueMap.get(Name), rm.getDeveloperName(), fieldName);}
					else { if (Name.containsIgnoreCase('RowCount')) { rowcountTemp = new wrapper(label, data.substringBefore('_DATA'), Name, valueMap.get(Name), rm.getDeveloperName(), fieldName);}}
				}
				else {
					if (Name.containsIgnoreCase('RowCount')) {
						rowcountTemp = new wrapper(label, data.substringBefore('_DATA'), Name, valueMap.get(Name), rm.getDeveloperName(), fieldName);
					}
				}
			}
			if (aggregateTemp != null) {
				return aggregateTemp;
			}
			else {
				return rowcountTemp;
			}
		}
		catch (Exception ex) {
			System.debug(ex.getMessage() + ' & ' + ex.getLineNumber());
			return new wrapper(null, null, null, null, null, fieldName);
		}
	}

	private static String getValue(String label, String value) {
		if (label.contains('%') || label.contains('$')) {
			label = label.remove(',');
			if (label.contains('%')) { value = label.remove('%');}
			else if (label.contains('$')) { value = label.remove('$');}
		}
		return value;
	}

	public class reportEntry {
		@AuraEnabled public String reportName {get;set;}
		@AuraEnabled public String fieldName {get;set;}
		@AuraEnabled public Boolean useAPIName {get;set;}
		public reportEntry(String rName, String fName, Boolean useApi) {
			this.reportName = rName;
			this.fieldName = fName;
			this.useAPIName = useApi;
		}
	}

	public class wrapper {
		@AuraEnabled
		public String reportName { get; set; }
		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String name { get; set; }
		@AuraEnabled
		public String dataType { get; set; }
		@AuraEnabled
		public Integer value { get; set; }
		@AuraEnabled
		public String fieldName { get; set; }

		public wrapper(String labelTemp, String dataTypeTemp, String nameTemp, Double valueTemp, String reportNameTemp, String fieldNameTemp) {
			//Label Name of the field returned
			label = labelTemp;
			//API Name of the field returned
			name = nameTemp;
			//Data type of the value
			dataType = dataTypeTemp;
			//Summary or the Rowcount value of the Report
			value = Integer.valueOf(valueTemp);
			//Report name mentioned by the user
			reportName = reportNameTemp;
			//Field Name Mentioned by the user
			fieldName = fieldNameTemp;
		}
	}
}