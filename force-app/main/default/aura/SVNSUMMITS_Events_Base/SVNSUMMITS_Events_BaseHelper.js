/**
 * Created by francois korb on 6/5/17.
 */
({
	custom : {
		EVENT_OBJ        : 'Event__c',
		MAX_FIELDS       : 3,
		SEARCH_SEPARATOR : ';',
		FIELD_SEPARATOR  : ',',
		SEARCH_FIELD     : ':',
		DATE_FORMAT      : 'YYYY-MM-DD'
	},

	events : {
		fields : {
			location:  'Location_Name__c',
			eventType: 'Event_Type__c'
		},
		listViewMode : {
			list     : 'List',
			calendar : 'Calendar'
		},
		auraId : {},
		values : {}
	},

	session : {
		viewState   : 'X7S_VIEW_STATE',
		calendarView: 'X7S_CAL_VIEW',
		listView    : 'X7S_LST_VIEW'
	},

	viewStateIsCalendar : function() {
		return this.events.listViewMode.calendar === this.retrieveViewState()
	},

	viewStateIsList : function() {
		return this.events.listViewMode.list === this.retrieveViewState()
	},

	retrieveViewState: function() {
		return this.getViewState();
	},

	persistCalendarView : function() {
		this.saveViewState(this.events.listViewMode.calendar);
	},

	persistCalendarDate: function(startDate) {
		sessionStorage.setItem(this.session.calendarView, moment(startDate).format('YYYY-MM-DD'));
	},

	retieveCalendarDate: function() {
		let start = sessionStorage.getItem(this.session.calendarView);
		return start ? moment(start) : '';
	},

	clearCaledarDate: function() {
		sessionStorage.removeItem(this.session.calendarView);
	},

	persistListView: function() {
		this.saveViewState(this.events.listViewMode.list);
	},

	saveViewState: function(state) {
		sessionStorage.setItem(this.session.viewState, state);
	},

	getViewState: function () {
		let viewState = sessionStorage.getItem(this.session.viewState) || '';
		return viewState ? viewState : this.events.listViewMode.list;
	},

	parseNamespace: function (component, obj) {
		var self = this;
		var model = (component.get("v.baseModel")) ? JSON.parse(component.get("v.baseModel")) : {};

		if (model.namespacePrefix) {
			for (var k in obj) {
				if (typeof obj[k] === "object" && obj[k] !== null) {
					self.parseNamespace(component, obj[k]);
				}
				if (k.indexOf(model.namespacePrefix + '__') >= 0) {
					var withoutNamespace = k.replace(model.namespacePrefix + '__', '');
					obj[withoutNamespace] = obj[k];
				}
			}
		}
		return obj;
	},

	setNamespace: function (component, obj) {
		var self = this;
		var model = (component.get("v.baseModel")) ? JSON.parse(component.get("v.baseModel")) : {};

		if (model.namespacePrefix) {
			for (var k in obj) {
				if (typeof obj[k] === "object" && obj[k] !== null) {
					self.setNamespace(component, obj[k]);
				}
				if (k.indexOf(model.namespacePrefix + '__') >= 0) {
					var withoutNamespace = k.replace(model.namespacePrefix + '__', '');
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
		return obj;
	},

	getNameSpacePrefix : function (component) {
		var nameSpace = '';

		var model = (component.get("v.baseModel")) ? JSON.parse(component.get("v.baseModel")) : {};

		if (model.namespacePrefix) {
			nameSpace = model.namespacePrefix + '__';
		}
		return nameSpace;
	},

	doCallout: function (component, method, params, hideToast, toastTitle) {
		var self = this;

		return new Promise($A.getCallback(function (resolve, reject) {
			var action = component.get(method);

			if (params) {
				action.setParams(params);
			}

			action.setCallback(component, function (response) {
				var state = response.getState();

				if (component.isValid() && state === "SUCCESS") {
					resolve(response.getReturnValue());
				} else {
					var errors = response.getError();

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

	getCustomFields: function (component) {
		var customFields = '';

		for  (var pos = 1; pos <= this.custom.MAX_FIELDS; pos++) {
			if (component.get('v.customField' + pos)) {
				customFields += component.get('v.customField' + pos) + ',';
			}
		}

		return customFields;
	},

	setCustomFields : function (component, objEventList, index) {
		for (var pos = 1; pos <= this.custom.MAX_FIELDS; pos++) {
			var customField = component.get('v.customField' + pos);

			if (customField.length) {
				var fieldSet   = true;
				var fieldParts = customField.split('.');
				var fieldValue = objEventList[index];

				for (var part = 0; part < fieldParts.length; part++) {
					if (fieldValue[fieldParts[part]]) {
						fieldValue = fieldValue[fieldParts[part]];
					}
					else {
						fieldSet = false;
						break;
					}
				}

				objEventList[index]['customField' + pos] = fieldSet ? fieldValue : '';
			}
		}
	},

	gotoUrl: function (component, url) {
		$A.get("e.force:navigateToURL")
			.setParams({
				url       : url,
				isredirect: true
			}).fire();
	},

	gotoRecord: function (component, recordId) {
		$A.get("e.force:navigateToSObject")
			.setParams({
				recordId    : recordId,
				slideDevName: "detail"
			}).fire();
	},

	showMessage: function (level, title, message) {
		$A.get("e.force:showToast")
			.setParams({
				title  : title,
				message: message,
				type   : level
			}).fire();
	},

	debug: function (component, msg, variable) {
		if (component.get("v.debugMode")) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}
});