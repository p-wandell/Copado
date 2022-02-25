/*
 * Copyright (c) 2018. 7Summits Inc. 
 */
({
	rerender: function(component, helper) {
        var ret = this.superRerender();
        helper.initializeSlider(component);
        return ret;
  }
})