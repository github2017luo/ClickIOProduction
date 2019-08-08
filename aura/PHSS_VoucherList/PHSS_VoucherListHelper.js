({
	getVouchers : function(component, event, helper) {
		var action = component.get("c.getVoucherList");
    
        action.setParams({ recId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.vouchList",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
	},
})