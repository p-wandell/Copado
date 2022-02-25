/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';


export default class X7sExpFeedItemTest extends LightningElement {
    @api title;
    @api href;
    @api authorName;
    @api dateTimeField;
    @api eventTimestamp;
    @api description;
    @api fullDescription;
}