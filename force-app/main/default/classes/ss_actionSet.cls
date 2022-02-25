/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/17/18.
 */

public with sharing class ss_actionSet
{
	@AuraEnabled
	public String name, label, title, iconName;

	@AuraEnabled
	public List<ss_actionModel> items;


	public ss_actionSet()
	{
		name        = '';
		label       = '';
		title       = '';
		iconName    = '';
		items       = new List<ss_actionModel>();
	}

	public void Dump(String message)
	{
		System.debug('Dump action set  : ' + message);
		System.debug('  name            : ' + name);
		System.debug('  label           : ' + label);
		System.debug('  title           : ' + title);
		System.debug('  icon            : ' + iconName);

		if (items != null)
		{
			Integer count = 0;
			for(ss_actionModel item : items)
			{
				item.Dump('item ' + ++count);
			}
		}
	}
}