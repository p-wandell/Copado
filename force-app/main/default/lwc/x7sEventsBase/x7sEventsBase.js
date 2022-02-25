/*
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

const custom = {
    EVENT_OBJ           : 'Event__c',
    MAX_FIELDS          :  3,
    SEARCH_SEPARATOR    : ';',
    FIELD_SEPARATOR     : ',',
    SEARCH_FIELD        : ':',
    DATE_FORMAT         : 'YYYY-MM-DD',
    DATE_LONG_FORMAT    : 'YYYY-MM-DD HH:mm:ss',
    DATE_DAY_FORMAT     : 'dd',
    DATE_MONTH_FORMAT   : 'MMM',
    DATE_YEAR_FORMAT    : 'yyyy',
    MAX_FILE_SIZE       : 4500000, //4500000 Max file size 4.5 MB
    DELAY               : 1000,
    MAX_SUMMARY_LENGTH  : 500,       // Max characters recommended for Add To Calendar ICS file
    ATTACHMENT_PATH     : '/servlet/servlet.FileDownload?file=',

};

const events = {
    fields : {
        location:  'Location_Name__c',
        eventType: 'Event_Type__c'
    },
    listViewMode : {
        list     : 'List',
        calendar : 'Calendar',
        tile	 : 'Tile'
    }
};

const session = {
    viewState   : 'X7S_VIEW_STATE',
    calendarView: 'X7S_CAL_VIEW',
    listView    : 'X7S_LST_VIEW',
    tileView    : 'X7S_TILE_VIEW'
};

const constants = {
    // LEX Edit Navigation State parameters (c__ is required for LEX)
    editLex: {
        id           : 'c__eventId',
        editMode     : 'c__isEdit',
        limitGroups  : 'c__limitToSpecificGroups',
        requireTopics: 'c__editsRequireTopics'
    },

    // Community Edit Navigation State parameters
    editComm: {
        id           : 'eventId',
        editMode     : 'isEdit',
        limitGroups  : 'limitToSpecificGroups',
        requireTopics: 'editsRequireTopics'
    },

    imageTypes: {
		EXTERNAL_URL 	: 'External URL',
		RELATED_FILES	: 'Related File',
		STATIC_RESOURCE	: 'Static Resource',
		ATTACHMENT		: 'Attachment',
		CMS_CONTENT		: 'CMS Content',
		NONE			: 'None'
	}
};

const viewStateIsCalendar = () => {
    return events.listViewMode.calendar === retrieveViewState();
};

const viewStateIsList = () => {
    return events.listViewMode.list === retrieveViewState();
};

const viewStateIsTile = () => {
    return events.listViewMode.tile === retrieveViewState();
};

const retrieveViewState = () => {
    return getViewState();
};

const getViewState = () => {
    let viewState = sessionStorage.getItem(session.viewState) || '';
    return viewState ? viewState : events.listViewMode.list;
};

const saveViewState = (state) => {
    sessionStorage.setItem(session.viewState, state);
};

const updateEventItem = (eventItem) => {
    //Date Formatting
    let startDate = new Date(eventItem.All_Day_Event__c ? eventItem.All_Day_Start__c : eventItem.Start_DateTime__c);
    let startDay = startDate.getDate();
    let startMonth = startDate.toLocaleString('default', {month: 'short'});
    let startYear = startDate.getFullYear();
    
    let endDate = new Date(eventItem.All_Day_Event__c ? eventItem.All_Day_End__c : eventItem.End_DateTime__c);
    let endDay = endDate.getDate();
    let endMonth = endDate.toLocaleString('default', {month: 'short'});
    let endYear = endDate.getFullYear();
    
    eventItem.localeStartDate = eventItem.All_Day_Event__c ? eventItem.All_Day_Start__c : eventItem.Start_DateTime__c;
    eventItem.localeEndDate = eventItem.All_Day_Event__c ? eventItem.All_Day_End__c : eventItem.End_DateTime__c;
    
    eventItem.showTo = endDate && endDate !== startDate;
    eventItem.showEndDate = startDay !== endDay || startMonth !== endMonth || startYear !== endYear;
    eventItem.showStartYear = endYear !== startYear;
    
    // date only portion of the DateTime fields
    eventItem.startDate = startDate.getFullYear() + '-' + startDate.getMonth() + '-' + startDate.getDate();
    eventItem.endDate = endDate.getFullYear() + '-' + endDate.getMonth() + '-' + endDate.getDate();
    
    if (eventItem.Name.length > 80) {
        eventItem.Name = eventItem.Name.substring(0, 77);
        eventItem.Name = eventItem.Name + '...';
    }
    
    return eventItem;
};

export {constants, custom, events , session , saveViewState , viewStateIsCalendar , viewStateIsList , viewStateIsTile, updateEventItem};