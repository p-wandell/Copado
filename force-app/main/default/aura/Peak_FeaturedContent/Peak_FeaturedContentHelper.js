/**
 * Created by brianpoulsen on 7/20/18.
 */
({
    getTopics: function(component, event, helper) {

        var layout = component.get('v.layoutType');
        var params = [
            component.get("v.cardTopic1"),
            component.get("v.cardTopic2"),
            component.get("v.cardTopic3"),
            component.get("v.cardTopic4")
        ];

        helper.doCallout(component,'c.getTopicNames',{topics:JSON.stringify(params)}).then(function(response){
            component.set("v.cardTopicList",response);

            if (layout === 'topics') {
                helper.createTopicLinks(component, event, helper);
            }
        });

    },

    createTopicLinks: function(component, event, helper) {
        var topic1 = component.get("v.cardTopic1");
        var topic2 = component.get("v.cardTopic2");
        var topic3 = component.get("v.cardTopic3");
        var topic4 = component.get("v.cardTopic4");

        var cardTopicList = component.get("v.cardTopicList");

        // build topic links
        component.set("v.cardLink1", "/topic/" + topic1 + '/' + helper.createTopicSlug(cardTopicList[0]));
        component.set("v.cardLink2", "/topic/" + topic2 + '/' + helper.createTopicSlug(cardTopicList[1]));
        component.set("v.cardLink3", "/topic/" + topic3 + '/' + helper.createTopicSlug(cardTopicList[2]));
        component.set("v.cardLink4", "/topic/" + topic4 + '/' + helper.createTopicSlug(cardTopicList[3]));
    },

    createTopicSlug: function (str) {
        var strLower = str.toLowerCase();
        return strLower.replace(/[^A-Z0-9]+/ig, "-");
    },

    mapCardColors: function(component, event, helper) {
        for (var i = 1; i < 5; i++) {
            component.set("v.cardColorClass"+ i +"", helper.colorMap( component.get("v.cardColor"+ i +"") ));
        }
    },

    colorMap: function(color) {
        return {
            'Brand Blue': 'brand',
            'Orange': 'orange',
            'Teal': 'teal',
            'Green': 'green',
            'Dark Blue': 'darkBlue',
            'Purple': 'purple',
            'Gray': 'gray'
        }[color];
    }
});