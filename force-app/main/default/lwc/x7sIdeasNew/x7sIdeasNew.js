/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {api, LightningElement, track, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';

import {custom, updateIdeaValues} from "c/x7sIdeasBase";
import {fireEvent, inLex, inLexMode, registerListener, showToast, unregisterAllListeners} from 'c/x7sShrUtils';

import checkDuplicateIdeas from "@salesforce/apex/x7sIdeasNewController.checkDuplicateIdeas";
import getIdeasNewModel from "@salesforce/apex/x7sIdeasNewController.getIdeasNewModel";
import getIdeaRecord from "@salesforce/apex/x7sIdeasNewController.getIdeaRecord";
import getRequestedByRecord from "@salesforce/apex/x7sIdeasNewController.getRequestedByRecord";
import getModel from "@salesforce/apex/x7sIdeasBaseController.getModel";
import createIdeaNew from "@salesforce/apex/x7sIdeasNewController.createIdeaNew";

import idea_label_spinnerSaving from "@salesforce/label/c.x7sIdeasNewLabelSpinnerSaving";
import idea_label_Title from "@salesforce/label/c.x7sIdeasNewLabelTitle";
import idea_error_titleTooShort from "@salesforce/label/c.x7sIdeasNewValErrTitleTooShort";
import idea_error_titleTooLong from "@salesforce/label/c.x7sIdeasNewValErrTitleTooLong";
import idea_error_titleEntry from "@salesforce/label/c.x7sIdeasNewValErrTitleEntry";
import idea_label_AlreadySubmitted from "@salesforce/label/c.x7sIdeasNewValErrAlreadySubmitted";
import idea_label_points from "@salesforce/label/c.x7sIdeasVotePoints";
import idea_label_Describe from "@salesforce/label/c.x7sIdeasNewLabelDescribe";
import idea_tooltip_UploadImage from "@salesforce/label/c.x7sIdeasNewTooltipUploadImage";
import idea_label_UploadImage from "@salesforce/label/c.x7sIdeasNewLabelUploadImage";
import idea_error_descriptionEntry from "@salesforce/label/c.x7sIdeasNewValErrDescriptionEntry";
import idea_label_ChooseFile from "@salesforce/label/c.x7sIdeasNewLabelChooseFile";
import idea_label_ChooseTheme from "@salesforce/label/c.x7sIdeasNewLabelChooseTheme";
import idea_label_PickTopic from "@salesforce/label/c.x7sIdeasNewLabelPickTopic";
import idea_label_Status from "@salesforce/label/c.x7sIdeasFilterLabelStatus";
import idea_label_SelectCategory from "@salesforce/label/c.x7sIdeasNewLabelSelectCategory";
import idea_label_StatusComment from "@salesforce/label/c.x7sIdeasNewLabelStatusComment";
import idea_error_statusComment from "@salesforce/label/c.x7sIdeasNewValErrStatusComment";
import idea_tooltip_UploadRelated from "@salesforce/label/c.x7sIdeasTooltipFileUploadRelated";
import idea_label_UploadRelated from "@salesforce/label/c.x7sIdeasNewUploadRelated";
import idea_label_Submit from "@salesforce/label/c.x7sIdeasNewButtonSubmit";
import idea_tooltip_Submit from "@salesforce/label/c.x7sIdeasNewTooltipSubmit";
import idea_label_Cancel from "@salesforce/label/c.x7sIdeasNewButtonCancel";
import idea_label_RequestedBy from "@salesforce/label/c.x7sIdeasNewLabelRequestedBy";
import idea_labelEdit from "@salesforce/label/c.x7sIdeasNewLabelEdit";
import idea_tooltip_Cancel from "@salesforce/label/c.x7sIdeasNewTooltipCancel";
import labelNewIdeaAria from "@salesforce/label/c.x7sIdeasNewAriaLabel";

export default class X7sIdeasNew extends NavigationMixin(LightningElement) {
	
	@api zoneName = "Internal Zone";
	@api headingTitle = "New Idea";
	@api variant = "featured";
	@api headerAlignment = "center";
	@api categoriesAllowed = '';
	@api statusAllowed = '';
	@api useTopics = 'true';
	@api editStatus = 'true';
	@api topicRequired = 'true';
	@api allowThemes = 'true';
	@api allowCategories = 'true';
	@api showDuplicates = 'true';
	@api requireComment = false;
	@api ideaListURL = 'X7S_Idea__c';
	@api ideaDetailURL = 'X7S_Idea_Detail__c';
	@api allowImages = 'true';
	@api attachmentAccept = 'png,jpg,jpeg,gif';
	@api simIdeasLimit = '5';
	@api showRelatedFiles = 'true';
	@api relatedFilesAccept = '.png, .jpg, .jpeg, .gif, .pdf';
	@api showCustomFields = 'true';
	@api customFieldSetName;
	@api presetField = '';
	@api presetValue = '';
	@api showRequestedBy = false;
	@api topicSet = '';
	@api customClass = '';
	@api listId = '';
	@api currIdea = {'sobjectType': 'Idea', 'Title': ''};
	@api createIdeaClick = false;
	@api selectedUser;
	@api isNewIdea = "true";
	@api showCross = "true";
	
	ss_idea_label_Title = idea_label_Title;
	ss_idea_error_titleTooLong = idea_error_titleTooLong;
	ss_idea_error_titleEntry = idea_error_titleEntry;
	ss_idea_label_AlreadySubmitted = idea_label_AlreadySubmitted;
	ss_idea_label_points = idea_label_points;
	errorShortTitle = idea_error_titleTooShort;
	ss_idea_label_Describe = idea_label_Describe;
	ss_idea_error_descriptionEntry = idea_error_descriptionEntry;
	ss_idea_label_UploadImage = idea_label_UploadImage;
	ss_idea_tooltip_UploadImage = idea_tooltip_UploadImage;
	ss_idea_label_ChooseFile = idea_label_ChooseFile;
	ss_idea_label_ChooseTheme = idea_label_ChooseTheme;
	ss_idea_label_PickTopic = idea_label_PickTopic;
	ss_idea_label_SelectCategory = idea_label_SelectCategory;
	ss_idea_label_Status = idea_label_Status;
	ss_idea_label_StatusComment = idea_label_StatusComment;
	ss_idea_error_statusComment = idea_error_statusComment;
	ss_idea_tooltip_UploadRelated = idea_tooltip_UploadRelated;
	ss_idea_label_UploadRelated = idea_label_UploadRelated;
	ss_idea_label_Submit = idea_label_Submit;
	ss_idea_tooltip_Submit = idea_tooltip_Submit;
	ss_idea_label_Cancel = idea_label_Cancel;
	ss_idea_tooltip_Cancel = idea_tooltip_Cancel;
	ss_idea_label_RequestedBy = idea_label_RequestedBy;
	labelAria = labelNewIdeaAria;
	
	recordId;
	zoneId = '';
	showSpinner = false;
	spinnerText = idea_label_spinnerSaving;
	minTitleLength = 2;
	maxTitleLength = 80;
	
	@track ideasList = [];
	@track customFields;
	@track themeSet = [];
	topicNamesList = [];
	predefinedTopic = '';
	categoriesSet = [];
	statusSet = [];
	isEditing = false;
	sitePrefix;
	maxFileSizeKb = "4248";
	attachmentUpload;
	attachmentName;
	validComment = true;
	relatedNames;
	relatedFilesUpload;
	validDescription = true;
	currentStatus = '';
	baseModel;
	ideaDetails;
	relatedFiles = {'sobjectType': 'RelatedFiles', 'files': []};
	relatedFile = {'sobjectType': 'RelatedFile', 'name': ''};
	
	reqrichtextVal;
	richtextVal;
	textVal;
	textareaVal;
	dateVal;
	datetimeVal;
	currencyVal;
	numberVal;
	percentVal;
	emailVal;
	phoneVal;
	checkboxVal;
	picklistVal;
	validField = true;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		this.baseModalNamespace();
		let editUrl = window.location.href;
		let newURL = new URL(editUrl).searchParams;
		let recordId = newURL.get(inLexMode() ? custom.urlParams.lexRecordId : "ideaId");
		let topicName = newURL.get("topic");
		this.predefinedTopic = decodeURI(topicName);
		
		if (recordId) {
			this.showSpinner = true;
			this.recordId = recordId;
			this.isEditing = true;
			this.headingTitle = idea_labelEdit;
		}
		
		// do not load Topics, Categories or Status if specified in the builder
		let useTopics = this.useTopics && !this.topicSet;
		let useCategories = this.allowCategories && this.categoriesAllowed === '';
		let useStatus = this.statusAllowed === '';
		
		getIdeasNewModel({
			zoneName: this.zoneName,
			fieldSetName: this.customFieldSetName,
			useTopics: useTopics,
			useCategories: useCategories,
			useStatus: useStatus
		})
			.then(result => {
				let model = result;
				this.maxFileSizeKb = model.maxFileSizeKb;
				// get the intersect between builder and community allowed file extensions
				if (model.allowedExtensions) {
					this.relatedFilesAccept = this.getAllowedExtensions(model.allowedExtensions, this.relatedFilesAccept);
					this.attachmentAccept = this.getAllowedExtensions(model.allowedExtensions, this.attachmentAccept);
				}
				const settings = model.settings;
				
				this.zoneId = settings.zoneId;
				this.sitePrefix = settings.sitePath;
				this.customFields = settings.customFields;
				
				let currIdea = JSON.parse(JSON.stringify(this.currIdea));
				
				currIdea.CommunityId = this.zoneId;
				
				if (currIdea && currIdea.Body) {
					this.ideaDetails = currIdea.Body;
				}
				
				if (this.allowThemes) {
					let themes = model.themes;
					if (themes && themes.length) {
						let themePickList = [];
						for (let i = 0; i < themes.length; i++) {
							themePickList.push({label: themes[i].Title, value: themes[i].Id});
						}
						this.themeSet = themePickList;
						currIdea.IdeaThemeId = themes.length ? themes[0].Id : '';
					}
				}
				
				if (this.useTopics) {
					let topicValues = this.topicSet;
					let topicList = [];
					
					if (topicValues && topicValues.trim() !== '') {
						topicValues.split(',').forEach(topic => topicList.push({'Name': topic.trim()}));
					} else {
						topicList = model.topics;
					}
					
					let topicPicklist = [];
					for (let i = 0; i < topicList.length; i++) {
						topicPicklist.push({label: topicList[i].Name, value: topicList[i].Name});
					}
					this.topicNamesList = topicPicklist;
					
					currIdea.Related_Topic_Name__c = topicList.length ? topicList[0].Name : '';
				}
				
				if (this.predefinedTopic) {
					currIdea.Related_Topic_Name__c = this.predefinedTopic;
				}
				
				if (this.allowCategories) {
					let categoryValues = this.categoriesAllowed;
					let categories = [];
					
					if (categoryValues && categoryValues.trim() !== '') {
						categoryValues.split(',').forEach(category => categories.push(category.trim()));
					} else {
						categories = model.categories;
					}
					let categorieslist = [];
					
					for (let i = 0; i < categories.length; i++) {
						categorieslist.push({label: categories[i], value: categories[i]});
					}
					this.categoriesSet = categorieslist;
					currIdea.Categories = categories.length ? categories[0] : '';
				}
				
				let statusValues = this.statusAllowed;
				let statusList = [];
				
				if (statusValues && statusValues.trim() !== '') {
					statusValues.split(',').forEach(status => statusList.push(status.trim()));
				} else {
					statusList = model.statusus;
				}
				let statusPickList = [];
				for (let i = 0; i < statusList.length; i++) {
					statusPickList.push({label: statusList[i], value: statusList[i]});
				}
				this.statusSet = statusPickList;
				currIdea.Status = model.defaultStatus;
				
				// load or set defaults
				if (this.isEditing) {
					this.getIdeaRecord();
				} else {
					this.currIdea = currIdea;
				}
			})
			.catch(errors => {
				if (errors && errors[0]) {
					showToast('GetIdeasNewModel', errors, 'error');
				}
			});
		this.showSpinner = false;
		registerListener('selectrecval', this.handleRequestby, this);
		registerListener('validatefield', this.handleValidation, this);
	}
	
	disconnectedCallback() {
		// unsubscribe from all event
		unregisterAllListeners(this);
	}
	
	renderedCallback() {
		if (this.selectedUser) {
			fireEvent(this.pageRef, 'customlookselectedrec', {value: this.selectedUser});
		}
	}
	
	get chkZoneId() {
		return (this.zoneId !== '');
	}
	
	get chkStatus() {
		return (this.isEditing && this.editStatus);
	}
	
	get attachmentNameSize() {
		return (this.attachmentName && this.attachmentName.length > 0);
	}
	
	get errorClass() {
		if (!this.validComment) {
			return `slds-has-error`;
		}
		return ``;
	}
	
	get errorClassDesc() {
		if (!this.validDescription) {
			return `slds-has-error`;
		}
		return ``;
	}
	get displayVariant(){
		return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
	}
	handleRequestby(event) {
		this.selectedUser = event.value;
	}
	
	handleValidation(event) {
		this.validField = event.validateField;
	}
	
	handleChangeCustomValue(event) {
		this.validField = event.detail.validField;
		if (event.detail.fieldType === 'reqRichText') {
			this.reqrichtextVal = event.detail;
		}
		if (event.detail.fieldType === 'text') {
			this.textVal = event.detail;
		}
		if (event.detail.fieldType === 'textArea') {
			this.textareaVal = event.detail;
		}
		if (event.detail.fieldType === 'richText') {
			this.richtextVal = event.detail;
		}
		if (event.detail.fieldType === 'date') {
			this.dateVal = event.detail;
		}
		if (event.detail.fieldType === 'dateTime') {
			this.datetimeVal = event.detail;
		}
		if (event.detail.fieldType === 'currency') {
			this.currencyVal = event.detail;
		}
		if (event.detail.fieldType === 'number') {
			this.numberVal = event.detail;
		}
		if (event.detail.fieldType === 'percent') {
			this.percentVal = event.detail;
		}
		if (event.detail.fieldType === 'phone') {
			this.phoneVal = event.detail;
		}
		if (event.detail.fieldType === 'email') {
			this.emailVal = event.detail;
		}
		if (event.detail.fieldType === 'checkbox') {
			this.checkboxVal = event.detail;
		}
		if (event.detail.fieldType === 'picklist') {
			this.picklistVal = event.detail;
		}
	}
	
	handleSubmitIdea() {
		fireEvent(this.pageRef, 'saveclick');
		this.showSpinner = true;
		this.validateIdeasDetails(this.ideaDetails);
		let validIdea = this.validDescription;
		
		const allValid = [...this.template.querySelectorAll("[data-id=validateInput]")]
			.reduce((validSoFar, inputCmp) => {
				inputCmp.reportValidity();
				return validSoFar && inputCmp.checkValidity();
			}, true);
		
		if (validIdea && allValid && this.validField) {
			let newIdea = this.currIdea;
			
			if (this.showCustomFields) {
				if (this.reqrichtextVal) {
					newIdea[this.reqrichtextVal.apiName] = this.reqrichtextVal.fieldValue;
				}
				if (this.richtextVal) {
					newIdea[this.richtextVal.apiName] = this.richtextVal.fieldValue;
				}
				if (this.textVal) {
					newIdea[this.textVal.apiName] = this.textVal.fieldValue;
				}
				if (this.textareaVal) {
					newIdea[this.textareaVal.apiName] = this.textareaVal.fieldValue;
				}
				if (this.dateVal) {
					newIdea[this.dateVal.apiName] = this.dateVal.fieldValue;
				}
				if (this.datetimeVal) {
					newIdea[this.datetimeVal.apiName] = this.datetimeVal.fieldValue;
				}
				if (this.currencyVal) {
					newIdea[this.currencyVal.apiName] = this.currencyVal.fieldValue;
				}
				if (this.numberVal) {
					newIdea[this.numberVal.apiName] = this.numberVal.fieldValue;
				}
				if (this.percentVal) {
					newIdea[this.percentVal.apiName] = this.percentVal.fieldValue;
				}
				if (this.emailVal) {
					newIdea[this.emailVal.apiName] = this.emailVal.fieldValue;
				}
				if (this.phoneVal) {
					newIdea[this.phoneVal.apiName] = this.phoneVal.fieldValue;
				}
				if (this.checkboxVal) {
					newIdea[this.checkboxVal.apiName] = this.checkboxVal.fieldValue;
				}
				if (this.picklistVal) {
					newIdea[this.picklistVal.apiName] = this.picklistVal.fieldValue;
				}
			}
			
			let requestedBy = this.selectedUser;
			if (requestedBy) {
				newIdea.Requested_By__c = requestedBy.Id;
			}
			
			let presetField = this.presetField;
			if (presetField) {
				newIdea[presetField] = this.presetValue;
			}
			this.submitIdea(newIdea);
		} else {
			this.showSpinner = false;
		}
	}
	
	handleRichText(evt) {
		this.ideaDetails = evt.target.value;
		this.currIdea.Body = this.ideaDetails;
		this.validateIdeasDetails(this.ideaDetails);
	}
	
	handleThemeChange(evt) {
		this.currIdea.IdeaThemeId = evt.target.value;
	}
	
	handleTextInput(evt) {
		this.currIdea.Title = evt.target.value;
	}
	
	handleTopicChange(evt) {
		this.currIdea.Related_Topic_Name__c = evt.target.value;
	}
	
	handleCategoryChange(evt) {
		this.currIdea.Categories = evt.target.value;
	}
	
	handleStatusChange(evt) {
		if (this.isEditing) {
			this.currIdea.Status = evt.target.value;
			this.validateStatus();
		}
	}
	
	validateStatus() {
		let valid = true;
		
		if (this.requireComment) {
			const prevStatus = this.currentStatus;
			
			if (prevStatus && (this.currIdea.Status !== prevStatus)) {
				const htmlString = this.currIdea.Status_Comment__c;
				valid = this.validateIdeasComment(htmlString);
			}
		}
		this.validComment = valid;
		return valid;
	}
	
	handleComment(evt) {
		if (this.isEditing ) {
			this.currIdea.Status_Comment__c = evt.target.value;
			if (this.requireComment) {
				this.validateStatus();
			}
		}
	}
	
	validateIdeasComment(ideaComment) {
		this.validComment = !!ideaComment && !!this.getHtmlPlainText(ideaComment).trim();
	}
	
	validateIdeasDetails(ideaDetails) {
		this.validDescription = !!ideaDetails && !!this.getHtmlPlainText(ideaDetails).trim();
	}
	
	submitIdea(currIdea) {
		let attachmentUpload = this.attachmentUpload;
		
		if (attachmentUpload) {
			this.loadFileContent(attachmentUpload)
				.then(fileContent => {
					if (fileContent.indexOf("image") > -1) {
						currIdea.AttachmentContentType = attachmentUpload.type;
						currIdea.AttachmentName = attachmentUpload.name.length > 40
							? attachmentUpload.name.substring(0, 40)
							: attachmentUpload.name;
						
						this.saveRelated(currIdea, fileContent.split(",")[1]);
					}
				}, error => console.error(error));
			
		} else {
			this.saveRelated(currIdea, '');
		}
	}
	
	saveRelated(currIdea, image) {
		
		let relatedFiles = [];
		let relatedCount = 0;
		let relatedTotal = 0;
		
		let relatedUpload = this.relatedFilesUpload;
		
		if (relatedUpload) {
			relatedTotal = relatedUpload.length;
			
			relatedUpload.forEach(file => {
				this.loadFileContent(file)
					.then(fileContent => {
						relatedFiles.push({
							name: (file.name.split('\\').pop().split('/').pop().split('.'))[0],
							fileName: file.name,
							dataString: fileContent.split(",")[1]
						});
						relatedCount += 1;
						
						if (relatedCount === relatedTotal) {
							this.saveIdea(currIdea, image, relatedFiles);
						}
					});
			});
		} else {
			this.saveIdea(currIdea, image, relatedFiles);
		}
	}
	
	saveIdea(currIdea, image, related) {
		
		// update the Apex RelatedFiles object
		let relatedItems = this.relatedFiles;
		relatedItems.files = [];
		
		let relatedString;
		
		if (related) {
			related.forEach(file => {
				let relatedItem = this.relatedFile;
				
				relatedItem.name = file.name;
				relatedItem.fileName = file.fileName;
				relatedItem.dataString = file.dataString;
				
				relatedItems.files.push(relatedItem);
			});
			
			relatedString = JSON.stringify(relatedItems);
		}
		
		
		// TODO handle visibility
		let relatedVisibility = 'AllUsers';
		
		// ignore status comments if status is not changed
		if (this.currentStatus === currIdea.Status) {
			currIdea.Status_Comment__c = '';
		}
		
		let params = {
			currIdeaList: new Array(currIdea),
			imageString: image,
			relatedFileString: relatedString,
			visibility: relatedVisibility,
			customFieldSetName: this.customFieldSetName
		};
		createIdeaNew(params)
			.then(result => {
				this.gotoIdeaDetail(result);
			})
			.catch(errors => {
				if (errors && errors[0]) {
					showToast('Save idea', errors, 'error');
				}
			});
	}
	
	gotoIdeaDetail(recordId) {
		this.gotoRecordUrl(recordId);
	}
	
	loadFileContent(fileUpload) {
		return new Promise((resolve, reject) => {
			const reader = new FileReader();
			
			reader.readAsDataURL(fileUpload);
			//reader.readAsArrayBuffer(fileUpload);
			
			reader.onload = () => resolve(reader.result);
			reader.onerror = error => reject(error);
		});
	}
	
	baseModalNamespace() {
		getModel()
			.then(result => {
				this.baseModel = result;
			})
			.catch(error => {
				console.error(error);
			});
	}
	
	getHtmlPlainText(htmlString) {
		return htmlString.replace(/<[^>]+>/g, '');
	}
	
	goBack() {
		if (this.createIdeaClick) {
			this.createIdeaClick = false;
		} else {
			if (this.isEditing) {
				this.gotoRecordUrl(this.recordId);
			} else {
				window.history.back();
			}
		}
	}
	
	getIdeaRecord() {
		getIdeaRecord({
			zoneId: this.zoneId,
			recordId: this.recordId,
			customFieldSetName: this.customFieldSetName
		}).then(wrapper => {
			let idea = updateIdeaValues(wrapper.ideaList[0], wrapper.topicNameToId, wrapper.sitePath, '', '', this.pageRef);
			this.ideaDetails = idea.Body;
			idea.Status_Comment__c = '';
			this.currentStatus = idea.Status;
			this.attachmentName = idea.AttachmentName;
			
			this.createCustomFields(idea);
			
			let themes = idea.IdeaTheme;
			if (themes && themes.length) {
				idea.IdeaThemeId = themes.Id;
			}
			
			let category = idea.Categories;

			if (category && category.length) {
				idea.Categories = category.length ? category : '';
			}

			this.currIdea = idea;
			if (idea.Requested_By__c) {
				let params = {
					userId: idea.Requested_By__c
				};
				this.getRequestedByRecord(params);
			}
		}).catch(errors => {
			if (errors && errors[0]) {
				showToast('get_IdeaRecord', errors, 'error');
			}
		});
	}
	
	getRequestedByRecord(params) {
		getRequestedByRecord(params)
			.then(result => {
				this.selectedUser = result;
			})
			.catch(errors => {
				if (errors && errors[0]) {
					showToast('get_requestedByRecord', errors, 'error');
				}
			});
	}
	
	createCustomFields(idea) {
		let customFields = JSON.parse(JSON.stringify(this.customFields));
		let strIdea = JSON.parse(JSON.stringify(idea));
		let newCus = [];
		if (strIdea) {
			if (customFields) {
				customFields.forEach(field => {
					field.value = strIdea[field.apiName] || '';
					
					switch (field.align) {
						case 'center':
							field.alignClass = 'slds-align_absolute-center';
							break;
						case 'right':
							field.alignClass = 'slds-float_right';
							break;
						default:
							field.alignClass = 'slds-text-align_left';
							break;
					}
					newCus.push(field);
				});
			}
			this.customFields = newCus;
		}
	}
	
	getAllowedExtensions(communityExt, builderExt) {
		let communityExtList = communityExt.split(',');
		let relatedExtList = builderExt.split(',').map(x => x.replace('.', '').trim());
		let relatedExtensions = relatedExtList.filter(x => communityExtList.includes(x));
		
		return relatedExtensions.map(x => '.' + x).join(',');
	}
	
	checkSimilarIdeas(event) {
		
		if (!this.isEditing && this.showDuplicates) {
			let ideaTitle = event.target.value;
			const minLength = this.minTitleLength;
			const statusList = this.statusAllowed;
			let inputTitle = this.template.querySelector("[data-id=validateInput]");
			let title = ideaTitle.trim();
			
			if (!title || title.length < minLength) {
				inputTitle.setCustomValidity(this.errorShortTitle);
			} else {
				inputTitle.setCustomValidity("");
				const zoneId = this.zoneId;
				let limit = Math.max(1, this.simIdeasLimit);
				
				this.showSpinner = true;
				checkDuplicateIdeas(
					{
						title: title,
						zoneId: zoneId,
						simIdeasLimit: limit,
						statusList: statusList
					})
					.then((ideasList) => {
						this.ideasList = ideasList;
						for (let i = 0; i < this.ideasList.length; i++) {
							if (i === 0) {
								this.ideasList.checkZero = true;
							}
						}
						this.showSpinner = false;
					});
			}
			inputTitle.reportValidity();
		}
	}
	
	ideaRecord(event) {
		let recordId = event.currentTarget.dataset.id;
		
		this.gotoRecordUrl(recordId);
	}
	
	gotoRecordUrl(recordId) {
		let pageRef = inLexMode() ? {
			type: 'standard__webPage',
			attributes: {
				url: custom.urlParams.lexPrefix
					+ this.ideaDetailURL
					+ '?' + custom.urlParams.lexRecordId + '=' + recordId
			}
		} : {
			type: 'standard__recordPage',
			attributes: {
				recordId: recordId,
				actionName: 'view'
			}
		};
		
		this[NavigationMixin.Navigate](pageRef);
		
	}
	
	handleAttachmentUpload(event) {
		let files = event.target.files;
		
		if (files.length > 0) {
			let file = files[0];
			
			if (file.size > custom.MAX_FILE_SIZE) {
				this.attachmentName = 'ALERT : File size cannot exceed '
					+ custom.MAX_FILE_SIZE + ' bytes. '
					+ ' Selected file size: ' + file.size;
			} else {
				this.attachmentUpload = file;
				this.attachmentName = file.name;
			}
		}
	}
	
	handleRelatedUpload(event) {
		let files = event.target.files;
		
		if (files.length > 0) {
			let relatedNames = [];
			let relatedFiles = [];
			
			for (let pos = 0; pos < files.length; ++pos) {
				let file = files[pos];
				
				if (file.size > custom.MAX_FILE_SIZE) {
					this[relatedNames[0]] = 'ALERT : File size cannot exceed '
						+ custom.MAX_FILE_SIZE + ' bytes. '
						+ ' Selected file size: ' + file.size;
					return;
				} else {
					relatedFiles.push(file);
					relatedNames.push(file.name);
				}
			}
			
			this.relatedFilesUpload = relatedFiles;
			this.relatedNames = relatedNames.join(', ');
		}
	}
}