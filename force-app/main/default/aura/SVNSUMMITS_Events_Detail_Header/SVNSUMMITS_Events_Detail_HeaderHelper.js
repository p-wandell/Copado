// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	gotoUrl: function (component, url) {
		$A.get("e.force:navigateToURL")
			.setParams({
				'url': url,
				'isredirect': true
			}).fire();
	},

	debug: function(component, msg, variable) {

        var debugMode = component.get("v.debugMode");

        if(debugMode)
        {
            if(msg)
            {
            	console.log(msg);
            }

            if(variable)
            {
            	console.log(variable);
            }
        }

    }
})