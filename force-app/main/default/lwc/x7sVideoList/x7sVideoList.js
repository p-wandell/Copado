/**
 * Copyright (c) 2020.  7Summits Inc. All rights reserved.
 */

import {LightningElement, api, track} from 'lwc';

import getVimeoVideos from '@salesforce/apex/x7sVideoListController.getVimeoVideos';
import getYouTubeVideosByChannel from '@salesforce/apex/x7sVideoListController.getYouTubeVideosByChannel';
import getYouTubeVideosByPlaylist from '@salesforce/apex/x7sVideoListController.getYouTubeVideosByPlaylist';
import getYouTubeVideosByUsername from '@salesforce/apex/x7sVideoListController.getYouTubeVideosByUsername';
import getBrightcoveVideos from '@salesforce/apex/x7sVideoListController.getBrightcoveVideos';
import getWistiaVideos from '@salesforce/apex/x7sVideoListController.getWistiaVideos';

import {classSet} from 'c/x7sShrUtils';

export default class X7SVideoList extends LightningElement {
    @api title = 'Video List';
    @api subTitle;
    @api align = 'left';

    @api moreText = 'See more videos like this!';
    @api videoGalleryLink;
    @api numberOfVideos = 9;
    @api order = 'date';
    @api carouselMode = false;
    @api apiKey;
    @api hideDescriptions = false;
    @api descriptionLineLength = 3;
    @api hasBorder = false;
    @api videosPerRow = '3';
    @api variant = 'slds-card'; // default, slds-card, featured
    @api showSeeMoreButton = "true";
    @api gallaryLink='';

    @track videoGallery;
    @track displayVideoGallery;

    currentCarouselPage = 0;
    isVimeo = false;
    isYouTube = false;
    isBrightcove = false;
    isWistia = false;
    youtubeType;

    error;
    debug = false;

    /**
     * Add video classes.
     * @returns {string}
     */
    get videoClasses() {
        return classSet('x7s-video-list__video-item slds-text-align_left')
            .add({
                'slds-box': this.hasBorder
            })
            .toString();
    }

    /**
     * Add row classes.
     * @returns {string}
     */
    get rowClasses() {
        return classSet('x7s-video-list__row slds-text-align_left slds-grid slds-wrap slds-grid_vertical-stretch')
            .add({
                'slds-grid_pull-padded-small': this.carouselMode
            })
            .toString();
    }
    /**
     * Display See More Button
     * @returns {boolean}
     */
    get displayMoreButton(){
        return (this.showSeeMoreButton && this.gallaryLink && this.moreText);
    }

    /**
     * Set responsive grid columns and other classes
     * @returns {string}
     */
    get colClasses() {
        let classes = 'x7s-video-list__video';
        classes += ' slds-text-align_left slds-p-horizontal_small slds-p-vertical_medium';
        classes += ' slds-size_1-of-1';
        classes += this.hasBorder ? ' hasBorder' : '';
        classes += this.videosPerRow ? ` slds-medium-size_1-of-${this.videosPerRow}` : '';
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
        return `display: -webkit-box; -webkit-line-clamp: ${this.descriptionLineLength}; -webkit-box-orient: vertical;`;
    }

    /**
     * Return the number of pages for the carousel
     * @returns {number}
     */
    get numberOfPages() {
        const videosPerRow = parseInt(this.videosPerRow, 10);
        const mod = (this.numberOfVideos % videosPerRow) ? 0 : 1;
        return Math.floor(this.numberOfVideos / videosPerRow) - mod;
    }

    /**
     * Hide the previous button on the first page
     * @returns {string}
     */
    get previousButtonClass() {
        return classSet('x7s-video-list__arrow slds-button')
            .add({
                'slds-hidden': this.currentCarouselPage <= 0
            })
            .toString();
    }

    /**
     * Hide the next button on the last page
     * @returns {string}
     */
    get nextButtonClass() {
        return classSet('x7s-video-list__arrow slds-button')
            .add({
                'slds-hidden': this.currentCarouselPage >= this.numberOfPages
            })
            .toString();
    }

    connectedCallback() {
        if (this.videoGalleryLink) {
            this.initializedVideos(this.videoGalleryLink);
        }
    }

