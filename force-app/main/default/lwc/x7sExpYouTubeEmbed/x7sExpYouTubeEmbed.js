/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import YouTubePath from '@salesforce/resourceUrl/x7sExpYouTubeJS';
import { showToast } from 'c/x7sShrUtils';

export default class X7sExpYouTubeEmbed extends LightningElement {

    @api title;
    @api titleAlignment = 'left';
    @api youTubeId;
    @api customClass;

    player;

    renderedCallback() {
        if (!this.youTubeId) {
            return;
        }

        if (window.YT) {
            if (this.player) {
                this.player.cueVideoById(this.youTubeId);
            } else {
                this.onYouTubeIframeAPIReady();
            }
        } else {
            Promise.all([
                loadScript(this, YouTubePath + '/iframe_api.js'),
                loadScript(this, YouTubePath + '/widget_api.js')
            ])
                .then(() => {
                    this.onYouTubeIframeAPIReady();
                })
                .catch(error => {
                    showToast('Error loading YouTube player', error, 'error');
                });
        }
    }

    onPlayerError(e) {
        let explanation = '';
        if (e.data === 2) {
            explanation = 'Invalid YouTube ID';
        } else if (e.data === 5) {
            explanation =
                'The requested content cannot be played in an HTML5 player or another error related to the HTML5 player has occurred.';
        } else if (e.data === 100) {
            explanation =
                'The video requested was not found. This error occurs when a video has been removed (for any reason) or has been marked as private.';
        } else if (e.data === 101 || e.data === 150) {
            explanation =
                'The owner of the requested video does not allow it to be played in embedded players.';
        }

        showToast('Error loading YouTube player', explanation, 'error');
    }

    onYouTubeIframeAPIReady() {
        const containerElem = this.template.querySelector('.video-container');
        const playerElem = document.createElement('DIV');
        playerElem.className = 'player';
        containerElem.appendChild(playerElem);

        this.player = new window.YT.Player(playerElem, {
            height: '390',
            width: '100%',
            videoId: this.youTubeId,
            events: {
                onError: this.onPlayerError.bind(this)
            }
        });
    }

    /**
     * @returns {string} SLDS text alignment class for component title
     */
    get titleClass() {
        return `slds-text-align_${this.titleAlignment}`;
    }

    /**
     * return 'video-container' class and any additional SLDS or CSS class(es) on <div> element
     * @returns {string}
     */
    get componentClass() {
        return `video-container ${this.customClass}`;
    }
}