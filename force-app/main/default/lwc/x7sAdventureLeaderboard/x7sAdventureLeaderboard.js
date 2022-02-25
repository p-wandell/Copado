/*
 * Copyright (c) 2021. 7summits Inc. All rights reserved.
*/

import {LightningElement, api, track, wire} from 'lwc';
import getLeaderboardData from '@salesforce/apex/x7sAdventureBaseController.getLeaderboardData';
import {fireEvent, inLexMode} from "c/x7sShrUtils";
import {CurrentPageReference} from 'lightning/navigation';
import labelAria from '@salesforce/label/c.x7sAdventureLeaderboardAriaLabel';

export default class X7sAdventureLeaderboard extends LightningElement {

    @api variant = "None";
    @api titletext = "Adventure Leaderboard";
    @api subtitletext;
    @api headeralign = "Center";
    @api sourceAdventureId;
    @api showInactiveAdventures = false;
    @api numberOfRecords = 10;
    @api height = "400px";
    @api defaultSort = "Task Percent Complete Descending";
    @api customClass = "";
    
    @api ownerImageLabel = "Image";
    @api ownerIconShape = "Square";
    @api ownerIconSize = "Medium";
    @api ownerNameLabel = "Owner";
    @api adventureNameLabel = 'Name';
    @api adventureTitleLabel = "Title";
    @api adventureDetailPageURL = 'x7s-adventure';
    @api activeFlagLabel = "Active";
    @api taskPercentCompletedLabel = "% Tasks Completed";
    @api completedTaskNumLabel = "Completed Tasks";
    @api modulePercentCompletedLabel = "% Modules Completed";
    @api completedModulesNumLabel = "Modules Completed";
    @api lastActivityLabel = "Last Activity";
    @api showAdventuresTitleLink = false;
    @api showAdventuresNameLink = false;

    @track tableData = [];
    @track columns = [];
    sortBy;
	sortDirection;
    adventureListSize = 0;
    sitePath;

    @wire(CurrentPageReference) pageRef;

    label = {labelAria};

    connectedCallback() {
        this.getAdventureList();
    }

    renderedCallback() {
		fireEvent(this.pageRef, "imagevariant", {size: this.ownerIconSize, shape: this.ownerIconShape});
	}

    get displayVariant() {
        return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
    }

    get titleAlignment() {
        return this.headeralign === 'Left' ? 'left' : this.headeralign === 'Right' ? 'right' : 'center';
    }

    get adjustHeight() {
		return `height: ${this.height};`;
	}

    get showTable() {
        return this.adventureListSize > 0;
    }

    get titleColumnType() {
        return this.showAdventuresTitleLink ? 'url': 'text';
    }

    get titleFieldName() {
        return this.showAdventuresTitleLink ? 'adventuretitleurl' : 'adventuretitle';
    }

    get nameColumnType() {
        return this.showAdventuresNameLink ? 'url': 'text';
    }

    get nameFieldName() {
        return this.showAdventuresNameLink ? 'adventuretitleurl' : 'adventurename';
    }

    get autoSlds() {
        return inLexMode();
    }

    // The method on sort event handler
	doSorting(event) {
		this.sortBy = event.detail.fieldName;
		this.sortDirection = event.detail.sortDirection;
		this.sortData(this.sortBy, this.sortDirection);
	}
	
	sortData(fieldName, direction) {
		let parseData = JSON.parse(JSON.stringify(this.tableData));
		
		// Return the value stored in the field
		let keyValue = (a) => {
			return a[fieldName];
		};
		
		// checking reverse direction
		let isReverse = direction === 'asc' ? 1 : -1;
		
		// sorting data
		parseData.sort((x, y) => {
			x = keyValue(x) ? keyValue(x) : ''; // handling null values
			y = keyValue(y) ? keyValue(y) : '';
			// sorting values based on direction
			return isReverse * ((x > y) - (y > x));
		});
		
		this.tableData = parseData;
	}

