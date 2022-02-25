/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

trigger x7sFileContentDocumentTrigger on ContentDocumentLink (before insert) {
	if (Trigger.isBefore) {
		if (Trigger.isInsert) { x7sFilesContentDocumentHelper.onBeforeInsert(Trigger.new);}
	}
}