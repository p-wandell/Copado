/*
* Copyright (c) 2020. 7summits Inc. All rights reserved.
*/
import {LightningElement, api, wire, track} from 'lwc';

import {NavigationMixin, CurrentPageReference} from "lightning/navigation";

import {custom, constants} from 'c/x7sEventsBase';
import {loadScript} from 'lightning/platformResourceLoader';
import EVENTSCUSTOM from '@salesforce/resourceUrl/x7sEventsCustom';
import {inLexMode} from 'c/x7sShrUtils';

import deleteAttachment from '@salesforce/apex/x7sEventsListController.deleteAttachment';
import saveEvents from '@salesforce/apex/x7sEventsListController.saveEvents';
import updateImage from '@salesforce/apex/x7sEventsListController.updateImage';
import getAudienceIdForRecId from '@salesforce/apex/x7sEventsListController.getAudienceIdForRecordId';
import getTopicsValues from '@salesforce/apex/x7sEventsListController.getTopics';
import getEventTypeList from '@salesforce/apex/x7sEventsListController.getEventTypeList';
import getSitePrefix from '@salesforce/apex/x7sEventsListController.getSitePrefix';
import getSessionId from '@salesforce/apex/x7sEventsListController.getSessionId';
import getLanguage from '@salesforce/apex/x7sEventsListController.getLanguage';
import audienceEnabled from '@salesforce/apex/x7sEventsListController.audienceEnabled';
import getAudienceList from '@salesforce/apex/x7sEventsListController.getAudienceList';
import getLanguageOption from '@salesforce/apex/x7sEventsListController.getLanguageOption';
import requireGroupMembership from '@salesforce/apex/x7sEventsListController.requireGroupMembership';
import getGroups from '@salesforce/apex/x7sEventsListController.getGroups';
import userAuthorizedToPost from '@salesforce/apex/x7sEventsListController.userAuthorizedToPost';
import getEventRecord from '@salesforce/apex/x7sEventsListController.getEventRecord';
import deleteCurrentAudience from '@salesforce/apex/x7sEventsListController.deleteCurrentAudience';
import getImageTypes from "@salesforce/apex/x7sEventsImageController.getImageTypes";
import getCMSImageURL from "@salesforce/apex/x7sEventsImageController.getCMSImageURL";
import saveRelatedFile from "@salesforce/apex/x7sEventsListController.saveRelatedFile";

import labelAudience from '@salesforce/label/c.x7sEventsCreateLabelAudience';
import labelAudiencePlaceholder from '@salesforce/label/c.x7sEventsCreatePlaceHolderAudience';
import labelEventsLanguageCombobox from '@salesforce/label/c.x7sEventsLanguageCombobox';
import labelEventsTitle from '@salesforce/label/c.x7sEventsCreateTitle';
import labelEnterDescriptiveEventTitle from '@salesforce/label/c.x7sEventsCreateEnterDescriptiveTitle';
import labelEventsCreateTooltipDelAud from '@salesforce/label/c.x7sEventsCreateTooltipDeleteAudience';
import labelEventsCreateAudNoAcc from '@salesforce/label/c.x7sEventsCreateAudienceNoAccess';
import labelEventsDatesAndLocation from '@salesforce/label/c.x7sEventsCreateDatesAndLocation';
import labelEnterEventsDatesAndLocation from '@salesforce/label/c.x7sEventsCreateDescEventDatesAndLocation';
import labelAllDayEvent from '@salesforce/label/c.x7sEventsCreateTitleAllDayEvent';
import labelStartDate from '@salesforce/label/c.x7sEventsCreateLabelStartDate';
import labelEndDate from '@salesforce/label/c.x7sEventsCreateLabelEndDate';
import labelEventLocationName from '@salesforce/label/c.x7sEventsCreateLabelLocationName';
import labelAddress from '@salesforce/label/c.x7sEventsCreateLabelAddress';
import labelLocationURL from '@salesforce/label/c.x7sEventsCreateLabelLocationURL';
import labelLocationUrlDescription from '@salesforce/label/c.x7sEventsCreateLabelLocationDesc';
import labelVenueInformation from '@salesforce/label/c.x7sEventsCreateLabelVenueInfo';
import labelEventDescription from '@salesforce/label/c.x7sEventsCreateDescription';
import labelEventDescDescription from '@salesforce/label/c.x7sEventsCreateLabelDescription';
import labelEnterEventDetails from '@salesforce/label/c.x7sEventsCreateEnterEventDetails';
import labelErrorEventDetails from '@salesforce/label/c.x7sEventsCreateErrMsgEventDetails';
import labelEventType from '@salesforce/label/c.x7sEventsCreatelabelEventType';
import labelUploadImgDesc from '@salesforce/label/c.x7sEventsCreateUploadPhotoDesc';
import labelUploadFeaturedPhoto from '@salesforce/label/c.x7sEventsCreateUploadPhoto';
import labelSelectTopics from '@salesforce/label/c.x7sEventsCreateLabelSelectTopics';
import labelTopicAddNew from '@salesforce/label/c.x7sEventTopicAddNew';
import labelLimitToSpecificGroups from '@salesforce/label/c.x7sEventsCreateTitleLimitToSpecificGrps';
import labelSelectGroupNone from '@salesforce/label/c.x7sEventsCreateSelectGroupsAll';
import labelLimitToSpecificGroupsTxt from '@salesforce/label/c.x7sEventsCreateTxtLimitToSpecificGrps';
import labelEventParticiOpt from '@salesforce/label/c.x7sEventsCreateLabelParticipationOptions';
import labelAddAbilityToRSVP from '@salesforce/label/c.x7sEventsCreateLabelAddAbilityToRSVP';
import labelShowRSVPCounter from '@salesforce/label/c.x7sEventsCreateLabelShowRSVPCounter';
import labelAddEventPricing from '@salesforce/label/c.x7sEventsCreateLabelAddEventPricing';
import labelTicketPrice from '@salesforce/label/c.x7sEventsCreateLabelTicketPrice';
import labelExternalEventPaymentURL from '@salesforce/label/c.x7sEventsCreateLabelExternalPaymentURL';
import labelSaveButton from '@salesforce/label/c.x7sEventsCreateLabelSaveButton';
import labelCancelButton from '@salesforce/label/c.x7sEventsCreateLabelCancelButton';
import labelAttachmentName from '@salesforce/label/c.x7sEventsAttachmentName';
import labelAttachmentFailErrMsg from '@salesforce/label/c.x7sEventsAttachmentFailErrMsg';
import labelEditEvent from '@salesforce/label/c.x7sEventsEditEventHeaderText';
import labelFeaturedImageType from '@salesforce/label/c.x7sEventsLabelFeaturedImageType';
import labelFeaturedImageReference from '@salesforce/label/c.x7sEventsLabelFeaturedImageReference';
import labelPlaceholderImageReference from '@salesforce/label/c.x7sEventsPlaceholderImageReference';
import labelCurrentImage from '@salesforce/label/c.x7sEventsLabelCurrentImage';
import toolTipImageReference from '@salesforce/label/c.x7sEventsToolTipImageReference';
import labelImageToBeUploaded from '@salesforce/label/c.x7sEventsLabelImageToBeUploaded';
import labelRelatedFileList from '@salesforce/label/c.x7sEventsLabelFileList';

