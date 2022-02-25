/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/14/17.
 */
({
    // Constants
    custom: {
        BUTTON_SUCCESS  : 'success',
        BUTTON_INVERSE  : 'inverse',
        BUTTON_BRAND    : 'brand',
        BUTTON_DELAY    : 5000
    },

    action: {
        ADD     : 'add',
        UPDATE  : 'update',
        DELETE  : 'delete',
        CLEAR   : 'clear',
        SUCCESS : 'success'
    },

    filter: {
        FAMILY  : 'family'
    },

    doCallout: function(component, method, params, hideToast, toastTitle) {
        const self = this;

        return new Promise($A.getCallback(function(resolve, reject) {
	        let action = component.get(method);

	        if (params) {
                action.setParams(params);
            }

            action.setCallback(component, function(response) {
	            let state = response.getState();

	            if (component.isValid() && state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
		            let errors = response.getError();
		            console.log(JSON.parse(JSON.stringify(errors)));

                    if (errors && errors[0] && errors[0].message && !hideToast) {
                        self.showMessage("error", toastTitle || 'Callback failed', errors[0].message);
                    } else if (!hideToast) {
                        self.showMessage("error", 'Callback failed', "Unknown Error");
                    }

                    reject(errors);
                }
            });

            $A.enqueueAction(action);
        }));
    },

	formatString: function (format) {
		let args = Array.prototype.slice.call(arguments, 1);
		return format.replace(/{(\d+)}/g, function (match, number) {
			return typeof args[number] !== 'undefined'
				? args[number]
				: match
				;
		});
	},

	findAction: function(data, target) {
    	let len = data.length;
    	let pos = 0;

    	while(pos < len) {
    		let item = data[pos];

    		if (item.name === target) {
    			return item;
		    }
		    pos++;
	    }

    	return undefined;
	},

    gotoUrl: function(component, url) {
        $A.get("e.force:navigateToURL")
            .setParams({
                'url': url,
                'isredirect': true
            }).fire();
    },

    gotoRecord: function(component, recordId) {
        $A.get("e.force:navigateToSObject")
            .setParams({
                "recordId": recordId,
                "slideDevName": "related"
            }).fire();
    },

    showMessage: function(level, title, message) {
        console.log("Message (" + level + "): " + message);

        $A.get("e.force:showToast")
            .setParams({
                "title": title,
                "message": message,
                "type": level
            }).fire();
    },

	showToast : function(component, name, title, message, variant) {
		component.find(name).showToast({
			"title"  : title,
			"message": message,
			"variant": variant | 'info'
		});
	}
});