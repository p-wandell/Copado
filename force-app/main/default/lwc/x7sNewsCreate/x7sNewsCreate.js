/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */
import {api, LightningElement, track, wire} from "lwc";
import {CurrentPageReference, NavigationMixin} from "lightning/navigation";
import {formatText} from 'c/x7sShrUtils';
import {inLexMode} from 'c/x7sShrUtils';
import {constants} from 'c/x7sNewsBase';

import x7sNewsDetailError from "@salesforce/label/c.x7sNewsDetailError";
import x7sNewsDetailPlaceholder from "@salesforce/label/c.x7sNewsDetailPlaceholder";
import x7sNewsAttachmentName from "@salesforce/label/c.x7sNewsAttachmentName";
import x7sNewsLabelNewsTitle from "@salesforce/label/c.x7sNewsLabelNewsTitle";
import x7sNewsLabelNewsDescription from "@salesforce/label/c.x7sNewsLabelNewsDescription";
import x7sNewsLabelNewsBody from "@salesforce/label/c.x7sNewsLabelNewsBody";
import x7sNewsLabelFullArticle from "@salesforce/label/c.x7sNewsLabelFullArticle";
import x7sNewsLabelSelectTopics from "@salesforce/label/c.x7sNewsLabelSelectTopics";
import x7sNewsLabelUploadPhoto from "@salesforce/label/c.x7sNewsLabelUploadPhoto";
import x7sNewsLabelArticleAuthor from "@salesforce/label/c.x7sNewsLabelArticleAuthor";
import x7sNewsLabelShowAuthor from "@salesforce/label/c.x7sNewsLabelShowAuthor";
import x7sNewsLabelDetailSelectAuthor from "@salesforce/label/c.x7sNewsLabelDetailSelectAuthor";
import x7sNewsLabelSchedulePublication from "@salesforce/label/c.x7sNewsLabelSchedulePublication";
import x7sNewsLabelLimitToSpecificGroups from "@salesforce/label/c.x7sNewsLabelLimitToSpecificGroups";
import x7sNewsLabelInvalidInput from "@salesforce/label/c.x7sNewsLabelInvalidInput";
import x7sNewsLabelAll from "@salesforce/label/c.x7sNewsLabelAll";
import x7sNewsLanguageCombobox from "@salesforce/label/c.x7sNewsLanguageCombobox";
import x7sNewsAuthorPlaceHolder from "@salesforce/label/c.x7sNewsAuthorPlaceHolder";
import x7sNewsLabelPublishNow from "@salesforce/label/c.x7sNewsLabelPublishNow";
import x7sNewsLabelPostPublishNow from "@salesforce/label/c.x7sNewsLabelPostPublishNow";
import x7sNewsLabelSetPublishDate from "@salesforce/label/c.x7sNewsLabelSetPublishDate";
import x7sNewsButtonSchedulePost from "@salesforce/label/c.x7sNewsButtonSchedulePost";
import x7sNewsButtonPublishNow from "@salesforce/label/c.x7sNewsButtonPublishNow";
import x7sNewsSubmitNewsText from "@salesforce/label/c.x7sNewsSubmitNewsText";
import labelShowSource from "@salesforce/label/c.x7sNewsLabelShowSource";
import labelShowEditor from "@salesforce/label/c.x7sNewsCreateLabelShowEditor";
import x7sNewsLabelCancel from "@salesforce/label/c.x7sNewsLabelCancel";
import labelSchedulePublication from "@salesforce/label/c.x7sNewLabelSchedulePublication";
import labelPublishDateDesc from "@salesforce/label/c.x7sNewsLabelPublishDateDesc";
import labelPublishDate from "@salesforce/label/c.x7sNewsLabelPublishDate";
import labelArchiveDateDesc from "@salesforce/label/c.x7sNewsCreateLabelArchiveDateDesc";
import labelArchiveDate from "@salesforce/label/c.x7sNewsCreateLabelArchiveDate";
import x7sNewsCreateLabelButtonAddTopics from "@salesforce/label/c.x7sNewsCreateLabelButtonAddTopics";
import x7s_News_Filters_Topics from "@salesforce/label/c.x7sNewsFiltersTopics";
import labelGroupDesc from "@salesforce/label/c.x7sNewsCreateLabelGroupDesc";
import labelPrivateGroup from "@salesforce/label/c.x7sNewsLabelPrivateGroup";
import tooltipPrivateGroup from "@salesforce/label/c.x7sNewsTooltipPrivateGroup";
import x7sNewsLabelSelectAuthor from "@salesforce/label/c.x7sNewsLabelSelectAuthor";
import labelNewInvalidInput from "@salesforce/label/c.x7sNewsCreateLabelNewInvalidInput";
import x7sNewsCreateLabelAudience from "@salesforce/label/c.x7sNewsCreateLabelAudience";
import x7sNewsCreateAudienceNoAccess from "@salesforce/label/c.x7sNewsCreateAudienceNoAccess";
import x7sNewsCreateTooltipDeleteAudience from "@salesforce/label/c.x7sNewsCreateTooltipDeleteAudience";
import x7sNewsCreatePlaceHolderAudience from "@salesforce/label/c.x7sNewsCreatePlaceHolderAudience";
import x7s_Feature_Image_Policy from "@salesforce/label/c.x7sFeatureImagePolicy";
import labelMaxFileSize from "@salesforce/label/c.x7sNewsCreateLabelMaxFileSize";
import x7s_NewsEdit_News_Label from "@salesforce/label/c.x7sNewsTitleEdit";
import x7sNewsAriaLabelForNewsCreateLandmark from "@salesforce/label/c.x7sNewsAriaLabelForNewsCreateLandmark";
import x7sNewsAriaLabelForSelectedTopics from '@salesforce/label/c.x7sNewsAriaLabelForSelectedTopics';

