/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-05-06.
*/
({
    init: function(component, event, helper) {
        sessionStorage.setItem('communityLogo', component.get('v.communityLogo'));
        component.set('v.isInBuilder', helper.isInBuilder(component, event, helper));
    },
    linkClick: function(component, event, helper) {
        var url = event.getParam('url');
        if(/[^/]*$/.exec(window.location.pathname)[0] !== ''){
            helper.goToLink(url);
        }
        if($A.util.hasClass(component.find('community-theme'), 'menu-active')){
            component.get('v.navigationButton').click();
            helper.removeMobileClass(component, helper);
        }
    },
    toggleSearch: function(component, event, helper) {
        var blurCalled = component.get('v.blurCalled');
        if(!blurCalled){
            helper.clearSearch(component, event, helper);
            helper.toggleSearchBar(component, event, helper);
        }
    },
    closeTerms: function(component, event, helper) {
        component.set('v.showTerms', false);
    },
    recordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === 'LOADED') {
            component.set('v.isInit', true);
            if(component.get('v.currentUser').Hive_Terms__c){
                helper.setupSearchAndMobileMenu(component, event, helper);
            }
        } else if(eventParams.changeType === 'CHANGED') {
            component.find('recordLoader').reloadRecord();
        } else if(eventParams.changeType === 'REMOVED') {
            // record is deleted
        } else if(eventParams.changeType === 'ERROR') {
            var errorMessage = event.getParam('message');
            helper.showMessage('Error', errorMessage);
            // there’s an error while loading, saving, or deleting the record
        }
    },
    acceptTerms: function(component, event, helper) {
        helper.setupSearchAndMobileMenu(component, event, helper);
        helper.handleSaveRecord(component, event, helper);
    },
    viewTerms: function(component, event, helper) {
        var termsFileId = component.get('v.termsFileId');
        $A.get('e.lightning:openFiles').fire({
            recordIds: [termsFileId]
        });
        component.set('v.acceptDisabled', false);
    },
    searchClick: function(component, event, helper) {
        var searchButton = component.get('v.searchButton');
        searchButton.click();
    },
})