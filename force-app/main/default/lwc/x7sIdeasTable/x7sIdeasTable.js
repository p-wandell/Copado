/*
 * Copyright (c) 2021. 7Summits Inc.
 */
import { LightningElement,api,wire,track } from 'lwc';
import {registerListener,formatText,inLexMode,showToast,unregisterAllListeners} from "c/x7sShrUtils";
import {CurrentPageReference,NavigationMixin} from 'lightning/navigation';
import isRecordEditable from '@salesforce/apex/x7sIdeasViewController.isRecordEditable';
import isRecordDeletable from '@salesforce/apex/x7sIdeasViewController.isRecordDeletable';
import deleteIdea from '@salesforce/apex/x7sIdeasViewController.deleteIdea';
import labelAriaWrapper from "@salesforce/label/c.x7sIdeasAriaLabelWrapper";
import labelEdit from '@salesforce/label/c.x7sIdeasTableEditLabel';
import labelDelete from '@salesforce/label/c.x7sIdeasTableDeleteLabel';
import labelDeleteConfirmMsg from "@salesforce/label/c.x7sIdeasDetailRemoveThisRecord";
import labelDeleteRecordToast from "@salesforce/label/c.x7sIdeasDetailLabelDeleted";
import labelDeleteRecordFailed from "@salesforce/label/c.x7sIdeasDetailErrorDelete";
import setVote from '@salesforce/apex/x7sIdeasViewController.vote';
import deleteVote from '@salesforce/apex/x7sIdeasViewController.deleteVote';
import labelUpVoted from "@salesforce/label/c.x7sIdeasVoted";
import labelDownVoted from "@salesforce/label/c.x7sIdeasVoteButtonsLabelDownVoted";
import labelVoteUp from "@salesforce/label/c.x7sIdeasVote";
import labelVoteDown from "@salesforce/label/c.x7sIdeasVoteDown";
import labelVoteClear from "@salesforce/label/c.x7sIdeasVoteClear";
import {action,custom} from 'c/x7sIdeasBase';
import currentUserId from '@salesforce/user/Id';

export default class X7sIdeasTable extends NavigationMixin(LightningElement) {

    @api listId;
    @api result;
    @api item;
    @api showTitle = "true";
    @api showDescription;
    @api customClass;
    @api variant;
    @api showEdit;
    @api showDelete;
    @api showStatus;
    @api showTopic;
    @api showVote;
    @api showRemoveVote;
    @api displayPostDateAuthor;
    @api ideaNewUrl = "new_Idea__c"; // Lex: x7s_New_Idea,Community :new_Idea__c 
    @api ideaDetailUrl='';

