/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class X7sShrTopicListItem extends NavigationMixin(LightningElement) {
    @api topic;
    @api type = 'tag'; // tag, pill

    handleClick(event) {
        event.preventDefault();
        event.stopPropagation();

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.topic.Id,
                actionName: 'view'
            }
        });
    }
}