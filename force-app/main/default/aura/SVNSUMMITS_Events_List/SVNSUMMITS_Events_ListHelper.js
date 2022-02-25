// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    getEventsHelper: function(component, event) {
        let self = this;
	    this.dumpEventRequest(component, 'getEventsHelper');

        // Load  Events data
        let action = component.get("c.getEventsList");
        action.setParams(this.getEventParams(component));

        action.setCallback(this, function(response) {
            let state = response.getState();

            self.debug(component, "Event_ListHelper.js - getEventsHelper() callback response state: ", state);

            let sortLabel = component.get('v.sortByLabel');
            if (component.isValid() && state === "SUCCESS") {
                self.debug(component, "Event list - Return value:", response.getReturnValue());
                let eventsListWrapper = self.parseNamespace(component, response.getReturnValue());

                //updated code to hide recommended component if no records found
                if (component.get("v.displayMode") === 'Compact') {
                    if (eventsListWrapper.objEventList.length === 0) {
                        $('.CCEVENTSLCSVNSUMMITS_Events_List').hide();
                    }
                }
                component.set("v.totalEvents", eventsListWrapper.totalResults);

                let appEvent = $A.get("e.c:SVNSUMMITS_Events_Header_Event");
                appEvent.setParams({
                    "sortByLabel": sortLabel,
                    "totalResults": eventsListWrapper.totalResults
                });
                appEvent.fire();

				component.set("v.wrappedEvents", self.updateEventsWrapper(component, eventsListWrapper));
            }
            else if (state === "ERROR") {
                self.debug(component, "problem in getEventsHelper while calling getEvents");
                self.debug(component, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

	updateEventsWrapper : function (component, eventsListWrapper) {
		eventsListWrapper.strTimeZone = this.getTimeZone(eventsListWrapper);

		let days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

		for (let i = 0; i < eventsListWrapper.objEventList.length; i++) {
		    eventsListWrapper.objEventList[i].showTo = false;

	        eventsListWrapper.objEventList[i].showEndDate = false;
		    let startDate, startTime;
		    let endDate, endTime;
		    let localeStartDate, localeEndDate;
		    let startDay, startMonth, startYear;
		    let endDay, endMonth, endYear;

			if (eventsListWrapper.objEventList[i].GroupId__c) {
				eventsListWrapper.objEventList[i].groupName = eventsListWrapper.groupIdToName[eventsListWrapper.objEventList[i].GroupId__c];
			}

	        if (eventsListWrapper.objEventList[i].Start_DateTime__c !== null) {
				if (typeof moment.tz === 'function') {
					localeStartDate = moment.tz(eventsListWrapper.objEventList[i].Start_DateTime__c, eventsListWrapper.strTimeZone).format('YYYY-MM-DD HH:mm:ss');
				} else {
					localeStartDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
				}

	            eventsListWrapper.objEventList[i].localeStartDate = localeStartDate;

	            startDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
	            startTime = moment(startDate).toDate();
	            eventsListWrapper.objEventList[i].strMinute = moment(startTime);

	            eventsListWrapper.objEventList[i].strDay = moment(startTime).format('ddd');
	        }

	        if (eventsListWrapper.objEventList[i].End_DateTime__c !== null) {
				if (typeof moment.tz === 'function') {
					localeEndDate = moment.tz(eventsListWrapper.objEventList[i].End_DateTime__c, eventsListWrapper.strTimeZone).format('YYYY-MM-DD HH:mm:ss');
				} else {
					localeEndDate = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
				}

				eventsListWrapper.objEventList[i].localeEndDate = localeEndDate;

	            endDate = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
	            endTime = moment(endDate).toDate();
	            eventsListWrapper.objEventList[i].endMinute = moment(endTime);
	        }

	        if (startTime !== null && endTime !== null) {
		        eventsListWrapper.objEventList[i].daysOfMultiDaysEvent = moment.duration((moment(endTime) - moment(startTime)), days).days();
	            eventsListWrapper.objEventList[i].showTo = true;
	        }

	        startDay   = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("DD");
	        startMonth = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("MMM");
	        startYear  = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("YYYY");

	        endDay     = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format("DD");
	        endMonth   = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format("MMM");
	        endYear    = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format("YYYY");

	        eventsListWrapper.objEventList[i].strMonth = startMonth;
	        eventsListWrapper.objEventList[i].intDate  = startDay;
            eventsListWrapper.objEventList[i].strYear  = startYear;

			if (startDay !== endDay || startMonth !== endMonth || startYear !== endYear) {
				eventsListWrapper.objEventList[i].showEndDate = true;
			    eventsListWrapper.objEventList[i].endDay      = endDay;
			    eventsListWrapper.objEventList[i].endMonth    = endMonth;
			    eventsListWrapper.objEventList[i].endYear     = endYear;
            }

		    if (eventsListWrapper.objEventList[i].Name.length > 80) {
			    eventsListWrapper.objEventList[i].Name = eventsListWrapper.objEventList[i].Name.substring(0, 77);
			    eventsListWrapper.objEventList[i].Name = eventsListWrapper.objEventList[i].Name + '...';
		    }

	        eventsListWrapper.objEventList[i].topics1 = [];
	        eventsListWrapper.objEventList[i].topics1.push(eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[i].Id]);
	        eventsListWrapper.objEventList[i].topics = [];

	        /* Logic for topics will be displayed till 27 characters only */
	        if (eventsListWrapper.objEventList[i].topics1 !== undefined) {
	            for (let j = 0; j < eventsListWrapper.objEventList[i].topics1.length; j++) {
	                let eventsname = '';
	                if (eventsListWrapper.objEventList[i].topics1[j] !== undefined) {
	                    for (let jj = 0; jj < eventsListWrapper.objEventList[i].topics1[j].length; jj++) {
	                        eventsname += eventsListWrapper.objEventList[i].topics1[j][jj].Topic.Name;
	                        if (eventsname.length <= 27 && eventsListWrapper.objEventList[i].topics !== undefined) {
	                            eventsListWrapper.objEventList[i].topics.push(eventsListWrapper.objEventList[i].topics1[j][jj]);
	                        }
	                    }
	                }
	            }
	        }

	        this.setCustomFields(component, eventsListWrapper.objEventList, i);
	    }

	    return eventsListWrapper;
    },

	getNextPage: function(component, event) {
        let self = this;
	    this.dumpEventRequest(component, 'getNextPage');

	    let action   = component.get("c.nextPageList");
	    let paramSet = this.getEventParams(component);
		paramSet.pageNumber = component.get("v.wrappedEvents").pageNumber;

	    action.setParams(paramSet);
        action.setCallback(this, function(response) {
	        let eventsListWrapper = self.parseNamespace(component, response.getReturnValue());

			component.set("v.wrappedEvents", self.updateEventsWrapper(component, eventsListWrapper));

            let pageNumberComp = self.component.find("pageNumber");
            pageNumberComp.set("v.value", eventsListWrapper.pageNumber);
        });

        $A.enqueueAction(action);
    },

    getPreviousPage: function(component, event) {
        let self   = this;
	    this.dumpEventRequest(component, 'getPreviousPage');

	    let action   = component.get("c.previousPageList");
	    let paramSet = this.getEventParams(component);
	    paramSet.pageNumber = component.get("v.wrappedEvents").pageNumber;

	    action.setParams(paramSet);
        action.setCallback(this, function(response) {
	        let eventsListWrapper = self.parseNamespace(component, response.getReturnValue());
			component.set("v.wrappedEvents", self.updateEventsWrapper(component, eventsListWrapper));

            let pageNumberComp = self.component.find("pageNumber");
            pageNumberComp.set("v.value", eventsListWrapper.pageNumber);
        });

        $A.enqueueAction(action);
    },

	getEventParams : function (component) {
		var paramSet = {
			compactMode  : component.get("v.displayMode") === 'Compact',
			recordSize   : component.get("v.numberofresults"),
			listSize     : component.get("v.listSize"),
			strFilterType: component.get("v.filterType"),
			sortBy       : component.get("v.sortBy"),
			filterByTopic: component.get("v.filterByTopic"),
			topicName    : component.get("v.topicValue"),
			searchTerm   : component.get("v.searchstr"),
			filterOn     : component.get("v.filterOn"),
			fromDate     : component.get("v.fromDate"),
			toDate       : component.get("v.toDate"),
			listViewMode : component.get("v.listViewMode"),
			customFields : this.getCustomFields(component),
			filters      : this.getFilterString(component)
		};

		return paramSet;
	},

	getFilterString: function (component) {
    	let filterString = this.getHiddenFilters(component);

        let typeFilter = component.get('v.eventTypeFilter');

        if (typeFilter) {
        	filterString += this.events.fields.eventType;
        	filterString += this.custom.SEARCH_FIELD;
        	filterString += typeFilter;
        	filterString += this.custom.SEARCH_SEPARATOR;
        }

        let locationFilter = component.get('v.locationFilter');

        if (locationFilter) {
        	filterString += this.events.fields.location;
	        filterString += this.custom.SEARCH_FIELD;
	        filterString += locationFilter;
	        filterString += this.custom.SEARCH_SEPARATOR;
        }

        let customFilter = component.get('v.customFilter');

        if (customFilter) {
        	filterString += customFilter;
        }

        return filterString;
	},

	getHiddenFilters: function (component) {
		let filterString = '';

		for (let pos=1; pos <= this.custom.MAX_FIELDS; pos++) {
			let customField = component.get('v.hiddenFilter'+pos);
			if (customField.length) {
				let customSearch = component.get('v.hiddenValue'+pos);

				if (customSearch.length) {
					filterString += customField + ':' + customSearch + ';';
				}
			}
		}

		return filterString;
	},

	// adjust for guest user
    getTimeZone : function(eventsListWrapper) {
        return !eventsListWrapper.strTimeZone || eventsListWrapper.strTimeZone === 'GMT'
            ? moment.tz.guess()
			: eventsListWrapper.strTimeZone;
    },

	dumpEventRequest : function (component, heading) {
		let debugMode = component.get("v.debugMode");
		if (debugMode) {
			console.log(heading);

			console.log('   	compactMode  :' + component.get("v.displayMode") === 'Compact' ?
				'    compactMode  :true' : '    compactMode  :false');
			console.log('   	recordSize   :' + component.get("v.numberofresults"));
			console.log('   	listSize     :' + component.get("v.listSize"));
			console.log('   	strFilterType:' + component.get("v.filterType"));
			console.log('   	sortBy       :' + component.get("v.sortBy"));
			console.log('   	filterByTopic:' + component.get("v.filterByTopic"));
			console.log('   	topicValue   :' + component.get("v.topicValue"));
			console.log('   	searchTerm   :' + component.get("v.searchstr"));
			console.log('   	filterOn     :' + component.get("v.filterOn"));
			console.log('   	fromDate     :' + component.get("v.fromDate"));
			console.log('   	toDate       :' + component.get("v.toDate"));
			console.log('   	listViewMode :' + component.get("v.listViewMode"));
			console.log('   	customFields :' + this.getCustomFields(component));
			console.log('   	filters      :' + this.getFilterString(component));
		}
	},

	gotoUrl: function (component, url) {
		$A.get("e.force:navigateToURL")
			.setParams({
				'url': url,
				'isredirect': true
			}).fire();
	},

	getSitePrefix: function (component) {
		let action = component.get("c.getSitePrefix");

		action.setCallback(this, function(response) {
			let sitePath = response.getReturnValue();
			let position = sitePath.lastIndexOf('/s');

			component.set("v.sitePrefix", sitePath.substring(0, position));
		});
		$A.enqueueAction(action);
	}
});