    columns = [];
    @track data = [];
    totalItems=0;
    tableItems;
    labels = {
        labelAriaWrapper
    }
    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        this.tableItems=this.result;
        this.getTableData();
        registerListener("TableViewData", this.dataHandle, this);
    }
    disconnectedCallback() {
		// unsubscribe from all event
		unregisterAllListeners(this);
	}
    get autoSlds(){
		return inLexMode();
    }
    get isItemAvailable(){
        return this.totalItems > 0;
    }
    get viewVariant(){
		return (this.variant === 'None') ? 'default' : 'featured';
	}
    getTableData(){
        let currentData = [];
        let baseUrl = 'https://'+location.host+'/';
        if(this.tableItems && this.tableItems.totalResults > 0 ){
            this.tableItems.ideaList.forEach((row) => {
                this.totalItems = this.tableItems.totalResults;
                let rowData = {};
                    if(row.Id){
                        rowData.ideaId = row.Id;
                        rowData.Title = row.Title;
                        rowData.TitleUrl = inLexMode() ? custom.urlParams.lexPrefix + this.ideaDetailUrl + '?' + custom.urlParams.lexRecordId + '=' + row.Id : baseUrl+row.Id;
                        rowData.Description = this.getHtmlPlainText(row.Body);
                        rowData.Status = row.Status;
                        rowData.Topic = row.Related_Topic_Name__c;
                        rowData.createdBy = row.CreatedBy.Name;
                        rowData.postedDate = new Date(row.fromNow);
                        rowData.enableVote = row.enableVote;
                        rowData.voteType = row.Votes ? row.Votes[0].Type : undefined;
                        rowData.voteId = rowData.voteType ? row.Votes[0].Id : undefined;
                        rowData.createdById = row.CreatedBy.Id;
                    }
                currentData.push(rowData);
                this.data = currentData;
                });

                this.showTitle ? this.columns.push({label:'Title',fieldName:'TitleUrl',type:'url',typeAttributes: {label: {fieldName: 'Title'},target : '_self'}}) : '';
                this.showDescription ? this.columns.push({label: 'Description', fieldName: 'Description', type: 'text'}) : '';
                this.showStatus ? this.columns.push({label: 'Status', fieldName: 'Status', type: 'text'}) : '';
                this.showTopic ? this.columns.push({label: 'Topic', fieldName: 'Topic', type: 'text'}) : '';
                this.displayPostDateAuthor ? this.columns.push({label: 'Author', fieldName: 'createdBy', type: 'text'}) : '';
                this.displayPostDateAuthor ? this.columns.push({label: 'Posted Date', fieldName: 'postedDate', type: 'date',typeAttributes : {year:"numeric",month:"2-digit",day:"2-digit"}}) : '';
                this.columns.push({ type: 'action', typeAttributes: { rowActions: this.getRowActions.bind(this) } });}
    }
    
    async getRowActions(row, doneCallback) {
        let id = row.ideaId;
        let voteId = row.voteId;
        let hasEdit = await this.isRecEdit(id);
        let hasDelete = await this.isRecDelete(id);
        let enableVote = row.enableVote;
        let voteType = row.voteType;
        let createdById = row.createdById;

        let displayVoteClear = (this.showVote && this.showRemoveVote && voteId) && (createdById!==currentUserId);
        let actions = [];
        this.showEdit && hasEdit ? actions.push({ label: labelEdit, name: action.EDIT }) :'';
        this.showDelete && hasDelete ? actions.push({ label: labelDelete, name: action.DELETE }) : '' ;
        this.showVote && voteType === 'Up' ? actions.push({ label: labelUpVoted, name: '',disabled : true }) :'';
        this.showVote && voteType === 'Down' ? actions.push({ label: labelDownVoted, name: '',disabled : true }) :'';
        (this.showVote && enableVote && voteType === undefined) ? actions.push({ label: labelVoteUp, name: action.VOTEUP }) :'';
        (this.showVote && enableVote && voteType === undefined) ? actions.push({ label: labelVoteDown, name: action.VOTEDOWN }) :'';
        displayVoteClear ? actions.push({ label: labelVoteClear, name: action.VOTEDELETE}) :'';

        doneCallback(actions);
    }
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case action.DELETE:
                this.deleteRow(row);
                break;
            case action.EDIT:
                this.editRow(row);
                break;
            case action.VOTEUP:
                this.handleVoteUp(row);
                break;
            case action.VOTEDOWN:
                this.handleVoteDown(row);
                break;
            case action.VOTEDELETE:
                this.handleVoteClear(row);
            break;
            default:
        }
    }
    deleteRow(row) {
        let id = row.ideaId;
		if (confirm(formatText(labelDeleteConfirmMsg))) {
			
			deleteIdea({
				ideaId: id
			})
				.then(result => {
					let deleteToast = labelDeleteRecordToast.replace('{0}', row.Title);
                    showToast(labelDelete, deleteToast, 'success', 'dismissable');
                    eval("$A.get('e.force:refreshView').fire();");
				})
				.catch(error => {
					console.error("Error occurred deleting Idea:" + error);
					
					let deleteFailed = labelDeleteRecordFailed
						.replace('{0}', row.Title)
						.replace('{1}', error[0]);
					showToast(labelDelete, deleteFailed, 'error', 'dismissable');
				})
		}     
    }
    editRow(row) {
        let id = row.ideaId;
		let url = this.ideaNewUrl;
		
		if (url) {
			let pageRef = inLexMode() ? {
				type: 'standard__webPage',
				attributes: {
					url: custom.urlParams.lexPrefix + url + '?' + custom.urlParams.lexRecordId + '=' + id
				},
				state: {
					'ideaId': id,
					'isEdit': true
				}
			} : {
				type: 'comm__namedPage',
				attributes: {
					name: url
				},
				state: {
					'ideaId': id,
					'isEdit': true
				}
			};
			
			this[NavigationMixin.Navigate](pageRef);
		}
	}
    handleVoteUp(row) {
		this.submitVote(true,row);
    }
    handleVoteDown(row) {
		this.submitVote(false,row);
    }
    handleVoteClear(row){
        this.clearVote(row.voteId);
    }
    checkIsRecordEditable(recordId) {
        return new Promise((resolve, reject) => {
            isRecordEditable({
                recordId: recordId
            })
            .then(result => {
                let hasEdit = result;
                resolve(hasEdit);
            })
            .catch(error => {
                reject(error);
            });
         });
	}
	
	checkIsRecordDeletable(recordId) {
		return new Promise((resolve, reject) => {
            isRecordDeletable({
              recordId: recordId
            })
            .then(result => {
                resolve(result);
            })
            .catch(error => {
                let errors = error;
                reject(errors);
            })
        });
    }
    submitVote(isUp,row) {
        let id = row.ideaId;
            setVote({
                recordId: id,
                isUp: isUp
            })
            .then(vote => {
                let currentVote = vote;
                eval("$A.get('e.force:refreshView').fire();");
            })
            .catch(error => {
                let errors = error;
            });
    }
    clearVote(voteId){
        deleteVote({
            recordId: voteId
        })
        .then(vote => {
            let currentVote = vote;
            if(currentVote){
                showToast(labelDelete, 'Vote', 'success', 'dismissable');
                eval("$A.get('e.force:refreshView').fire();");
            }else{
                showToast(labelDelete, 'Unable to Delete', 'error', 'dismissable');
            }
        })
        .catch(error => {
            let errors = error;
        });
    }
    async isRecEdit(recId){
        const result = await this.checkIsRecordEditable(recId);
        return result;
    }
    async isRecDelete(recId){
        const result = await this.checkIsRecordDeletable(recId);
        return result;
    }
    getHtmlPlainText(htmlString) {
		return htmlString.replace(/<[^>]+>/g, '');
    }
    dataHandle(event){
        this.data=[];
        this.columns=[];
        this.tableItems = event.value;
        this.totalItems= this.tableItems.totalResults;
        this.getTableData();
    }
}