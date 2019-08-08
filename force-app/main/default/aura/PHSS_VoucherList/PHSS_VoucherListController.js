({
	doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        if($A.util.isEmpty(recordId)){
            var recordIdpattern = new RegExp("[?&]recordId=(([^&]*)&?|&|$)");
            var urlRecordId = recordIdpattern.exec(location.href);
            if (urlRecordId != null && urlRecordId.length > 2 && urlRecordId[2] != null && urlRecordId[2].length > 2) {
                recordId = urlRecordId[2];
                component.set("v.recordId",recordId);
            }
        }
        helper.getVouchers(component, event, helper); 
    },
            
    // handle action
    handleAction: function(component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        component.set("v.voucherId",id_str);    
        component.set("v.showModal",true);        
    },
        
    refreshVoucherList : function(component, event, helper) {
        component.set("v.showModal",false);    
    	helper.getVouchers(component, event, helper);        
    },
            
    closeModal : function(component, event, helper) {
 		component.set("v.showModal",false);    
    } 
})