//Validation Messages
import ValMsgBlankName from '@salesforce/label/c.x7sEventsValMsgBlankName';
import ValMsgLongName from '@salesforce/label/c.x7sEventsValMsgLongName';
import ValMsgBlankEndDate from '@salesforce/label/c.x7sEventsValMsgBlankEndDate';
import ValMsgEndDate from '@salesforce/label/c.x7sEventsValMsgEndDate';
import ValMsgBlankStartDate from '@salesforce/label/c.x7sEventsValMsgBlankStartDate';
import ValMsgStartDate from '@salesforce/label/c.x7sEventsValMsgStartDate';
import ValMsgBlankLocation from '@salesforce/label/c.x7sEventsValMsgBlankLocation';
import ValMsgLongLocation from '@salesforce/label/c.x7sEventsValMsgLongLocation';
import ValMsgLongAdd from '@salesforce/label/c.x7sEventsValMsgLongAdd';
import ValMsgLongLocationURL from '@salesforce/label/c.x7sEventsValMsgLongLocationURL';
import ValMsgBlankPaymentURL from '@salesforce/label/c.x7sEventsValMsgBlankPaymentURL';
import ValMsgLongPaymentURL from '@salesforce/label/c.x7sEventsValMsgLongPaymentURL';
import ValMsgFileSize from '@salesforce/label/c.x7sEventsValMsgFileSize';
import ValMsgFileType from '@salesforce/label/c.x7sEventsValMsgFileType';
import ValMsgTopic from '@salesforce/label/c.x7sEventsValMsgTopic';
import ValMsgRSVPCounter from '@salesforce/label/c.x7sEventsValMsgRSVPCounter';
import ValMsgOnSave from '@salesforce/label/c.x7sEventsValMsgOnSave';
import valMsgInvalidImageRef from '@salesforce/label/c.x7sEventsValMsgInvalidRef';

export default class X7sEventsCreate extends NavigationMixin(LightningElement) {
	
	@api recordId;
	//Design Properties
	@api headerText = "Create Event";
	@api headerAlignment = "center";
	@api variant = "featured";
	@api showEventType = false;
	@api showTopics = "true";
	@api useTopics = false;
	@api customClass;
	@api defaultImageType = 'Attachment';
	
	@api customField1 = "";
	@api customLabel1 = "";
	customValue1 = "";
	@api customField2 = "";
	@api customLabel2 = "";
	customValue2 = "";
	@api customField3 = "";
	@api customLabel3 = "";
	customValue3 = "";
	
	@api pathToDetail = "/event/";
	@api allEventsUrl = "event-list-view-page";
	@api limitToSpecificGroups = false;
	
	@api isEdit = false;
	
	@api sitePath;
	@api sitePrefix;
	pageLoaded = false;
	selectedTopicIds = [];
	attachmentList;
	attachmentUpload;
	sessionId;
	
	disableDateTime = false;
	disableButton = false;
	topicValues = [];
	
	//Language
	requireLanguage = false;
	eventsLanguage = "";
	labelLanguage = labelEventsLanguageCombobox;
	userLangEnabled;
	languageValues;
	
	//Audience targeting
	audienceEnabled = true;
	audienceLabel = labelAudience;
	audiencePlaceHolder = labelAudiencePlaceholder;
	audienceList;
	audienceSelected = "";
	audienceName = "";
	audienceAssigned = false;
	audienceShowCombo = true;
	audienceShowDelete = false;
	audienceNoAccess = false;
	
	//spinner
	loading = false;
	
	validDetails = true;
	errorDetails = labelErrorEventDetails;
	error;
	
	eventName;
	eventAllDay = false;
	eventDetails;
	eventEnablePricing = false;
	eventEnableRSVP = false;
	eventEndTime;
	@api allDayEventEndDate;
	eventGroupId = "";
	eventLocationAddress;
	eventLocationName;
	eventLocationURl;
	eventPaymentURL;
	eventRSVPThreshold = 0;
	eventStartTime;
	@api allDayEventStartDate;
	eventTicketPrice;
	eventVenueInfo = "";
	@api eventType = "";
	userTimeZone;
	eventObj = {'Name': ''};
	
	//File upload
	@api isFileDeleted = false;
	@api isFileSelected = false;
	@api attachmentName = labelAttachmentName;
	@api attachmentAccept = "png,jpg,jpeg,gif";
	@api attachments = [];
	@api strAttachmentError = [];
	@api isAttachment;
	@api strError;
	@api topicError;
	@api isBrowseError;
	@track imageTypes;
	selectedImageType = '';
	imageReference;
	showPreview = false;
	previewURL = '';
	attachmentPath;
	invalidImage = false;
	imageURL;
	isRelatedFile = false;
	cmsImageURL = '';

	attachedFileURL = '';
	fileName = labelAttachmentName;
	@track relatedFileList = [];
	selectedFile = '';
	showRelatedFileList = false;
	
	// Groups
	groupValues;
	requireGroups = false;
	canPostToAll = false;
	
