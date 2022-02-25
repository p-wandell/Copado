/* eslint-disable no-console */
import { LightningElement, track, api } from "lwc";
import getRecord from "@salesforce/apex/x7sGuideMeController.getRecord";
import updateUser from "@salesforce/apex/x7sGuideMeController.updateUser";

export default class GuideMe extends LightningElement {
	@api modalButtonPosition = "Center";

	@api pageLeft = false;
	@api pageCenter = false;
	@api pageRight = false;

	@api hideButton = false;
	@api showAgainMessage = "";
	@api hasOnePage = false;
	@api hastwoPages = false;
	@api hasThreePages = false;
	@api hasFourPages = false;
	@api hasFivePages = false;
	@api hasSixPages = false;
	@api fieldApiName = "";
	@api hasFieldApiName = false;
	@api autoDisplay = false;
	@api isChecked = false;
	@api error = "";
	@api userRec;

	@api buttonText = "Open Modal";

	@api numberOfPages = "1";

	@api twoPages = false;
	@api threePages = false;
	@api fourPages = false;
	@api fivePages = false;
	@api sixPages = false;

	@api borderOn = false;

	@api topTitle = "";

	@api title = "Title One";
	@api imageSrc = "";
	@api description = "";

	@api titleTwo = "Title Two";
	@api imageSrcTwo = "";
	@api descriptionTwo = "";

	@api titleThree = "Title Three";
	@api imageSrcThree = "";
	@api descriptionThree = "";

	@api titleFour = "Title Four";
	@api imageSrcFour = "";
	@api descriptionFour = "";

	@api titleFive = "Title Five";
	@api imageSrcFive = "";
	@api descriptionFive = "";

	@api titleSix = "Title Six";
	@api imageSrcSix = "";
	@api descriptionSix = "";

	@api pageOne = false;
	@api pageTwo = false;
	@api pageThree = false;
	@api pageFour = false;
	@api pageFive = false;
	@api pageSix = false;

	pageOne = true;

	@track position = 0;

	@api layout = "1 - Image / Step / Desc";

	@api layoutOne = false;
	@api layoutTwo = false;
	@api layoutThree = false;

	@api borderOnOne = false;

	handleBorder() {
		if (this.imageSrc === "") {
			this.borderOnOne = false;
		} else {
			this.borderOnOne = true;
		}
		if (this.imageSrcTwo === "") {
			this.borderOnTwo = false;
		} else {
			this.borderOnTwo = true;
		}
		if (this.imageSrcThree === "") {
			this.borderOnThree = false;
		} else {
			this.borderOnThree = true;
		}
		if (this.imageSrcFour === "") {
			this.borderOnFour = false;
		} else {
			this.borderOnFour = true;
		}
		if (this.imageSrcFive === "") {
			this.borderOnFive = false;
		} else {
			this.borderOnFive = true;
		}
		if (this.imageSrcSix === "") {
			this.borderOnSix = false;
		} else {
			this.borderOnSix = true;
		}
	}

	handleLayout() {
		if (this.layout === "1 - Image / Step / Desc") {
			this.layoutOne = true;
			this.layoutTwo = false;
			this.layoutThree = false;
		}
		if (this.layout === "2 - Step / Desc / Image") {
			this.layoutTwo = true;
			this.layoutOne = false;
			this.layoutThree = false;
		}
		if (this.layout === "3 - Step / Image / Desc") {
			this.layoutThree = true;
			this.layoutTwo = false;
			this.layoutOne = false;
		}
	}

	handleNumberOfPages() {
		if (this.numberOfPages === "1") {
			this.hasOnePage = true;
		}
		if (this.numberOfPages === "2") {
			this.hasTwoPages = true;
			this.twoPages = true;
		}
		if (this.numberOfPages === "3") {
			this.hasThreePages = true;
			this.twoPages = true;
			this.threePages = true;
		}
		if (this.numberOfPages === "4") {
			this.hasFourPages = true;
			this.twoPages = true;
			this.threePages = true;
			this.fourPages = true;
		}
		if (this.numberOfPages === "5") {
			this.hasFivePages = true;
			this.twoPages = true;
			this.threePages = true;
			this.fourPages = true;
			this.fivePages = true;
		}
		if (this.numberOfPages === "6") {
			this.hasSixPages = true;
			this.twoPages = true;
			this.threePages = true;
			this.fourPages = true;
			this.fivePages = true;
			this.sixPages = true;
		}
	}

