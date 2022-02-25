// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {

	},

	handleMemberClick : function(component, event, helper) {
		helper.toggleMembership(component);
	},

	goToRecord : function(component, event, helper){
        $A.get("e.force:navigateToSObject")
		  .setParams({
		      "recordId": $(event.currentTarget).data("id"),
	          "slideDevName": "related"})
          .fire();
	},

	openPopInfo : function(component, event, helper){
		$A.util.addClass(component.find('popInfo'), "slds-rise-from-ground");
		$A.util.removeClass(component.find('popInfo'), "slds-fall-into-ground");
	},

	closePopInfo : function(component, event, helper){
		$A.util.addClass(component.find('popInfo'), "slds-fall-into-ground");
		$A.util.removeClass(component.find('popInfo'), "slds-rise-from-ground");
	},

	openPopAnnouncement : function(component, event, helper){
		$A.util.addClass(component.find('popAnnouncement'), "slds-rise-from-ground");
		$A.util.removeClass(component.find('popAnnouncement'), "slds-fall-into-ground");
	},

	closePopAnnouncement : function(component, event, helper){
		$A.util.addClass(component.find('popAnnouncement'), "slds-fall-into-ground");
		$A.util.removeClass(component.find('popAnnouncement'), "slds-rise-from-ground");
	}
});