/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/17/18.
 */

public with sharing class ss_actionModel
{
	@AuraEnabled
	public String name, label, actionValue, actionType, title;

	@AuraEnabled
	public Boolean newWindow;

	public ss_actionModel()
	{
		name        = '';
		label       = '';
		actionValue = '';
		actionType  = '';
		title = '';
		newWindow   = false;
	}

	public void Dump(String title)
	{
		System.debug('Dump action mode  : ' + title);
		System.debug('  name            : ' + name);
		System.debug('  label           : ' + label);
		System.debug('  type            : ' + actionType);
		System.debug('  value           : ' + actionValue);
		System.debug('  tooltip         : ' + title);
		System.debug('  newWindow       : ' + newWindow);
	}
}