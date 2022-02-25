/**
 * Created by brianpoulsen on 7/20/18.
 */
({
    doInit:function(component, event, helper) {
        helper.isExternalLink(component);
    },

    gotoUrl: function(component, event, helper) {
        event.preventDefault();
        var url = event.currentTarget.getAttribute('href');
        helper.gotoURL(url);
    },

    gotoTopic: function(component, event, helper) {
        var url = '/topic/' + event.currentTarget.dataset.id + '/' + helper.createTopicSlug(component.get("v.topicLabel"));
        helper.gotoURL(url);
    }
});