/*
 * Copyright (c) 2019. 7Summits Inc.
 * Created by 7Summits - Joe Callin on 2019-04-10.
*/
import {LightningElement,wire,track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import {getRecord, getFieldValue, getFieldDisplayValue} from 'lightning/uiRecordApi';
import {NavigationMixin} from 'lightning/navigation';
export default class x7SUtils extends NavigationMixin(LightningElement){
    @track userData;

    @wire(getRecord, { recordId: '$recordId', layoutTypes: ['Full'] })
    wiredRecord({ error, data }) {
        if (error) {
            let message = 'Unknown error';
            if (Array.isArray(error.body)) {
                message = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                message = error.body.message;
            }

            this.dispatchEvent(x7SUtils.showToast('error', message));
        } else if (data) {
            console.log('UTILS HIR');
        }
    }
    static showToast(level, message) {
        level = level.toLowerCase();
        const event = new ShowToastEvent({
            title: level === "error" ? "Error" : "Message",
            message: message,
            variant: level
        });
        dispatchEvent(event);
    }
    static isEmpty(value){
        return !value;
    }
    static isDefined(value){
        return !!value;
    }
    static getCurrentUserId() {
        return Id;
    }
    static navigateToRecord(navigation) {
        console.log('navigateToRecord');
        // Opens the new Account record modal
        // to create an Account.
        console.log(this[NavigationMixin.Navigate]);
        console.log(super[NavigationMixin.Navigate]);
        console.log(navigation);
        super[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: '0058000000DnKw6AAF',
                objectApiName: 'User',
                actionName: 'view'
            }
        });
    }
    static getRecordData() {
        console.log('in here');
        console.log(this.userData);
        // getFieldDisplayValue(this.getCurrentUserId(), 'Name');
        // console.log('oh yeah');
    }
    static getUserData(){
        console.log('hello');
        console.log(this.wiredUser);
        // // let thisId = Id;
        // // getRecord({recordId: thisId, layoutTypes: ['Full']}).then(data => {
        //     this.fieldLabels = data.labels;
        //     this.getAllAssets();
        //     if(!data.success){
        //         x7SUtils.showToast('error', data.messages[0]);
        //         // console.log( data);
        //     }
        // // }).catch(error => {
        //     x7SUtils.showToast('error', error);
        //     // console.log(error);
        // // });
    }

}
// export default class getRecordData{
// // export function getRecordData(){
//     @wire(getRecord, { recordId: '$recordId', fields: ['Account.Name']})
//     wiredData({ error, data }){
//         if (data) {
//             this.record = data;
//             this.error = undefined;
//         } else if (error) {
//             this.error = error;
//             this.record = undefined;
//         }
//     }
// }