/*
 * Copyright (c) 2020. 7Summits Inc.
 */

trigger x7sIdeasContentDocumentLinkTrigger on ContentDocumentLink (before insert) {

	if (Trigger.isBefore) {
		if (Trigger.isInsert) {
			x7sIdeasContentDocumentLinkHelper.onBeforeInsert(Trigger.new);
		}
	}
}