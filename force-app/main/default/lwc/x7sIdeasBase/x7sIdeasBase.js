/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {inLex, inLexMode} from 'c/x7sShrUtils';
import getModel from '@salesforce/apex/x7sIdeasBaseController.getModel';

const custom = {
    layout : {
        LIST        : 'List View',
        GRID        : 'Tile View'
    },
    urlParams: {
        edit        : 'c__edit',
        recordId    : 'recordId',
        lexPrefix   : '/lightning/n/',
        lexRecordId : 'c__ideaId', // the c__ namespace prefix is vital for this to work.
	    lexEditMode : 'c__isEdit',
        view        : '/view'
    },
    profileUrl : {
        lex         : '/lightning/r/User/',
        view        : '/view',
        community   : '/profile/'
    },
    topicUrl : {
        lex         : '/lightning/r/Topic/',
        view        : 'view',
        community   : '/topic/'
    },
    VOTE_STATUS_DELIMITER : ',',
    MAX_FILE_SIZE   : 4500000, //Max file size 4.5 MB
    CHUNK_SIZE      : 750000,   //Chunk Max size 750Kb
    customFields: {
        fieldTypeText  : 'Text',
        fieldTypeRich  : 'Richtext',
        fieldTypeMulti : 'Mulitline'
    },
	MAX_RELATED_FILES  : 20
	
};

const action = {
	EDIT	 : 'edit',
	DELETE	 : 'delete',
	VOTEUP	 : 'voteUp',
	VOTEDOWN : 'voteDown',
	VOTEDELETE : 'voteDelete'
}

const baseModalNamespace = () => {
	let baseModel;
	getModel()
		.then(result => {
			baseModel = result;
			return baseModel;
		})
		.catch(error => {
			console.error("Error occurred getting base model:" + error);
			return undefined;
		})
};

const parseNamespace = (baseModel, obj) => {
	let model = baseModel ? JSON.parse(baseModel) : {};
	if (model) {
		if (model.namespacePrefix) {
			for (let k in obj) {
				if (typeof obj[k] === "object" && obj[k] !== null) {
					parseNamespace(model, obj[k]);
				}
				if (k.indexOf(model.namespacePrefix + '__') >= 0) {
					let withoutNamespace = k.replace(model.namespacePrefix + '__', '');
					obj[withoutNamespace] = obj[k];
				}
			}
		}
	}
	return obj;
};

const setNamespace = (baseModel, obj) => {
	let model = baseModel ? JSON.parse(baseModel) : {};
	if (model) {
		if (model.namespacePrefix) {
			for (let k in obj) {
				if (typeof obj[k] === "object" && obj[k] !== null) {
					setNamespace(model, obj[k]);
				}
				if (k.indexOf(model.namespacePrefix + '__') >= 0) {
					let withoutNamespace = k.replace(model.namespacePrefix + '__', '');
					if (obj[withoutNamespace]) {
						obj[k] = obj[withoutNamespace];
						delete obj[withoutNamespace];
					}
				} else if (k.indexOf('__c') >= 0) {
					obj[model.namespacePrefix + '__' + k] = obj[k];
					delete obj[k];
				}
			}
		}
	}
	return obj;
};

const getHtmlPlainText = (htmlString) => {
	return htmlString.replace(/<[^>]+>/g, '');
};

const updateIdeaValues = (idea, topicMap, sitePath, sortBy, voteDisableStatus, pageRef) => {
	if (idea) {
		//if (idea.Categories) {
		//    idea.Categories = idea.Categories.split(";");
		//}
		
		idea.fromNow = idea.CreatedDate;
		idea.submitDate = idea.CreatedDate;
		idea.enableVote = true;
		
		if (voteDisableStatus)
			idea.enableVote = enableVoting(idea.Status, voteDisableStatus);
		
		if (topicMap) {
			idea.topicName = idea.Related_Topic_Name__c;
			
			let topicId = topicMap[idea.topicName];
			
			if (idea.Related_Topic_Name__c) {
				let pageInLexMode = pageRef && inLex(pageRef);
				if (topicId) {
					idea.topicLink = pageInLexMode ? custom.topicUrl.lex : (sitePath + custom.topicUrl.community);
					idea.topicLink += topicId;
					idea.topicLink += "/";
					idea.topicLink += pageInLexMode ? custom.topicUrl.view : encodeURIComponent(idea.topicName);
				} else {
					idea.topicLink = '#';
				}
			}
		}
		if (sortBy && sortBy === "Recent Comments") {
			idea.LastComment.fromNow = idea.LastComment.CreatedDate;
		}
	}
	return idea;
};

const enableVoting = (ideaStatus, voteDisableStatusList) => {
	let enableVote = true;
	
	if (voteDisableStatusList) {
		let statusList = voteDisableStatusList.split(custom.VOTE_STATUS_DELIMITER);
		if (statusList.includes(ideaStatus)) {
			enableVote = false;
		}
	}
	
	return enableVote;
}

// VOTING
const enableVote = (settings) => {
	return settings.disableReadOnlyUsers ? settings.isAuthenticated && settings.canCreateNew : true;
};

const enableSubscribe = (settings) => {
	return settings.disableReadOnlyUsers ? settings.isAuthenticated && settings.canCreateNew : true;
};

const enableCommenting = (settings) => {
	return settings.disableReadOnlyUsers ? settings.isAuthenticated && settings.canCreateNew : true;
};

const getURLParam = () => {
	let query = location.search.substr(1);
	let result = {};
	
	query.split("&").forEach(part => {
		let items = part.split("=");
		
		// replace string concatenation + character before decodeURI to preserve real '+' characters
		if (items.length > 1) {
			result[items[0]] = decodeURIComponent(items[1].replace(/\+/g, '%20'));
		}
	});
	
	return result;
};

const getRecordIdFromURL = () => {
	let search = getURLParam();
	let recordId = '';
	
	if (search && search[custom.urlParams.lexRecordId]) {
		recordId = search[custom.urlParams.lexRecordId];
	}
	return recordId;
};

export {
	custom,
	baseModalNamespace,
	parseNamespace,
	setNamespace,
	enableVote,
	getHtmlPlainText,
	enableSubscribe,
	enableCommenting,
	updateIdeaValues,
	getRecordIdFromURL,
	getURLParam,
	action
}