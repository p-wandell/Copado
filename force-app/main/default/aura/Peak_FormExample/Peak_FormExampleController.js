({
    submitForm: function (component,event,helper) {
        // If valid, submit
        var requiredFields = ['SayHello'];
        var isValid = helper.validateForm(component,null,requiredFields);
        if (isValid){
            helper.submitForm(component);
        }
    },
    submitForm2: function (component,event,helper) {
        // If valid, submit
        var requiredFields =  ['SayHello2'];
        var isValid = helper.validateForm(component,null,requiredFields);
        if (isValid){
            helper.showMessage('Success','Great Job!');
        } else {
            helper.showMessage('Error','Try Again');
        }
    }
})