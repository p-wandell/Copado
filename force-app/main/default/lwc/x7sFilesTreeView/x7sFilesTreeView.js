/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import {LightningElement, api, wire} from 'lwc';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import {fireEvent, registerListener,unregisterAllListeners} from "c/x7sShrUtils";

import getFolders from "@salesforce/apex/x7sFilesController.getFolders";
import treeViewAriaLabel from '@salesforce/label/c.x7sFilesTreeViewAriaLabel';

export default class X7sFilesTreeView extends NavigationMixin(LightningElement) {
    @api items;
    @api header = "";
    @api customClass = '';
    @api listId = "ID_1";
    @api recordId;
    result;
    finalTree = [];
    parentNodeList = [];
    childNodeList = [];
    count = 0;
    selectedItemValue = '';

    @wire(CurrentPageReference) pageRef;

    label = {treeViewAriaLabel}

    connectedCallback() {
        getFolders({recordId: this.recordId})
            .then(result => {
                this.result = result;
                this.getTreeData(this.result);
                this.getTree(this.parentNodeList, this.childNodeList);
            });

        registerListener("folderClick", this.handleFolderSelected, this); 
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    get componentClass() {
        return `x7s-files-tree-view ${this.customClass}`;
    }

    getTreeData(result) {
        if(result) {
            result.files.forEach(element => {
                if (element.ParentId) {
                    this.childNodeList.push(
                        {
                            Id: element.Id,
                            parentId: element.ParentId,
                            label: element.Title,
                            breadcrumbs: element.breadcrumbs
                        });
                } else {
                    this.parentNodeList.push(
                        {
                            Id: element.Id,
                            label: element.Title,
                            breadcrumbs: element.breadcrumbs
                        });
                }
            });
        } else {
            console.error('No Result found for the tree.');
        }
    }

    getTree(parentNodeList, childNodeList) {
        let parent = [];
        for (let index in parentNodeList) {
            if (index < parentNodeList.length) {
                let treeData = {};
                treeData.items = this.getChildNode(parentNodeList[index].Id, childNodeList);

                treeData.label = parentNodeList[index].label;
                treeData.name = parentNodeList[index].Id;
                treeData.expanded = false;
                parent.push(treeData);
            }
        }
        this.finalTree = parent;
    }

    getChildNode(strId, childNodeList) {
        let child = [];
        for (let index in childNodeList) {
            if (childNodeList[index].parentId === strId) {
                let childData = {};
                childData.label = childNodeList[index].label;
                childData.name = childNodeList[index].Id;
                childData.breadcrumbs = childNodeList[index].breadcrumbs;
                childData.expanded = false;
                childData.items = this.getChildNode(childNodeList[index].Id, childNodeList);
                if (childData.items.length === 0) {
                    this.count = this.count + 1;
                }
                child.push(childData);
            }
        }
        return child;
    }

    handleOnselect(event) {
        this.selectedItemValue = event.detail.name;
        this.handleFolders();   
    }

    handleFolderSelected(event) {
        if(this.listId === event.id){
            this.selectedItemValue = event.value;
            this.handleFolders();
        }
    }

    handleFolders(){
        let foundItem = this.childNodeList.filter(item => { return item.Id === this.selectedItemValue});

        if (foundItem.length === 0) {
            foundItem = this.parentNodeList.filter(item => { return item.Id === this.selectedItemValue});
        }
        fireEvent(this.pageRef, "folderSearchEvent", {id: this.listId, value: this.selectedItemValue, breadcrumbs: foundItem[0].breadcrumbs});
    }


}