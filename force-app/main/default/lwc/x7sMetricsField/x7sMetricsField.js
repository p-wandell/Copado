/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import { LightningElement,api,track} from 'lwc';
import fetchMetricsData from "@salesforce/apex/x7sMetricFieldController.fetchMetricsData";

export default class X7sMetricsField extends LightningElement {

    // Builder properties
    @api titleAlignment = 'Center';
    @api noOfMetricsToDisplay;
    @api isBold = false;

    @api title1;
    @api fieldNameAPI1;
    @api metricLabel1;
    @api iconName1;
    @api iconHoverText1;
    @api iconColor1;
    @api showLeftButton1 = false;
    @api labelForLeftButton1;
    @api urlForLeftButton1;
    @api showRightButton1 = false;
    @api labelForRightButton1;
    @api urlForRightButton1;

    @api title2;
    @api fieldNameAPI2;
    @api metricLabel2;
    @api iconName2;
    @api iconHoverText2;
    @api iconColor2;
    @api showLeftButton2 = false;
    @api labelForLeftButton2;
    @api urlForLeftButton2;
    @api showRightButton2 = false;
    @api labelForRightButton2;
    @api urlForRightButton2;

    @api title3;
    @api fieldNameAPI3;
    @api metricLabel3;
    @api iconName3;
    @api iconHoverText3;
    @api iconColor3;
    @api showLeftButton3 = false;
    @api labelForLeftButton3;
    @api urlForLeftButton3;
    @api showRightButton3 = false;
    @api labelForRightButton3;
    @api urlForRightButton3;

    @api title4;
    @api fieldNameAPI4;
    @api metricLabel4;
    @api iconName4;
    @api iconHoverText4;
    @api iconColor4;
    @api showLeftButton4 = false;
    @api labelForLeftButton4;
    @api urlForLeftButton4;
    @api showRightButton4 = false;
    @api labelForRightButton4;
    @api urlForRightButton4;

    //Other properties
    @track error;
    @api metricValue1;
    @api metricValueType1;
    @api metricValue2;
    @api metricValueType2;
    @api metricValue3;
    @api metricValueType3;
    @api metricValue4;
    @api metricValueType4;
    metric1 = false;
    metric2 = false;
    metric3 = false;
    metric4 = false;

    connectedCallback(){
        let display = this.noOfMetricsToDisplay;
        for(let i=1; i<=display; i++){
            if (i === 1)
                this.metric1 = true;
            else if(i === 2)
                this.metric2 = true;
            else if(i === 3)
                this.metric3 = true; 
            else if(i === 4)
                this.metric4 = true;
        }
        if(this.fieldNameAPI1 || this.fieldNameAPI2 || this.fieldNameAPI3 || this.fieldNameAPI4){
             this.getMetricsData();
         }
    }
    get titleAlignmentInLower(){
        return (this.titleAlignment.toLowerCase());
    }
    getMetricsData(){
        let fieldNames = [this.fieldNameAPI1, this.fieldNameAPI2, this.fieldNameAPI3, this.fieldNameAPI4];
        fetchMetricsData({fieldNames: fieldNames})
        .then(result=>{
            const metricsData = JSON.parse(result);
            if(metricsData != null){
                let fieldValue;
                let fieldType;
                let fieldTypeValue;
                for (let i = 0; i < metricsData.length; i++){
                    fieldType = metricsData[i].fieldType;
                    if(fieldType){
                        if(fieldType === 'CURRENCY'){
                            fieldTypeValue = fieldType.toLowerCase();
                            fieldValue = metricsData[i].fieldMetricValue;
                        }else if(fieldType === 'PERCENT'){
                            fieldTypeValue = fieldType.toLowerCase();
                            fieldValue = metricsData[i].fieldMetricValue / 100;
                        }else {
                            fieldTypeValue = fieldType;
                            fieldValue = metricsData[i].fieldMetricValue;
                        }
                        if(metricsData[i].fieldApiName === this.fieldNameAPI1){
                            this.metricValue1 = fieldValue;
                            this.metricValueType1 = fieldTypeValue;
                        }else if(metricsData[i].fieldApiName === this.fieldNameAPI2){
                            this.metricValue2 = fieldValue;
                            this.metricValueType2 = fieldTypeValue;
                        }else if(metricsData[i].fieldApiName === this.fieldNameAPI3){
                            this.metricValue3 = fieldValue;
                            this.metricValueType3 = fieldTypeValue;
                        }else if(metricsData[i].fieldApiName === this.fieldNameAPI4){
                            this.metricValue4 = fieldValue;
                            this.metricValueType4 = fieldTypeValue;
                        }
                    }
                }                
            }
            this.error = null;
        })
        .catch(error=>{
            this.error = error;
        })
    }
    
}