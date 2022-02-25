/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import {api, LightningElement, wire} from 'lwc';
import {fireEvent} from "c/x7sShrUtils";
import {CurrentPageReference} from 'lightning/navigation';

export default class X7sFilesBreadcrumbItem extends LightningElement {
    @api folderId = '';
    @api name = '';
    @api listId = 'ID_1';

    @wire(CurrentPageReference) pageRef;

    handleClick() {
       fireEvent(this.pageRef,"folderClick",{id: this.listId, value: this.folderId});
    }
}