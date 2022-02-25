/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, wire} from 'lwc';

import {NavigationMixin, CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from 'c/x7sShrUtils';

import labelTaskRemainingPlural from '@salesforce/label/c.x7sAdventureBannerPrgTasks';
import labelTaskRemainingSingular from '@salesforce/label/c.x7sAdventureBannerPrgTaskSigular';
import labelAriaWrapper  from '@salesforce/label/c.x7sAdventureAriaLabelWrapper';
import labelOwner  from '@salesforce/label/c.x7sAdventureBannerOwnerText';
import labelExploreOtherAdventures  from '@salesforce/label/c.x7sAdventureBannerExploreAdventures';
import labelSource  from '@salesforce/label/c.x7sAdventureBannerSourceText';
import labelTaskCompleted  from '@salesforce/label/c.x7sAdventureBannerTaskCompletedText';

export default class X7sAdventureBanner extends NavigationMixin (LightningElement) {
	
	@api customClass = '';
	@api displayTitle = "true";
	@api displaySubTitle = false;
	@api displayDescription = false;
	@api variant = "None";
	@api showSource = "true";
	@api showOwner = "true";
	@api showTaskRemaining = "true";
	@api showPercentComplete = "true";
	@api showCloneButton = "true";
	@api cloneButtonLabel = "Clone";
	@api exploreOtherAdventuresAPI = "";
	@api showViewOtherAdventures = false;
	@api showTopics = false;
	@api listId = 'ID_1';

	@api adventure = [];
	@api numberOfTasksRemaining = 0;
	@api adventureProgress = 0;
	@api isLex = false;
	owner;
	sourceAdventure;
	topics;
	
	@wire(CurrentPageReference) pageRef;

	labels = {
		labelAriaWrapper,
		labelExploreOtherAdventures,
		labelOwner,
		labelSource,
		labelTaskCompleted
	};
	
	connectedCallback() {
		registerListener("adventureBanner", this.handleBanner, this);
	}
	
	disconnectedCallback() {
		unregisterAllListeners(this);
	}

	get showBanner() {
		return this.adventure;
	}

	get displayVariant() {
        return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
    }

	get title() {
		return this.displayTitle && this.adventure ? this.adventure.Title__c : '';
	}

	get subTitle() {
		return this.displaySubTitle && this.adventure ? this.adventure.Subtitle__c : '';
	}

	get description() {
		return this.displayDescription && this.adventure ? this.adventure.Description__c : '';
	}

	get displaySource() {
		return this.showSource && this.sourceAdventure;
	}

	get showMetaSlot() {
		return this.showSource || this.showOwner || this.showTaskRemaining;
	}

	get displayCloneButton() {
		return this.showCloneButton && this.recordId;
	}
	
    get tasksRemaining() {
		return this.numberOfTasksRemaining === 1 ? this.numberOfTasksRemaining + '  ' + labelTaskRemainingSingular : this.numberOfTasksRemaining + '  ' + labelTaskRemainingPlural;
	}
	
	get sectionClass() {
		return `x7s-adventure ${this.customClass}`;
	}

	get recordId() {
		return this.adventure ? this.adventure.Id : undefined;
	}

	get topicList() {
		return this.showTopics ? this.topics : '';
	}

	get taskCompletedPercentage() {
		return parseInt(this.adventureProgress);
	}
	
	handleBanner(event) {
		if (this.listId === event.id) {
			this.adventure = event.adventure;
			this.isLex = event.isLex;
			this.numberOfTasksRemaining = event.numberOfTasksRemaining;
			this.owner =  this.adventure && this.adventure.OwnerId ? this.adventure.Owner.Name : '';
			this.sourceAdventure = this.adventure && this.adventure.Source_Template__r ? this.adventure.Source_Template__r.Name : '';
			this.adventureProgress = !isNaN(event.adventureProgress) ? event.adventureProgress : 0;
			let topics = event.topics;
			this.topics = Object.keys(topics).map((key) => {
				return ({Name: topics[key], Id: key, Topic: {Id: key, Name: topics[key]}});
			});
		}
	}

	navigateToListView(){
		if(this.exploreOtherAdventuresAPI !== '' && this.exploreOtherAdventuresAPI !== undefined) {
			if (this.isLex) {
				this[NavigationMixin.Navigate]({
					  type: 'standard__navItemPage',
					  attributes: {
						 apiName: this.exploreOtherAdventuresAPI
					  }
				   });
			} else {
				this[NavigationMixin.Navigate]({
					type: 'comm__namedPage',
					attributes: {
						name: this.exploreOtherAdventuresAPI
					}
				});
			}
		} else {
			this[NavigationMixin.Navigate]({
				type: 'standard__objectPage',
				attributes: {
					objectApiName: 'X7S_Adventure__c',
					actionName: 'list'
				},
			});
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