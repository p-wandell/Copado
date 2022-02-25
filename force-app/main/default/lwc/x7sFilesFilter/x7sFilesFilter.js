/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

import { LightningElement, api, wire } from 'lwc';
import {NavigationMixin,CurrentPageReference} from 'lightning/navigation';
import {fireEvent} from "c/x7sShrUtils";
import labelFromDateValidation from '@salesforce/label/c.x7sFilesFilterFromDateValidationLabel';
import labelToDateValidation from '@salesforce/label/c.x7sFilesFilterToDateValidationLabel';
import labelFileType from '@salesforce/label/c.x7sFilesFilterFileTypeLabel';
import labelFileTypePlaceholder from '@salesforce/label/c.x7sFilesFilterFileTypePlaceholderLabel';
import labelFileSize from '@salesforce/label/c.x7sFilesFilterFileSizeLabel';
import labelFileSizePlaceholder from '@salesforce/label/c.x7sFilesFilterFileSizePlaceholderLabel';
import labelCreatedBy from '@salesforce/label/c.x7sFilesFilterCreatedByLabel';
import labelCreatedByPlaceholder from '@salesforce/label/c.x7sFilesFilterCreatedByPlaceholderLabel';
import labelLastModifiedBy from '@salesforce/label/c.x7sFilesFilterLastModifiedByLabel';
import labelLastModifiedByPlaceholder from '@salesforce/label/c.x7sFilesFilterLastModifiedByPlaceholderLabel';
import labelFromCreatedDate from '@salesforce/label/c.x7sFilesFilterFromCreatedDateLabel';
import labelFromCreatedDatePlaceholder from '@salesforce/label/c.x7sFilesFilterFromCreatedDatePlaceholderLabel';
import labelToCreatedDate from '@salesforce/label/c.x7sFilesFilterToCreatedDateLabel';
import labelToCreatedDatePlaceholder from '@salesforce/label/c.x7sFilesFilterToCreatedDatePlaceholderLabel';
import labelFromLastModifiedDate from '@salesforce/label/c.x7sFilesFilterFromLastModifiedDateLabel';
import labelFromLastModifiedPlaceholder from '@salesforce/label/c.x7sFilesFilterFromLastModifiedPlaceholderLabel';
import labelToLastModifiedDate from '@salesforce/label/c.x7sFilesFilterToLastModifiedDateLabel';
import labelToLastModifiedDateDatePlaceholder from '@salesforce/label/c.x7sFilesFilterToLastModifiedDateDatePlaceholderLabel';
import labelClearDateButton from '@salesforce/label/c.x7sFilesFilterClearDateButtonLabel';
import labelClearAllButton from '@salesforce/label/c.x7sFilesFilterClearAllButtonLabel';
import filterAriaLabel from '@salesforce/label/c.x7sFilesListControlAriaLabel';
import lessThan10KBLabel from '@salesforce/label/c.x7sFilesFilterSizeLessThan10KBLabel';
import greaterThan10KBLabel from '@salesforce/label/c.x7sFilesFilterSizeGreaterThan10KBLabel';
import greaterThan100KBLabel from '@salesforce/label/c.x7sFilesFilterSizeGreaterThan100KBLabel';
import greaterThan1MBLabel from '@salesforce/label/c.x7sFilesFilterSizeGreaterThan1MBLabel';
import greaterThan10MBLabel from '@salesforce/label/c.x7sFilesFilterSizeGreaterThan10MBLabel';
import greaterThan50MBLabel from '@salesforce/label/c.x7sFilesFilterSizeGreaterThan50MBLabel';
import greaterThan100MBLabel from '@salesforce/label/c.x7sFilesFilterSizeGreaterThan100MBLabel';

import getFileType from "@salesforce/apex/x7sFilesFilterData.getFileType";
import getOwners from "@salesforce/apex/x7sFilesFilterData.getOwners";
import getModifierUsers from "@salesforce/apex/x7sFilesFilterData.getModifierUsers";
import {formattedFileSize} from 'c/x7sFilesBase';

