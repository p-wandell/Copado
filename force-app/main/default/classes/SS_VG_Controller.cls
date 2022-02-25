/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/6/18.
 */

public with sharing class SS_VG_Controller
{
	public static final String LIST_FIELD_NAME = 'video_list_7s__c';

	@AuraEnabled
	public static SS_VG_Response getInitialData(Id recordId)
	{
		SS_VG_Response response = new SS_VG_Response();

		//get object Name
		Schema.DescribeSObjectResult objDescribe = recordId.getSobjectType().getDescribe();
		String sObjName = objDescribe.getName();


		String queryString = 'select id,' + LIST_FIELD_NAME + ' FROM ' + sObjName + ' Where id=: recordId';

		//check if field Video_List_7S__c exist on object or not
		if (objDescribe.fields.getMap().keySet().contains(LIST_FIELD_NAME))
		{
			List<SObject> listOfResults = Database.query(queryString);

			if (listOfResults != null && listOfResults.size() > 0) {  response.success = true;
				String listOfVideoIds = (String) listOfResults[0].get(LIST_FIELD_NAME);
				if (!String.isEmpty(listOfVideoIds)) { response.results.addAll(listOfVideoIds.split(','));}
			}

		} else
		{
			response.success = false;
			response.messages.add('The Video List custom field has not yet been created for this object.');
		}


		return response;
	}
}