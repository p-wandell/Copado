/**
 * Created by jonbalza on 12/9/18.
 */
({
    setHorizontalAlignment: function (component, event, helper) {
        var horizontalAlignment = component.get("v.horizontalAlignment");
        component.set("v._horizontalAlignment", helper.getHorizontalAlignment(horizontalAlignment));
    },

    // object-literal lookup maps the user-friendly attribute to an SLDS class name
    getHorizontalAlignment: function (horizontalAlignment) {
        var variant = {
            'Left': 'left',
            'Center': 'center',
            'Right': 'right'
        };
        return variant[horizontalAlignment] || variant['Center'];
    },

    setRowWidths: function(component, event, helper) {
        component.set("v._rowWidthSmall", 12 / component.get("v.itemsPerRowSmall"));
        component.set("v._rowWidthMedium", 12 / component.get("v.itemsPerRowMedium"));
        component.set("v._rowWidthLarge", 12 / component.get("v.itemsPerRowLarge"));
    },

    setVerticalAlignment: function (component, event, helper) {
        var verticalAlignment = component.get("v.verticalAlignment");
        component.set("v._verticalAlignment", helper.getVerticalAlignment(verticalAlignment));
    },

    // object-literal lookup maps the user-friendly attribute to an SLDS class name
    getVerticalAlignment: function (verticalAlignment) {
        var variant = {
            'Top': 'start',
            'Middle': 'center',
            'Bottom': 'end'
        };
        return variant[verticalAlignment] || variant['Middle'];
    },

    filterTopics: function(topics, filters) {
        if(typeof filters === 'undefined' || filters === '') {
            return topics;
        }

        var filteredTopics = [];
        var filterList = filters.split(',');

        filterList.forEach(function(id) {
            var filteredTopic = topics.filter(function(topic) {
                return topic.id == id;
            })[0];
            if(typeof filteredTopic !== 'undefined') {
                filteredTopics.push(filteredTopic);
            } else {
                console.warn('Featured Topics warning: a featured topic with the ID of "' + id + '" is not found.')
            }
        });
        return filteredTopics;
    },

    listFeaturedTopics: function(component, event, helper) {
        var topics = component.get("v.topics");
        var topicList = '';
        topics.forEach(function(topic, i) {
            if(i !== 0) {
                topicList += ', ';
            }
            topicList += topic.topic.name + ': ' + topic.id;
        });
        return(topicList);
    }
})