export default class X7sFilesFilter extends NavigationMixin(LightningElement) {

    @api showFileType = false;
    @api showFileSize = false;
    @api showOwner = false;
    @api showDate = false;
    @api showCreatedDate = false;
    @api showModifiedDate = false;
    @api showModifier = false;
    @api customClass='';
    @api listId='ID_1';
    @api variant='None';
    @api showClear=false;

    fileTypeListValues = [];
    selectedTypeIds = [];
    fileSizeListValues = [];
    userValue = [];
    modifierUerValue = [];
    disableClear=true;

    selectedSizeValue = '';
    selectedFromDate = '';
    selectedToDate = '';
    selectedModFromDate = '';
    selectedModToDate = '';
    fromDate="fromDate";
    toDate="toDate";
    createdDate = "createdDate";
    modifiedDate = "modifiedDate";
    fromModifiedDate = "fromModifiedDate";
    toModifiedDate = "toModifiedDate";
    selectedOwnerId = '';
    selectedModifierId = '';

    lightningLayoutSize='12';
    smallDeviceSize='12';
    mediumDeviceSize='6';
    largeDeviceSize='2';

    flag=false;

    @wire(CurrentPageReference) pageRef;

    labels={labelFileType,
        labelFileTypePlaceholder,
        labelFileSize,
        labelFileSizePlaceholder,
        labelCreatedBy,
        labelCreatedByPlaceholder,
        labelLastModifiedBy,
        labelLastModifiedByPlaceholder,
        labelClearDateButton,
        labelClearAllButton,
        labelFromCreatedDate,
        labelFromCreatedDatePlaceholder,
        labelToCreatedDate,
        labelToCreatedDatePlaceholder,
        labelFromLastModifiedDate,
        labelFromLastModifiedPlaceholder,
        labelToLastModifiedDate,
        labelToLastModifiedDateDatePlaceholder,
        filterAriaLabel
    }

    connectedCallback(){

        getFileType().then(result=>{
            let data = result;
            let res = Object.keys(data).map((key) => {
              return ({name: data[key].FileType, id: data[key].FileType});
            });
            let filterList =res;
            this.fileTypeListValues=filterList;
            this.flag=true;
        }).catch(error => {
            console.error(error);        
        });

        getOwners().then(result=>{
        let   list   = [];
        let conts = result;
        for(let key in conts){
              list.push({label:conts[key], value:key}); //Here we are creating the array to show on UI.
        }
        list.sort(function (a, b) {
          let nameA = a.label.toUpperCase(); // ignore upper and lowercase
          let nameB = b.label.toUpperCase(); // ignore upper and lowercase
          if (nameA < nameB) {
              return -1;
          }
          if (nameA > nameB) {
              return 1;
          }
            // names must be equal
          return 0;
          });
        list.unshift({value: '', label:'All'});
        this.userValue=list;

        }).catch(error => {
            console.error(error);        
        });

        getModifierUsers().then(result=>{
        let   list   = [];
        let conts = result;
        for(let key in conts){
              list.push({label:conts[key], value:key}); //Here we are creating the array to show on UI.
        }
        list.sort(function (a, b) {
          let nameA = a.label.toUpperCase(); // ignore upper and lowercase
          let nameB = b.label.toUpperCase(); // ignore upper and lowercase
          if (nameA < nameB) {
              return -1;
          }
          if (nameA > nameB) {
              return 1;
          }
            // names must be equal
          return 0;
          });
        list.unshift({value: '', label:'All'});
        this.modifierUerValue=list;
        }).catch(error => {
            console.error(error);        
        });

    }

    createOptions(fieldValueToDisplay) {
        let optionList = [];
        optionList.unshift({value:'', label: 'All'});

            for(let index in fieldValueToDisplay)
            {
                if(fieldValueToDisplay[index]){
                    let opt = {label: formattedFileSize(index.toString()) , value: index};
                    optionList.push(opt); 
                }
            } 
        let uniqueArray = this.removeDuplicates(optionList, "label");  
        return uniqueArray;
    } 
    
