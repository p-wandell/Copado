// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    fetchFeaturedFourEvents : function(component,event) {
        var self = this;

        var action = component.get("c.getFeaturedEvents");
        action.setParams({
            recordId1: component.get("v.recordId1"),
            recordId2: component.get("v.recordId2"),
            recordId3: component.get("v.recordId3"),
            recordId4: component.get("v.recordId4"),
            recordId5: component.get("v.recordId5")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var eventsListWrapper  = this.parseNamespace(component, response.getReturnValue());

	            eventsListWrapper.strTimeZone = self.getTimeZone(eventsListWrapper);

                for (var i=0; i< eventsListWrapper.objEventList.length; i++) {
                    eventsListWrapper.objEventList[i].showTo = false;
					eventsListWrapper.objEventList[i].showEndDate = false;

                    var startDate;var startTime ;var endDate;var endTime;
                    var startDay, startMonth, startYear;
                    var endDay, endMonth, endYear;

                    if (eventsListWrapper.objEventList[i].Start_DateTime__c !== null) {
                        startDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
                        startTime = moment(startDate).toDate();
                        eventsListWrapper.objEventList[i].strMinute = moment(startTime);//.format('HH:mm A');
                        var days = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
                        eventsListWrapper.objEventList[i].strDay = moment(startTime).format('ddd');
                    }

                    if (eventsListWrapper.objEventList[i].End_DateTime__c !== null) {
                        endDate = moment(eventsListWrapper.objEventList[i].End_DateTime__c).format('YYYY-MM-DD HH:mm:ss');
                        endTime = moment(endDate).toDate();
                        eventsListWrapper.objEventList[i].endMinute = moment(endTime);//.format('HH:mm A');
                    }

                    if (startTime !== null && endTime !== null) {
                        var diffDays = Math.round(Math.abs((endTime.getTime() - startTime.getTime())/(24*60*60*1000)));
                        eventsListWrapper.objEventList[i].daysOfMultiDaysEvent = diffDays;
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
					    eventsListWrapper.objEventList[i].endDay = endDay;
					    eventsListWrapper.objEventList[i].endMonth = endMonth;
					    eventsListWrapper.objEventList[i].endYear = endYear;
		            }

                    eventsListWrapper.objEventList[i].strMonth = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("MMM");
                    eventsListWrapper.objEventList[i].intDate = moment(eventsListWrapper.objEventList[i].Start_DateTime__c).format("DD");

                    if (eventsListWrapper.objEventList[i].Name.length > 40) {
                        eventsListWrapper.objEventList[i].Name = eventsListWrapper.objEventList[i].Name.substring(0,37);
                        eventsListWrapper.objEventList[i].Name = eventsListWrapper.objEventList[i].Name + '...';
                    }

                    eventsListWrapper.objEventList[i].topics1 = [];
                    eventsListWrapper.objEventList[i].topics1.push(eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[i].Id]);
                    eventsListWrapper.objEventList[i].topics = [];

                    /* Logic for topics will be displayed till 27 characters only */
                    if (eventsListWrapper.objEventList[i].topics1 !== undefined) {
                        for (var j=0; j< eventsListWrapper.objEventList[i].topics1.length; j++) {
                            var eventsname='';
                            if (eventsListWrapper.objEventList[i].topics1[j] !== undefined) {
                                for (var jj=0; jj < eventsListWrapper.objEventList[i].topics1[j].length; jj++) {
                                    eventsname += eventsListWrapper.objEventList[i].topics1[j][jj].Topic.Name;
                                    if (eventsname.length <= 27) {
                                        eventsListWrapper.objEventList[i].topics.push(eventsListWrapper.objEventList[i].topics1[j][jj]);
                                    }
                                }
                            }
                        }
                    }
                }

                component.set("v.wrappedEventsObj", eventsListWrapper);
            }
        });
        $A.enqueueAction(action);
    },

    get_SitePrefix : function(component) {
        var action = component.get("c.getSitePrefix");
        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);
            component.set("v.sitePrefix", sitePath.replace("/s",""));
        });
        $A.enqueueAction(action);

        var action1 = component.get("c.isObjectCreatable");
        action1.setCallback(this, function(actionResult1) {
            var isObjectCreatable = actionResult1.getReturnValue();
            component.set("v.isObjectCreatable", isObjectCreatable);
        });
        $A.enqueueAction(action1);
    },

	// adjust for guest user
    getTimeZone : function(eventsListWrapper) {
        return !eventsListWrapper.strTimeZone || eventsListWrapper.strTimeZone === 'GMT'
            ? moment.tz.guess()
			: eventsListWrapper.strTimeZone;
    },

    debug: function(component, msg, variable) {
        var debugMode = component.get("v.debugMode");
        if (debugMode) {
            if (msg) {
                console.log(msg);
            }
            if(variable) {
                console.log(variable);
            }
        }
    }
})