	labels = {
		labelEventsTitle,
		labelEnterDescriptiveEventTitle,
		labelAudience,
		labelEventsCreateTooltipDelAud,
		labelEventsCreateAudNoAcc,
		labelEventsDatesAndLocation,
		labelEnterEventsDatesAndLocation,
		labelAllDayEvent,
		labelStartDate,
		labelEndDate,
		labelEventLocationName,
		labelAddress,
		labelLocationURL,
		labelLocationUrlDescription,
		labelVenueInformation,
		labelEventDescription,
		labelEventDescDescription,
		labelEnterEventDetails,
		labelEventType,
		labelUploadImgDesc,
		labelUploadFeaturedPhoto,
		labelSelectTopics,
		labelTopicAddNew,
		labelLimitToSpecificGroups,
		labelLimitToSpecificGroupsTxt,
		labelEventParticiOpt,
		labelAddAbilityToRSVP,
		labelShowRSVPCounter,
		labelAddEventPricing,
		labelTicketPrice,
		labelExternalEventPaymentURL,
		labelSaveButton,
		labelCancelButton,
		labelFeaturedImageType,
		labelFeaturedImageReference,
		labelPlaceholderImageReference,
		labelCurrentImage,
		toolTipImageReference,
		labelImageToBeUploaded,
		valMsgInvalidImageRef,
		labelRelatedFileList
	}
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		loadScript(this, EVENTSCUSTOM + '/EventsCustom/moment.min.js');
		
		this.get_SitePrefix();
		this.get_SessionId();
		this.isLangEnabled();
		this.getLanguageOptions();
		this.isAudienceEnabled();
		this.getAudienceList();
		this.getTopics();
		this.get_Image_Types();
		
		if (this.showEventType) {
			this.getEventType();
		}
		if (this.limitToSpecificGroups) {
			this.getGroups();
		}
		let eventURL = new URL(window.location.href).searchParams;
		
		const urlSet = inLexMode() ? constants.editLex : constants.editComm;
		
		this.isEdit = eventURL.get(urlSet.editMode);
		
