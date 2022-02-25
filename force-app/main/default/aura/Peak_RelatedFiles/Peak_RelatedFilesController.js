/**
 * Created by kentheberling on 6/7/18.
 */
({
    initPeakRelatedFiles: function (component,event,helper) {
        helper.doCallout(component,"c.getFilesForCurrentUserForRecord",{"recordIdString":component.get("v.recordId")}).then(function(response){
            console.log(response);
            if(response.success){
                component.set("v.peakResponse",response)
            } else {
                helper.showMessage('Error',response.messages[0]);
            }
        }).catch(function(error){
            console.log("Failed with state: " + error);
            helper.showMessage('Error',error);
        });

        // Get site prefix too!
        helper.doCallout(component,"c.getSitePrefix",{}).then(function(response){
            component.set("v.sitePrefix",response.replace('/s','')); // servlet link needs the Community Suffix, but not /s/
        }).catch(function(error){
            console.log("Failed with state: " + error);
            helper.showMessage('Error',error);
        });
    }


})