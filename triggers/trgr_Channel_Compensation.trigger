trigger trgr_Channel_Compensation on Channel_Compensation__c (before insert, before update) {
	
	if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
		
		cls_Channel_Compensation.updateUniqueIdentifier(Trigger.new);
		cls_Channel_Compensation.uniqueRecordConstraint(Trigger.new);
		cls_Channel_Compensation.updateTerritoryCodeLookup(Trigger.new);
	
	}
	
}