		if (this.isEdit) {
			this.recordId = eventURL.get(urlSet.id);
			this.headerText = labelEditEvent;
			this.getEventsRecord();
			this.getEventAudience();
		}
		if (this.eventObj.RSVP_Count_Threshold__c === '') {
			this.eventObj.RSVP_Count_Threshold__c = 10;
		}
	}
	
	get componentClass() {
		return `x7s-events-create ${this.customClass}`;
	}
	
	get isUserLangEnabled() {
		return this.userLangEnabled != null;
	}
	
	get customField1HasVal() {
		return (this.customField1 !== '' && this.customField1 !== null);
	}
	
	get customField2HasVal() {
		return (this.customField2 !== '' && this.customField2 !== null);
	}
	
	get customField3HasVal() {
		return (this.customField3 !== '' && this.customField3 !== null);
	}

	get showAttachment() {
		return this.selectedImageType === constants.imageTypes.ATTACHMENT || this.selectedImageType === constants.imageTypes.RELATED_FILES;
	}

	get hideImageRef() {
		return this.selectedImageType === constants.imageTypes.NONE;
	}

	get isdisableButton() {
		return this.disableButton || this.invalidImage;
	}

	get hideTopicSelection() {
		return !this.useTopics && !this.showTopics;
	}
	
	getGroups() {
		requireGroupMembership()
			.then(result => {
				this.requireGroups = result;
				
				getGroups()
					.then(res => {
						let data = res;
						let grp = Object.keys(data).map((key) => {
							return ({label: data[key], value: key});
						});
						
						grp.unshift({label: labelSelectGroupNone, value: ''});
						
						this.groupValues = grp;
						if (grp && grp.length) {
							userAuthorizedToPost()
								.then(result => {
									let postToAll = result;
									if (!this.isEdit && this.requireGroups && !postToAll) {
										this.eventGroupId = this.groupValues[0].value;
									}
									if (postToAll) {
										this.requireGroups = false;
									}
								})
								.catch(error => {
									this.error = error;
									console.error("Error Occurred getting user Authorized To Post:" + this.error);
								})
						}
						if (this.isEdit && this.eventGroupId === undefined) {
							this.eventGroupId = this.groupValues[0].value;
						}
					})
					.catch(error => {
						this.error = error;
					})
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	getAudienceList() {
		getAudienceList({
			networkId: '',
			currentUser: ''
		})
			.then(result => {
				this.audienceSelected = '';
				let data = result;
				let res = Object.keys(data).map((key) => {
					return ({label: data[key], value: key});
				});
				res.unshift({label: 'All', value: ''});
				this.audienceList = res;
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	isAudienceEnabled() {
		audienceEnabled()
			.then(result => {
				this.audienceEnabled = result;
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then(result => {
				if (result) {
					let sitePath = result;
					this.sitePath = sitePath;
					// remove the trailing /s for the image
					if (sitePath[sitePath.length - 1] === 's') {
						this.sitePrefix = sitePath.substring(0, sitePath.length - 2);
					} else {
						this.sitePrefix = sitePath.replace("/s", "/");
					}
				}
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	get_SessionId() {
		getSessionId()
			.then(result => {
				this.sessionId = result;
			})
			.catch(error => {
				this.error = error;
				console.error("Error occured while getting Session Id:" + this.error);
			})
	}
	
	getEventType() {
		getEventTypeList()
			.then(result => {
				if (result) {
					let data = result;
					let res = Object.keys(data).map((key) => {
						return ({label: data[key], value: data[key]});
					});
					this.eventTypeValues = res;
					if (this.showEventType && !this.isEdit) {
						this.eventType = result[0];
					}
				}
			})
			.catch(error => {
				this.error = error;
				console.error("Error occurred getting event types:" + this.error);
			})
	}
	
	getTopics() {
		getTopicsValues()
			.then(result => {
				let data = result;
				let res = Object.keys(data).map((key) => {
					return ({name: data[key], id: key});
				});
				this.topicValues = res;
				this.pageLoaded = true;
			})
			.catch(error => {
				console.error("Error occurred getting Topics:" + error[0]);
			});
	}

	get_Image_Types() {
		getImageTypes()
			.then(result => {
				let data = result;
				let options = Object.keys(data).map((key) => {
					return ({label: data[key], value: key});
				});
			
				this.imageTypes = options;
				if(!this.isEdit) {
					this.selectedImageType = this.defaultImageType;
				}
			})
			.catch(error => {
				console.error("Error Occurred getting Image Types:" + error);
			})
	}
	
	isLangEnabled() {
		getLanguage()
			.then(result => {
				this.userLangEnabled = result;
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	getLanguageOptions() {
		getLanguageOption()
			.then(result => {
				if (result) {
					let data = result;
					let res = Object.keys(data).map((key) => {
						return ({label: key, value: data[key]});
					});
					this.languageValues = res;
					
					if (this.eventsLanguage === "" && (this.userLangEnabled != null || this.userLangEnabled !== "")) {
						this.eventsLanguage = this.userLangEnabled;
					}
				}
			})
			.catch(error => {
				this.error = error;
			})
	}
	
	handleAudienceChange(event) {
		this.audienceSelected = event.target.value;
	}
	
	handleEventGroupChange(event) {
		this.eventGroupId = event.target.value;
	}
	
	handleVenueChange(event) {
		this.eventVenueInfo = event.target.value;
	}
	
	handleEnablePricing(event) {
		this.eventEnablePricing = event.target.checked;
		if (!this.eventEnablePricing) {
			this.eventTicketPrice = null;
			this.eventPaymentURL = null;
		}
	}
	
	handleTicketPrice(event) {
		this.eventTicketPrice = event.detail.value;
	}
	
	handleAllday(event) {
		this.eventAllDay = event.target.checked;
		;
		this.disableDateTime = this.eventAllDay;
		if (this.eventAllDay) {
			this.eventEndTime = null;
			this.eventStartTime = null;
		} else {
			this.allDayEventStartDate = null;
			this.allDayEventEndDate = null;
		}
	}
	
	handleEnableRSVP(event) {
		this.eventEnableRSVP = event.target.checked;
		if (!this.eventEnableRSVP) {
			this.eventRSVPThreshold = 0;
		}
	}
	
	handleEventType(evt) {
		this.eventType = evt.target.value;
	}
	
	handleEventDetail(evt) {
		this.eventDetails = evt.target.value;
		;
		let eventDetails = this.eventDetails;
		this.validateEventDetails(eventDetails);
	}
	
	handleCustomField1Change(evt) {
		this.customValue1 = evt.detail.value;
	}
	
	handleCustomField2Change(evt) {
		this.customValue2 = evt.detail.value;
	}
	
	handleCustomField2Change(evt) {
		this.customValue2 = evt.detail.value;
	}
	
	validateEventDetails(eventDetails) {
		this.validDetails = !!eventDetails && !!this.getHtmlPlainText(eventDetails).trim();
	}

	handleImageTypeChange(event) {
		this.selectedImageType = event.target.value;
		this.getImagePreview();
	}

	handleImageReference(event) {
		this.imageReference = event.target.value;
		this.getImagePreview();				
	}

	handleFileSelection(event) {
		this.selectedFile = event.target.value;
		this.imageReference = event.target.value;
		let selectedFileName = event.target.options.find(opt => opt.value === event.detail.value).label;
		this.fileName = labelImageToBeUploaded + ' ' + selectedFileName;
		this.getImagePreview();	
	}

	getImagePreview() {
		this.invalidImage = false;
		this.disableButton = false;
		this.isRelatedFile = false;

		switch (this.selectedImageType) {
			case constants.imageTypes.EXTERNAL_URL:
				if(this.imageReference !== '' && this.imageReference !== undefined) {
					this.showPreview = true;
					this.previewURL = this.imageReference;
				} else {
					this.showPreview = false;
				}
				break;

			case constants.imageTypes.STATIC_RESOURCE:
				if(this.imageReference !== '' && this.imageReference !== undefined) {
					this.showPreview = true;
					this.previewURL = '/resource/' + this.imageReference;
				} else {
					this.showPreview = false;
				}
				break;

			case constants.imageTypes.ATTACHMENT:
				if(this.attachmentPath !== undefined && this.attachmentPath !== null) {
					this.showPreview = true;
					this.previewURL = this.attachmentPath;
				} else {
					this.showPreview = false;
				}
				break;
			case constants.imageTypes.RELATED_FILES:
				this.isRelatedFile = true;
				this.imageReference = '';
				if(this.selectedFile != undefined && this.selectedFile != '') {
					this.imageReference = this.selectedFile;
				}

				if(this.attachedFileURL !== undefined && this.attachedFileURL !== '' && this.imageReference !== '' && this.imageReference !== undefined) {
					this.showPreview = true;
					this.previewURL = this.attachedFileURL + this.imageReference;
				} else {
					this.showPreview = false;
				}
				break;
			case constants.imageTypes.CMS_CONTENT:
				if(this.cmsImageURL !== undefined && this.cmsImageURL !== '') {
					this.showPreview = true;
					this.previewURL = this.cmsImageURL;

				} else if(this.imageReference !== '' && this.imageReference !== undefined){
					let cmsContentIds = [];
					cmsContentIds.push(this.imageReference);

					getCMSImageURL({
						eventsWithCMSImage : {},
						contectIdList : cmsContentIds
					})
						.then(result => {
							let cmsMap = result;
							if(cmsMap !== '' && cmsMap !== undefined) {
								this.showPreview = true;
								this.previewURL = cmsMap[this.imageReference];
							} else {
								this.showPreview = false;
							}
						})
						.catch(error => {
							this.showPreview = false;
							console.error('Error occurred getting CMS Image URL:'+JSON.stringify(error));
						})
				} else {
					this.showPreview = false;
				}
				break;
			case constants.imageTypes.NONE:
				this.showPreview = false;
			default:
				this.showPreview = false;
				break;
		}
	}
	
	getHtmlPlainText(htmlString) {
		//Remove all HTML Tags, This is required to check Initial space if entered
		return htmlString.replace(/<[^>]+>/g, '');
	}
	
	validateEventName(evt) {
		this.eventName = evt.detail.value;
		let eventNameCmp = this.template.querySelector("[data-id=eventName]");
		if (!this.eventName || this.eventName.trim() === "") {
			eventNameCmp.setCustomValidity(ValMsgBlankName);
		} else if (this.eventName.length > 80)
			eventNameCmp.setCustomValidity(ValMsgLongName);
		else
			eventNameCmp.setCustomValidity("");
		eventNameCmp.reportValidity();
	}
	
	validateStartDate(evt) {
		if (this.eventAllDay) {
			this.allDayEventStartDate = evt.detail.value;
			let eventStartDate = this.allDayEventStartDate;
			let eventStartDateCmp = this.template.querySelector("[data-id=eventStartDate]");
			let startDate;
			
			if (!eventStartDate || eventStartDate.trim() === "") {
				eventStartDateCmp.setCustomValidity(ValMsgBlankStartDate);
			} else {
				eventStartDateCmp.setCustomValidity("");
				startDate = moment(eventStartDate).format('YYYY-MM-DD HH:mm:ss');
				if (moment().isAfter(startDate, 'day')) {
					eventStartDateCmp.setCustomValidity(ValMsgStartDate);
				} else {
					eventStartDateCmp.setCustomValidity("");
					
					//checking End date if already entered
					let eventEndDate = this.allDayEventEndDate;
					if (eventEndDate && eventEndDate.trim() !== '') {
						let eventEndDateCmp = this.template.querySelector("[data-id=eventEndDate]");
						let frmDtStr = moment(startDate).toDate();
						let endDate = moment(eventEndDate).format('YYYY-MM-DD HH:mm:ss');
						let toDtStr = moment(endDate).toDate();
						
						if (moment(toDtStr).isBefore(frmDtStr)) {
							eventEndDateCmp.setCustomValidity(ValMsgEndDate);
						} else {
							eventEndDateCmp.setCustomValidity("");
						}
						eventEndDateCmp.reportValidity();
					}
				}
			}
			eventStartDateCmp.reportValidity();
		}
	}
	
	validateEndDate(evt) {
		if (this.eventAllDay) {
			this.allDayEventEndDate = evt.detail.value;
			let eventEndDate = this.allDayEventEndDate;
			let eventEndDateCmp = this.template.querySelector("[data-id=eventEndDate]");
			let eventStartDate = this.allDayEventStartDate;
			
			if (!eventEndDate || eventEndDate.trim() === "") {
				eventEndDateCmp.setCustomValidity(ValMsgBlankEndDate);
			} else {
				eventEndDateCmp.setCustomValidity("");
				if (eventStartDate && eventStartDate.trim() !== "") {
					let startDate = moment(eventStartDate).format('YYYY-MM-DD HH:mm:ss');
					let frmDtStr = moment(startDate).toDate();
					let endDate = moment(eventEndDate).format('YYYY-MM-DD HH:mm:ss');
					let toDtStr = moment(endDate).toDate();
					
					if (toDtStr !== '' && toDtStr && moment(toDtStr).isBefore(frmDtStr)) {
						eventEndDateCmp.setCustomValidity(ValMsgEndDate);
					} else {
						eventEndDateCmp.setCustomValidity("");
					}
				} else
					eventEndDateCmp.setCustomValidity("");
			}
			eventEndDateCmp.reportValidity();
		}
	}
	
	validateEndDateTime(evt) {
		this.eventEndTime = evt.detail.value;
		let eventEndDate = this.eventEndTime;
		let eventEndDateCmp = this.template.querySelector("[data-id=eventEndDateTime]");
		let eventStartDate = this.eventStartTime;
		
		if (!this.eventAllDay) {
			if (!eventEndDate || eventEndDate.trim() === "") {
				eventEndDateCmp.setCustomValidity(ValMsgBlankEndDate);
			} else {
				eventEndDateCmp.setCustomValidity("");
				if (eventStartDate && eventStartDate.trim() !== "") {
					let startDate = moment(eventStartDate).format('YYYY-MM-DD HH:mm:ss');
					let frmDtStr = moment(startDate).toDate();
					let endDate = moment(eventEndDate).format('YYYY-MM-DD HH:mm:ss');
					let toDtStr = moment(endDate).toDate();
					
					if (toDtStr !== '' && toDtStr && moment(toDtStr).isBefore(frmDtStr)) {
						eventEndDateCmp.setCustomValidity(ValMsgEndDate);
					} else {
						eventEndDateCmp.setCustomValidity("");
					}
				} else {
					eventEndDateCmp.setCustomValidity("");
				}
			}
			eventEndDateCmp.reportValidity();
		}
	}
	
	validateStartDateTime(evt) {
		this.eventStartTime = evt.detail.value;
		let eventStartDate = this.eventStartTime;
		let eventStartDateCmp = this.template.querySelector("[data-id=eventStartDateTime]");
		
		if (!this.eventAllDay) {
			if (!eventStartDate || eventStartDate.trim() === "") {
				eventStartDateCmp.setCustomValidity(ValMsgBlankStartDate);
			} else {
				eventStartDateCmp.setCustomValidity("");
				let startDate = moment(eventStartDate).format('YYYY-MM-DD HH:mm:ss');
				if (moment().isAfter(startDate, 'day')) {
					eventStartDateCmp.setCustomValidity(ValMsgStartDate);
				} else {
					eventStartDateCmp.setCustomValidity("");
					
					//checking End datetime if already entered
					let eventEndDate = this.eventEndTime;
					if (eventEndDate && eventEndDate.trim() !== '') {
						
						let eventEndDateCmp = this.template.querySelector("[data-id=eventEndDateTime]");
						let frmDtStr = moment(startDate).toDate();
						let endDate = moment(eventEndDate).format('YYYY-MM-DD HH:mm:ss');
						let toDtStr = moment(endDate).toDate();
						
						if (moment(toDtStr).isBefore(frmDtStr)) {
							eventEndDateCmp.setCustomValidity(ValMsgEndDate);
						} else {
							eventEndDateCmp.setCustomValidity("");
						}
						eventEndDateCmp.reportValidity();
					}
				}
			}
			eventStartDateCmp.reportValidity();
		}
	}
	
	validateLocationName(evt) {
		this.eventLocationName = evt.detail.value;
		let locationCmp = this.template.querySelector("[data-id=eventLocationName]");
		let locationName = this.eventLocationName;
		if (!locationName || locationName.trim() === "") {
			{
				locationCmp.setCustomValidity(ValMsgBlankLocation);
			}
		} else {
			if (locationName.length > 255) {
				locationCmp.setCustomValidity(ValMsgLongLocation);
			} else {
				locationCmp.setCustomValidity("");
			}
		}
		locationCmp.reportValidity();
	}
	
	validateAddress(evt) {
		this.eventLocationAddress = evt.detail.value;
		let eventAddressCmp = this.template.querySelector("[data-id=eventAddress]");
		let eventAddress = this.eventLocationAddress;
		if (!eventAddress || eventAddress.trim() === "") {
			eventAddressCmp.setCustomValidity("");
		} else {
			if (eventAddress.length > 255) {
				eventAddressCmp.setCustomValidity(ValMsgLongAdd);
			} else {
				eventAddressCmp.setCustomValidity("");
			}
		}
		eventAddressCmp.reportValidity();
	}
	
	validateLocationURL(evt) {
		this.eventLocationURl = evt.detail.value;
		let eventLocationURLCmp = this.template.querySelector("[data-id=eventLocationURL]");
		let eventLocationURL = this.eventLocationURl;
		if (!eventLocationURL || eventLocationURL.trim() === "") {
			eventLocationURLCmp.setCustomValidity("");
		} else if (eventLocationURL.length > 255) {
			eventLocationURLCmp.setCustomValidity(ValMsgLongLocationURL);
		} else {
			eventLocationURLCmp.setCustomValidity("");
		}
		eventLocationURLCmp.reportValidity();
	}
	
	validateRSVPCount(evt) {
		this.eventRSVPThreshold = 0;
		if (this.eventEnableRSVP) {
			this.eventRSVPThreshold = evt.detail.value;
			let eventRSVPThresholdCmp = this.template.querySelector("[data-id=eventThresholdCount]");
			let eventThresholdCountValue = this.eventRSVPThreshold;
			
			if (!eventThresholdCountValue && !this.isInt(eventThresholdCountValue)) {
				eventRSVPThresholdCmp.setCustomValidity(ValMsgRSVPCounter);
			} else {
				eventRSVPThresholdCmp.setCustomValidity("");
			}
			eventRSVPThresholdCmp.reportValidity();
		}
	}
	
	isInt(value) {
		return !isNaN(value) && (function (x) {
			return (x | 0) === x;
		})(parseFloat(value))
	}
	
	validatePaymentURL(evt) {
		this.eventPaymentURL = evt.detail.value;
		let eventPaymentURL = this.eventPaymentURL;
		let paymentUrlCmp = this.template.querySelector("[data-id=eventExternalPaymentURL]");
		if (this.eventEnablePricing) {
			if (!eventPaymentURL || eventPaymentURL.trim() === "") {
				paymentUrlCmp.setCustomValidity(ValMsgBlankPaymentURL);
			} else if (eventPaymentURL && eventPaymentURL.length > 255) {
				paymentUrlCmp.setCustomValidity(ValMsgLongPaymentURL);
			} else {
				paymentUrlCmp.setCustomValidity("");
			}
		} else {
			paymentUrlCmp.setCustomValidity("");
		}
		paymentUrlCmp.reportValidity();
	}
	
	deleteAudience() {
		deleteCurrentAudience({
			recordId: this.recordId
		})
			.then(result => {
				this.audienceSelected = '';
				this.audienceAssigned = false;
				this.audienceShowCombo = true;
				this.audienceShowDelete = false;
			})
			.catch(error => {
				console.error("Error has occurred deleting audience record:" + error);
			})
	}
	
	notifyFileSelected(evt) {
		this.showPreview = false;
		let fileInput = evt.target.files;
		let eventAttachmentCmp = this.template.querySelector("[data-id=image]");
		
		if (fileInput && fileInput.length > 0) {
			//this.attachmentName = fileInput[0].name;
			let file = fileInput[0];
			
			if (fileInput[0].type.indexOf("image") === -1) {
				this.isFileSelected = false;
				eventAttachmentCmp.setCustomValidity(ValMsgFileType);
				eventAttachmentCmp.reportValidity();
				
			} else if (file.size > custom.MAX_FILE_SIZE) {
				this.isFileSelected = false;
				eventAttachmentCmp.setCustomValidity(ValMsgFileSize + ' ' + custom.MAX_FILE_SIZE);
				eventAttachmentCmp.reportValidity();
				
			} else {
				this.attachmentUpload = fileInput[0];
				this.attachmentList = fileInput;
				this.imageReference = '';
				this.invalidImage = false;
				
				if(this.selectedImageType === constants.imageTypes.RELATED_FILES) {
					this.fileName = labelImageToBeUploaded + ' ' + fileInput[0].name;
					this.attachedFileURL = '';
				} else {
					this.isFileSelected = true;
					this.attachmentName = labelImageToBeUploaded + ' ' + fileInput[0].name;
				}

				eventAttachmentCmp.setCustomValidity("");
				eventAttachmentCmp.reportValidity();
			}
		} else {
			eventAttachmentCmp.setCustomValidity("");
			eventAttachmentCmp.reportValidity();
			if (this.isEdit && this.isAttachment && (this.attachmentName === labelAttachmentName || this.fileName === labelAttachmentName)) {
				this.isFileDeleted = true;
			}
		}
	}
	
	handleTopicChangeEvent(event) {
		this.selectedTopicIds = event.detail;
		this.validateTopics();
	}
	
	validateTopics() {
		this.topicError = this.useTopics && this.selectedTopicIds.length < 1 ? ValMsgTopic : null;
	}
	
	submitEvent() {
		this.loading = true;
		let allDayEventStartDate;
		let allDayEventEndDate;
		
		if (this.eventAllDay) {
			// want the date portion only
			let startDate = this.allDayEventStartDate;
			if (startDate) {
				allDayEventStartDate = moment(startDate).format('YYYY-MM-DD');
			}
			
			let endDate = this.allDayEventEndDate;
			if (endDate) {
				allDayEventEndDate = moment(endDate).format('YYYY-MM-DD');
			} else {
				// same day
				if (allDayEventStartDate) {
					allDayEventEndDate = allDayEventStartDate;
				}
			}
		} else {
			allDayEventStartDate = this.eventStartTime;
			allDayEventEndDate = this.eventEndTime;
		}
		
		const allValid = [...this.template.querySelectorAll(".validatInput")]
			.reduce((validSoFar, inputCmp) => {
				inputCmp.reportValidity();
				return validSoFar && inputCmp.checkValidity();
			}, true);
		
		this.validateEventDetails(this.eventDetails);
		this.validateTopics();
		
		if (allValid && this.validDetails && !this.topicError) {
			this.strError = "";
			
			let eventObj = this.eventObj;
			eventObj['Name'] = this.eventName;
			eventObj['All_Day_Event__c'] = this.eventAllDay;
			eventObj['Details__c'] = this.eventDetails;
			eventObj['Enable_Pricing_Payment__c'] = this.eventEnablePricing;
			eventObj['Enable_RSVP__c'] = this.eventEnableRSVP;
			eventObj['End_DateTime__c'] = this.eventEndTime;
			eventObj['All_Day_End__c'] = this.allDayEventEndDate;
			eventObj['Location_Address__c'] = this.eventLocationAddress;
			eventObj['Location_Name__c'] = this.eventLocationName;
			eventObj['Location_URL__c'] = this.eventLocationURl;
			eventObj['Payment_URL__c'] = this.eventPaymentURL;
			eventObj['RSVP_Count_Threshold__c'] = this.eventRSVPThreshold;
			eventObj['Start_DateTime__c'] = this.eventStartTime;
			eventObj['All_Day_Start__c'] = this.allDayEventStartDate;
			eventObj['Ticket_Price__c'] = this.eventTicketPrice;
			eventObj['Venue_Information__c'] = this.eventVenueInfo;
			eventObj['Event_Type__c'] = this.eventType;
			eventObj['GroupId__c'] = this.eventGroupId;
			eventObj['Image_Type__c'] = this.selectedImageType;
			eventObj['Image_Reference__c'] = this.imageReference;
			
			if (this.userLangEnabled != null) {
				eventObj['Language__c'] = this.eventsLanguage;
			}
			
			// add custom fields
			for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
				let customField = this[`customField${pos}`];
				if (customField && customField.length) {
					let customValue = this[`customValue${pos}`];
					if (customValue) {
						eventObj[customField] = customValue;
					}
				}
			}
			
			const fileDetail = {
				eventId: '',
				attachmentName: '',
				attachmentType: '',
				set objectId(eId) {
					this.eventId = eId;
				},
				set fileName(attName) {
					this.attachmentName = attName;
				},
				set fileType(attType) {
					this.attachmentType = attType;
				},
				get getFileName() {
					return this.attachmentName;
				}
				,
				get getFileType() {
					return this.attachmentType;
				}
				,
				get getId() {
					return this.eventId;
				}
			}
			this.disableButton = true;
			this.deleteAttachment()
				.then(result => {
					return this.saveEvents(eventObj, allDayEventStartDate, allDayEventEndDate);
				})
				.then(resId => {
					fileDetail.eventId = resId;
					let attachmentUpload = this.attachmentUpload;
					
					if (attachmentUpload) {
						fileDetail.attachmentType = attachmentUpload.type;
						fileDetail.attachmentName = attachmentUpload.name.length > 40
							? attachmentUpload.name.substring(0, 40)
							: attachmentUpload.name;
						return this.loadFileContent(attachmentUpload)
						
					} else if (resId && resId !== null && resId.length > 0) {
						this.goToRecord(resId);
						throw new Error('Success'); // Used for stop further execution
					}
				})
				.then((fileContent) => {
					let image = '';
					if (fileContent && fileContent.indexOf("image") > -1) {
						image = fileContent.split(",")[1];

						if(this.selectedImageType === constants.imageTypes.RELATED_FILES) {
							let fileName = this.fileName.replace(labelImageToBeUploaded , '');
							return this.saveFile(fileDetail.eventId, fileName, image);
						} else {
							return this.saveAttachment(fileDetail.getId, fileDetail.getFileType, fileDetail.getFileName, image);
						}
					}
				})
				.then(result => {
					this.loading = false;
					this.goToRecord(fileDetail.getId);
				})
				.catch(error => {
					this.loading = false;
					console.log('Error.... : ' + error);
				})
		} else {
			this.loading = false;
			console.log("Got some error");
			this.strError = ValMsgOnSave;
		}
	}
	
	saveEvents(eventObj, allDayEventStartDate, allDayEventEndDate) {
		return new Promise((resolve, reject) => {
			let selectedTopicIds = this.selectedTopicIds;
			let strFilterByTopic = selectedTopicIds.join(',');
			let audience = this.audienceSelected;
			
			saveEvents({
				eventObj: eventObj,
				strEventFilterTopic: strFilterByTopic,
				allDayEventStartDate: allDayEventStartDate,
				allDayEventEndDate: allDayEventEndDate,
				audience: audience
			})
				.then(result => {
					let data = result;
					let resId;
					if (data) {
						resId = data.Id;
					}
					resolve(resId);
				})
				.catch(error => {
					let errors = error;
					if (errors[0] && errors[0].fieldErrors) {
						if (errors[0].fieldErrors.EntityId[0].message.length > 0) {
							this.strError = errors[0].fieldErrors.EntityId[0].message;
						}
					}
					if (errors[0] && errors[0].pageErrors) {
						this.strError = errors[0].pageErrors[0].message;
					}
					if (errors[0] && errors[0].message) {
						this.strError = errors[0].message;
					}
					reject(errors);
				})
		});
	}
	
	deleteAttachment() {
		return new Promise((resolve, reject) => {
			if (this.isFileSelected || this.isFileDeleted) {
				deleteAttachment({
					eventRecordId: this.recordId
				})
					.then(result => {
						let attachments = result;
						this.attachments = attachments;
						resolve("SUCCESS");
					})
					.catch(error => {
						this.error = error;
						reject(error);
					})
			} else
				resolve("SUCCESS");
		});
	}
	
	loadFileContent(fileUpload) {
		return new Promise((resolve, reject) => {
			const reader = new FileReader();
			reader.readAsDataURL(fileUpload);
			reader.onload = () => resolve(reader.result);
			reader.onerror = error => reject(error);
		});
	}
	
	saveAttachment(resId, attachmentType, attachmentName, image) {
		return new Promise((resolve, reject) => {
			updateImage({
				eventId: resId,
				attachmentType: attachmentType,
				attachmentName: attachmentName,
				image: image
			})
				.then(result => {
					let data = result
					if (data.Id !== null) {
						resolve(resId);
					} else {
						this.strError = labelAttachmentFailErrMsg + ' ' + errors[0].message;
					}
				})
				.catch(error => {
					let errors = error;
					this.strError = labelAttachmentFailErrMsg + ' ' + errors[0].message;
					alert("Attachment Error: " + errors[0].message);
					reject(errors);
				})
		});
	}

	saveFile(eventId, attachmentName, image) {
		return new Promise((resolve, reject) => {
			saveRelatedFile({
				eventId: eventId,
				attachmentName: attachmentName,
				image: image
			})
				.then(result => {
					let data = result
					if (data.Id !== null) {
						resolve(eventId);
					} else {
						this.strError = labelAttachmentFailErrMsg + ' ' + errors[0].message;
					}
				})
				.catch(error => {
					let errors = error;
					this.strError = labelAttachmentFailErrMsg + ' ' + errors[0].message;
					alert("File Error: " + errors[0].message);
					reject(errors);
				})
		});
	}
	
	handleCancelButton() {
		if (this.isEdit) {
			this.isEdit = false;
			this.goToRecord(this.recordId);
		} else {
			this.gotoUrl(this.allEventsUrl);
		}
	}
	
	getEventsRecord() {
		this.loading = true;
		getEventRecord({
			eventRecordId: this.recordId,
			customFields: this.getCustomFields()
		})
			.then(result => {
				this.loading = false;
				let eventsListWrapper = result;
				let eventObj = eventsListWrapper.objEventList[0];
				this.eventObj = eventObj;
				this.userTimeZone = eventsListWrapper.strTimeZone;
				
				let allDayEvent = eventObj['All_Day_Event__c'];
				this.allDayEventStartDate = eventObj['All_Day_Start__c'];
				this.allDayEventEndDate = eventObj['All_Day_End__c'];
				this.eventStartTime = eventObj['Start_DateTime__c'];
				this.eventEndTime = eventObj['End_DateTime__c'];
				this.eventName = eventObj.Name;
				this.eventAllDay = eventObj['All_Day_Event__c'];
				this.attachments = eventObj.Attachments;
				this.eventDetails = eventObj['Details__c'];
				this.eventLocationName = eventObj['Location_Name__c'];
				this.eventEnablePricing = eventObj['Enable_Pricing_Payment__c'];
				this.eventEnableRSVP = eventObj['Enable_RSVP__c'];
				this.eventGroupId = eventObj['GroupId__c'];
				this.eventLocationAddress = eventObj['Location_Address__c'];
				this.eventLocationURl = eventObj['Location_URL__c'];
				this.eventPaymentURL = eventObj['Payment_URL__c'];
				this.eventRSVPThreshold = eventObj['RSVP_Count_Threshold__c'];
				this.eventTicketPrice = eventObj['Ticket_Price__c'];
				this.eventVenueInfo = eventObj['Venue_Information__c'];
				this.eventType = eventObj['Event_Type__c'];
				this.audienceAssigned = eventObj['Audience_Selected__c'];
				this.selectedImageType = eventObj["Image_Type__c"];
				this.imageReference = eventObj["Image_Reference__c"];
				this.imageURL =  eventsListWrapper.eventIdtoimageURLMap[eventsListWrapper.objEventList[0].Id];
				this.cmsImageURL = eventObj["Image_Type__c"] === constants.imageTypes.CMS_CONTENT ? eventsListWrapper.eventIdtoimageURLMap[eventsListWrapper.objEventList[0].Id] : '';
				this.attachedFileURL = eventsListWrapper.attachedFileURL;

				// List of attached related files having images
				let options = [];
				eventsListWrapper.relatedFilesDetails.forEach(element => {
					if(element.selectedImage === true) {
						this.selectedFile = element.latestImageVersionId;
						this.fileName = labelCurrentImage + ' ' + element.imageTitle;
					}
					options.push({label: element.imageTitle, value: element.latestImageVersionId});
				});

				this.relatedFileList = options;
				this.showRelatedFileList = this.isEdit && this.relatedFileList && this.relatedFileList.length>0;
				
				let languageEnabled = this.userLangEnabled;
				if (languageEnabled != null) {
					this.eventsLanguage = eventObj['Language__c'];
				}
				for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
					let customField = this[`customField${pos}`];
					if (customField && customField.length) {
						let customValue = eventObj[customField];
						if (customValue) {
							this[`customValue${pos}`] = customValue;
						}
					}
				}
				if (eventObj['GroupId__c']) {
					let groupIdCmp = this.template.querySelector("[data-id=filterByGroup]");
					groupIdCmp.value = eventObj['GroupId__c'];//need to check - eventGroupId
				}
				this.disableDateTime = allDayEvent;
				
				if (eventObj.Attachments && eventObj.Attachments.length > 0) {
					this.isAttachment = true;
					this.attachmentName = this.selectedImageType === constants.imageTypes.ATTACHMENT ? labelCurrentImage + ' ' + eventObj.Attachments[0].Name : labelImageToBeUploaded + ' ' + eventObj.Attachments[0].Name;
					this.attachmentPath = this.sitePrefix + custom.ATTACHMENT_PATH + eventObj.Attachments[0].Id;
				}
				this.getImagePreview();	
				
				eventsListWrapper.objEventList[0].topics = [];
				
				if (eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[0].Id] !== undefined) {
					eventsListWrapper.objEventList[0].topics.push(
						eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[0].Id]
					);
				}
				eventObj.topics = [];
				eventObj.topics.push(eventsListWrapper.eventsToTopicsMap[eventsListWrapper.objEventList[0].Id]);
				let selectedTopics = [];
				if (eventObj.topics[0] && eventObj.topics[0].length) {
					eventObj.topics[0].forEach(topic => {
						selectedTopics.push(topic.TopicId);
					});
				}
				this.selectedTopicIds = selectedTopics;
				this.clearError();
			})
			.catch(error => {
				this.loading = false;
				this.error = error;
				console.error("Error occurred getting Event Record:" + JSON.stringify(error));
			})
	}
	
	clearError() {
		this.disableButton = false;
	}
	
	getCustomFields() {
		let customFields = '';
		for (let pos = 1; pos <= custom.MAX_FIELDS; pos++) {
			let customField = this[`customField${pos}`];
			if (customField && customField.length) {
				customFields += customField + ',';
			}
		}
		return customFields;
	}
	
	getEventAudience() {
		if (this.audienceEnabled) {
			getAudienceIdForRecId({
				networkId: '',
				recordId: this.recordId
			})
				.then(audienceId => {
					if (audienceId && audienceId.length > 0) {
						this.audienceSelected = audienceId;
						this.audienceName = this.getAudienceName();
						this.audienceShowDelete = true;
						this.audienceShowCombo = false;
					} else
						this.audienceShowCombo = true;
				})
				.catch(error => {
					this.error = error;
					console.error("Error getting Event Audience:" + error);
				})
		}
	}
	
	getAudienceName() {
		const audienceId = this.audienceSelected;
		const audienceList = this.audienceList;
		let currentAudience = audienceList.filter(item => item.value === audienceId);
		return currentAudience ? currentAudience[0].label : '';
	}
	
	goToRecord(recId) {
		this[NavigationMixin.Navigate]({
			type: "standard__recordPage",
			attributes: {
				recordId: recId,
				actionName: "view"
			}
		});
	}
	
	gotoUrl(url) {
		if (inLexMode()) {
			this[NavigationMixin.Navigate]({
				type: 'standard__navItemPage',
				attributes: {
					apiName: url
				}
			});
		} else {
			this[NavigationMixin.Navigate]({
				type: 'comm__namedPage',
				attributes: {
					name: url
				}
			});
		}
	}
	
	hideSpinner() {
		this.loading = false;
	}
	
	showSpinner() {
		this.loading = true;
	}

	handleImageError(event) {
		this.invalidImage = true;
		this.previewURL = '';
	}
}