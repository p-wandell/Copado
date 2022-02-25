/**
 * Created by francoiskorb on 9/17/18.
 */

public with sharing class ss_util_metadata
{
	@TestVisible
	private static String getNameSpacePrefix()
	{
		String namespacePrefix = [SELECT NamespacePrefix FROM ApexClass WHERE Name = 'ss_util_metadata' LIMIT 1].NamespacePrefix;

		return String.isNotBlank(namespacePrefix) ? namespacePrefix + '__' : '';
	}

	@TestVisible
	public static String buildQuery(String objectName, String additionalFields)
	{
		String nameSpace = getNameSpacePrefix();

		DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(nameSpace+objectName).getDescribe();

		List<String> fieldNames = new List<String>( describeResult.fields.getMap().keySet() );
		String fields = String.join( fieldNames, ',' );

		if (String.isNotBlank(additionalFields))
		{
			fields += ',' + additionalFields;
		}

		String query = ' SELECT ' +  fields +  ' FROM ' +  describeResult.getName();

		return query;
	}

	@TestVisible
	public static String buildSubQuery(String objectName, String fieldList)
	{
		String nameSpace = getNameSpacePrefix();

		List<String> queryStrings = new List<String>();

		// use regex command and space to find custom fields
		for (String field : fieldList.split('[, ]'))
		{
			if (field.endsWith('__c'))
			{
				queryStrings.add(nameSpace + objectName+'.'+field);
			}
		}

		return String.join(queryStrings, ',');
	}

}