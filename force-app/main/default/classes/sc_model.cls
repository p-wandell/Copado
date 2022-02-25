/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 8/4/17.
 */

// -----------------------------------------------------------
// Shopping Cart Object Wrapper

public with sharing class sc_model {

	@AuraEnabled
	public SObject record {
		get;
		set;
	}

	@AuraEnabled
	public String id, productId, externalUrl, name, family, productCode, imageUrl;

	@AuraEnabled
	public Decimal quantity, unitPrice, unitTotal;

	public sc_model(OrderItem item, String communityUrl, Id imageId) {
		this.record      = item;
		this.id          = item.Id;
		this.productId   = item.Product2Id;
		this.quantity    = item.Quantity;
		this.unitPrice   = item.UnitPrice;
		this.name        = item.Product2.Name;
		this.productCode = item.Product2.ProductCode;
		this.family      = item.Product2.Family;
		this.unitTotal   = quantity * unitPrice;
		this.externalUrl = item.Product2.External_Image_URL__c;

		if (imageId != null && String.isNotBlank(communityUrl)) {
			this.imageUrl = communityUrl + ss_contentDocument.CHATTER_FILE_LOCATION + imageId + ss_contentDocument.CHATTER_FILE_PARAMS;
			System.debug('imageUrl = ' + this.imageUrl);
		}
	}

	public sc_model()
	{
		this.record = null;
	}

	public void dumpModel(String title)
	{
		System.debug('Dump sc_model: ' + title);
		System.debug('  Id      : ' + this.id);
		System.debug('  Prod Id : ' + this.productId);
		System.debug('  Name    : ' + this.name);
		System.debug('  qty     : ' + this.quantity);
	}
}