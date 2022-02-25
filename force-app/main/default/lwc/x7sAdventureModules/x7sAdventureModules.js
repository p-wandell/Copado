/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, wire} from 'lwc';
import labelBannerCompletePrg from '@salesforce/label/c.x7sAdventureModuleTaskCompletedText';
import {NavigationMixin, CurrentPageReference} from 'lightning/navigation';
import getModuleTaskProgress from '@salesforce/apex/x7sAdventureModuleTasks.getModuleTaskProgress';

export default class X7sAdventureModules extends NavigationMixin(LightningElement) {

    @api stepModule;
    @api adventureSetup;
    @api customClass;
    @api layout = 'vertical';
    @api tileVariant = 'default';
    @api textAlign = 'center';
    @api showAvatar;
    @api showImages;
    @api taskCheckboxSetup;
    @api showLinks;
    @api taskProgress;
    @api listId = 'ID_1';
    @api myFilter;
    @api isLex;
    @api moduleProgressType = false;
    @api truncate;
    @api showModuleTooltip;

    @wire(CurrentPageReference) pageRef;

    get moduleTitleCSS() {
        return this.truncate === true ? ['progressBarCss', 'slds-list__item', 'slds-truncate_container_66', 'slds-truncate'].join(' ') : ['progressBarCss'].join(' ');
    }

    get moduleTooltip() {
        return this.truncate === true ? 'float:left;padding-left:7px;' : 'float:left;padding-left:0px;';
    }

    get moduleTitleItemSize() {
        return this.moduleProgressType ? '12' : '10';
    }

    get isTaskAssigned() {
        return this.stepModule.moduleTasks.length > 0;
    }

    get useAvatar() {
        return (this.showImages && this.showAvatar);
    }

    get hide_image() {
        return (!this.showImages);
    }

    get proggressBarLabel() {
        return this.taskProgress + labelBannerCompletePrg;
    }

    getModuleProgress(event) {
        let moduleId = this.stepModule.id;
        console.log('**moduleId :' + moduleId);
        if (this.listId === event.id) {
            if (moduleId !== null) {
                let params = ({
                    "moduleId": moduleId
                });

                getModuleTaskProgress(params)
                    .then(result => {
                        let moduleProgress = 0;
                        if (result.Task_Progress__c !== null) {
                            moduleProgress = Math.round(result.Task_Progress__c);
                        }

                        console.log('**taskProgress :' + moduleProgress);
                        this.taskProgress = moduleProgress;
                    })
                    .catch(error => {
                        this.error = error;
                    });
            }
        }
    }

    get ancherColor() {
        return 'color:' + this.adventureSetup.Override_Link_Color__c + ';';
    }

    linkClick(event) {
        let url = event.currentTarget.dataset.href;
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    }
}