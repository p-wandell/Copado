/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-05-07.
*/
({
    toggleSearchBar: function(component, event, helper, handlingBlur) {
        var showSearch = !component.get('v.showSearch');
        var searchField = component.get('v.searchField');

        if(showSearch){
            window.setTimeout(function ()
            {
                searchField.focus();
            }, 0);
            this.adjustSearchBar(component, event, helper, showSearch);
        }else{
            this.clearSearch(component, event, helper);
            var searchBox = component.get('v.searchBox');
            var searchButton = component.get('v.searchButton');
            var searchWrapper = component.get('v.searchWrapper');
            var originalSearchOffset = component.get('v.originalSearchOffset');
            var search = component.find('theme-search').getElement();
            search.setAttribute('style','width:0px;left:' + originalSearchOffset + 'px');
            $A.util.removeClass(searchBox, 'focused');
            $A.util.removeClass(searchButton, 'focus');
            $A.util.removeClass(searchWrapper, 'smallOnlyDisplay');
            if(handlingBlur){
                window.setTimeout(function ()
                {
                    component.set('v.blurCalled', false);
                }, 250);
            }
        }
        component.set('v.showSearch', showSearch);
    },
    clearSearch: function(component, event, helper) {
        var searchField = component.get('v.searchField');
        searchField.value = '';
    },
    adjustSearchBar: function(component, event, helper, open) {
        var search = component.find('theme-search').getElement();
        var navigation = component.find('theme-navigation_wrapper').getElement();
        var toggleWidth = component.find('search-toggle').getElement().offsetWidth;
        var originalSearchOffset = (navigation.offsetLeft + navigation.offsetWidth + toggleWidth + 12);
        if(component.get('v.isMobile')){
            var userOffset = component.find('theme-user').getElement().offsetLeft;
            originalSearchOffset = userOffset + 10;
            search.setAttribute('style','width:0px;left:' + originalSearchOffset + 'px');
        }else if(open){
            search.setAttribute('style','width: ' + (navigation.offsetWidth + toggleWidth + 12) + 'px;left: ' + navigation.offsetLeft + 'px');
        }else{
            search.setAttribute('style','width:0px;left:' + originalSearchOffset + 'px');
        }
        component.set('v.originalSearchOffset', originalSearchOffset);

    },
    toggleMobileMenu: function(component, helper) {
        var theme = component.find('community-theme');
        $A.util.toggleClass(theme, 'menu-active');
    },
    removeMobileClass: function(component, helper) {
        var theme = component.find('community-theme');
        $A.util.removeClass(theme, 'menu-active');
    },
    handleSaveRecord: function(component, event, helper) {
        console.log('handleSaveRecord');
        var currentUser = component.get('v.currentUser');
        currentUser.Hive_Terms__c = true;
        console.log(currentUser);
        component.set('v.currentUser', currentUser);
        component.find('recordLoader').saveRecord($A.getCallback(function(saveResult) {
            console.log('saveResult');
            console.log(saveResult);
            if (saveResult.state === 'SUCCESS' || saveResult.state === 'DRAFT') {
                console.log('saved user');
                // handle component related logic in event handler
            } else if (saveResult.state === 'INCOMPLETE') {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === 'ERROR') {
                console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },
    setupSearchAndMobileMenu: function(component, event, helper) {
        setTimeout(function() {
            var mediaList = window.matchMedia('(max-width: 767px)');
            var search = component.find('theme-search').getElement();
            var navigation = component.find('theme-navigation_wrapper').getElement();
            var searchField = search.getElementsByClassName('search-field')[0];
            var searchBox = search.getElementsByClassName('forceCommunitySearchBox')[0];
            var searchButton = search.getElementsByClassName('search-button')[0];
            var searchWrapper = search.getElementsByClassName('search-field-wrapper')[0];
            component.set('v.searchField', searchField);
            component.set('v.searchBox', searchBox);
            component.set('v.searchButton', searchButton);
            component.set('v.searchWrapper', searchWrapper);
            setTimeout(function () {
                search.setAttribute('style', 'left: ' + (search.offsetLeft) + 'px');
                component.set('v.originalSearchOffset', (search.offsetLeft));
            }, 500);
            searchField.addEventListener('blur', function () {
                var showSearch = component.get('v.showSearch');
                if (showSearch) {
                    component.set('v.blurCalled', true);
                    helper.toggleSearchBar(component, null, helper, true);
                }
            });
            window.addEventListener('resize', function (event) {
                var showSearch = component.get('v.showSearch');
                helper.adjustSearchBar(component, event, helper, showSearch);
            }, true);
            function screenTest(e) {
                if (e.matches) {
                    setTimeout(function () {
                        var navigationButton = navigation.getElementsByTagName('COMMUNITY_NAVIGATION-GLOBAL-NAVIGATION-TRIGGER')[0].getElementsByTagName('BUTTON')[0];
                        navigationButton.addEventListener('click', function (event) {
                            helper.toggleMobileMenu(component, helper);
                            if ($A.util.hasClass(component.find('community-theme'), 'menu-active')) {
                                setTimeout(function () {
                                    var navigationList = navigation.getElementsByClassName('comm-navigation__list')[0];
                                    navigationList.getElementsByTagName('A').forEach(function (element) {
                                        element.addEventListener('click', function (event) {
                                            helper.removeMobileClass(component, helper);
                                        });
                                    });
                                    component.set('v.navigationList', navigationList);
                                }, 0);
                            }
                        });
                        component.set('v.navigationButton', navigationButton);
                    }, 0);
                }
                component.set('v.isMobile', e.matches);
            }

            mediaList.addEventListener('change', function (event) {
                screenTest(mediaList)
            });
            screenTest(mediaList);
            // Write your custom code here.
        }, 100);
    },
})