/* eslint-disable no-else-return */
/* eslint-disable no-console */
import { LightningElement, api, track } from "lwc";
import getAudioData from "@salesforce/apex/x7sMediaController.getAudioData";

export default class AudioPlayer extends LightningElement {
  @api recordId;

  @api hasError = false;
  @api isNothing = false;
  @api recordIdValue = "";
  @api fieldApiName1 = "";
  @api fieldApiName2 = "";
  @api fieldApiName3 = "";
  @api fieldApiName4 = "";
  @api fieldApiName5 = "";
  @api fieldApiName6 = "";
  @api invalidBehavior = "";
  @api invalidMessage = "";
  @api hasOneFile = false;

  @api mediaFiles = "";
  @api fileBorder = false;
  @api media = "Audio";
  @api title = "";
  @api description = "";
  @api border = false;

  @api mediaFile = "";
  @api mediaFileTwo = "";
  @api mediaFileThree = "";
  @api mediaFileFour = "";
  @api mediaFileFive = "";
  @api mediaFileSix = "";

  @api titleOne = "";
  @api titleTwo = "";
  @api titleThree = "";
  @api titleFour = "";
  @api titleFive = "";
  @api titleSix = "";

  @api mediaOne = false;
  @api mediaTwo = false;
  @api mediaThree = false;
  @api mediaFour = false;
  @api mediaFive = false;
  @api mediaSix = false;

  @api labelForAriaDiv = "Media Player";
  @api ariaLandmarkRoleForComponent = "main";
  
  @track element1Size;
  @track width;

  renderedCallback() {
    this.element1Size = this.template.querySelector(".container").offsetWidth;
    if (this.element1Size > 1000) {
      this.width = 380;
    } else {
      this.width = 280;
    }
  }

  get inlineStyle() {
    return "width:" + this.width + "px; margin: auto;";
  }

  handleStuff() {
    encodeURIComponent(this.mediaFile);
    encodeURIComponent(this.mediaFileTwo);
    encodeURIComponent(this.mediaFileThree);
    encodeURIComponent(this.mediaFileFour);
    encodeURIComponent(this.mediaFileFive);
    encodeURIComponent(this.mediaFileSix);

    if (this.mediaFile === "") {
      this.mediaOne = false;
    } else {
      this.mediaOne = true;
    }
    if (this.mediaFileTwo === "") {
      this.mediaTwo = false;
    } else {
      this.mediaTwo = true;
    }
    if (this.mediaFileThree === "") {
      this.mediaThree = false;
    } else {
      this.mediaThree = true;
    }
    if (this.mediaFileFour === "") {
      this.mediaFour = false;
    } else {
      this.mediaFour = true;
    }
    if (this.mediaFileFive === "") {
      this.mediaFive = false;
    } else {
      this.mediaFive = true;
    }
    if (this.mediaFileSix === "") {
      this.mediaSix = false;
    } else {
      this.mediaSix = true;
    }
    if (
      !this.mediaOne &&
      !this.mediaTwo &&
      !this.mediaThree &&
      !this.mediaFour &&
      !this.mediaFive &&
      !this.mediaSix
    ) {
      this.hasError = true;
      if (this.invalidBehavior === "Show Nothing") {
        this.isNothing = true;
      } else {
        this.isNothing = false;
      }
    }

    if (this.mediaFiles === "1") {
      this.hasOneFile = true;
      this.mediaTwo = false;
      this.mediaThree = false;
      this.mediaFour = false;
      this.mediaFive = false;
      this.mediaSix = false;
    } else if (this.mediaFiles === "2") {
      this.mediaThree = false;
      this.mediaFour = false;
      this.mediaFive = false;
      this.mediaSix = false;
    } else if (this.mediaFiles === "3") {
      this.mediaFour = false;
      this.mediaFive = false;
      this.mediaSix = false;
    } else if (this.mediaFiles === "4") {
      this.mediaFive = false;
      this.mediaSix = false;
    } else if (this.mediaFiles === "5") {
      this.mediaSix = false;
    }
  }
  get styleClass() {
    if (this.isAudio) {
      return "audioContainer";
    } else {
      if (this.mediaFiles !== "1") {
        return "audioContainer";
      } else {
        return "";
      }
    }
  }
  get componentBorder() {
    return this.border ? "slds-card" : "";
  }

  @api error = "";
  connectedCallback() {
    console.log("Media " + this.media);
    if (this.media !== "Audio") {
      this.isAudio = false;
    } else {
      this.isAudio = true;
    }

    if (this.invalidBehavior === "Show Nothing") {
      this.isNothing = true;
    } else {
      this.isNothing = false;
    }
    if (this.recordIdValue === "recordId") {
      this.recordIdValue = this.recordId;
    }

    if (this.recordIdValue !== "" && this.recordIdValue !== null) {
      getAudioData({
        recordId: this.recordIdValue,
        fieldAPIName: this.fieldApiName1,
        fieldAPIName2: this.fieldApiName2,
        fieldAPIName3: this.fieldApiName3,
        fieldAPIName4: this.fieldApiName4,
        fieldAPIName5: this.fieldApiName5,
        fieldAPIName6: this.fieldApiName6
      })
        .then(result => {
          this.hasError = false;
          if (this.fieldApiName1 !== "") {
            let field = this.fieldApiName1;
            if (result[field]) {
              this.mediaFile = result[field];
            }
          }
          if (this.fieldApiName2 !== "") {
            let field = this.fieldApiName2;
            if (result[field]) {
              this.mediaFileTwo = result[field];
            }
          }
          if (this.fieldApiName3 !== "") {
            let field = this.fieldApiName3;
            if (result[field]) {
              this.mediaFileThree = result[field];
            }
          }
          if (this.fieldApiName4 !== "") {
            let field = this.fieldApiName4;
            if (result[field]) {
              this.mediaFileFour = result[field];
            }
          }
          if (this.fieldApiName5 !== "") {
            let field = this.fieldApiName5;
            if (result[field]) {
              this.mediaFileFive = result[field];
            }
          }
          if (this.fieldApiName6 !== "") {
            let field = this.fieldApiName6;
            if (result[field]) {
              this.mediaFileSix = result[field];
            }
          }
          this.handleStuff();
        })
        .catch(error => {
          this.hasError = true;
          this.error = error;
        });
    } else {
      this.handleStuff();
    }
  }

  @api pagePosition = "";

  get wrapperClass() {
    return `slds-text-align_${this.pagePosition.toLowerCase()}`;
  }
}