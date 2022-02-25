/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/6/18.
 */

public with sharing class SS_VG_Response
{
	// success or failure
	@AuraEnabled public Boolean success { get; set; }
	// messages to display
	@AuraEnabled public List<String> messages { get; set; }
	// results to iterate over - use this when querying SOjbects directoy@AuraEnabled public List<Peak_ContentObject> peakResults{get;set;} // custom results to iterate over - use this when creating a list of custom wrapper classes
	@AuraEnabled public List<Object> results { get; set; }

	public SS_VG_Response()
	{
		success  = true;
		messages = new List<String>();
		results  = new List<Object>();
	}
}