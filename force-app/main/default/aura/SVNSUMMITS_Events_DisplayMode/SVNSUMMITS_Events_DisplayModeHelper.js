// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	setListButtonActive: function (component) {
		$A.util.removeClass(component.find('calendarBTN'), 'btnActive');
		$A.util.addClass(component.find('listBTN'), 'btnActive');
		$A.util.removeClass(component.find('tileBTN'), 'btnActive');
	},

	setTileButtonActive: function (component) {
		$A.util.removeClass(component.find('calendarBTN'), 'btnActive');
		$A.util.removeClass(component.find('listBTN'), 'btnActive');
		$A.util.addClass(component.find('tileBTN'), 'btnActive');
	},

	setCalendarButtonActive: function (component) {
		$A.util.addClass(component.find('calendarBTN'), 'btnActive');
		$A.util.removeClass(component.find('listBTN'), 'btnActive');
		$A.util.removeClass(component.find('tileBTN'), 'btnActive');
	}
})