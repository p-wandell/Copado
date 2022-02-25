/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-05-07.
*/
({
    afterRender: function (component, helper) {
        this.superAfterRender();
        if(component.get('v.isInit')){
            helper.setupSearchAndMobileMenu(component, null, helper);
        }
    },
})