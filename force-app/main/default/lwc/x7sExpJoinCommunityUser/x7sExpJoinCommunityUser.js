/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import { LightningElement, api, track } from 'lwc';
import { stringifyStyles } from 'c/x7sShrUtils';

export default class X7sExpJoinCommunityUser extends LightningElement {
    @api user;

    // - Value getters --------------------------------------------------------

    get photoStyle() {
        return stringifyStyles({
            'background-image': `url('${this.user.FullPhotoUrl}')`,
            'display': 'block',
            'height': '100%',
            'width': '100%',
            'background-size': 'cover',
            'z-index': '1',
            'border-radius': '50%'
        });
    }

    get hasPhoto() {
        return (this.user != null) && (this.user.FullPhotoUrl != null);
    }
}