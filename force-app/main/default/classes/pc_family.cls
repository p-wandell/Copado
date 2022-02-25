/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/21/17.
 */

public with sharing class pc_family
{
	@AuraEnabled
	public String name, imageUrl;

	public pc_family(String familyName, String familyImageUrl)
	{
		this.name     = familyName;
		this.imageUrl = familyImageUrl;
	}
}