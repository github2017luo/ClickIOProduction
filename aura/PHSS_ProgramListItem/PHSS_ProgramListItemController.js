({
	goToProgram: function(component, event, helper) {
		$A.get("e.force:navigateToURL").setParams({
			url: '/phss_program/' + component.get('v.program.Id')
		}).fire();
	}
})