import get_topics from "@salesforce/apex/x7sNewsController.getTopics";
import getLanguageOption from "@salesforce/apex/x7sNewsController.getLanguageOption";
import get_language from "@salesforce/apex/x7sNewsController.getLanguage";
import require_Group_Membership from "@salesforce/apex/x7sNewsController.requireGroupMembership";
import user_Authorized_To_Post from "@salesforce/apex/x7sNewsController.userAuthorizedToPost";
import get_Groups from "@salesforce/apex/x7sNewsController.getGroups";
import get_Users from "@salesforce/apex/x7sNewsController.getUsers";
import saveNews from "@salesforce/apex/x7sNewsController.saveNews";
import delete_Attachment from "@salesforce/apex/x7sNewsController.deleteAttachment";
import getSitePrefix from "@salesforce/apex/x7sNewsController.getSitePrefix";
import get_News_Record from "@salesforce/apex/x7sNewsController.getNewsRecord";
import getCurrentUser from "@salesforce/apex/x7sNewsController.getCurrentUser";
import searchUsers from "@salesforce/apex/x7sNewsController.searchUsers";
import audienceEnabled from "@salesforce/apex/x7sNewsController.audienceEnabled";
import deleteCurrentAudience from "@salesforce/apex/x7sNewsController.deleteCurrentAudience";
import getAudienceIdForRecordId from "@salesforce/apex/x7sNewsController.getAudienceIdForRecordId";
import get_audienceList from "@salesforce/apex/x7sNewsController.getAudienceList";

import currentUserId from "@salesforce/user/Id";

export default class X7sNewsCreate extends NavigationMixin(LightningElement) {
	
	//builder properties
	@api recordId;
	@api headingTitle = "Create News Article";
	@api requireTopics = false;
	@api variant = "featured";
	@api allowShowSource = false;
	@api pathToDetail = "/news/";
	@api allNewsUrl = "/news/";
	@api limitToSpecificGroups = false;
	@api headerAlignment = "center";
	@api customClass = '';
	@api ariaLandmarkRoleForComponent = 'main';
	
	newsName = "";
	newsDetails = "";
	newsShowAuthor = false;
	newsAuthor = "";
	newsGroup = "";
	newsPrivate = false;
	newsPublishDate;
	newsArchiveDate;
	
	detailValid = true;
	detailError = x7sNewsDetailError;
	detailPlaceholder = x7sNewsDetailPlaceholder;
	@track topicValues = [];
	@track groupValues = [];
	@track languageValues = [];
	isFileSelected = false;
	authorValues = [];
	strError;
	isBrowseError;
	detailPageUrl = "/news/";
	sitePath;
	sitePrefix;
	useTopics = false;
	strAttachmentError;
	isEdit = false;
	
