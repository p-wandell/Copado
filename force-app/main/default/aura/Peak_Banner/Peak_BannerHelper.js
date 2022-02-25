({
    setVerticalAlignment: function (component, event, helper) {
        let verticalAlignment = component.get("v.verticalAlignment");
        component.set("v._verticalAlignment", helper.getVerticalAlignment(verticalAlignment));
    },

    // object-literal lookup maps the user-friendly attribute to an SLDS class name
    getVerticalAlignment: function (verticalAlignment) {
        let variant = {
            'Top': 'start',
            'Middle': 'center',
            'Bottom': 'end',
            'default': 'start'
        };
        return variant[verticalAlignment] || variant['default'];
    },

    setPadding: function (component, event, helper) {
        let horizontalPadding = component.get("v.horizontalPadding");
        let verticalPadding = component.get("v.verticalPadding");
        component.set("v._horizontalPadding", helper.getPadding(horizontalPadding, 'horizontal'));
        component.set("v._verticalPadding", helper.getPadding(verticalPadding, 'vertical'));
    },

    // object-literal lookup maps the user-friendly attribute to an SLDS padding class name
    getPadding: function (padding, type) {
        let map = {
            'none': '',
            'xx-large': 'slds-p-' + type + '_xx-large',
            'x-large': 'slds-p-' + type + '_x-large',
            'large': 'slds-p-' + type + '_large',
            'medium': 'slds-p-' + type + '_medium',
            'small': 'slds-p-' + type + '_small',
            'x-small': 'slds-p-' + type + '_x-small',
            'xx-small': 'slds-p-' + type + '_xx-small'
        };
        return map[padding] || map['none'];
    },

    setContainer: function (component, event, helper) {
        let container = component.get("v.container");
        component.set("v._container", helper.getContainer(container));
    },

    // object-literal lookup maps the user-friendly attribute to an SLDS class name
    getContainer: function (container) {
        let map = {
            'none': '',
            'x-large': 'slds-container_x-large',
            'large': 'slds-container_large',
            'medium': 'slds-container_medium',
            'small': 'slds-container_small'
        };
        return map[container] || map['none'];
    },
});