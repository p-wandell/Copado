// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    // Method called on scripts load
	doInit : function(component, event, helper) {
		let a = component.get('c.selectSortBy');
		$A.enqueueAction(a);

		let b = component.get('c.selectGroupType');
		$A.enqueueAction(b);
	},

	onFilterMyGroups: function (component, event, helper) {
		let myGroups = component.get('v.filterMyGroups');
		let appEvent = $A.get("e.c:SVNSUMMITS_Groups_Filters_Event");

		appEvent.setParams({
			"searchMyGroups" : myGroups ? 'My Groups' : ''
		});

		if(component.get("v.isSearchText")){
			appEvent.setParams({
				"searchString" : component.get("v.searchString"),
			});
		}

		appEvent.fire();
	},

    //Method to sort groups
    sortByMyGroups : function(component, event, helper) {

        let cmpTarget = component.find('checkImg');

        let appEvent = $A.get("e.c:SVNSUMMITS_Groups_Filters_Event");

        if(cmpTarget.elements[0].className === 'showImg tickSymbol' || cmpTarget.elements[0].className === 'tickSymbol showImg'){
            $A.util.removeClass(cmpTarget, 'showImg');
        	$A.util.addClass(cmpTarget, 'hideImg');

            component.set("v.filterMyGroups",false);
            appEvent.setParams({
                "searchMyGroups" : ''
            });

            if(component.get("v.isSearchText")){
                appEvent.setParams({
                    "searchString" : component.get("v.searchString"),
                });
            }
        } else {
            $A.util.removeClass(cmpTarget, 'hideImg');
        	$A.util.addClass(cmpTarget, 'showImg');

            component.set("v.filterMyGroups",true);

            appEvent.setParams({
                "searchMyGroups" : component.find("myGrps").get("v.value"),
            });

            if(component.get("v.isSearchText")){
                appEvent.setParams({
                    "searchString" : component.get("v.searchString"),
                });
            }
        }

        appEvent.fire();
    },

	// Method to select sort by method
	selectSortBy : function(component, event, helper) {
	   let appEvent = $A.get("e.c:SVNSUMMITS_Groups_SortBy_Event");
		appEvent.setParams({
			"sortBy" : component.find("headerSort").get("v.value"),
		});
		appEvent.fire();
	},

	// Method to select group type
	selectGroupType : function(component, event, helper) {
		let appEvent = $A.get("e.c:SVNSUMMITS_Groups_Type_Event");
		appEvent.setParams({
			"groupType" : component.find("headerType").get("v.value"),
		});
		appEvent.fire();
	}
});