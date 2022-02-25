<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PSA_Milestone_Approved_True</fullName>
        <field>pse__Approved__c</field>
        <literalValue>1</literalValue>
        <name>PSA Milestone Approved True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Milestone_Closed_For_Expense_True</fullName>
        <field>pse__Closed_for_Expense_Entry__c</field>
        <literalValue>1</literalValue>
        <name>PSA Milestone Closed For Expense True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Milestone_Closed_For_Time_Entry_True</fullName>
        <field>pse__Closed_for_Time_Entry__c</field>
        <literalValue>1</literalValue>
        <name>PSA Milestone Closed For Time Entry True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Milestone_IFF_True</fullName>
        <field>pse__Include_In_Financials__c</field>
        <literalValue>1</literalValue>
        <name>PSA Milestone IFF True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Milestone_Status_Open</fullName>
        <field>pse__Status__c</field>
        <literalValue>Open</literalValue>
        <name>PSA Milestone Status Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSA_Milestone_Status_Set_To_Approved</fullName>
        <field>pse__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>PSA Milestone Status Set To Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PSA Actual Date Approves And Closes Milestone</fullName>
        <actions>
            <name>PSA_Milestone_Approved_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSA_Milestone_Closed_For_Expense_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSA_Milestone_Closed_For_Time_Entry_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSA_Milestone_IFF_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSA_Milestone_Status_Set_To_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When Milestone Actual Date is entered, Milestone is Approved</description>
        <formula>Not(isblank(pse__Actual_Date__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSA Milestone Create Defaults</fullName>
        <actions>
            <name>PSA_Milestone_Status_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Defaults that trigger on Milestone Creation</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
