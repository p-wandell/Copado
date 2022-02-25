/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';


export default class X7sExpFeedItemBlog extends LightningElement {
    @api title;
    @api href;
    @api authorName;
    @api publishDate;
    @api publishTimestamp;
}