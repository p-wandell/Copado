/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/18/17.
 */

public with sharing class ss_settings
{
	private final String    DEFAULT_NAME        = 'Default';
	private final String    SETTINGS_NAME       = 'SS_Product_Settings__mdt';
	private final String    SETTINGS_ACTION     = 'SS_Product_Action__mdt';
	private final String    SETTINGS_ACTION_SET = 'SS_Product_Action_Set__mdt';

	private final Integer   MAX_ACTIONS   = 5;

	static final String FIELD_SEPARATOR   = ',';
	static final String QUANTITY_DEFAULTS = '1,2,3,4,5,6,7,8,9,10,20,30,50,100';

	@AuraEnabled
	public Boolean hideAddToCart {
		get;
		private set;
	}

	@AuraEnabled
	public Boolean hideImages {
		get;
		private set;
	}

	@AuraEnabled
	public Boolean hideUnitPrice {
		get;
		set;
	}

	@AuraEnabled
	public Boolean usePoints {
		get;
		private set;
	}

	@AuraEnabled
	public Boolean enableDiscount {
		get;
		private set;
	}

	@AuraEnabled
	public String pricebookId {
		get;
		private set;
	}

	@AuraEnabled
	public String accountId {
		get;
		private set;
	}

	@AuraEnabled
	public Boolean suggestEmail {
		get;
		private set;
	}

	@AuraEnabled
	public List<String> familyIds {
		get;
		private set;
	}

	@AuraEnabled
	public List<String> quantityList {
		get;
		private set;
	}

	@AuraEnabled
	public ss_actionSet actionSet {
		get;
		private set;
	}

	public ss_settings() {
		getCustomSettings('Default');
	}

	public ss_settings(String name)
	{
		getCustomSettings(String.isBlank(name) ? DEFAULT_NAME : name);
	}

	public ss_settings(String accountId, Boolean usePoints, String priceBookId) {
		this.accountId      = accountId;
		this.hideAddToCart  = false;
		this.hideImages     = false;
		this.hideUnitPrice  = false;
		this.pricebookId    = priceBookId;
		this.usePoints      = usePoints;
		this.enableDiscount = false;
		this.suggestEmail   = false;
		this.familyIds      = null;
		this.quantityList   = null;
	}

	private void getCustomSettings(String name) {
		String query = ss_util_metadata.buildQuery(SETTINGS_NAME, '') + ' WHERE DeveloperName = \'' + name + '\'';

		try
		{
			SS_Product_Settings__mdt  settings = (SS_Product_Settings__mdt) Database.query(query);

			if (settings != null)
			{
				getSettings(settings);
			}
		}
		catch (QueryException ex)
		{
			System.debug('Settings not found for ' + name);
		}
	}

	private void getSettings(SS_Product_Settings__mdt  settings)
	{
		this.accountId      = settings.Account_Id__c;
		this.hideAddToCart  = settings.Hide_Add_to_Cart__c;
		this.hideImages     = settings.Hide_Images__c;
		this.hideUnitPrice  = settings.Hide_Unit_Price__c;
		this.pricebookId    = settings.Pricebook_Id__c;
		this.usePoints      = settings.Use_Points__c;
		this.enableDiscount = settings.Enable_Discount__c;
		this.suggestEmail   = settings.Suggest_Email__c;
		this.familyIds      = String.isNotBlank(settings.Product_Family_List_IDs__c) ? settings.Product_Family_List_IDs__c.split(FIELD_SEPARATOR) : new List<String>();
		this.quantityList   = String.isNotBlank(settings.Quantity_List__c) ? settings.Quantity_List__c.split(FIELD_SEPARATOR) : QUANTITY_DEFAULTS.split(FIELD_SEPARATOR);

		if (settings.Action_Set__c != null)
		{
			this.actionSet      = new ss_actionSet();

			String actionSetQuery = ss_util_metadata.buildQuery(SETTINGS_ACTION_SET, '');
			actionSetQuery       += ' WHERE Id = \'' + settings.Action_Set__c + '\' LIMIT 1';

			SS_Product_Action_Set__mdt actionSet = (SS_Product_Action_Set__mdt)Database.query(actionSetQuery);

			this.actionSet.label    = actionSet.Label;
			this.actionSet.title    = actionSet.Title__c;
			this.actionSet.iconName = actionSet.iconName__c;

			for(Integer actionCount = 1; actionCount <= MAX_ACTIONS; ++actionCount)
			{
				String actionName = 'Action_' + actionCount + '__c';
				Id     actionId   = (Id) actionSet.get(actionName);

				if (actionId != null)
				{
					String actionQuery = ss_util_metadata.buildQuery(SETTINGS_ACTION, '');
					actionQuery += ' WHERE Id =\'' + actionId + '\' LIMIT 1';

					SS_Product_Action__mdt actionItem = (SS_Product_Action__mdt)Database.query(actionQuery);

					if (actionItem != null)
					{
						this.actionSet.items.add(setActionModel(actionItem));
					}
				}
			}
		}
	}

	private static ss_actionModel setActionModel(SS_Product_Action__mdt actionItem)
	{
		ss_actionModel model = new ss_actionModel();

		model.name          = actionItem.DeveloperName;
		model.label         = actionItem.Label;
		model.actionType    = actionItem.Action_Type__c;
		model.actionValue   = actionItem.Action_Value__c;
		model.title         = actionItem.Action_Title__c;
		model.newWindow     = actionItem.New_Window__c;

		return model;
	}
}