	disableButton = false;
	attachmentName = x7sNewsAttachmentName;
	labelNewsTitle = x7sNewsLabelNewsTitle;
	labelNewsDescription = x7sNewsLabelNewsDescription;
	labelNewsBody = x7sNewsLabelNewsBody;
	labelFullArticle = x7sNewsLabelFullArticle;
	labelSelectTopics = x7sNewsLabelSelectTopics;
	labelUploadPhoto = x7sNewsLabelUploadPhoto;
	labelArticleAuthor = x7sNewsLabelArticleAuthor;
	labelShowAuthor = x7sNewsLabelShowAuthor;
	labelSelectAuthor = x7sNewsLabelDetailSelectAuthor;
	labelSchedulePublication = x7sNewsLabelSchedulePublication;
	labelLimitToSpecificGroups = x7sNewsLabelLimitToSpecificGroups;
	labelInvalidInput = x7sNewsLabelInvalidInput;
	labelAll = x7sNewsLabelAll;
	labelEditNews = x7s_NewsEdit_News_Label;
	ariaLabelForNewsCreateLandmark = x7sNewsAriaLabelForNewsCreateLandmark;
	ariaSelectedTopicsLabel = x7sNewsAriaLabelForSelectedTopics;

	// language
	
	requireLanguage = false;
	newsLanguage = "";
	labelLanguage = x7sNewsLanguageCombobox;
	userLangEnabled;
	
	// Groups
	
	requireGroups = false;
	canPostToAll = false;
	
	// author search
	
	authorPlaceHolder = x7sNewsAuthorPlaceHolder;
	searchString = "";
	searchFlag = false;
	
	// Publish
	
	labelPublishNow = x7sNewsLabelPublishNow;
	labelPostPublishNow = x7sNewsLabelPostPublishNow;
	labelSetPublishDate = x7sNewsLabelSetPublishDate;
	publishNow = false;
	
	// Audience targeting
	
	audienceEnabled = true;
	audienceLabel = x7sNewsCreateLabelAudience;
	audiencePlaceHolder = x7sNewsCreatePlaceHolderAudience;
	audienceList = [];
	audienceSelected = "";
	audienceName = "";
	audienceAssigned = false;
	audienceShowCombo = true;
	audienceShowDelete = false;
	audienceNoAccess = false;
	
	// Buttons
	
	buttonSchedulePost = x7sNewsButtonSchedulePost;
	buttonPublishNow = x7sNewsButtonPublishNow;
	submitNewsText = x7sNewsSubmitNewsText;
	labelCancel = x7sNewsLabelCancel;
	
	// File upload
	
	isFileDelete = false;
	isAttachment = false;
	@api attachmentAccept = "png,jpg,jpeg,gif";
	@track attachmentUpload = [];
	@track selectedItemIds = [];
	attachmentList;
	
	topics;
	topicSelected = false;
	
	isLoading = true;
	showSource;
	isError = false;
	@track newsObj = [];
	
	labelwhenoff = labelShowSource;
	labelwhenon = labelShowEditor;
	schedulePublication = labelSchedulePublication;
	publishDateDesc = labelPublishDateDesc;
	publishDateLabel = labelPublishDate;
	labelArchiveDateDesc = labelArchiveDateDesc;
	labelArchiveDate = labelArchiveDate;
	addTopics = x7sNewsCreateLabelButtonAddTopics;
	filterTopicLabel = x7s_News_Filters_Topics;
	labelGroupDesc = labelGroupDesc;
	tooltip_privateGroup = tooltipPrivateGroup;
	label_privateGroup = labelPrivateGroup;
	newsLabelSelectAuthor = x7sNewsLabelSelectAuthor;
	newInvalidInput = labelNewInvalidInput;
	newsCreateTooltipDeleteAudience = x7sNewsCreateTooltipDeleteAudience;
	newsCreateAudienceNoAccess = x7sNewsCreateAudienceNoAccess;
	x7sFeatureImagePolicy = x7s_Feature_Image_Policy;
	
	@wire(CurrentPageReference) pageRef;
	