    getAdventureList() {
        getLeaderboardData({
            sourceAdventureId: this.sourceAdventureId,
            numberOfRecords: this.numberOfRecords,
            showInactiveAdventures: this.showInactiveAdventures,
            sortBy: this.defaultSort
        })
            .then(result => {   

                let baseUrl = 'https://'+location.host+'/';

                if(result) {
                    if(result.adventureWrapper && result.adventureWrapper.length > 0) {
                        this.adventureListSize = result.adventureWrapper.length;
                        this.sitePath = result.sitePrefix;

                        result.adventureWrapper.forEach((row) => {
                            let rowData = {};
                            let adventure = row.adventure;
                            rowData.active = adventure.Active__c;
                            rowData.ownername = adventure.OwnerId  ? adventure.Owner.Name : '';
                            rowData.adventurename = adventure.Name;
                            rowData.adventuretitle = adventure.Title__c;
                            rowData.completedtaskpercent = parseInt(adventure.Task_Progress__c)/100;
                            rowData.numberofcompletedtask = adventure.Number_of_Completed_Tasks__c;
                            rowData.numberofcompletedmodule = adventure.Number_of_Completed_Modules__c;
                            rowData.completedmodulepercent = parseInt(adventure.Module_Progress__c)/100;
                            rowData.lastupdateddate = adventure.LastModifiedDate;
                            rowData.profile_url = row.ownerSmallPhotoURL;
                            if(inLexMode()) {
                                rowData.adventuretitleurl = baseUrl + adventure.Id;
                                rowData.ownerprofileurl = adventure.OwnerId  ?  baseUrl + adventure.Owner.Id : '';
                            } else {
                                rowData.ownerprofileurl = adventure.OwnerId  ? this.sitePath + '/profile/' + adventure.Owner.Id : '';
                                rowData.adventuretitleurl = baseUrl + this.sitePath + '/' + this.adventureDetailPageURL + '/' +adventure.Id;
                            }
                            this.tableData.push(rowData);
                        });

                        this.columnWrapper();
                    }
                }
            })
            .catch(error => {
                console.error('Error occurred while getting leaderboard data:'+JSON.stringify(error));
            })
    }

    columnWrapper() {

        if (this.ownerImageLabel !== '' && this.ownerImageLabel !== undefined) {
			this.columns.push({
				label: this.ownerImageLabel,
				fieldName: 'profile_url',
				type: 'image',
                cellAttributes: {
                    alignment: 'center',
                },
                hideDefaultActions: true
			});
		}

        if (this.ownerNameLabel !== '' && this.ownerNameLabel !== undefined) {
			this.columns.push({
				label: this.ownerNameLabel,
				fieldName: 'ownerprofileurl',
                type: 'url',
				sortable: true,
                typeAttributes: {
					label: {
						fieldName: 'ownername'
					},
					target: '_self'
				},
                cellAttributes: {alignment: 'left'},
                hideDefaultActions: true
			});
		}

        if (this.activeFlagLabel !== '' && this.activeFlagLabel !== undefined) {
			this.columns.push({
				label: this.activeFlagLabel,
				fieldName: 'active',
                type: 'boolean',
				sortable: true,
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true
			});
		}
        if (this.adventureNameLabel !== '' && this.adventureNameLabel !== undefined) {
			this.columns.push({
				label: this.adventureNameLabel,
				fieldName: this.nameFieldName,
                type: this.nameColumnType,
				sortable: true,
                typeAttributes: {
					label: {
						fieldName: 'adventurename'
					},
					target: '_self'
				},
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true
			});
		}
        if (this.adventureTitleLabel !== '' && this.adventureTitleLabel !== undefined) {
			this.columns.push({
				label: this.adventureTitleLabel,
				fieldName: this.titleFieldName,
                type: this.titleColumnType,
				sortable: true,
                typeAttributes: {
					label: {
						fieldName: 'adventuretitle'
					},
					target: '_self'
				},
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true
			});
		}
        if (this.taskPercentCompletedLabel !== '' && this.taskPercentCompletedLabel !== undefined) {
			this.columns.push({
				label: this.taskPercentCompletedLabel,
				fieldName: 'completedtaskpercent',
                type: 'percent',
				sortable: true,
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true
			});
		}
        if (this.completedTaskNumLabel !== '' && this.completedTaskNumLabel !== undefined) {
			this.columns.push({
				label: this.completedTaskNumLabel,
				fieldName: 'numberofcompletedtask',
                type: 'number',
				sortable: true,
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true
			});
		}
        if (this.modulePercentCompletedLabel !== '' && this.modulePercentCompletedLabel !== undefined) {
			this.columns.push({
				label: this.modulePercentCompletedLabel,
				fieldName: 'completedmodulepercent',
                type: 'percent',
				sortable: true,
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true
			});
		}
        if (this.completedModulesNumLabel !== '' && this.completedModulesNumLabel !== undefined) {
			this.columns.push({
				label: this.completedModulesNumLabel,
				fieldName: 'numberofcompletedmodule',
                type: 'number',
				sortable: true,
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true
			});
		}
        if (this.lastActivityLabel !== '' && this.lastActivityLabel !== undefined) {
			this.columns.push({
				label: this.lastActivityLabel,
				fieldName: 'lastupdateddate',
                type: "date",
                typeAttributes:{
                    year: "numeric",
                    month: "long",
                    day: "2-digit",
                    hour: "2-digit",
                    minute: "2-digit" },
				sortable: true,
				cellAttributes: {alignment: 'left'},
				hideDefaultActions: true,
                columnWidthsMode: "auto"
			});
		}
    }
    
}