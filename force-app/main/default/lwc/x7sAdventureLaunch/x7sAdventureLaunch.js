/*
 * Copyright (c) 2021. 7summits Inc. All rights reserved.
*/

import {LightningElement, api} from 'lwc';
import getAdventure from '@salesforce/apex/x7sAdventureBaseController.getAdventureToLaunch';
import userId from '@salesforce/user/Id';

const CMS_PATH = '/cms/delivery/media/';

export default class X7sAdventureLaunch extends LightningElement {

    @api adventure;
    @api titleText;
    @api description;
    @api imageType = 'None';
    @api imageReference;
    @api cmsContentKey;
    @api backgroundColor;
    @api textColor;
    @api tileHeight = '80px';
    @api tileWidth;
    @api customClass = '';
    @api borderRadius = '10px';
    @api recordId;
    @api backgroundImageUrl = '';

    connectedCallback() {
        this.getLaunchAdventure();
    }

    getLaunchAdventure() {
        getAdventure({
            adventureId : this.adventure,
            activeUserId : userId
        })
            .then(result => {
                this.recordId = result;

                switch (this.imageType) {
                    case 'Image Reference':
                        this.backgroundImageUrl = this.imageReference;
                        break;
                    case 'CMS Image':
                        if(this.cmsContentKey) {
                            this.backgroundImageUrl = CMS_PATH + this.cmsContentKey;
                        }
                        break;
                    default:
                        this.backgroundImageUrl = '';
                        break;
                }
            })
            .catch(error=> {
                console.error('Error getting adventure:'+error);
            })
    }
}