    /**
     * Go to the next page in the carousel
     */
    handleNext() {
        this.currentCarouselPage++;
        const videosPerRow = parseInt(this.videosPerRow, 10);
        const start = this.currentCarouselPage * videosPerRow;
        const end = start + videosPerRow;
        this.displayVideoGallery = this.videoGallery.slice(start, end);

        setTimeout(() => {
            this.setUpTextContent();
        });
    }

    /**
     * Go to the previous page in the carousel
     */
    handlePrevious() {
        this.currentCarouselPage--;
        const videosPerRow = parseInt(this.videosPerRow, 10);
        const start = this.currentCarouselPage * videosPerRow;
        const end = start + videosPerRow;
        this.displayVideoGallery = this.videoGallery.slice(start, end);

        setTimeout(() => {
            this.setUpTextContent();
        });
    }

    /**
     * Set up the videos based on the provided URL
     * @param link
     */
    initializedVideos(link) {
        const url = (link.endsWith('/')) ? link.substring(0, link.length - 1) : link;

        this.isYouTube = url.includes('youtu.be') || url.includes('youtube');
        this.isVimeo = url.includes('vimeo');
        this.isBrightcove = url.includes('brightcove') || url.includes('bcove');
        this.isWistia = url.includes('wistia');

        if (this.isYouTube) {
            const userUrl = url.match(/user\/(.*)/);
            const channelUrl = url.match(/channel\/(.*)/);
            const playlistUrl = url.match(/playlist\?list=(.*)/) ;
            const videoSeriesUrl = url.match(/videoseries\?list=(.*)/);
            let galleryId;

            if (userUrl) {
                galleryId = userUrl.pop();
                this.getYouTubeVideosByUsername(galleryId);
                this.youtubeType = 'user';
                this.gallaryLink = `https://www.youtube.com/user/${galleryId}`;
            } else if (channelUrl) {
                galleryId = channelUrl.pop();
                this.getYouTubeVideosByChannel(galleryId);
                this.youtubeType = 'channel';
                this.gallaryLink = `https://www.youtube.com/channel/${galleryId}`;
            } else if (playlistUrl) {
                galleryId = playlistUrl.pop();
                this.getYouTubeVideosByPlaylist(galleryId);
                this.youtubeType = 'playlist';
                this.gallaryLink = `https://www.youtube.com/playlist/${galleryId}`;
            } else if (videoSeriesUrl) {
                galleryId = videoSeriesUrl.pop();
                this.getYouTubeVideosByPlaylist(galleryId);
                this.youtubeType = 'playlist';
                this.gallaryLink = `https://www.youtube.com/playlist/${galleryId}`;
            }
        } 
        else if (this.isVimeo) {
            const channelUrl = url.match(/vimeo\.com\/channels\/(.*)/);
            const showcaseUrl = url.match(/vimeo\.com\/showcase\/(.*)/);
            const groupUrl = url.match(/vimeo\.com\/groups\/(.*)/);
            let galleryId = null;

            if (channelUrl) {
                galleryId = 'channel/' + channelUrl.pop();
            } else if (showcaseUrl) {
                galleryId = 'album/' + showcaseUrl.pop();
            } else if (groupUrl) {
                galleryId = 'group/' + groupUrl.pop();
            }

            if (galleryId) {
                this.getVimeoVideos(galleryId);
                this.gallaryLink = url;
            } else {
                this.showSeeMoreButton = false;
                console.error('Your Video Reference is not compatible. ' + url);
            }

        } 
        else if(this.isBrightcove){
            // const bcove = url.match(/bcove\.video\/(.*)/);
            const players = url.match(/players\.brightcove\.net\/(.*)/);
            const accIdUrl = players.pop();
            const accountId = accIdUrl.slice(0, accIdUrl.indexOf("/"));
            const playlistId = accIdUrl.substr(accIdUrl.lastIndexOf('=') + 1);
            if(accountId && playlistId){
               this.getBrightcoveVideos(accountId,playlistId);
               this.gallaryLink = url;
            }
            else {
                this.showSeeMoreButton = false;
                console.error('Your Video Reference is not compatible. ' + url);
            }
        }
        else if(this.isWistia){
            let galleryId = null;
            this.gallaryLink = url;
            const wistiaUrl = url.match(/\wistia.com\/projects\/(.*)/);
            galleryId = wistiaUrl.pop();
            this.getWistiaVideos(galleryId);
        }
        else{
            this.showSeeMoreButton = false;
            console.error('Your Video Reference is not compatible.');
        }
    }

