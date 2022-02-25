/**
 * Copyright (c) 2020. 7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track} from 'lwc';

import getInitialData from '@salesforce/apex/x7sVideoController.getInitialData';
import labelAriaWrapper  from '@salesforce/label/c.x7sVideoGalleryAriaLabelWrapper';

import {classSet} from 'c/x7sShrUtils';

export default class X7SVideo extends LightningElement {
	@api title = '7S Video';
	@api subTitle;
	@api align = 'left';
	
	@api videoURL1;
	@api videoTitle1;
	@api videoDescription1;
	
	@api videoURL2;
	@api videoTitle2;
	@api videoDescription2;
	
	@api videoURL3;
	@api videoTitle3;
	@api videoDescription3;
	
	@api hideDescriptions = false;
	@api descriptionLineLength;
	@api hasBorder = false;
	@api useFromRecord = false;

	@api recordId;

	@api variant = 'slds-card'; // default, slds-card, featured
	
	@track videos;
	
	debug = true;
	error = false;
	show  = false;

	label = {labelAriaWrapper};
	
	get showComponent() {
		return !this.error && this.show;
	}
	
	/**
	 * Add video classes.
	 * @returns {string}
	 */
	get videoClasses() {
		return classSet('x7s-video__video-item')
			.add({
				'slds-box': this.hasBorder
			})
			.toString();
	}
	
	/**
	 * Set responsive grid columns and other classes
	 * @returns {string}
	 */
	get colClasses() {
		let classes = 'x7s-video__video';
		classes += ' slds-p-horizontal_small slds-p-vertical_medium';
		classes += ' slds-size_1-of-1';
		if (this.videos.length) {
			const num = this.videos.length > 3 ? 3 : this.videos.length;
			classes += ` slds-medium-size_1-of-${num}`;
		}
		return classes;
	}
	
	/**
	 * Set line clamping on descriptions
	 * @returns {string}
	 */
	get lineClampStyle() {
		// NOTE: -webkit-line-clamp is non-standard CSS, but has pretty good support.
		// Salesforce appears to strip out some of the non-standard properties from the CSS,
		// so they needed to be inlined here.
		// https://caniuse.com/#feat=css-line-clamp
		if (this.descriptionLineLength) {
			return `display: -webkit-box; -webkit-line-clamp: ${this.descriptionLineLength}; -webkit-box-orient: vertical;`;
		} else {
			return '';
		}
	}
	
	connectedCallback() {
		if (this.useFromRecord && this.recordId) {
			this.setVideosFromRecord();
		} else {
			this.setVideosFromConfig();
		}
	}
	
	/**
	 * Set the videos as an array of objects from RecordId
	 */
	setVideosFromRecord() {
		getInitialData({recordId: this.recordId})
			.then(response => {
				if (response && response.results.length) {
					let videos = [];
					
					for (let x = 0; x < response.results.length; x++) {
						let link = response.results[x];
						let obj = this.getVideoInfo(link);
						videos.push(obj);
					}
					
					this.show   = videos.length > 0;
					this.videos = videos;
				} else {
					// fallback
					this.setVideosFromConfig();
				}
			})
			.catch(error => {
				this.error = true;
				if (this.debug) {
					console.error('getInitialData', error);
				}
				this.setVideosFromConfig();
			});
	}
	
	/**
	 * Set the videos as an array of objects from Builder Config
	 */
	setVideosFromConfig() {
		let videos = [];
		
		for (let x = 1; x <= 3; x++) {
			if (this[`videoURL${x}`]) {
				const link = this[`videoURL${x}`];
				let obj = this.getVideoInfo(link);
				
				obj.title = this[`videoTitle${x}`] ? this[`videoTitle${x}`] : '';
				obj.description = this[`videoDescription${x}`] ? this[`videoDescription${x}`] : '';
				videos.push(obj);
			}
		}
		this.show   = videos.length > 0;
		this.videos = videos;
	}
	
	/**
	 * Takes a video URL and returns an object with what type of video and the embed URL.
	 * @param link
	 * @returns {Object}
	 */
	getVideoInfo(link) {
		const url = (link.endsWith('/')) ? link.substring(0, link.length - 1) : link;
		const isYouTube = url.includes('youtu.be') || url.includes('youtube');
		const isVimeo = url.includes('vimeo');
		const isWistia = url.includes('wistia');
		const isVidyard = url.includes('vidyard');
		const isBrightcove = url.includes('brightcove') || url.includes('bcove');

		
		let obj = {};
		let videoUrl;
		let videoUrl1;
		let videoUrl2;
		let videoUrl3;
		let embedUrl1 = '';
		let embedUrl2 = '';
		let videoId;
		let videoEmbedUrl = '';
		
		if (isVimeo) {
			videoUrl1 = url.match(/vimeo\.com\/(.*)/);
			videoUrl2 = url.match(/player\.vimeo\.com\/video\/(.*)/);
			embedUrl1 = 'https://player.vimeo.com/video/';
			embedUrl2 = '?title=0&byline=0&portrait=0&playsinline=0';
		} else if (isYouTube) {
			videoUrl1 = url.match(/youtube\.com\/watch\?v=(.*)/);
			videoUrl2 = url.match(/youtu\.be\/(.*)/);
			videoUrl3 = url.match(/googleapis\.com\/v\/(.*)/);
			embedUrl1 = 'https://www.youtube.com/embed/';
			embedUrl2 = '?rel=0&modestbranding=1&playsinline=0';
		} else if (isWistia) {
			videoUrl1 = url.match(/wistia.com\/medias\/(.*)/);
			embedUrl1 = '//fast.wistia.net/embed/iframe/';
			embedUrl2 = '?videoFoam=true';
		} else if (isVidyard) {
			videoUrl1 = url.match(/vidyard.com\/watch\/(.*)/);
			videoUrl2 = url.match(/vidyard.com\/(.*)/);
			embedUrl1 = '//play.vidyard.com/';
			embedUrl2 = url.includes('?v=') ? '' : '?v=3.1.1';
		}else if(isBrightcove){
			videoUrl1 = url.match(/bcove\.video\/(.*)/);
			videoUrl2 = url.match(/players\.brightcove\.net\/(.*)/);

			if(videoUrl2){
				embedUrl1 = '//players.brightcove.net/';
			}else if(videoUrl1){
				embedUrl1 = '//bcove.video/';
			}
		}
		
		if (videoUrl1) {
			videoUrl = videoUrl1;
		} else if (videoUrl2) {
			videoUrl = videoUrl2;
		} else if (videoUrl3) {
			videoUrl = videoUrl3;
		}
		
		if (videoUrl) {
			videoId = videoUrl.pop();
			videoEmbedUrl = embedUrl1 + videoId + embedUrl2;
			
			obj.isVimeo = isVimeo;
			obj.isYouTube = isYouTube;
			obj.isWistia = isWistia;
			obj.isVidyard = isVidyard;
			obj.isBrightcove = isBrightcove;
			obj.videoId = videoId;
			obj.embedUrl = videoEmbedUrl;
		} else {
			this.error = true;
			if (this.debug) {
				console.error('Error getting video ID. Please check the format of your video URLs.');
			}
		}
		
		return obj;
	}
}