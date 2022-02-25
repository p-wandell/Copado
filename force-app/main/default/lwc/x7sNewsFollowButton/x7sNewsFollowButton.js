/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

import { LightningElement,api} from 'lwc';

import followRecord from "@salesforce/apex/x7sNewsController.followRecord";
import unfollowRecord from "@salesforce/apex/x7sNewsController.unfollowRecord";
import isFollow from "@salesforce/apex/x7sNewsController.isFollowing";

import labelButtonFollow from "@salesforce/label/c.x7sNewsLabelButtonFollow";
import labelButtonFollowing from "@salesforce/label/c.x7sNewsLabelButtonFollowing";
import labelButtonUnfollow from "@salesforce/label/c.x7sNewsLabelButtonUnfollow";

export default class X7sNewsFollowButton extends LightningElement {

    @api recordId;
    @api isFollowing=false;
    labelWhenOff=labelButtonFollow;
    labelWhenOn=labelButtonFollowing;
    labelWhenHover=labelButtonUnfollow;
    error;

    connectedCallback(){
        this.setIsFollowing();
    }
    handleFollowClick(){
        if (this.isFollowing) {
			this.unfollow();
		} else {
			this.follow();
		}
    }
    follow() {
        followRecord({recordId: this.recordId})
            .then(result => {
                this.isFollowing =true ;
            })
            .catch(error => {
                this.error = error;
            });
    }
    unfollow() {
        unfollowRecord({recordId: this.recordId})
            .then(result => {
                this.isFollowing =false ;
            })
            .catch(error => {
                this.error = error;
            });
    }
    setIsFollowing() {
        isFollow({recordId: this.recordId})
            .then(result => {
                this.isFollowing =result ;
            })
            .catch(error => {
                this.error = error;
            });
	}
}