/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/15/17.
 */

public with sharing class pc_listModel {

	@AuraEnabled
	public List<pc_model> items {
		get;
		set;
	}

	@AuraEnabled
	public Decimal total {
		get;
		set;
	}

	@AuraEnabled
	public Decimal pageCount {
		get;
		set;
	}

	@AuraEnabled
	public Decimal pageSize {
		get;
		set;
	}

	@AuraEnabled
	public Decimal pageCurrent {
		get;
		set;
	}

	@AuraEnabled
	public Boolean pageHasNext {
		get;
		set;
	}

	@AuraEnabled
	public Boolean pageHasPrevious {
		get;
		set;
	}

	@AuraEnabled
	public Boolean usePoints {
		get;
		set;
	}

	@AuraEnabled
	public Boolean hideImages {
		get;
		set;
	}

	@AuraEnabled
	public Boolean hideAddToCart {
		get;
		set;
	}

	@AuraEnabled
	public Boolean hideUnitPrice {
		get;
		set;
	}

	@AuraEnabled
	public String pricebookId {
		get;
		set;
	}

	@AuraEnabled
	public List<String> quantityList {
		get;
		set;
	}

	@AuraEnabled
	public ss_actionSet actionSet
	{
		get;
		set;
	}

	public pc_listModel() {
		this.items           = new List<pc_model>();
		this.total           = 0;
		this.pageCount       = 0;
		this.pageSize        = 0;
		this.pageCurrent     = 0;
		this.pageHasNext     = false;
		this.pageHasPrevious = false;
		this.usePoints       = false;
		this.hideImages      = false;
		this.hideAddToCart   = false;
		this.hideUnitPrice   = false;
		this.pricebookId     = '';
		this.quantityList    = null;
	}

	public pc_model getItemByProductId(String id)
	{
		for (pc_model item : this.items)
		{
			if (item.productId.startsWith(id))
			{
				return item;
			}
		}

		return null;
	}

	public void dumpModel(String title) {
		System.debug('Dump pc_listModel: ' + title);
		System.debug('  model.total        : ' + this.total);
		System.debug('  model.pageCount    : ' + this.pageCount);
		System.debug('  model.pageSize     : ' + this.pageSize);
		System.debug('  model.pageCurrent  : ' + this.pageCurrent);
		System.debug('  model.hasNext      : ' + this.pageHasNext);
		System.debug('  model.hasPrevious  : ' + this.pageHasPrevious);
		System.debug('  model.usePoints    : ' + this.usePoints);
		System.debug('  model.items        : ' + this.items.size());
		System.debug('  model.quantityList : ' + this.quantityList);

		if (items.size() > 0)
		{
			Integer count = 1;

			for(pc_model item: this.items)
			{
				item.dumpModel('item ' + count);
				count += 1;
			}
		}
	}
}