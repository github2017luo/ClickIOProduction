trigger skedLocationTrigger on sked__Location__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            skedLocationHandler.afterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
            skedLocationHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}