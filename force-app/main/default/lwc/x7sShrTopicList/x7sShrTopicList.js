/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track} from 'lwc';

export default class x7sShrTopicList extends LightningElement {
    @api customClass = '';
    @api type = 'tag'; // tag, pill
    @api maxTopics = 0;

    @api
    get topics() {
        return this._topics || [];
    }
    set topics(value) {
        let newTopicsList = [];
        const maxTopics = this.maxTopics;
        value.forEach(function(topic, i) {
            if(maxTopics === 0 || maxTopics > i) {
                // Create the new topic that we'll be using to generate the list
                const newTopic = {
                    'Id': topic.Topic.Id,
                    'NetworkId': topic.NetworkId,
                    'Name': topic.Topic.Name,
                    // 'Image': '',// TODO: Image may come in handy
                };
                newTopicsList.push(newTopic);
            }
        });

        // console.log('newTopicsList', newTopicsList);
        this._topics = newTopicsList;
    }

    get componentClass() {
        return `topic-list topic-list_${this.type} ${this.customClass}`;
    }
}