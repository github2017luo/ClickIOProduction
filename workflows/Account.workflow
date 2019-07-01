<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Increment_Num_Of_Times_Terminated_to_1</fullName>
        <field>Number_of_Times_Terminated__c</field>
        <literalValue>1</literalValue>
        <name>Increment Num Of Times Terminated to 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>NextValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inv_Del_Assign_Date_field_update</fullName>
        <description>Inv Del Assign Date field update to today when Invoice delivery method is set.</description>
        <field>Inv_Del_Assign_Date__c</field>
        <formula>TODAY()</formula>
        <name>Inv Del Assign Date field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MALatitude_c_Purge</fullName>
        <field>MALatitude__c</field>
        <name>Account.MALatitude_c_Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MALongitude_c_Purge</fullName>
        <field>MALongitude__c</field>
        <name>Account.MALongitude_c_Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PO</fullName>
        <description>When Payment Status Terminated, PO should be blank</description>
        <field>Red_Cross_PO__c</field>
        <name>PO #</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Status_EXPIRED</fullName>
        <field>Payment_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>Payment Status EXPIRED</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prefered_Payment_Type</fullName>
        <description>Prefered Payment type = null if Payment Status &quot;Terminated&quot;</description>
        <field>Preferred_Payment_type__c</field>
        <name>Prefered Payment Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Red_Cross_PO_Expiration_Date</fullName>
        <field>Red_Cross_PO_expiration_Date__c</field>
        <name>Red Cross PO# Expiration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Owner_to_House_Account</fullName>
        <field>OwnerId</field>
        <lookupValue>rcspo@redcross.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Account Owner to House Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Coverage_Field_to_NONE_Value</fullName>
        <field>Agreement_Covers__c</field>
        <name>Update Coverage Field to NONE Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shipping_City</fullName>
        <field>ShippingCity</field>
        <formula>BillingCity</formula>
        <name>Update Shipping City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shipping_Country</fullName>
        <description>update shipping country from Billing</description>
        <field>ShippingCountry</field>
        <formula>BillingCountry</formula>
        <name>Update Shipping Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shipping_State</fullName>
        <description>copy from Billing state</description>
        <field>ShippingState</field>
        <formula>BillingState</formula>
        <name>Update Shipping State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shipping_Street</fullName>
        <description>After Copy Billing to Shipping checkbox Shipping address updates</description>
        <field>ShippingStreet</field>
        <formula>BillingStreet</formula>
        <name>Update Shipping Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shipping_Zip</fullName>
        <field>ShippingPostalCode</field>
        <formula>BillingPostalCode</formula>
        <name>Update Shipping Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Billing to Shipping Address</fullName>
        <actions>
            <name>Update_Shipping_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Shipping_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Shipping_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Shipping_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Shipping_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Copy_Billing_to_Shipping__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Payment Status EXPIRED</fullName>
        <actions>
            <name>Payment_Status_EXPIRED</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When date in the Red Cross PO# Expiration Date field passed, this would be automatically invoked at midnight on the Date of Expiration. It would also trigger and email to the account owner since action would be needed.</description>
        <formula>IF( Red_Cross_PO_expiration_Date__c &lt; Today(), True, False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Payment Status Terminated</fullName>
        <actions>
            <name>Prefered_Payment_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Red_Cross_PO_Expiration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When Payment status=Terminated, Preferred payment type and PO# should be null.</description>
        <formula>AND( ISPICKVAL( Payment_Status__c , &quot;Terminated&quot;),  $Setup.Workflow_Rules__c.Bypass_Rules__c = False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Payment Status Terminated Increment</fullName>
        <actions>
            <name>Increment_Num_Of_Times_Terminated_to_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Payment_Status__c</field>
            <operation>equals</operation>
            <value>Terminated</value>
        </criteriaItems>
        <description>If Payment Status Terminated, then Payment Status Terminated field Checked</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Account owner to House Owner for RCS Channels</fullName>
        <actions>
            <name>Update_Account_Owner_to_House_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.PHSS_Channel__c</field>
            <operation>equals</operation>
            <value>RCS Retail</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.PHSS_Channel__c</field>
            <operation>equals</operation>
            <value>RCS Distributor</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Coverage field to None for RCS PO Accounts</fullName>
        <actions>
            <name>Update_Coverage_Field_to_NONE_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>INCLUDES(PHSS_Channel__c, &quot;RCS Retail&quot;) || INCLUDES(PHSS_Channel__c, &quot;RCS Distributor&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Invoice delivery date for RCSPO Account</fullName>
        <actions>
            <name>Inv_Del_Assign_Date_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  OR(  INCLUDES(PHSS_Channel__c, &quot;RCS Retail&quot;),  INCLUDES(PHSS_Channel__c, &quot;RCS Distributor&quot;)),  !ISBLANK(TEXT(Invoice_Delivery_Type__c)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>a0Rd00000006eWgEAI_Purge</fullName>
        <actions>
            <name>MALatitude_c_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitude_c_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Account.a0Rd00000006eWgEAI_Purge</description>
        <formula>OR(ISCHANGED(BillingStreet),ISCHANGED(BillingCity),ISCHANGED(BillingState),ISCHANGED(BillingPostalCode),ISCHANGED(BillingCountry))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
