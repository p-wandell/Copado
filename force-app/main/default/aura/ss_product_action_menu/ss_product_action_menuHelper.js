/*
 * Copyright (c) 2018. 7Summits Inc.
 */

/**
 * Created by francoiskorb on 9/18/18.
 */
({
	startFlow: function (component, flowName, product, recordId) {
		let flow = component.find('actionFlow');

		let input = [
			{
				name:   'recordId',
				type:   'String',
				value:  recordId
			},
			{
				name:   'productId',
				type:   'String',
				value:  product.productId
			},
			{
				name:   'quantity',
				type:   'Number',
				value:  1
			},
			{
				name:   'unitPrice',
				type:   'Number',
				value:  product.unitPrice
			},
			{
				name:   'pricebookEntryId',
				type:   'String',
				value:  product.id
			},
			{
				name:   'pricebookId',
				type:   'String',
				value:  component.get('v.pricebookId')
			}
		];

		console.log('Calling flow: ' + flowName + ' with productId:  ' + product.productId + ', recordId: ' + recordId);
		flow.startFlow(flowName, input);
	},
});