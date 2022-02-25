/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 11/21/17.
 */

public with sharing class pc_suggestController
{
	@AuraEnabled
	public static void sendSuggestedEmail(String setting, String contactName, String contactEmail, String productId)
	{
		System.debug('Sending email to contact ' + contactName + ' for ' + productId);
		ss_settings  settings = new ss_settings(setting);

		if (settings.suggestEmail)
		{
			notifyContact(setting, contactName, contactEmail, productId, settings.usePoints);
		}
	}

	public static void notifyContact(String setting, String contactName, String contactEmail, String productId, Boolean usePoints)
	{
		pc_model     item        = pc_listController.getProductById(setting, productId);
		System.debug('notifyContact item: ' + item);
		Organization org         = [SELECT Name FROM Organization];
		String[]     toAddresses = new String[] {contactEmail};
		Decimal      unitPrice   = usePoints ? item.points : item.unitPrice;
		String       productLink = System.Url.getSalesforceBaseUrl().toExternalForm() + '/' + item.id;

		List<String> params = new String[] {
			contactName,
			item.name,
			unitPrice.format(),
			productLink,
			org.Name
		};

		String emailSubject = String.format(System.Label.ss_email_suggestSubject, params);
		String emailBody    = String.format(System.Label.ss_email_suggestBody, params);

		System.debug('email address: ' + toAddresses);
		System.debug('email subject: ' + emailSubject);
		System.debug('email body   : ' + emailBody);

		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

		email.setToAddresses(toAddresses);
		email.setSubject(emailSubject);
		email.setPlainTextBody(emailBody);

		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
	}
}