	connectedCallback() {
		let newURL = new URL(window.location.href).searchParams;
		const urlSet = constants.edit;
		
		this.isEdit = newURL.get(urlSet.editMode);
		
		if (this.isEdit) {
			this.recordId        = newURL.get(urlSet.id);
			this.allowShowSource = newURL.get(urlSet.showSource);
			this.requireTopics   = newURL.get(urlSet.requireTopics);
			this.limitToSpecificGroups = newURL.get(urlSet.limitGroups);
			this.headingTitle = this.labelEditNews;
			
			this.submitNewsText = "Save";
		}
		
		this.isLangEnabled();
		this.isAudienceEnabled();
		this.isLoading = false;
		this.getTopics();
		this.get_SitePrefix();
		
		this.getAuthors();
		if (this.limitToSpecificGroups) {
			this.getGroups();
		}
		
		if (this.isEdit) {
			this.getNewsRecord();
			this.getNewsAudience();
		} else {
			if (!this.newsAuthor) {
				this.setDefaultAuthor();
			}
		}
	}
	
	get user_Lang_Enabled() {
		return this.userLangEnabled !== "" && this.userLangEnabled !== undefined;
	}
	
	handleName(event) {
		this.newsName = event.target.value;
		this.nameValidate();
		this.setSubmitButtonStateCheck();
	}
	
	handleLanguage(event) {
		this.newsLanguage = event.target.value;
	}
	
	handleArchive(event) {
		this.newsArchiveDate = event.target.value;
		this.dateValidate();
	}
	
	handlePublish(event) {
		this.newsPublishDate = event.target.value;
		this.dateValidate();
	}
	
	handleAuthor(event) {
		this.newsAuthor = event.target.value;
	}
	
	handlePrivate(event) {
		this.newsPrivate = event.target.checked;
	}
	
	handleAuthorDropdown(event) {
		this.newsShowAuthor = event.target.checked;
		this.showHideAuthors();
	}
	
	handleAudience(event) {
		this.audienceSelected = event.target.value;
	}
	
	handleDetail(event) {
		this.newsDetails = event.target.value;
		this.detailValidate();
		this.setSubmitButtonStateCheck();
	}
	
	handleSearch(event) {
		this.searchString = event.target.value;
		if (!this.searchFlag) {
			this.isLoading = true;
			this.searchAuthors();
		}
	}
	
	handleGroup(event) {
		this.newsGroup = event.target.value;
	}
	
	handleCancel() {
		if (this.isEdit) {
			this.goToRecord(this.recordId);
		} else {
			this.gotoUrl(this.allNewsUrl);
		}
	}
	
	handleTopicChangeEvent(event) {
		this.selectedItemIds = event.detail;
		this.setSubmitButtonStateCheck();
	}
	
	handleSourceToggle() {
		this.showSource = !this.showSource;
	}
	
	nameValidate() {
		let newsName = this.newsName;
		let inputTitleCmp = this.template.querySelector("[data-id=newsName]");
		if (!newsName || newsName.trim() === "") {
			inputTitleCmp.setCustomValidity("Please fill out the Title field.");
			this.isError = true;
		} else {
			if (newsName.length > 80) {
				inputTitleCmp.setCustomValidity(
					"Event Title cannot exceed 80 characters. Please enter a title less than 80 characters."
				);
				this.isError = true;
			} else {
				inputTitleCmp.setCustomValidity("");
				this.isError = false;
			}
		}
		inputTitleCmp.reportValidity();
	}
	
	detailValidate() {
		let fullArticleCmp = this.newsDetails;
		if (!fullArticleCmp) {
			this.detailValid = false;
			this.isError = true;
		} else {
			this.detailValid = true;
			this.isError = false;
		}
	}
	
	dateValidate() {
		let pbdt = new Date(this.newsPublishDate);
		let ardt = new Date(this.newsArchiveDate);
		let publishDate = this.newsPublishDate;
		let publishDateCmp = this.template.querySelector("[data-id=publishDate]");
		if (!publishDate || publishDate.trim() === "") {
			publishDateCmp.setCustomValidity("Please Select Publication Date.");
			this.isError = true;
		} else {
			if (ardt !== null && ardt && pbdt > ardt) {
				publishDateCmp.setCustomValidity(
					"Publication date must be before archive date."
				);
				this.isError = true;
			} else {
				publishDateCmp.setCustomValidity("");
				this.isError = false;
			}
		}
		publishDateCmp.reportValidity();
	}
	
