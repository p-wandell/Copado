/**
 * Created by kentheberling on 9/5/18.
 */
({
    consoleTest: function (component,event,helper) {
        console.log('Test!');
    },
    closeModal: function (component,event,helper) {
        component.set('v.isOpen',false);
    },
    openModal: function (component,event,helper) {
        component.set('v.isOpen',true);
    } 
})