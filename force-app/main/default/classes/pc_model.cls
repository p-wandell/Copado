/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/14/17.
 */

public with sharing class pc_model
{

	// -----------------------------------------------------------
	// Object wrapper

	@AuraEnabled
	public SObject record
	{
		get;
		set;
	}

	@AuraEnabled
	public String id, productId, name, description, productCode, family, priceBookId;

	@AuraEnabled
	public Decimal unitPrice, points;

	@AuraEnabled
	public List<String> imageUrl;

	@AuraEnabled
	public String externalProductUrl;

	@AuraEnabled
	public Boolean featured;

	@AuraEnabled
	public Integer sequence;

	public pc_model(PricebookEntry entry, String communityUrl, List<Id> imageIds)
	{
		this.record             = entry;
		this.id                 = entry.Id;
		this.priceBookId        = entry.Pricebook2Id;
		this.productId          = entry.Product2.Id;
		this.name               = entry.Product2.Name;
		this.description        = entry.Product2.Description;
		this.productCode        = entry.ProductCode;
		this.family             = entry.Product2.Family;
		this.unitPrice          = entry.UnitPrice;
		this.points             = entry.Product2.Points__c;
		this.externalProductUrl = entry.Product2.External_Product_URL__c;
		this.featured           = entry.Product2.Featured__c;
		this.sequence           = Integer.valueOf(entry.Product2.Sequence__c);
		this.imageUrl           = new List<String>();

		System.debug('External Image: ' + entry.Product2.External_Image_URL__c);

		if (String.isNotBlank(entry.Product2.External_Image_URL__c))
		{
			for(String imageString : entry.Product2.External_Image_URL__c.split(','))
			{
				this.imageUrl.add(imageString);
			}
		}

		// build the image URL
		if (imageIds != null && imageIds.size() > 0)
		{
			for (Id imageId : imageIds)
			{
				this.imageUrl.add(communityUrl
					+ ss_contentDocument.CHATTER_FILE_LOCATION
					+ imageId
					+ ss_contentDocument.CHATTER_FILE_PARAMS);
			}
		}
	}


	// -------------------------------------------------------------
	// Utility functions
	// -------------------------------------------------------------
	public static String getCommunityUrl()
	{
		String baseUrl = System.Url.getSalesforceBaseUrl().toExternalForm();
		System.debug('baseUrl =' + baseUrl);

		try
		{
			String url = Network.getLoginUrl(Network.getNetworkId());
			String communityUrl = url.substring(0, url.lastIndexOf('/s/'));
			System.debug('comm URL = ' + communityUrl);

			return communityUrl;
		} catch (Exception e)
		{
			System.debug('No community found');
			return baseUrl;
		}
	}

	public void dumpModel(String title)
	{
		System.debug('Dump pc_model: ' + title);
		System.debug('  id               : ' + this.id);
		System.debug('  name             : ' + this.name);
		System.debug('  productId        : ' + this.productId);
		System.debug('  priceBookId      : ' + this.priceBookId);
	}
}