/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track, wire} from 'lwc';
import getFeaturedTopics from '@salesforce/apex/x7sExpFeaturedTopicsController.getFeaturedTopics';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelWrapper';
import { NavigationMixin  } from 'lightning/navigation';

export default class X7sExpFeaturedTopics extends NavigationMixin(LightningElement) {
    @api animateHover = false;
    @api customClass;
    @api descriptionColor;
    @api descriptionColorHover;
    @api horizontalAlignment;
    @api hideDescription = false;
    @api hideOverlay = false;
    @api imageBorderRadius;
    @api imageHeight;
    @api imageWidth;
    @api itemsPerRow = 2;
    @api itemsPerRowSmall = 2; // 1, 2, 3, 4, 6, auto
    @api itemsPerRowMedium = 6; // 1, 2, 3, 4, 6, auto
    @api itemsPerRowLarge = 6; // 1, 2, 3, 4, 6, auto
    @api itemSpacing;
    @api maxHeight;
    @api overlayColor;
    @api overlayColorHover;
    @api title;
    @api titleColor;
    @api titleColorHover;
    @api titleAlign = 'left';
    @api topicFilterList;
    @api verticalAlignment;
    @api viewType = 'Tile'; // Tile, List, Icon

    @track reduceAnimation = false;
    @track displayedTopics;
    @track topics;
    @track isLoaded = false;
    @track hasTopics = false;
    @track error;
    label = {labelAriaWrapper};

    connectedCallback(){
        getFeaturedTopics()
        .then(result=>{
            this.topics=result.managedTopics;
            console.log('--first time--'+JSON.stringify(this.topics));
            this.displayedTopics = this.filterTopics(this.topics,this.topicFilterList);
            console.log('displayedTopics', JSON.parse(JSON.stringify(this.displayedTopics)));
            this.isLoaded = true;
        })
        .catch(error=>{
            this.error = error;
            console.error(JSON.parse(error));
            this.topics = undefined;
            this.isLoaded = true;
        });
    }
    filterTopics(topics, filters) {
        if (filters === undefined || filters === '') {
            return topics;
        }
        
        let filteredTopics = [];
        let filterList = new Set(filters.split(','));

        filterList.forEach(id=> {
            let filteredTopic = topics.filter(topic=> {
                return topic.topic.id === id;
            })[0];
            if (filteredTopic !== undefined) {
                filteredTopics.push(filteredTopic);
            } else {
                console.warn('Featured Topics warning: a featured topic with the ID of "' + id + '" is not found.')
            }
        });
        return filteredTopics;
    }

    /* Item Sizes */
    get itemSize() {
        return (12 / this.itemsPerRow);
    }

    get itemSizeSmall() {
        return (12 / this.itemsPerRowSmall);
    }

    get itemSizeMedium() {
        return (12 / this.itemsPerRowMedium);
    }

    get itemSizeLarge() {
        return (12 / this.itemsPerRowLarge);
    }

    get itemClass() {
        return 'item-class';
    }

    get showTileView() {
        return this.viewType === 'Tile';
    }

    get showIconView() {
        return this.viewType === 'Icon';
    }

    get showListView() {
        return this.viewType === 'List';
    }

    get reduceAnimation() {
        return !this.animateHover;
    }

    get showTopics() {
        return this.displayedTopics && this.displayedTopics.length > 0;
    }

    get componentClass() {
        return `x7s-featured-topics ${this.isLoaded ? 'loaded' : ''}`;
    }

    /* Styles */
    get gridStyles() {
        return `margin: -${this.itemSpacing / 2}px;`;
    }

    get itemStyles() {
        return `padding: ${this.itemSpacing / 2}px;`;
    }
}