/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';

import isInAGroup from '@salesforce/apex/x7sExpMyGroupsController.isInAGroup';
import getMyGroups from '@salesforce/apex/x7sExpMyGroupsController.getMyGroups';
import getFeaturedGroups from '@salesforce/apex/x7sExpMyGroupsController.getFeaturedGroups';

import x7s_member_label from '@salesforce/label/c.x7sExpLabelMember';
import x7s_members_label from '@salesforce/label/c.x7sExpLabelMembers';
import labelAriaWrapper  from '@salesforce/label/c.x7sExpAriaLabelWrapper';

export default class X7sExpMyGroups extends NavigationMixin(LightningElement) {

    // Builder Config
    @api title;
    @api titleNoGroups;
    @api groupsIntro;
    @api groupsIntroWithRecommendations;
    @api recommendedGroupIds;
    @api numberOfResults;
    @api showDescription;
    @api showMembers;
    @api moreGroupsButtonText;
    @api exploreMoreGroupsButtonText;
    @api groupsUrl;
    @api customClass;

    // Method results
    @api isInAGroup = false;
    @api myGroups = [];
    @api featuredGroups = [];

    label = {labelAriaWrapper};

    /**
     * Methods to call upon connection
     */
    connectedCallback(){
        this.getUsersGroupStatus();
        this.getUsersGroups();
        this.getFeaturedGroups();
    }

    /**
     * Gets a boolean for whether the user is in a group or not
     */
    getUsersGroupStatus() {
        isInAGroup().then(result => {
            this.isInAGroup = result;
        }).catch(error => {
            console.log("Get method for isInAGroup resulted in the following error: ", error.body.message);
        });
    }

    /**
     * Obtains a list of the currently logged in user's groups
     * Parameters include the number of results
     */
    getUsersGroups(){
        getMyGroups({numResultsString: this.numberOfResults}).then(result => {
            if(result.success) {
                if(result.hasOwnProperty('results')) {

                    result.results.forEach(result => {
                        if(result.hasOwnProperty('MemberCount')){
                            result.memberIcon = result.MemberCount > 1 ? "utility:groups" : "utility:user";
                            result.memberText = result.MemberCount > 1 ? x7s_members_label : x7s_member_label;
                        }
                    });

                    this.myGroups = result.results;
                }
            }
        }).catch(error => {
            console.log("Get method for getMyGroups encountered the following error:", error.body.message);
        });
    }

    /**
     * Gets the featured groups
     * Parameters include the groupId(s) obtained from the builder
     */
    getFeaturedGroups(){
        let recommendedGroupIds = this.recommendedGroupIds ? this.recommendedGroupIds.replace(/ /g, "").split(",") : '';
        getFeaturedGroups({groupIdStrings: recommendedGroupIds, numResultsString: this.numberOfResults}).then(result => {
            if(result.success) {
                if(result.hasOwnProperty('results')) {
                    result.results.forEach(result => {
                        if(result.hasOwnProperty('MemberCount')){
                            result.memberIcon = result.MemberCount > 1 ? "utility:groups" : "utility:user";
                            result.memberText = result.MemberCount > 1 ? x7s_members_label : x7s_members_label;

                        }
                    });
                    this.featuredGroups = result.results;
                }
            }
        }).catch(error => {
            console.log("Get method for getFeaturedGroups encountered the following error:", error.body.message);
        });
    }

    /**
     * Navigation to the groups page
     * If the groups URL is defined, we will use the comm__namedPage navigation method
     * If it is undefined, default to the collaboration group list view
     */
    navigateToGroupsPage(){
        if(this.groupsUrl){
            let groupsUrl=this.remove_forwardslash(this.groupsUrl);
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    pageName: groupsUrl
                }
            });
        } else {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'CollaborationGroup',
                    actionName: 'list'
                },
                state: {
                    filterName: 'Recent'
                }
            });
        }
    }
    remove_forwardslash(str) {
        return (str.charAt(0)==='/' || str.charAt(str.length - 1)==='/') ? 
        str.replace(/\//g, '') : str; 
    }
    /**
     * Returns the appropriate text for the more groups button label
     * based on if the user is currently in a group or not
     * @returns {String} more groups / explore more groups text
     */
    get navigateToGroupButtonLabel(){
        return this.isInAGroup ? this.moreGroupsButtonText : this.exploreMoreGroupsButtonText;
    }

    /**
     * Returns the appropriate title text based on if the user
     * is currently in a group or not
     * @returns {String} title
     */
    get componentTitle(){
        return this.isInAGroup ? this.title : this.titleNoGroups;
    }

    /**
     * Determines whether to display featured groups based upon
     * if the user is not in a group and there are featured groups to show
     * @returns {boolean}
     */
    get showFeaturedGroups(){
        return !this.isInAGroup && this.featuredGroups.length > 0;
    }

    /**
     * Gets the appropriate intro string based on whether
     * there are featured groups or not
     * @returns {String} introduction
     */
    get notInGroupIntro(){
        return this.featuredGroups.length > 0 ? this.groupsIntroWithRecommendations : this.groupsIntro;
    }
}