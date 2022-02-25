// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {

        //Fetch search string from url
        var url = window.location.href;
        component.set("v.currentURL",encodeURIComponent(url));

        var topicValue = url.split("/").pop();

        topicValue = decodeURIComponent(topicValue);
        topicValue = topicValue.replace(/#/g , "");
        component.set("v.searchstr",topicValue);

        //fetch news
        helper.getEventList(component);
    },
})