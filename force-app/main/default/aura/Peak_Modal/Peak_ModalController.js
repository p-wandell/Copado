/**
 * Created by kentheberling on 9/5/18.
 */
({
    closeModal: function (component,event,helper) {
        helper.closeModal(component,event,helper);
    },
    openModal: function (component,event,helper) {
        helper.openModal(component,event,helper);
    },
    doClick: function (component,event,helper) {
        // Get action we want to run
        helper.doAction(component,event,helper);
    }
})