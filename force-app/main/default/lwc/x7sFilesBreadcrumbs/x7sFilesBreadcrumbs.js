/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import {api, LightningElement, track, wire} from 'lwc';
import {fireEvent} from "c/x7sShrUtils";
import {CurrentPageReference} from 'lightning/navigation';

export default class X7sFilesBreadcrumbs extends LightningElement {
    @api workspace = {};
    @api parentId = '';
    @api listId = 'ID_1';
    
    @track level1Id = '';
    @track level1Name = '';
    @track level2Id = '';
    @track level2Name = '';
    @track level3Id = '';
    @track level3Name = '';
    @track level4Id = '';
    @track level4Name = '';
    @wire(CurrentPageReference) pageRef;

    get isParentId() {
        return this.parentId;
    }

    @api
    get folders() {
        return this._folders;
    }
    set folders(value) {
        //this.setAttribute('pageSize', value);
        this._folders = value;
        this.setFolderTree();
    }
    @track _folders = [];

    // When showing levels, the last level is always the library.
    // We check the ID of the library and if it is the same, we don't show it.
    // Remember the ID of the library is stored as the name in the breadcrumbs... (Confusing, I know)
    get showLevel1() {
        return this.level1Name;
    }
    get showLevel2() {
        return this.level2Name;
    }
    get showLevel3() {
        return this.level3Name;
    }
    get showLevel4() {
        return this.level4Name;
    }

    get linkStyle() {
        return "padding-right:3px";
    }

    handleClick(evt) {
        const clickEvent = new CustomEvent('click', { detail: evt.detail });
        this.dispatchEvent(clickEvent);
    }

    handleAllClick() {
        fireEvent(this.pageRef,"allFolderClick");
    }

    clearFolderTree() {
        this.level1Id = '';
        this.level1Name = '';
        this.level2Id = '';
        this.level2Name = '';
        this.level3Id = '';
        this.level3Name = '';
        this.level4Id = '';
        this.level4Name = '';
    }
    setFolderTree() {
        // If you jump multiple levels up the breadcrumbs, you need to make sure you clear the old folder trail
        this.clearFolderTree();
        // console.log('folders:', JSON.parse(JSON.stringify(this.folders)));


        if (this.folders && this.folders[0]) {
            console.log('folders:', JSON.stringify(this.folders));

            let currentFolder = JSON.parse(this.folders[0]);

            this.level1Id = currentFolder.Id;
            this.level1Name = currentFolder.Name;

            if (this.folders[1]) {
                currentFolder = JSON.parse(this.folders[1]);

                this.level2Id = currentFolder.Id;
                this.level2Name = currentFolder.Name;

                if (this.folders[2]) {
                    currentFolder = JSON.parse(this.folders[2]);

                    this.level3Id = currentFolder.Id;
                    this.level3Name = currentFolder.Name;

                    if (this.folders[3]) {
                        currentFolder = JSON.parse(this.folders[3]);

                        this.level4Id = currentFolder.Id;
                        this.level4Name = currentFolder.Name;
                    }
                }
            }
        }
    }

}