    get componentClass() {
		return `x7s-files-filter ${this.customClass}`;
    }

    get fileTypeData(){
        return this.fileTypeListValues;
    }

    get isShowFileType(){
        return this.flag && this.showFileType;
    }

    get isShowFileSize(){
        return this.showFileSize;
    }

    get fileSizeData(){
        return [{label:'< '+lessThan10KBLabel , value: 'lessThan10KB'},
        {label:'> '+greaterThan10KBLabel , value: 'greaterThan10KBTo100KB'},
        {label:'> '+greaterThan100KBLabel , value: 'greaterThan100KBTO1MB'},
        {label:'> '+greaterThan1MBLabel , value: 'greaterThan1MBTO10MB'},
        {label:'> '+greaterThan10MBLabel , value: 'greaterThan10MBTO50MB'},
        {label:'> '+greaterThan50MBLabel , value: 'greaterThan50MBTO100MB'},
        {label:'> '+greaterThan100MBLabel , value: 'greaterThan100MB'},];
    }

    get displayVariant(){
        return this.variant === 'Featured' ? 'featured' : this.variant === 'Outline' ? 'slds-card' : 'default';
    }

    removeDuplicates(originalArray, prop) {
        var newArray = [];
        var lookupObject = {};
    
        for (var i in originalArray) {
            lookupObject[originalArray[i][prop]] = originalArray[i];
        }
    
        for (i in lookupObject) {
            newArray.push(lookupObject[i]);
        }
        return newArray;
    }

    clearDates(){
        this.disableClear = true;
        this.selectedFromDate = '';
        this.selectedToDate = '';
        let buttonId = this.template.querySelector(".createdDate");
        buttonId.disabled = true; 

        let fromDateCmp = this.template.querySelector("[data-dateval=fromDate]");
        let toDateCmp = this.template.querySelector("[data-dateval=toDate]");
        
        if (toDateCmp) {
        this.selectedToDate = '';
        toDateCmp.setCustomValidity("");
        toDateCmp.reportValidity();
        }

        if (fromDateCmp) {
        this.selectedFromDate = '';
        fromDateCmp.setCustomValidity("");
        fromDateCmp.reportValidity();
        }
        this.filterList();
    }

    clearModDates(){
        this.disableClear = true;
        this.selectedModFromDate = '';
        this.selectedModToDate= '';
        let buttonId = this.template.querySelector(".modifiedDate");
        buttonId.disabled = true; 

        let fromModDateCmp = this.template.querySelector("[data-dateval=fromModifiedDate]");
        let toModDateCmp = this.template.querySelector("[data-dateval=toModifiedDate]");

         if (toModDateCmp) {
        this.selectedModToDate = '';
        toModDateCmp.setCustomValidity("");
        toModDateCmp.reportValidity();
        }

        if (fromModDateCmp) {
        this.selectedModFromDate = '';
        fromModDateCmp.setCustomValidity("");
        fromModDateCmp.reportValidity();
        }
        this.filterList();
    }

    clearAll() {
        this.disableClear = true; 
        this.selectedFromDate = '';
        this.selectedToDate = '';
        this.selectedModFromDate = '';
        this.selectedModToDate = '';
        this.selectedModifierId='';
        this.selectedOwnerId='';
        this.selectedSizeValue='';
        this.selectedTypeIds = [];
        
        let buttonId = this.template.querySelector(".modifiedDate");
        buttonId.disabled = true; 

        let buttonId1 = this.template.querySelector(".createdDate");
        buttonId1.disabled = true; 

        const inputFields = this.template.querySelectorAll('lightning-combobox');
        if (inputFields) {
                inputFields.forEach(field => {
                    field.value = '';
                });
        }

        let fromDateCmp = this.template.querySelector("[data-dateval=fromDate]");
        let toDateCmp = this.template.querySelector("[data-dateval=toDate]");
        let fromModDateCmp = this.template.querySelector("[data-dateval=fromModifiedDate]");
        let toModDateCmp = this.template.querySelector("[data-dateval=toModifiedDate]");

         if (toDateCmp) {
        this.selectedToDate = '';
        toDateCmp.setCustomValidity("");
        toDateCmp.reportValidity();
        }

        if (fromDateCmp) {
        this.selectedFromDate = '';
        fromDateCmp.setCustomValidity("");
        fromDateCmp.reportValidity();
        }

         if (toModDateCmp) {
        this.selectedModToDate = '';
        toModDateCmp.setCustomValidity("");
        toModDateCmp.reportValidity();
        }

        if (fromModDateCmp) {
        this.selectedModFromDate = '';
        fromModDateCmp.setCustomValidity("");
        fromModDateCmp.reportValidity();
        }

        this.template.querySelector("c-x7s-files-filter-multi-select-type").handleClearAllTopics();

       this.filterList();
      }