	handlePageForward() {
		this.position++;
		if (this.position === 0) {
			this.pageOne = true;
		} else if (this.position === 1) {
			this.pageTwo = true;
			this.pageOne = false;
		} else if (this.position === 2) {
			this.pageThree = true;
			this.pageTwo = false;
		} else if (this.position === 3) {
			this.pageFour = true;
			this.pageThree = false;
		} else if (this.position === 4) {
			this.pageFive = true;
			this.pageFour = false;
		} else if (this.position === 5) {
			this.pageSix = true;
			this.pageFive = false;
		}
	}

	handlePageBack() {
		this.position--;
		if (this.position === 5) {
			this.pageSix = true;
		} else if (this.position === 4) {
			this.pageFive = true;
			this.pageSix = false;
		} else if (this.position === 3) {
			this.pageFour = true;
			this.pageFive = false;
		} else if (this.position === 2) {
			this.pageThree = true;
			this.pageFour = false;
		} else if (this.position === 1) {
			this.pageTwo = true;
			this.pageThree = false;
		} else if (this.position === 0) {
			this.pageOne = true;
			this.pageTwo = false;
		}
	}

	@track openmodel = false;

	openmodal() {
		this.openmodel = true;
	}

	closeModal() {
		this.openmodel = false;
		this.position = 0;
		this.pageOne = true;
		this.pageTwo = false;
		this.pageThree = false;
		this.pageFour = false;
		this.pageFive = false;
		this.pageSix = false;
		if (this.userRec) {
			let priorValue = this.userRec[this.fieldApiName];
			if (priorValue !== this.isChecked) {
				this.saveUser();
			}
		}
	}

	saveUser() {
		this.userRec[this.fieldApiName] = this.isChecked;
		//console.log("userrec::" + JSON.stringify(this.userRec));

		updateUser({
			userRec: JSON.stringify(this.userRec)
		}).catch(error => {
			this.isChecked = false;
			this.error = error;
		});
	}

	saveMethod() {
		this.closeModal();
	}

	handleValue(event) {
		this.isChecked = event.target.checked;
		//console.log("Checked " + this.isChecked);
	}

	handlePosition() {
		if (this.modalButtonPosition === "Right") {
			this.pageRight = true;
		}
		if (this.modalButtonPosition === "Left") {
			this.pageLeft = true;
		}
		if (this.modalButtonPosition === "Center") {
			this.pageCenter = true;
		}
		if (this.modalButtonPosition === "None") {
			this.hideButton = true;
		}
	}

	get wrapperClass() {
		return `slds-text-align_${this.modalButtonPosition.toLowerCase()}`;
	}

	handleFieldApi() {
		if (this.fieldApiName !== "") {
			this.hasFieldApiName = true;
			getRecord({
				fieldApiName: this.fieldApiName
			})
				.then(result => {
					this.userRec = JSON.parse(result);
					this.isChecked = this.userRec[this.fieldApiName];
					//console.log("result::" + this.isChecked);
					if (this.autoDisplay) {
						if (!this.isChecked) {
							this.openmodal();
						}
					}
				})
				.catch(error => {
					this.isChecked = false;
					this.error = error;
				});
		} else {
			if (this.autoDisplay) {
				this.openmodal();
			}
		}
	}

	connectedCallback() {
		this.handleFieldApi();
		this.handlePosition();
		this.handleNumberOfPages();
		this.handleLayout();
		this.handleModalSize();
		this.handleBorder();
	}

	@api modalSize = "Large - 390px";

	@api largeModal = false;
	@api smallModal = false;
	@api mobileModal = false;

	handleModalSize() {
		if (this.modalSize === "Small - 390px") {
			this.smallModal = true;
			this.largeModal = false;
			this.mobileModal = false;
		}
		if (this.modalSize === "Large - 600px") {
			this.largeModal = true;
			this.smallModal = false;
			this.mobileModal = false;
		}
		if (this.modalSize === "Mobile") {
			this.mobileModal = true;
			this.smallModal = false;
			this.largeModal = false;
		}
	}

	@api leftAlign = false;

	hanldeProgressValueChange(event) {
		//console.log("event fired::" + event.detail);
		this.isChecked = event.detail;
		/*eslint-disable no-console */
		//console.log("isChecked::" + this.isChecked);
	}
}