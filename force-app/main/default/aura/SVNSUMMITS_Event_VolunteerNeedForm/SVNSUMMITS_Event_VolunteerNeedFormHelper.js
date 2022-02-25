/**
 * Created by kentheberling on 9/26/17.
 */
({
    needsToRemove: [], // track records removed from form for delete from server

    // Init records and populate form
    initRecord: function (component) {
        // Needed for callback
        var self = this;

        // empty the needs to remove array in case someone clicked remove and then cancelled
        this.needsToRemove = [];

        // check here that we don't have any straggling items in the remove array
        // console.log('Remove Init', this.needsToRemove);

        var action = component.get("c.initVolunteerNeeds");
        action.setParams({
            'eventIdString': component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {

                // Namespace for managed package
                var data = response.getReturnValue();
                data = self.parseNamespace(component, data);

                if (data.Volunteer_Description__c){
                    component.set("v.volunteerDescription",data.Volunteer_Description__c)
                }

                if (data.Volunteer_Needs__r){
                    var lineItems = data.Volunteer_Needs__r;
                } else {
                    var lineItems = [];
                }


                // replace 999999 volunteers needed with 0 (no limit) for display only
                // this will be restored to 999999 on save if user leaves value at 0
                // 999999 = no-limit flag
                for (var x=0;x<lineItems.length;x++) {
                    if (lineItems[x].Volunteers_Needed__c == 999999) {
                        lineItems[x].Volunteers_Needed__c = 0
                    }
                }

                component.set("v.event",data); // track original event
                component.set("v.lineItems", lineItems); // save line items into separate list!
                this.addVolunteerNeed(component);
                component.set("v.isInit",true);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    // Add a new item to the form
    addVolunteerNeed: function (component) {
        var eventId = component.get("v.recordId")
        var lineItems = component.get("v.lineItems");

        lineItems.push({
            Event__c: eventId,
            sobjectType: "Volunteer_Need__c",
            Name: "",
            Volunteers_Needed__c: 1
        });

        // console.log('addVolunteerNeed',lineItems);
        component.set("v.lineItems",lineItems);
    },

    // Remove an item from the form
    removeLineItem: function (component,index) {
        var lineItems = component.get("v.lineItems");
        var results = lineItems.splice(index,1);

        this.needsToRemove.push(results[0]);

        component.set("v.lineItems",lineItems);
    },

    // validate the description field; save if valid
    formValidation: function(component, event, helper) {

        if(!component.get("v.volunteerDescription")){
            component.set("v.validity", false);
            $A.util.toggleClass(component.find("ErrorMessage"), "slds-hidden");
        }
        else{
            component.set("v.validity", true);
            helper.saveAction(component);
        }
    },

    // Do the saving!
    saveAction: function (component) {
        var self = this;

        // Namespace for managed package
        var event = component.get("v.event");
        event.Volunteer_Description__c = component.get("v.volunteerDescription");
        event = self.setNamespace(component, event);

        var lineItems = component.get("v.lineItems");
        var lineItemsToRemove = this.needsToRemove;
        var detailPageUrl = component.get("v.detailPageUrl");
        var recordId = component.get("v.recordId");


        // replace 0 volunteers needed with 999999 (no-limit flag)
        for (var x=0;x<lineItems.length;x++) {
            if (lineItems[x].Volunteers_Needed__c == 0) {
                lineItems[x].Volunteers_Needed__c = 999999
            }
        }

        // remove Line items with empty name or volunteers needed
        lineItems = lineItems.filter(function( obj ) {
            return obj.Name !== '' && obj.Volunteers_Needed__c !== '';
        });
        lineItemsToRemove = lineItemsToRemove.filter(function( obj ) {
            return obj.Id != null;
        });

        // And now translate all
        for (var x=0;x<lineItems.length;x++) {
            lineItems[x] = self.setNamespace(component, lineItems[x]);
        }


        // Set both event and needs because event.somelist__r does not get passed back to Apex!
        var action = component.get("c.createVolunteerNeeds");
        action.setParams({
            "event": event,
            "volunteerNeeds": lineItems,
            "needsToRemove": lineItemsToRemove
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // Results - a list of possible error messages. If none, great!
                var saveResults = response.getReturnValue();

                if (saveResults.length>0){
                    component.set("v.saveResults",response.getReturnValue());
                } else {
                    component.set("v.submissionSuccess",true);
                    this.needsToRemove = []; // empty needs to remove array
                    self.goToURL(detailPageUrl + recordId);
                }

            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //goToURL: function(url, isredirect) {
    goToURL: function (url) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url,
        });
        urlEvent.fire();
    },

    // Fetching Site Path
    get_SitePrefix: function (component) {
        var action = component.get("c.getSitePrefix");

        action.setCallback(this, function (actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);
            component.set("v.sitePrefix", sitePath.replace("/s", ""));
        });
        $A.enqueueAction(action);
    },
})