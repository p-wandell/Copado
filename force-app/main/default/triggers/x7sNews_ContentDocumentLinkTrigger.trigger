/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

trigger x7sNews_ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) { x7sNewsDocumentLinkHelper.onBeforeInsert(Trigger.new);}
	}
}