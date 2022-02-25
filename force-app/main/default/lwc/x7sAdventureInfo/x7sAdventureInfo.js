/*
 * Copyright (c) 2021. 7summits Inc. All rights reserved.
*/

import {LightningElement, api, track, wire} from 'lwc';

import {NavigationMixin, CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from 'c/x7sShrUtils';

import labelOwner from '@salesforce/label/c.x7sAdventureBannerOwnerText';
import labelTaskRemainingPlular from '@salesforce/label/c.x7sAdventureBannerPrgTasks';
import labelTaskRemainingSigular from '@salesforce/label/c.x7sAdventureBannerPrgTaskSigular';
import labelAria from '@salesforce/label/c.x7sAdventureInfoAriaLabel';

export default class X7sAdventureInfo extends NavigationMixin(LightningElement) {

    //Builder Properties
    @api customClass = '';
    @api displayVariant = 'Featured';
    @api titleText = 'Adventure Info';
    @api titleAlign = 'Left';
    @api showProgressRing = false;
    @api showCloneButton = false;
    @api cloneButtonLabel = 'Clone';
    @api showOwner = false;
    @api showTaskRemaining = false;
    @api listId = 'ID_1';

    @api recordId;
    @api taskCheckboxSetup = false;
    @api adventureProgress = 0;
    @track adventure = [];
    numberOfTasksRemaining = 0;
    owner;

    labels = {
        labelOwner,
        labelAria
    }

    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
		  registerListener("adventureBanner", this.getAdventureDetails, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}

    get variant() {
        return this.displayVariant === 'Featured' ? 'featured' : this.displayVariant === 'Outline' ? 'slds-card' : 'default';
	}
	
	get titleAlignment() {
		return this.titleAlign === 'Right' ? 'right' : this.titleAlign === 'Center' ? 'center' : 'left';
	}

    get componentClass() {
		return `x7s-adventure ${this.customClass}`;
    }

    get displayCloneButton() {
		return this.showCloneButton && this.recordId;
    }
    
    get displayProgressRing() {
        return this.showProgressRing && this.taskCheckboxSetup;
    }

    get tasksRemaining() {
		return this.numberOfTasksRemaining === 1 ? this.numberOfTasksRemaining + '  ' + labelTaskRemainingSigular : this.numberOfTasksRemaining + '  ' + labelTaskRemainingPlular;
	}

    getAdventureDetails(event) {
		if (this.listId === event.id) {
			this.adventure = event.adventure;
			this.numberOfTasksRemaining = event.numberOfTasksRemaining;
			this.owner =  this.adventure && this.adventure.OwnerId ? this.adventure.Owner.Name : '';
            this.recordId = this.adventure ? this.adventure.Id : undefined;
            this.taskCheckboxSetup = event.taskCheckboxSetup;
			this.adventureProgress = event.adventureProgress;
		}
	}

    navigateToProfile() {
		if(this.adventure) {
			this[NavigationMixin.Navigate]({
				type: 'standard__recordPage',
				attributes: {
					recordId: this.adventure.OwnerId,
					objectApiName:'Profile',
					actionName: 'view'
				},
			});
		}
	}
}