	submitNews() {
		this.setSubmitButtonStateCheck();
		this.isLoading = true;
		this.showSource = false;
		this.strError = null;
		this.isBrowseError = false;
		
		let fileInput = this.attachmentList;
		// Input validation
		this.nameValidate();
		this.dateValidate();
		this.detailValidate();
		
		if (
			fileInput &&
			fileInput.length > 0 &&
			fileInput[0].type.indexOf("image") === -1
		) {
			this.isError = true;
			this.isBrowseError = true;
			this.strError = "Error : Selected file must be an image.";
		} else if (
			fileInput &&
			fileInput.length > 0 &&
			fileInput[0].size > 25000000
		) {
			this.isError = true;
			this.isBrowseError = true;
			this.strError = "Error : Image size must be less than 25MB.";
		} else {
			if (
				this.isEdit &&
				this.attachmentName === "No File Chosen" &&
				this.isAttachment
			) {
				this.isFileDelete = true;
			}
			this.isBrowseError = false;
			this.strError = null;
		}
		if (this.isError === true) {
			console.log("Error Occured---" + this.strError);
			this.isLoading = false;
		} else {
			let newsObj = {};
			newsObj["id"] = this.recordId;
			newsObj["name"] = this.newsName;
			newsObj["details"] = this.newsDetails;
			newsObj["groupId"] = this.newsGroup || "";
			newsObj["language"] = this.newsLanguage || "";
			newsObj["privateGroup"] = this.newsPrivate;
			newsObj["showAuthor"] = this.newsShowAuthor;
			newsObj["author"] = this.newsAuthor;
			newsObj["publishDate"] = this.newsPublishDate;
			newsObj["archiveDate"] = this.newsArchiveDate;
			
			this.submit_News(newsObj);
		}
	}
	
	submit_News(newsObj) {
		let selectedItemIds = this.selectedItemIds;
		let strFilterByTopic = selectedItemIds.join(constants.custom.FIELD_SEPARATOR);
		
		if (this.isFileSelected || this.isFileDelete) {
			this.deleteAttachment();
		}
		
		if (this.attachmentUpload && this.attachmentUpload.length) {
			this.loadFileContent(this.attachmentUpload[0])
				.then(fileContent => {
						if (fileContent.indexOf("image") > -1) {
							this.saveNewsCallout(
								newsObj,
								strFilterByTopic,
								this.attachmentUpload[0].type,
								this.attachmentUpload[0].name.substring(0, 40),
								fileContent.split(",")[1]);
						}
					},
					(error) => console.log(error)
				);
		} else {
			this.saveNewsCallout(newsObj, strFilterByTopic, '', '', '');
		}
	}
	
	saveNewsCallout(
		newsObj,
		strFilterByTopic,
		attachmentType,
		attachmentName,
		image
	) {
		let audience = this.audienceSelected;
		let modelFinal = JSON.stringify(newsObj);
		saveNews({
			model: modelFinal,
			strFilterByTopic: strFilterByTopic,
			attachmentType: attachmentType,
			attachmentName: attachmentName,
			image: image,
			audience: audience
		})
			.then((result) => {
				this.isLoading = false;
				let data = result.id;
				this.goToRecord(data);
			})
			.catch((error) => {
				this.isLoading = false;
				this.error = error;
			});
	}
	
	getNewsRecord() {
		this.isLoading = true;
		this.attachmentName = "No File Chosen";
		get_News_Record({newsRecordId: this.recordId})
			.then((result) => {
				this.isLoading = false;
				let newsListWrapper = result;
				if (
					newsListWrapper.newsList[0].Attachments &&
					newsListWrapper.newsList[0].Attachments.length > 0
				) {
					this.isAttachment = true;
					this.attachmentName = newsListWrapper.newsList[0].Attachments[0].Name;
				}
				let newsObj = newsListWrapper.newsList[0];
				this.newsObj = newsObj;
				this.newsName = newsObj.Name;
				this.newsDetails = newsObj["Details__c"];
				this.newsShowAuthor = newsObj["Show_Author__c"];
				this.newsAuthor = newsObj["Author__c"];
				this.newsPublishDate = newsObj["Publish_DateTime__c"];
				this.newsArchiveDate = newsObj["Archive_DateTime__c"];
				this.newsLanguage = newsObj["Language__c"];
				this.audienceAssigned = newsObj["Audience_Selected__c"];
				
				if (this.limitToSpecificGroups) {
					if (newsObj["GroupId__c"] && newsObj["GroupId__c"].length > 0) {
						this.newsGroup = newsObj["GroupId__c"];
						this.newsPrivate = newsObj["Private_Group__c"];
						
						let groupList = this.groupValues;
						if (groupList) {
							groupList.forEach((item) => {
								if (item.value === newsObj["GroupId__c"]) {
									item.selected = true;
									this.newsGroup = item.value;
								}
							});
							this.groupValues = groupList;
						}
					}
				}
				
				newsObj.topics = [];
				newsObj.topics.push(newsListWrapper.newsToTopicsMap[newsObj.Id]);
				if (newsObj.topics[0] && newsObj.topics[0].length) {
					let selection = [];
					newsObj.topics[0].forEach((topic) => {
						selection.push(topic.TopicId);
					});
					this.selectedItemIds = selection;
				}
				
				let showAuthor = this.showHideAuthors();
				
				// make sure the current author is in the drop down list and selected
				if (showAuthor) {
					let itemAuthor = newsObj["Author__c"];
					this.addAuthorToSelection(itemAuthor.Id, itemAuthor.Name);
					this.newsAuthor = newsObj["Author__c"];
				}
				
				this.setSubmitButtonStateCheck();
			})
			.catch((error) => {
				this.isLoading = false;
				this.error = error;
			});
	}
	
