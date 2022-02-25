/*
 * Copyright (c) 2018. 7Summits Inc. 
 */
({
    // Label references for packaging - does not seem to work
    //$Label.c.ss_mbr_text_selectAll
    // switch from Contact record to User record
    getPicklists: function (component) {
        if (component.get('v.showPicklists')) {
            if (component.get('v.showTitleFilter')) {
                this.getMemberPicklistValues(
                    component,
                    this.contact.auraId.title,
                    this.contact.fields.title,
                    this.contact.values.title,
                    '');
            }

            if (component.get('v.showCountryFilter')) {
                this.getMemberPicklistValues(
                    component,
                    this.contact.auraId.country,
                    this.contact.fields.country,
                    this.contact.values.country,
                    '');
            }

            if (component.get('v.showStateFilter')) {
                this.getMemberPicklistValues(
                    component,
                    this.contact.auraId.state,
                    this.contact.fields.state,
                    this.contact.values.state,
                    '');
            }

            if (component.get('v.showCityFilter')) {
                this.getMemberPicklistValues(
                    component,
                    this.contact.auraId.city,
                    this.contact.fields.city,
                    this.contact.values.city,
                    '');
            }

            if (component.get('v.showAccountFilter')) {
                this.getMemberPicklistValues(
                    component,
                    this.contact.auraId.account,
                    this.contact.fields.account,
                    this.contact.values.account,
                    '');
            }

            for (var pos = 1; pos <= this.custom.MAX_FIELDS; pos++) {
                var customField = component.get('v.customField' + pos);

                if (customField.length) {
                    var auraId = 'typeAheadCustomField' + pos;
                    this.getMemberPicklistValues(component, auraId, customField, 'v.customValuesField' + pos, '');
                }
            }
        }

        if (component.get('v.showTopicFilter')) {
            this.getTopicValues(component);
        }
    },

    getMemberPicklistValues : function (component, fieldAuraId, fieldName, valueSet, searchString) {
        var action = component.get('c.getMemberPicklist');

        action.setParams({
            'fieldName'    : fieldName,
            'searchString' : searchString
        });

        action.setStorable();

        action.setCallback(this, function (actionResult) {
            if (actionResult.getState() === 'SUCCESS') {
                var values = actionResult.getReturnValue();

                if (searchString.length && !values.length) {
                    // console.log('Type ahead pickList empty for ' + fieldName);
                    this.setInvalidField(component, fieldAuraId);
                }

                values.unshift(component.get('v.selectAll'));

	            var items = [];
	            for (var i = 0; i < values.length; i++) {
                    var item = {
                        "label": values[i],
                        "value": values[i]
                    };

		            items.push(item);
		        }
		        
	            component.set(valueSet, items);
                // console.log('Picklist (' + fieldName + ')');
                // console.log('    ' + values);
            }
        });

        $A.enqueueAction(action);
    },

    setInvalidField : function (component, fieldId) {
        // this works but is horribly slow
        //var inputField = component.find(fieldAuraId);
        //inputField.set('v.validity', {valid:false, badInput :true});

        $A.util.addClass(component.find(fieldId), 'showInvalid');
    },

    clearInvalidField : function (component, fieldId) {
        // this works but is horribly slow
        //var inputField = component.find(fieldAuraId);
        //inputField.set('v.validity', {valid:true, badInput :false});

        $A.util.removeClass(component.find(fieldId), 'showInvalid');
    },

    showSpinner: function (component) {
        //console.log('Spinner on...');
        $A.util.removeClass(component.find('loadingSpinner'), 'slds-hidden');
    },

    hideSpinner: function (component) {
        //console.log('Spinner off...');
        $A.util.addClass(component.find('loadingSpinner'), 'slds-hidden');
    },

    getTopicValues : function(component) {
        var action = component.get('c.getTopicValues');
        action.setStorable();

        action.setCallback(this, function (actionResult) {
            if (actionResult.getState() === 'SUCCESS') {
                var results = actionResult.getReturnValue();
                var values  = [];

                values.push({
                    label: component.get('v.selectAll'),
                    value:''
                });

                for(var i in results) {
                    values.push({
                        label: results[i],
                        value: i
                    });
                }

                component.set('v.topicValues', values);
            }
        });

        $A.enqueueAction(action);
    },

    // this builds a complicated search string pattern for the Apex getMemberList function
    //
    // searchString:field1,..field[n];memberField1:value1;memberField2:value2;
    //  where:
    //      searchString   = search string
    //      memberField[n] = Member.Contact Field
    //      value[n]       = Member.Contact.Field[n] value
    // and
    //      field1 to n are additional member object search fields for the searchString
    //
    // if searchLastName is enabled, the search pattern is:
    //      ::;LastName:xxxxx;FirstName:yyyyy;
    // other filters still apply after this
    //
    // example:  apple:phone,email;MailingCountry:US;MailingCity:New York;
    //  search for 'apple' in Name, phone, email AND country == US, city == New York

    fireSearchEvent: function (component, clearAll)
    {
        this.showSpinner(component);

        var threshold    = component.get('v.searchThreshold');
        var selectAll    = component.get('v.selectAll');
        var searchString = component.get('v.searchString');
        var searchFields = component.get('v.searchFields');
        var myMembers    = component.get('v.showMyMembers');
        var topicString  = '';

        if (component.get('v.searchLastName')) {
            var searchLastFirst = searchString;
            var searchNameParts = searchLastFirst.split(',');

            // ignore regular search
            searchString = ':;';

            if (searchNameParts.length) {
                if (searchNameParts[0].trim().length > 0) {
                    searchString += this.contact.fields.lastName + ':' + searchNameParts[0].trim() + ';';

                    if (searchNameParts.length > 1) {
                        searchString += this.contact.fields.firstName + ':' + searchNameParts[1].trim() + ';';
                    }
                }
            }
        }
        else {
            searchString += ':';
            searchString += searchString.length > 1 ? searchFields : '';
            searchString += ';';
        }

        if (component.get('v.showTitleFilter')) {
            var titleSearch = component.get('v.titleSearch');

            if (titleSearch.length >= threshold && titleSearch !== selectAll) {
                searchString +=  this.contact.fields.title + ':' + titleSearch + ';';
            }
        }

        if (component.get('v.showCountryFilter')) {
            var countrySearch = component.get('v.countrySearch');

            if (countrySearch.length >= threshold && countrySearch !== selectAll) {
                searchString += this.contact.fields.country + ':' + countrySearch + ';';
            }
        }

        if (component.get('v.showStateFilter')) {
            var stateSearch = component.get('v.stateSearch');

            if (stateSearch.length >= threshold && stateSearch !== selectAll) {
                searchString += this.contact.fields.state +':' + stateSearch + ';';
            }
        }

        if (component.get('v.showCityFilter')) {
            var citySearch = component.get('v.citySearch');

            if (citySearch.length >= threshold && citySearch !== selectAll) {
                searchString +=  this.contact.fields.city +':' + citySearch + ';';
            }
        }

        if (component.get('v.showAccountFilter')) {
            var accountSearch = component.get('v.accountSearch');

            if (accountSearch.length >= threshold && accountSearch !== selectAll) {
                searchString += this.contact.fields.account +':' + accountSearch + ';';
            }
        }

        if (component.get('v.showTopicFilter')) {
            var topicSearch = component.get('v.topicSearch');

            if (topicSearch.length && topicSearch !== selectAll) {
                topicString = topicSearch;
            }
        }

        for (var pos = 1; pos <= this.custom.MAX_FIELDS; pos++) {

            // Custom field
            var customField = component.get('v.customField'+pos);
            if (customField.length) {
                var customSearch = component.get('v.searchCustomField'+pos);

                if (customSearch.length && customSearch !== selectAll) {
                    searchString += customField + ':' + customSearch + ';';
                }
            }
        }

        console.log('fireSearchEvent:');
        console.log('    searchString    :' + searchString);
        console.log('    topicString     :' + topicString);
        console.log('    searchMyMembers :' + myMembers ? 'true' : '');

        var searchEvent  = $A.get("e.c:SVNSUMMITS_Members_Filters_Event");

        searchEvent.setParams({
            'searchString'    : searchString,
            'topicString'     : topicString,
            'searchMyMembers' : myMembers ? 'true' : '',
            'clearAll'        : clearAll
        });

        searchEvent.fire();
    },

    getTranslatedText: function (component, source, destination, labelHandle) {
        var labelRegex = /^\$Label\.([a-zA-Z0-9_]*\.){1}([a-zA-Z0-9_]+)$/;
        //console.log("source = ", source);
        var text = component.get(source);
        //console.log("text = ", text);

        if (text !== undefined && text !== '') {
            if (text.indexOf('$Label') !== -1) {
                var label = '';
                if (labelRegex.test(text)) {
                    label = $A.getReference(text);
                } else {
                    label = 'This is an invalid label. Please check it.'
                }
                component.set(destination, label);
            } else {
                component.set(destination, text);
            }
        } else {
            component.set(destination, text);
            // If they empty out the design attribute, reset to normal translated value
            if (text === '') {

                label = $A.getReference(labelHandle);
                component.set(destination, label);
            } else {
                // set it to the text they put in the design attribute
                component.set(destination, text);
            }
        }
    }
})