/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/20/18.
 */

public class pc_contentDocumentLInkTriggerHandler
{
	public static void onBeforeInsert(List<ContentDocumentLink> listOfContentDocLinks)
	{
		System.debug('pc_contentDocumentLInkTriggerHandler');

		for (ContentDocumentLink cdl : listOfContentDocLinks)
		{
			System.debug('cdl before id: ' + cdl.LinkedEntityId + ' visibility: '  + cdl.Visibility);

			if (cdl.LinkedEntityId.getSobjectType() == Product2.SObjectType)
			{
				cdl.Visibility = 'AllUsers';
			}
			System.debug('cdl after id: ' + cdl.LinkedEntityId + ' visibility: '  + cdl.Visibility);
		}
	}
}