    handleFromCreatedDateChange(event) {
       this.disableClear = false; 
        this.selectedFromDate = event.detail.value;
        if (this.selectedFromDate  && this.selectedFromDate.trim() !== '') {
           let fromDateCmp = this.template.querySelector("[data-dateval=fromDate]");

            let fromDate = new Date(this.selectedFromDate);
            let toDate = new Date(this.selectedToDate);

                if (fromDate > toDate ) {
                    fromDateCmp.setCustomValidity(labelFromDateValidation);
                } else {
                    fromDateCmp.setCustomValidity("");
                }
                fromDateCmp.reportValidity();
        }
        if (this.selectedToDate && this.selectedToDate.trim() !== '') {
            let toDateCmp = this.template.querySelector("[data-dateval=toDate]");

            let fromDate = new Date(this.selectedFromDate);
            let toDate = new Date(this.selectedToDate);
            
            if (toDate < fromDate) {
                    toDateCmp.setCustomValidity(labelToDateValidation);
            } else {
                toDateCmp.setCustomValidity("");
            }
            toDateCmp.reportValidity();
        }
        let buttonId = this.template.querySelector(".createdDate");
        if(this.selectedFromDate){
            buttonId.disabled = false; 
        }
        this.filterList();
    }
  
    handleToCreatedDateChange(event) {
       this.disableClear = false; 
        this.selectedToDate = event.detail.value;
        if (this.selectedToDate && this.selectedToDate.trim() !== '') {
            let toDateCmp = this.template.querySelector("[data-dateval=toDate]");

            let fromDate = new Date(this.selectedFromDate);
            let toDate = new Date(this.selectedToDate);
            
            if (toDate < fromDate) {
                    toDateCmp.setCustomValidity(labelToDateValidation);
            } else {
                toDateCmp.setCustomValidity("");
            }
            toDateCmp.reportValidity();
        }

        if (this.selectedFromDate  && this.selectedFromDate.trim() !== '') {
            let fromDateCmp = this.template.querySelector("[data-dateval=fromDate]");
 
             let fromDate = new Date(this.selectedFromDate);
             let toDate = new Date(this.selectedToDate);
 
                 if (fromDate > toDate ) {
                     fromDateCmp.setCustomValidity(labelFromDateValidation);
                 } else {
                     fromDateCmp.setCustomValidity("");
                 }
                 fromDateCmp.reportValidity();
         }
         let buttonId = this.template.querySelector(".createdDate");
         if(this.selectedToDate){
             buttonId.disabled = false; 
         }
         this.filterList();
    }


