/*
 * Copyright (c) 2020. 7Summits Inc.
 */
import {LightningElement, api, track} from 'lwc';
import getreportData from "@salesforce/apex/x7sMetricReportController.reportData";

export default class X7sMetricsReport extends LightningElement {
	// Builder properties
	@api titleAlignment = 'Left';
	@api noOfMetricsToDisplay = 1;
	@api isBold = false;
	
	@api title1;
	@api reportAPIName1;
	@api useFieldAPI1 = false;
	@api fieldName1;
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
	@api reportAPIName2;
	@api useFieldAPI2 = false;
	@api fieldName2;
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
	@api reportAPIName3;
	@api useFieldAPI3 = false;
	@api fieldName3;
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
	@api reportAPIName4;
	@api useFieldAPI4 = false;
	@api fieldName4;
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
	
	connectedCallback() {
		let display = this.noOfMetricsToDisplay;
		for (let i = 1; i <= display; i++) {
			if (i === 1)
				this.metric1 = true;
			else if (i === 2)
				this.metric2 = true;
			else if (i === 3)
				this.metric3 = true;
			else if (i === 4)
				this.metric4 = true;
		}
		if (this.reportAPIName1 || this.reportAPIName2 || this.reportAPIName3 || this.reportAPIName4) {
			this.getMetricsData();
		}
	}
	
	get titleAlignmentInLower() {
		return (this.titleAlignment.toLowerCase());
	}
	
	getMetricsData() {
		getreportData({
			reportName1: this.reportAPIName1,
			fieldName1: this.fieldName1,
			useAPIName1: this.useFieldAPI1,
			reportName2: this.reportAPIName2,
			fieldName2: this.fieldName2,
			useAPIName2: this.useFieldAPI2,
			reportName3: this.reportAPIName3,
			fieldName3: this.fieldName3,
			useAPIName3: this.useFieldAPI3,
			reportName4: this.reportAPIName4,
			fieldName4: this.fieldName4,
			useAPIName4: this.useFieldAPI4
		})
			.then(result => {
				let metricsData = JSON.parse(result);
				if (this.fieldName1 == null) {
					this.fieldName1 = 'null';
				}
				if (this.fieldName2 == null) {
					this.fieldName2 = 'null';
				}
				if (this.fieldName3 == null) {
					this.fieldName3 = 'null';
				}
				if (this.fieldName4 == null) {
					this.fieldName4 = 'null';
				}
				
				for (let i = 0; i < metricsData.length; i++) {
					if (this.reportAPIName1 === metricsData[i].reportName && this.fieldName1 === metricsData[i].fieldName) {
						this.metricValueType1 = metricsData[i].dataType.toLowerCase();
						if (metricsData[i].dataType.toLowerCase() === 'percent') {
							this.metricValue1 = metricsData[i].value / 100;
						} else if (metricsData[i].dataType.toLowerCase() === 'int') {
							this.metricValue1 = metricsData[i].value;
							this.metricValueType1 = 'decimal';
						} else {
							this.metricValue1 = metricsData[i].value;
						}
					}
					
					if (this.reportAPIName2 === metricsData[i].reportName && this.fieldName2 === metricsData[i].fieldName) {
						this.metricValueType2 = metricsData[i].dataType.toLowerCase();
						if (metricsData[i].dataType.toLowerCase() === 'percent') {
							this.metricValue2 = metricsData[i].value / 100;
						} else if (metricsData[i].dataType.toLowerCase() === 'int') {//Need to check this condition
							this.metricValue2 = metricsData[i].value;
							this.metricValueType2 = 'decimal';
						} else {
							this.metricValue2 = metricsData[i].value;
						}
					}
					
					if (this.reportAPIName3 === metricsData[i].reportName && this.fieldName3 === metricsData[i].fieldName) {
						this.metricValueType3 = metricsData[i].dataType.toLowerCase();
						if (metricsData[i].dataType.toLowerCase() === 'percent') {
							this.metricValue3 = metricsData[i].value / 100;
						} else if (metricsData[i].dataType.toLowerCase() === 'int') {//Need to check this condition
							this.metricValue3 = metricsData[i].value;
							this.metricValueType3 = 'decimal';
						} else {
							this.metricValue3 = metricsData[i].value;
						}
					}
					
					if (this.reportAPIName4 === metricsData[i].reportName && this.fieldName4 === metricsData[i].fieldName) {
						this.metricValueType4 = metricsData[i].dataType.toLowerCase();
						if (metricsData[i].dataType.toLowerCase() === 'percent') {
							this.metricValue4 = metricsData[i].value / 100;
						} else if (metricsData[i].dataType.toLowerCase() === 'int') {//Need to check this condition
							this.metricValue4 = metricsData[i].value;
							this.metricValueType4 = 'decimal';
						} else {
							this.metricValue4 = metricsData[i].value;
						}
					}
				}
				this.error = null;
			})
			.catch(error => {
				this.error = error;
			})
	}
}