	isAudienceEnabled() {
		audienceEnabled()
			.then((result) => {
				this.audienceEnabled = result;
				if (this.audienceEnabled) {
					this.getAudienceList();
				}
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	getAudienceList() {
		get_audienceList({networkId: "", currentUser: ""})
			.then((items) => {
				let audienceList = [];
				audienceList.push({label: "All", value: ""});
				this.audienceSelected = "";
				
				for (let item in items) {
					if (items.hasOwnProperty(item)) {
						audienceList.push({label: items[item], value: item});
					}
				}
				this.audienceList = audienceList;
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	getNewsAudience() {
		if (this.audienceEnabled) {
			getAudienceIdForRecordId({
				networkId: "",
				currentUser: "",
				recordId: this.recordId
			}).then((audienceId) => {
				if (audienceId && audienceId.length > 0) {
					this.audienceSelected = audienceId;
					this.audienceName = this.getAudienceName();
					this.audienceShowDelete = true;
					this.audienceShowCombo = false;
				} else {
					if (this.audienceAssigned) {
						this.audienceNoAccess = true;
						this.audienceShowCombo = false;
					}
				}
			});
		}
	}
	
	getAudienceName() {
		const audienceId = this.audienceSelected;
		const audienceList = this.audienceList;
		let currentAudience = audienceList.filter(
			(item) => item.value === audienceId
		);
		return currentAudience ? currentAudience[0].label : "";
	}
	
	notifyFileSelected(event) {
		let fileInput = event.target.files;
		
		if (fileInput && fileInput.length) {
			console.log("Event: ", event.target.files);
			let file = fileInput[0];
			
			if (file.size > constants.custom.MAX_FILE_SIZE) {
				
				this.attachmentName = formatText(labelMaxFileSize, constants.custom.MAX_FILE_SIZE, file.size);
				this.isFileSelected = false;
			} else {
				this.isFileSelected = true;
				this.attachmentName = fileInput[0].name;
				this.attachmentList = fileInput;
				this.attachmentUpload.push(fileInput[0]);
			}
		}
	}
	
	loadFileContent(fileUpload) {
		return new Promise((resolve, reject) => {
			const reader = new FileReader();
			
			reader.readAsDataURL(fileUpload);
			//reader.readAsArrayBuffer(fileUpload);
			
			reader.onload = () => resolve(reader.result);
			reader.onerror = (error) => reject(error);
		});
	}
	
	deleteAudience() {
		deleteCurrentAudience({recordId: this.recordId})
			.then(() => {
				this.audienceSelected = "";
				this.audienceShowCombo = true;
			})
			.catch((error) => {
				this.error = error;
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
	
	getTopics() {
		get_topics()
			.then((result) => {
				let data = result;
				this.topicValues = Object.keys(data).map((key) => {
					return {name: data[key], id: key};
				});
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	getAuthors() {
		get_Users()
			.then((result) => {
				let data = result;
				let userId = currentUserId;
				let res = Object.keys(data).map((key) => {
					return {label: data[key], value: key, selected: userId === key};
				});
				let sortedUsers = res.sort((a, b) => a.label.localeCompare(b.label));
				if (sortedUsers.find((x) => x.key === userId)) {
					this.newsAuthor = userId;
				}
				this.authorValues = sortedUsers;
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	searchAuthors() {
		let search = this.searchString;
		searchUsers({searchString: search})
			.then((result) => {
				this.searchFlag = false;
				let values = result;
				let valuesTemp = [];
				for (let value in values) {
					if (values.hasOwnProperty(value)) {
						valuesTemp.push({
							value: value,
							label: values[value],
							selected: false
						});
					}
				}
				
				// handle edge condition
				if (valuesTemp.length === 1) {
					valuesTemp[0].selected = true;
					this.newsAuthor = valuesTemp[0].value;
				}
				this.authorValues = valuesTemp;
				this.isLoading = false;
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	getLanguage() {
		getLanguageOption()
			.then((result) => {
				let data = result;
				this.languageValues = Object.keys(data).map((key) => {
					return {label: key, value: data[key]};
				});
				let selectedLanguage = this.newsLanguage;
				let userDefaultLang = this.userLangEnabled;
				
				if (selectedLanguage === "" && userDefaultLang != null) {
					this.newsLanguage = userDefaultLang;
				}
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	isLangEnabled() {
		get_language()
			.then((result) => {
				this.userLangEnabled = result;
				if (this.userLangEnabled) {
					this.getLanguage();
				}
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	requireGroupMembership() {
		require_Group_Membership()
			.then((result) => {
				this.requireGroups = result;
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	userAuthorizedToPost() {
		user_Authorized_To_Post()
			.then((result) => {
				this.canPostToAll = result;
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	getGroups() {
		this.requireGroupMembership();
		this.userAuthorizedToPost();
		get_Groups()
			.then((result) => {
				let data = result;
				let res = Object.keys(data).map((key) => {
					return {label: data[key], value: key};
				});
				if (!this.requireGroups || this.canPostToAll) {
					res.splice(0, 0, {
						value: "",
						label: this.labelAll
					});
				}
				this.groupValues = res;
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	setDefaultAuthor() {
		getCurrentUser()
			.then((result) => {
				this.newsAuthor = result.Id;
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	addAuthorToSelection(id, name) {
		let authorList = this.authorValues;
		
		// wanted to use the find() function but it is not supported in older browsers
		if (authorList) {
			if (
				!authorList.find((x) => {
					return x.value === id;
				})
			) {
				authorList.push({
					value: id,
					label: name,
					selected: true
				});
				
				this.newsAuthor = id;
				this.authorValues = authorList;
			}
		}
	}
	
	showHideAuthors() {
		let showAuthor = this.newsShowAuthor;
		let cmpTarget = this.template.querySelector(".authorSelection");
		console.log("--cmpTarget-" + cmpTarget);
		if (showAuthor === true) {
			cmpTarget.classList.remove("hideDropdown");
			cmpTarget.classList.add("showDropdown");
		} else {
			cmpTarget.classList.remove("showDropdown");
			cmpTarget.classList.add("hideDropdown");
		}
		
		return showAuthor;
	}
	
	deleteAttachment() {
		delete_Attachment({newsRecordId: this.recordId})
			.then(() => {
				console.log('Attachment deleted');
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	get_SitePrefix() {
		getSitePrefix()
			.then((result) => {
				let sitePath = result;
				this.sitePath = sitePath;
				this.sitePrefix = sitePath.replace("/s", "");
			})
			.catch((error) => {
				this.error = error;
			});
	}
	
	setSubmitButtonStateCheck() {
		this.disableButton = false;
		
		let name = this.newsName.trim();
		let details = this.newsDetails.trim();
		let topics = this.requireTopics ? this.selectedItemIds.length : 1;
		let time = this.newsPublishDate;
		
		if (this.requireTopics) {
			if (this.selectedItemIds.length < 1)
				this.strError = 'Please select a topic';
			else
				this.strError = null;
		}
		
		if (!name || !topics || !details || !time) {
			this.disableButton = true;
		}
	}
	
	toggleSchedule() {
		if (!this.isEdit) {
			if (this.publishNow) {
				this.submitNewsText = this.buttonSchedulePost;
				this.publishNow = false;
			} else {
				this.submitNewsText = this.buttonPublishNow;
				this.publishNow = true;
				
				let today = new Date();
				this.newsPublishDate = today.toISOString();
			}
		}
		this.setSubmitButtonStateCheck();
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
}