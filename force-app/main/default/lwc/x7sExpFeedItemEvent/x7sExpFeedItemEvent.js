/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';


export default class X7sExpFeedItemEvent extends LightningElement {
    @api title;
    @api href;
    @api dateTimeField;
    @api eventTimestamp;
}