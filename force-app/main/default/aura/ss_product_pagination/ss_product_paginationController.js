/*
 * Copyright (c) 2017. 7Summits inc.
 */
/**
 * Created by joecallin on 7/20/17.
 */
({
    init: function (component, event, helper) {
        component.set('v.isInit', true);

	    // default alignment is start but cannot be specified - rip it out
	    let align = component.get('v.align');

	    if (align === 'start') {
		    $A.util.removeClass(component.find('paginationControl'), 'horizontalAlign');
	    }
    },

    paginate: function (component, event, helper) {
	    let buttonName = event.getSource().get('v.name');
	    let paginateEvent = component.getEvent('paginateEvent');
	    paginateEvent.setParams({
		    'buttonClicked': buttonName
	    });
	    paginateEvent.fire();
    }
});