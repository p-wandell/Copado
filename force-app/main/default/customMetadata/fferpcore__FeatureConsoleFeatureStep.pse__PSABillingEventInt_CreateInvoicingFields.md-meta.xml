<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Create Invoicing Fields on Billing Event</label>
    <protected>false</protected>
    <values>
        <field>fferpcore__Configuration__c</field>
        <value xsi:type="xsd:string">{
               &quot;pse__Billing_Event__c.Billing_Document__c&quot;: {
					&quot;Custom Field Operation&quot;: {
						&quot;enable&quot;: &quot;Add&quot;
					},
					&quot;Custom Field Type&quot;: &quot;Text&quot;,
					&quot;Custom Field Label&quot;: &quot;Billing Document&quot;,
					&quot;Custom Field Description&quot;: &quot;Billing document that is used to invoice the billing event.&quot;,
					&quot;Custom Field Inline Help Text&quot;: &quot;Billing document that is used to invoice the billing event.&quot;,
					&quot;Custom Field Formula&quot;: &quot;HYPERLINK(&apos;/&apos;+IF( NOT( ISBLANK( msg_Link_PSA_Id__r.ffbc__ConsolidatedBillingDocument__c ) ), msg_Link_PSA_Id__r.ffbc__ConsolidatedBillingDocument__c , msg_Link_PSA_Id__c), IF( NOT( ISBLANK( msg_Link_PSA_Id__r.ffbc__ConsolidatedBillingDocument__c ) ), msg_Link_PSA_Id__r.ffbc__ConsolidatedBillingDocument__r.Name , msg_Link_PSA_Id__r.Name), &apos;_self&apos;)&quot;
				},
				&quot;pse__Billing_Event__c.Billing_Document_Status__c&quot;: {
					&quot;Custom Field Operation&quot;: {
						&quot;enable&quot;: &quot;Add&quot;
					},
					&quot;Custom Field Type&quot;: &quot;Text&quot;,
					&quot;Custom Field Label&quot;: &quot;Billing Document Status&quot;,
					&quot;Custom Field Description&quot;: &quot;Status of the billing document used for invoicing.&quot;,
					&quot;Custom Field Inline Help Text&quot;: &quot;Status of the billing document used for invoicing.&quot;,
					&quot;Custom Field Formula&quot;: &quot;IF( NOT( ISBLANK( msg_Link_PSA_Id__r.ffbc__ConsolidatedBillingDocument__c ) ) , TEXT(msg_Link_PSA_Id__r.ffbc__ConsolidatedBillingDocument__r.fferpcore__DocumentStatus__c) , TEXT(msg_Link_PSA_Id__r.fferpcore__DocumentStatus__c))&quot;
				}
            }</value>
    </values>
    <values>
        <field>fferpcore__DisableRevertAction__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>fferpcore__Feature__c</field>
        <value xsi:type="xsd:string">pse__PSABillingEventInt</value>
    </values>
    <values>
        <field>fferpcore__IsOptional__c</field>
        <value xsi:type="xsd:string">Required</value>
    </values>
    <values>
        <field>fferpcore__StepDescription__c</field>
        <value xsi:type="xsd:string">pse__PsaBillingEvent_featureStep_createInvoicingFields_description</value>
    </values>
    <values>
        <field>fferpcore__StepNumber__c</field>
        <value xsi:type="xsd:double">3.0</value>
    </values>
    <values>
        <field>fferpcore__StepType__c</field>
        <value xsi:type="xsd:string">Custom Field</value>
    </values>
</CustomMetadata>
