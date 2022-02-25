// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    // Method called to scroll the calendar scroll
    calenderScroll : function(component,event) {
        // vertical scroll position is the same as the number of pixels that are hidden from
        // view above the scrollable area. Setting the scrollTop positions the vertical scroll of
        // each matched element.
        //if(component.get("v.isRender")) {
        var scrollSize = 400;
        $('#stDate').click(function(e) {
            if($(window).scrollTop() > scrollSize)
            $(window).scrollTop(0);
        });
        $('#endDt').click(function(e){
            if($(window).scrollTop() > scrollSize) {
                $(window).scrollTop(0);
            }
        });
        //}
    },

	setDates: function (component) {
		var appEvent = $A.get("e.c:SVNSUMMITS_Events_Date_Filter_Event");

		appEvent.setParams({
			fromDate: component.get('v.fromDt'),
			toDate  : component.get('v.toDt')
		});
		appEvent.fire();

		if (component.get('v.listViewMode') === 'Calendar') {
			component.set('v.fromDt', '');
		}
	}
});