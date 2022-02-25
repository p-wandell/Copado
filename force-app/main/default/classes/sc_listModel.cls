/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 8/4/17.
 */

// -----------------------------------------------------------
// Shopping Cart List Wrapper

public with sharing class sc_listModel {

	@AuraEnabled
	public SObject record {
		get;
		set;
	}

	@AuraEnabled
	public String userId {
		get;
		set;
	}

	@AuraEnabled
	public Decimal balance {
		get;
		set;
	}

	@AuraEnabled
	public String orderId {
		get;
		set;
	}

	@AuraEnabled
	public String orderNumber{
		get;
		set;
	}

	@AuraEnabled
	public Decimal subTotal {
		get;
		set;
	}

	@AuraEnabled
	public Boolean usePoints {
		get;
		set;
	}

	@AuraEnabled
	public Boolean enableDiscount {
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
	public List<sc_model> items {
		get;
		set;
	}

	@AuraEnabled
	public Decimal totalItems {
		get;
		set;
	}

	public sc_listModel() {
		this.userId         = null;
		this.orderId        = null;
		this.balance        = 0;
		this.orderNumber    = null;
		this.subTotal       = 0;
		this.totalItems     = 0;
		this.usePoints      = false;
		this.enableDiscount = false;
		this.pricebookId    = null;
		this.items          = new List<sc_model>();
		this.quantityList   = null;
	}

	public void dumpModel(String title) {
		System.debug('Dump sc_listModel: ' + title);
		System.debug('  model.userId       : ' + this.userId);
		System.debug('  model.orderId      : ' + this.orderId);
		System.debug('  model.balance      : ' + this.balance);
		System.debug('  model.orderNumber  : ' + this.orderNumber);
		System.debug('  model.subTotal     : ' + this.subTotal);
		System.debug('  model.usePoints    : ' + this.usePoints);
		System.debug('  model.pricebookId  : ' + this.pricebookId);
		System.debug('  model.items        : ' + this.items.size());
		System.debug('  modal.totalItems   : ' + this.totalItems);
		System.debug('  model.quantityList : ' + this.quantityList);

		if (this.items.size() > 0)
		{
			Integer count = 1;
			for(sc_model item : this.items)
			{
				item.dumpModel('item ' + count);
				count += 1;
			}
		}
	}
}