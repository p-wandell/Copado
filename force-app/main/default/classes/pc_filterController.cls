/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/20/17.
 */

public with sharing class pc_filterController {

	@AuraEnabled
	public static List<String> getPicklistValues(String objName, String fieldName) {
		List<String>                     options     = new List<String>();
		Schema.SObjectType               objType     = Schema.getGlobalDescribe().get(objName);
		Schema.DescribeSObjectResult     objDescribe = objType.getDescribe();
		Map<String, Schema.SObjectField> fieldMap    = objDescribe.fields.getMap();
		List<Schema.PicklistEntry>       values      = fieldMap.get(fieldName).getDescribe().getPicklistValues();

		if (values.size() > 0)
		{
			// Add these values to the select option list.
			for (Schema.PicklistEntry a : values)
			{
				options.add(a.getLabel());
			}
		}

		return options;
	}
}