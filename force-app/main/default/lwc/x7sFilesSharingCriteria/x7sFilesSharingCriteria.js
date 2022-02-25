/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import {api, LightningElement, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";

import {showToast} from "c/x7sShrUtils";
import {criteriaActions} from "c/x7sFilesBase";

import getBaseUrl from '@salesforce/apex/x7sFilesController.getBaseUrl';
import getAllSettings from '@salesforce/apex/x7sFilesShareController.getFolderSettings';
import getCriteriaValues from '@salesforce/apex/x7sFilesController.getCriteriaValues';
import getFolder from '@salesforce/apex/x7sFilesController.getFolder';
import shareFolder from '@salesforce/apex/x7sFilesShareController.shareCurrentFolder';
import saveFolder from '@salesforce/apex/x7sFilesShareController.updateFolderSetting';

import noResultLabel from '@salesforce/label/c.x7sFilesListViewNoResultLabel';
import labelView from '@salesforce/label/c.x7sFilesCriteriaActionLabelView';
import labelCMTView from '@salesforce/label/c.x7sFilesCriteriaLabelCMTSetup';
import labelSettings from '@salesforce/label/c.x7sFilesLabelCriteriaSettings';
import labelNone from '@salesforce/label/c.x7sFilesSettingsSelectLabelNone';
import labelShare from '@salesforce/label/c.x7sFilesCriteriaActionLabelShare';
import labelLogic from '@salesforce/label/c.x7sFilesCriteriaLabelLogic';
import tooltipShare from '@salesforce/label/c.x7sFilesCriteriaActionTooltipShare';
import labelSave from '@salesforce/label/c.x7sFilesSettingsButtonSave';
import tooltipSave from '@salesforce/label/c.x7sFilesSettingsTooltipSave';
import labelAriaCriteria from '@salesforce/label/c.x7sFilesSharingCriteriaAriaLabel';

import labelCriteriaId from '@salesforce/label/c.x7sFilesCriteriaLabelId';
import labelCriteriaObject from '@salesforce/label/c.x7sFilesCriteriaLabelObject';
import labelCriteriaField from '@salesforce/label/c.x7sFilesCriteriaLabelField';
import labelCriteriaOperator from '@salesforce/label/c.x7sFilesCriteriaLabelOperator';
import labelCriteriaValue from '@salesforce/label/c.x7sFilesCriteriaLabelValue';
import shareToastTitle from '@salesforce/label/c.x7sFilesCriteriaShareToastTitle';
import shareToastMessage from '@salesforce/label/c.x7sFilesCriteriaShareToastMessage';
import shareToastError from '@salesforce/label/c.x7sFilesCriteriaShareToastError';
import saveToastTitle from '@salesforce/label/c.x7sFileSettingsSaveToastTitle';
import saveToastMessage from '@salesforce/label/c.x7sFileSettingsSaveToastMessage'

export default class X7SFilesSharingCriteria extends NavigationMixin(LightningElement) {
	@api recordId = "";
	@api customClass = '';
	@api listId = "ID_1";
	@api tileVariant = 'None';
	@api showTitle = false;
	@api title = '';
	@api showIcon = false;
	@api iconName = 'utility:socialshare';
	@api iconSize = 'small';
	
	criteriaId = '';
	columns = [];
	data = [];
	totalItems = 0;
	showActionView = true;
	
	baseUrl = '';
	metadataPrefix = '/lightning/setup/CustomMetadata/page?address=%2F';
	metadataSetup = '/lightning/setup/CustomMetadata/home';
	
	setting = '';
	settings = [];
	settingId = '';
	currentSettingId = '';
	settingLogic = '';
	settingCustom = '';
	
	@wire(CurrentPageReference) pageRef;
	
	labels = {
		labelAriaCriteria, noResultLabel, labelView, labelCMTView, labelSettings, labelNone,
		labelShare, tooltipShare,
		labelLogic,
		shareToastTitle, shareToastMessage, shareToastError,
		labelSave, tooltipSave,
		saveToastTitle, saveToastMessage
	}
	
	get componentClass() {
		return `x7s-files-sharing-list ${this.customClass}`;
	}
	
	get viewVariant() {
		return (this.tileVariant === 'None') ? 'default' : this.tileVariant === 'Featured' ? 'featured' : 'slds-card';
	}
	
	get defaultLogic() {
		return this.settingLogic;
	}
	
	get customLogic() {
		return this.settingCustom;
	}
	
	get isItemAvailable() {
		//return this.totalItems > 0;
		return true;
	}
	
	get disableSave() {
		return this.currentSettingId === this.settingId;
	}
	
	get showSettingNavigation() {
		return this.settingId;
	}
	
	connectedCallback() {
		this.getOrgBaseUrl();
		this.getColumnData();
		this.getSharingData();
		this.getSettingsList();
	}
	
	handleRowAction(event) {
		const actionName = event.detail.action.name;
		const row = event.detail.row;
		switch (actionName) {
			case criteriaActions.VIEW:
				this.actionViewRow(row.id);
				break;
		}
	}
	
	
	actionViewRow(id) {
		const actionUrl = this.baseUrl + this.metadataPrefix + id;
		this.navigateToUrl(actionUrl);
	}
	
	navigateToCustomMetadataSetup() {
		this.navigateToUrl(this.metadataSetup);
	}
	
	navigateToUrl(actionUrl) {
		this[NavigationMixin.GenerateUrl]({
			type: 'standard__webPage',
			attributes: {
				url: actionUrl
			}
		}).then(url => {
			window.open(url, "_blank");
		});
	}
	
	navigateToSetting() {
		this.actionViewRow(this.criteriaId);
	}
	
	handleSettingSelection(event) {
		this.settingId = event.detail.value;
		this.getCriteriaValues();
	}
	
	handleSaveSettings() {
		saveFolder({folderId: this.recordId, settingId: this.settingId})
			.then(result => {
				if (result) {
					showToast(this.labels.saveToastTitle, this.labels.saveToastMessage, 'info');
					this.getSharingData();
					this.applyFolderShare();
				}
			})
			.catch(error => {
				console.error(error);
			});
	}
	
	handleFolderShare() {
		if (this.recordId) {
			this.applyFolderShare();
		}
	}
	
	applyFolderShare() {
		shareFolder({folderId: this.recordId})
			.then((result) => {
				showToast(this.labels.shareToastTitle, result ? this.labels.shareToastMessage : this.labels.shareToastError, result ? 'info' : 'error');
			})
			.catch(error => {
				showToast(this.labels.shareToastTitle, this.labels.shareToastError, 'error');
				console.error(JSON.stringify(error));
			});
	}
	
	getSettingsList() {
		getAllSettings()
			.then(settingResult => {
				this.setSettings(settingResult);
			})
			.catch(error => {
				console.error(error);
			});
	}
	
	setSettings(settingResult) {
		let settingList = [];
		
		settingList.push({label: this.labels.labelNone, value: ''});
		
		for (let settingKey in settingResult) {
			if (settingResult.hasOwnProperty(settingKey)) {
				settingList.push({label: settingResult[settingKey], value: settingKey});
			}
		}
		
		this.settings = settingList;
	}
	
	getSharingData() {
		if (this.recordId) {
			getAllSettings()
				.then(settingResult => {
					this.setSettings(settingResult);
					getFolder({recordId: this.recordId})
						.then(result => {
							if (result !== null) {
								this.currentSettingId = this.settingId = result.sharingSetting ? result.sharingSetting : '';
								this.getCriteriaValues();
							}
						})
						.catch(error => {
							console.error(error);
						});
				});
		}
	}
	
	getCriteriaValues() {
		getCriteriaValues({settingId: this.settingId})
			.then(model => {
				let dataSet = [];
				
				if (model) {
					this.criteriaId = model.id;
					this.settingLogic = model.defaultLogic || 'AND';
					this.settingCustom = model.customLogic;
					model.criteriaFieldList.forEach(criteriaEntry => {
						let rowEntry = {};
						rowEntry.id = criteriaEntry.id;
						rowEntry.criteriaId = criteriaEntry.logicId;
						rowEntry.criteriaObject = this.getLastEntry(criteriaEntry.fieldName, 2);
						rowEntry.criteriaField = this.getLastEntry(criteriaEntry.fieldName, 1);
						rowEntry.criteriaOperator = criteriaEntry.operator;
						rowEntry.criteriaValue = criteriaEntry.fieldValue;
						
						dataSet.push(rowEntry);
					});
				} else {
					this.settingLogic = '';
					this.settingCustom = '';
				}
				this.data = dataSet;
				this.totalItems = dataSet.length;
			})
			.catch(error => {
				console.error(error);
			});
	}
	
	getLastEntry(fullEntry, endPos) {
		let entries = fullEntry.split(/\./);
		return entries.length >= endPos ? entries[entries.length - endPos] : fullEntry;
	}
	
	getColumnData() {
		this.columns.push({
			label: labelCriteriaId,
			fieldName: 'criteriaId',
			type: 'string',
			typeAttributes: {label: {fieldName: 'criteriaId'}, target: '_self'},
			hideDefaultActions: true
		});
		this.columns.push({
			label: labelCriteriaObject,
			fieldName: 'criteriaObject',
			type: 'string',
			typeAttributes: {label: {fieldName: 'criteriaObject'}, target: '_self'},
			hideDefaultActions: true
		});
		this.columns.push({
			label: labelCriteriaField,
			fieldName: 'criteriaField',
			type: 'string',
			typeAttributes: {label: {fieldName: 'criteriaField'}, target: '_self'},
			hideDefaultActions: true
		});
		this.columns.push({
			label: labelCriteriaOperator,
			fieldName: 'criteriaOperator',
			type: 'string',
			typeAttributes: {label: {fieldName: 'criteriaOperator'}, target: '_self'},
			hideDefaultActions: true
		});
		this.columns.push({
			label: labelCriteriaValue,
			fieldName: 'criteriaValue',
			type: 'string',
			typeAttributes: {label: {fieldName: 'criteriaValue'}, target: '_self'},
			hideDefaultActions: true
		});
		this.columns.push({type: 'action', typeAttributes: {rowActions: this.getRowActions.bind(this)}});
	}
	
	async getRowActions(row, doneCallback) {
		let actions = [];
		this.showActionView ? actions.push({label: labelView, name: criteriaActions.VIEW}) : '';
		doneCallback(actions);
	}
	
	getOrgBaseUrl() {
		getBaseUrl().then(result => {
			if (result) {
				this.baseUrl = result;
			}
		});
	}
}