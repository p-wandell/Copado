/*
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

import { LightningElement,api } from 'lwc';

import likeNews from "@salesforce/apex/x7sNewsController.likeNews";
import unLikeNews from "@salesforce/apex/x7sNewsController.unLikeNews";
import isLiking from "@salesforce/apex/x7sNewsController.isLiking";

import labelButtonLike from "@salesforce/label/c.x7sNewsLabelButtonLike";
import labelButtonLiked from "@salesforce/label/c.x7sNewsLabelButtonLiked";
import labelButtonUnlike from "@salesforce/label/c.x7sNewsLabelButtonUnlike";

export default class X7sNewsLikeButton extends LightningElement {

    @api recordId;
    @api isLiking=false;
    @api likeCount=0;
    labelwhenhover=labelButtonUnlike;

    connectedCallback(){
        this.setIsLiking();
    }
    getlike(newsId) {
        likeNews({recordId: newsId})
            .then(result => {
                this.isLiking=true;
                if(result){
                    this.likeCount = this.likeCount + 1;
                }
            })
            .catch(error => {
                this.error = error;
            });
    }

    getunLike(newsId) {
        unLikeNews({recordId: newsId})
            .then(result => {
                this.isLiking = false;
                if(result){
                    this.likeCount = this.likeCount - 1;
                }
            })
            .catch(error => {
                this.error = error;
            });
    }
    handleTileLikeClick(){
		if (this.isLiking) {
			this.getunLike(this.recordId);
		} else {
			this.getlike(this.recordId);
		}
    }
    setIsLiking() {
        isLiking({recordId: this.recordId})
            .then(result => {
                this.isLiking = result;
            })
            .catch(error => {
                this.error = error;
            });
    }
    get labelWhenOff(){
        return labelButtonLike + ' ' + this.likeCount;
    }
    get labelWhenOn(){
        return labelButtonLiked + ' ' + this.likeCount;
    }
}