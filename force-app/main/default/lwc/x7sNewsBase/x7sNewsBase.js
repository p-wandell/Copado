/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

const constants = {
	custom: {
		ATTACHMENT_PATH : '/servlet/servlet.FileDownload?file=',
		FIELD_SEPARATOR : ",",
		MAX_FILE_SIZE   : 4500000 //Max file size 4.5 MB
	},
	// LEX Edit  Navigation State parameters (c__ is required for LEX)
	edit: {
		id              : 'c__newsId',
		editMode        : 'c__isEdit',
		showSource      : 'c__allowShowSource',
		limitGroups     : 'c__limitToSpecificGroups',
		requireTopics   : 'c__editsRequireTopics'
	}
};

export {constants}