    /**
     * Set up Vimeo videos
     * @param id
     */
    getVimeoVideos(id) {
        getVimeoVideos({
            channel: id
        }).then(result => {
            if (result) {
                let data = JSON.parse(result);

                data = data.slice(0, this.numberOfVideos);
                this.videoGallery = data.map(e => ({
                    embed_url: `https://player.vimeo.com/video/${e.id}?title=0&byline=0&portrait=0&playsinline=0`,
                    data_attr: `x7s-video-${e.id}`,
                    ...e
                }));

                if (this.carouselMode) {
                    this.displayVideoGallery = this.videoGallery.slice(0, this.videosPerRow);
                } else {
                    this.displayVideoGallery = this.videoGallery.slice(0);
                }
            } else {
                this.error = 'Invalid Request to Vimeo. Please check the channel name.';
            }
        }).then(() => {
            this.setUpTextContent();
        }).catch(error => {
            this.showSeeMoreButton = false;
        });
    }
    /**
     * Set up Brightcove videos
     * @param accountId
     * @param playlistId
     */
    getBrightcoveVideos(accId,playlistId) {
        getBrightcoveVideos({
            accountId: accId,
            playlistId: playlistId,
            policyKey : this.apiKey
        }).then(result => {
            if (result) {
                let data = JSON.parse(result);
                let videoItem = data.videos;
                if(this.numberOfVideos > videoItem.length){
                    this.numberOfVideos = videoItem.length;
                }
                videoItem = videoItem.slice(0, this.numberOfVideos);
                this.videoGallery = videoItem.map(e => ({
                    embed_url: `https://players.brightcove.net/${accId}/default_default/index.html?videoId=${e.id}`,
                    data_attr: `x7s-video-${e.id}`,
                    id: e.id,
                    title: e.name,
                    description: e.description,
                    ...e
                }));

                if (this.carouselMode) {
                    this.displayVideoGallery = this.videoGallery.slice(0, this.videosPerRow);
                } else {
                    this.displayVideoGallery = this.videoGallery.slice(0);
                }
            } 
        }).then(() => {
            this.setUpTextContent();
        }).catch(error => {
            this.showSeeMoreButton = false;
            if (error) {
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                } 
                else if (typeof error.body.message === 'string') {
                    this.error = `<p><strong>${error.body.message}</strong></p>`;
                }
            }
        });
    }
    /**
     * Set up getWistiaVideos videos
     * @param projectId
     */
    getWistiaVideos(projectId) {
        getWistiaVideos({
            projectId: projectId,
            key : this.apiKey
        }).then(result => {
            if (result) {
                let data = JSON.parse(result);
                let videoItem = data.medias;
                if(this.numberOfVideos > videoItem.length){
                    this.numberOfVideos = videoItem.length;
                }
                videoItem = videoItem.slice(0, this.numberOfVideos);
                this.videoGallery = videoItem.map(e => ({
                    embed_url: `//fast.wistia.net/embed/iframe/${e.hashed_id}?videoFoam=true`,
                    data_attr: `x7s-video-${e.hashed_id}`,
                    id: e.hashed_id,
                    title: e.name,
                    description: e.description,
                    ...e
                }));

                if (this.carouselMode) {
                    this.displayVideoGallery = this.videoGallery.slice(0, this.videosPerRow);
                } else {
                    this.displayVideoGallery = this.videoGallery.slice(0);
                }
            } 
        }).then(() => {
            this.setUpTextContent();
        }).catch(error => {
            this.showSeeMoreButton = false;
            if (error) {
                if (Array.isArray(error.body)) {
                    this.error = error.body.map(e => e.message).join(', ');
                } 
                else if (typeof error.body.message === 'string') {
                    this.error = `<p><strong>${error.body.message}</strong></p>`;
                }
            }
        });
    }
    /**
     * Set up YouTube Channel videos
     * @param id
     */
    getYouTubeVideosByChannel(id) {
        if (this.apiKey) {
            getYouTubeVideosByChannel({
                results: this.numberOfVideos,
                channel: id,
                key: this.apiKey,
                order: this.order
            }).then(result => {
                this.mapYouTubeData(result);
            }).then(() => {
                this.setUpTextContent();
            }).catch(error => {
                this.showSeeMoreButton = false;
                console.error(error);
            });
        }
    }

    /**
     * Set up YouTube Playlist videos
     * @param id
     */
    getYouTubeVideosByPlaylist(id) {
        if (this.apiKey) {
            getYouTubeVideosByPlaylist({
                results: this.numberOfVideos,
                playlistId: id,
                key: this.apiKey,
                order: this.order
            }).then(result => {
                this.mapYouTubeData(result);
            }).then(() => {
                this.setUpTextContent();
            }).catch(error => {
                this.showSeeMoreButton = false;
                console.error(error);
            });
        }
    }

    /**
     * Set up YouTube User videos
     * @param id
     */
    getYouTubeVideosByUsername(id) {
        if (this.apiKey) {
            getYouTubeVideosByUsername({
                results: this.numberOfVideos,
                username: id,
                key: this.apiKey,
                order: this.order
            }).then(result => {
                this.mapYouTubeData(result);
            }).then(() => {
                this.setUpTextContent();
            }).catch(error => {
                this.showSeeMoreButton = false;
                console.error(error);
            });
        }
    }

    /**
     * Set up YouTube data
     * @param result
     */
    mapYouTubeData(result) {
        if (result) {
            let data = JSON.parse(result);
            let items = data.items;
            if(this.numberOfVideos > items.length){
                this.numberOfVideos = items.length;
            }
            if (!data.error && this.youtubeType !== 'playlist') {
                this.videoGallery = data.items.map(e => ({
                    embed_url: `https://www.youtube.com/embed/${e.id.videoId}?rel=0&modestbranding=1&playsinline=0`,
                    data_attr: `x7s-video-${e.id.videoId}`,
                    id: e.id.videoId,
                    title: e.snippet.title,
                    description: e.snippet.description,
                    ...e
                }));

                if (this.carouselMode) {
                    this.displayVideoGallery = this.videoGallery.slice(0, this.videosPerRow);
                } else {
                    this.displayVideoGallery = this.videoGallery.slice(0);
                }
                this.error = '';
            } else if (!data.error) {
                this.videoGallery = data.items.map(e => ({
                    embed_url: `https://www.youtube.com/embed/${e.snippet.resourceId.videoId}?rel=0&modestbranding=1&playsinline=0`,
                    data_attr: `x7s-video-${e.snippet.resourceId.videoId}`,
                    id: e.snippet.resourceId.videoId,
                    title: e.snippet.title,
                    description: e.snippet.description,
                    ...e
                }));

                if (this.carouselMode) {
                    this.displayVideoGallery = this.videoGallery.slice(0, this.videosPerRow);
                } else {
                    this.displayVideoGallery = this.videoGallery.slice(0);
                }
                this.error = '';
            } else {
                this.showSeeMoreButton = false;
                this.error = `<p><strong>${data.error.errors[0].message}</strong></p>`;
            }
        } else {
            this.showSeeMoreButton = false;
            this.error = 'Invalid Request to YouTube. Please check your username and API Key.';
        }
    }

    /**
     * Pass title and description through innerHTML to pass HTML present in data.
     */
    setUpTextContent() {
        if (this.displayVideoGallery.length) {
            this.displayVideoGallery.forEach(e => {
                const titleEl = this.template.querySelector(`[data-video-title="${e.data_attr}"]`);
                titleEl.innerHTML = e.title;

                if (!this.hideDescriptions) {
                    const desc = this.stringToHref(e.description);
                    const descEl = this.template.querySelector(`[data-video-id="${e.data_attr}"]`);
                    descEl.innerHTML = desc;
                }
            });
        }
    }

    /**
     * Finds links inside string and place them href tags
     * @param {string} str
     * @returns {string}
     */
    stringToHref(str) {
        const urlRegex = /(https?:\/\/[^\s|^<]+)/g;
        if(str){
            return str.replace(urlRegex, '<a href="$1" target="_blank">$1</a>');
        }
        return '';
    }
}