    handleModFromdateChange(event) {
       this.disableClear = false; 
        this.selectedModFromDate = event.detail.value;
        if (this.selectedModFromDate  && this.selectedModFromDate.trim() !== '') {
           let fromDateCmp = this.template.querySelector("[data-dateval=fromModifiedDate]");

            let fromDate = new Date(this.selectedModFromDate);
            let toDate = new Date(this.selectedModToDate);

                if (fromDate > toDate ) {
                    fromDateCmp.setCustomValidity(labelFromDateValidation);
                } else {
                    fromDateCmp.setCustomValidity("");
                }
                fromDateCmp.reportValidity();
        }
        if (this.selectedModToDate && this.selectedModToDate.trim() !== '') {
            let toDateCmp = this.template.querySelector("[data-dateval=toModifiedDate]");

            let fromDate = new Date(this.selectedModFromDate);
            let toDate = new Date(this.selectedModToDate);
            
            if (toDate < fromDate) {
                    toDateCmp.setCustomValidity(labelToDateValidation);
            } else {
                toDateCmp.setCustomValidity("");
            }
            toDateCmp.reportValidity();
        }
        let buttonId = this.template.querySelector(".modifiedDate");
        if(this.selectedModFromDate){
            buttonId.disabled = false; 
        }
        this.filterList();
    }
  
    handleModTodateChange(event) {
       this.disableClear = false; 
        this.selectedModToDate = event.detail.value;

        if (this.selectedModToDate && this.selectedModToDate.trim() !== '') {
            let toDateCmp = this.template.querySelector("[data-dateval=toModifiedDate]");

            let fromDate = new Date(this.selectedModFromDate);
            let toDate = new Date(this.selectedModToDate);
            
            if (toDate < fromDate) {
                    toDateCmp.setCustomValidity(labelToDateValidation);
            } else {
                toDateCmp.setCustomValidity("");
            }
            toDateCmp.reportValidity();
        }

        if (this.selectedModFromDate  && this.selectedModFromDate.trim() !== '') {
            let fromDateCmp = this.template.querySelector("[data-dateval=fromModifiedDate]");
 
             let fromDate = new Date(this.selectedModFromDate);
             let toDate = new Date(this.selectedModToDate);
 
                 if (fromDate > toDate ) {
                     fromDateCmp.setCustomValidity(labelFromDateValidation);
                 } else {
                     fromDateCmp.setCustomValidity("");
                 }
                 fromDateCmp.reportValidity();
         }
         let buttonId = this.template.querySelector(".modifiedDate");
         if(this.selectedModToDate){
             buttonId.disabled = false; 
         }
         this.filterList();
    }


    handleFileTypeChangeEvent(event) {
     //   this.disableClear = false; 
        this.selectedTypeIds = event.detail;
        this.setClearAll();
        this.filterList();
    }

    handleSizeFilterChangeEvent(event){
        this.disableClear = false; 
        console.log('event.detail.value',event.detail.value);
        this.selectedSizeValue = event.detail.value;
        this.setClearAll();
        this.filterList();
    }

    handleOwnerChangeEvent(event) {
        this.disableClear = false; 
        this.selectedOwnerId = event.detail.value;
        console.log(this.selectedOwnerId);
        this.setClearAll();
        this.filterList();
    }

    handleModifierChangeEvent(event) {
        this.disableClear = false; 
        this.selectedModifierId = event.detail.value;
        console.log(this.selectedModifierId);
        this.setClearAll();
        this.filterList();
    }

    filterList(){
        let selectedTypeId='';
        let _selectedTypeIds = this.selectedTypeIds;
         for(let i=0;i<_selectedTypeIds.length;i++) {
            if(i === (_selectedTypeIds.length -1))
            selectedTypeId += _selectedTypeIds[i];
            else
            selectedTypeId += _selectedTypeIds[i] + ';';
          }
        let filter = {
            selectedFileTypeValue : selectedTypeId,
            selectedFromDate : this.selectedFromDate,
            selectedToDate : this.selectedToDate,
            selectedModFromDate : this.selectedModFromDate,
            selectedModToDate : this.selectedModToDate,
            selectedFileSizeValue : this.selectedSizeValue,
            selectedOwnerId : this.selectedOwnerId,
            selectedModifierId : this.selectedModifierId
        }
      fireEvent(this.pageRef,"fileFilterEvent",{
          id: this.listId,
          value: filter
      });
    }

    setClearAll() {
        this.disableClear = !((this.selectedModifierId && this.selectedModifierId.length) || this.selectedOwnerId || this.selectedSizeValue || (this.selectedTypeIds && this.selectedTypeIds.length > 0));
    }
 
}