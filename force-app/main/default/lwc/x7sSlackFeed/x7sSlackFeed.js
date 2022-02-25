//Copyright (c) 2020. 7summits Inc. All rights reserved.
import { LightningElement, api, track } from "lwc";
import getChannelFeed from "@salesforce/apex/x7sSlackController.getChannelFeed";
import getUsersList from "@salesforce/apex/x7sSlackController.getUsersList";
import postToSlack from "@salesforce/apex/x7sSlackController.postToSlack";
import slackImage from "@salesforce/apex/x7sSlackController.slackImage";
import slackLogo from "@salesforce/resourceUrl/x7s_Slack_Logo";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";

export default class X7sSlackFeed extends NavigationMixin(LightningElement) {
  @api title;
  @api description;
  @api channelId;
  @api variant;
  @api alignButton;
  @api userImgSize = "Medium";
  @api showInput;
  @api feedLimit = "10";
  @api messageSort = "Most Recent on Top";
  @api slackUrl;
  @api showLaunch;
  @api showImages;
  @api height;
  @api customClass;
  @track error;
  @track feed = [];
  @track userList = [];
  @track userMap = new Map();
  @track postTextval;
  @track avaterSize = "48px";
  @track useAvatar = true;
  @track slckImg = slackLogo;
  @track loaded = false;
  token =
    "xoxp-3875761969-1097165596804-1104686010611-5e780e0e35114ecec9dce2505ededea7";

  connectedCallback() {
    this.getUserFromChannel();
    getChannelFeed({ channelId: this.channelId, feedLimit: this.feedLimit })
      .then((response) => {
        if (
          response.hasOwnProperty("responseCode") &&
          response.responseCode === 200 &&
          response.hasOwnProperty("responseBody")
        ) {
          let tempRes = JSON.parse(decodeURI(response.responseBody));
          this.feed = tempRes.messages;
          for (let i = 0; i < this.feed.length; i++) {
            this.feed[i].text = this.feed[i].text.replace(/[<>@]/g, "");
            let publicFiles = [];
            let privateFiles = [];
            let imageFile = this.feed[i];

            if (imageFile.files) {
              for (let k = 0; k < imageFile.files.length; k++) {
                if (imageFile.files[k].mode === "hosted") {
                  const str = imageFile.files[k].permalink_public;
                  const n = 10;
                  let secret = str.slice(str.length - n);
                  let publicImgUrl =
                    imageFile.files[k].url_private + "?pub_secret=" + secret;
                  this.makeSlackPublic(imageFile.files[k].id);
                  if (
                    imageFile.files[k].public_url_shared === true &&
                    (imageFile.files[k].filetype === "jpg" ||
                      imageFile.files[k].filetype === "gif" ||
                      imageFile.files[k].filetype === "png" ||
                      imageFile.files[k].filetype === "jpeg")
                  ) {
                    publicFiles.push({
                      id: imageFile.files[k].id,
                      imgurl: publicImgUrl,
                      imgTitle: imageFile.files[k].title
                    });
                    this.feed[i].publicFiles = publicFiles;
                  } else {
                    privateFiles.push({
                      id: imageFile.files[k].id,
                      imgurl: publicImgUrl,
                      imgTitle: imageFile.files[k].title
                    });
                    this.feed[i].privateFiles = privateFiles;
                  }
                }
              }
            }
            for (let j = 0; j < this.userList.length; j++) {
              let userId = this.userList[j].id;
              let find = this.userMap.get(userId);
              this.feed[i].text = this.feed[i].text.replace(userId, find);
              if (this.feed[i].user === this.userList[j].id) {
                this.feed[i].userName = this.userList[j].real_name;
                if (this.userImgSize != "None") {
                  this.useAvatar = true;
                  if (this.userImgSize === "Small") {
                    this.feed[i].userIcon = this.userList[j].profile.image_32;
                    this.avaterSize = "32px";
                  } else if (this.userImgSize === "Medium") {
                    this.feed[i].userIcon = this.userList[j].profile.image_48;
                    this.avaterSize = "48px";
                  } else if (this.userImgSize === "Large") {
                    this.feed[i].userIcon = this.userList[j].profile.image_72;
                    this.avaterSize = "72px";
                  }
                } else {
                  this.useAvatar = false;
                }

                let utcSeconds = this.feed[i].ts;
                let d = new Date(utcSeconds * 1000);
                let finalTime = d.toLocaleString();
                let reply;
                let whoResponded = [];
                if (this.feed[i].reply_count > 0) {
                  reply = this.feed[i].reply_count;
                  this.feed[i].text =
                    this.feed[i].text +
                    "\n" +
                    "Number of Replies on this thread : " +
                    reply;

                  for (let u = 0; u < this.feed[i].reply_users.length; u++) {
                    whoResponded.push(
                      this.feed[i].reply_users[u].replace(userId, find)
                    );
                  }
                  this.feed[i].text =
                    this.feed[i].text +
                    "\n" +
                    " Who Responded ?  " +
                    whoResponded;
                }
                this.feed[i].userName =
                  this.feed[i].userName + " posted on " + finalTime;
              }
            }
          }
          if (this.messageSort === "Most Recent on Bottom") {
            this.feed = this.feed.reverse();
          }
          console.log('-----Feed Wraper-----'+JSON.stringify(this.feed));
        }
      })
      .catch((error) => {
        this.error = error;
      });
  }
  renderedCallback() {
    if (this.messageSort === "Most Recent on Bottom") {
      let scrollWindow = this.height.slice(0, this.height.length - 2);
      window.scrollTo(0, scrollWindow);
      let scrollingElement = this.template.querySelector(".scroll");
      scrollingElement.scrollTop = scrollingElement.scrollHeight;
    }
  }
  refreshHandle() {
    this.loaded = true;
    window.setTimeout(() => (this.loaded = false), 1000);
    return refreshApex(this.connectedCallback());
  }
  get getMinHeight() {
    if (this.variant === "default") {
      if (this.userImgSize === "Small") {
        return `32px`;
      } else if (this.userImgSize === "Medium") {
        return `48px`;
      } else if (this.userImgSize === "Large") {
        return `72px`;
      } else if (this.userImgSize === "None") {
        return `2px`;
      }
    }
  }
  get adjustHeight() {
    return `height: ${this.height};`;
  }
  get buttonAlign() {
    if (this.alignButton === "Right") {
      return "left";
    } else if (this.alignButton === "Left") {
      return "right";
    }
  }
  makeSlackPublic(fileId) {
    slackImage({ fileId: fileId }).then((response) => {
    });
  }
  getUserFromChannel() {
    getUsersList({ channel: this.channelId })
      .then((response) => {
        if (
          response.hasOwnProperty("responseCode") &&
          response.responseCode === 200 &&
          response.hasOwnProperty("responseBody")
        ) {
          let tempRes = JSON.parse(response.responseBody);
          this.userList = tempRes.members;
         
          for (let i = 0; i < this.userList.length; i++) {
            if (this.userList[i].real_name) {
              this.userMap.set(this.userList[i].id, this.userList[i].real_name);
            }
          }
        }
      })
      .catch((error) => {
        this.error = error;
      });
  }
  inputChange(event) {
    this.postTextval = event.target.value;
  }
  handlePost() {
    postToSlack({ channelId: this.channelId, postText: this.postTextval })
      .then((response) => {
        if (
          response.hasOwnProperty("responseCode") &&
          response.responseCode === 200 &&
          response.hasOwnProperty("responseBody")
        ) {
          this.postTextval = "";
        }
      })
      .catch((error) => {
        this.error = error;
      });
  }
  gotoUrl() {
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: this.slackUrl
      }
    });
  }
}