({
        fetchListOfRecordTypes: function(component, event, helper) {
            console.log('----e');
            var action = component.get("c.fetchRecordTypeValues");
            action.setCallback(this, function(response) {
                component.set("v.lstOfRecordType", response.getReturnValue());
            });
            $A.enqueueAction(action);
        },
        
        createRecord: function(component, event, helper) {
            
            var action = component.get("c.getRecTypeId");
            var recordTypeLabel = component.find("selectid").get("v.value");
            console.log('--'+component.find("selectid").get("v.value"));
            if(!recordTypeLabel){recordTypeLabel = 'B2B'}
            action.setParams({
                "recordTypeLabel": recordTypeLabel
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var createRecordEvent = $A.get("e.force:createRecord");
                    console.log('Value of RecordTypeLabel is '+recordTypeLabel);
                    var RecTypeID  = response.getReturnValue();
                    if(recordTypeLabel=='C2C'){
                        console.log('Value of Client Category is '+component.get("v.simpleRecord").Client_Category__c);
                    createRecordEvent.setParams({
                        "entityApiName": 'Opportunity',
                        "recordTypeId": RecTypeID,
                          'defaultFieldValues': {                              
                              'AccountId' : component.get("v.recordId"),
                              'CurrencyIsoCode' : 'INR',
                              'Company__c' : component.get("v.simpleRecord").Registered_Name__c,
                              'Email__c': component.get("v.simpleRecord").Email__c,
                              'LeadSource': 'Self',
                              'Name' : component.get("v.simpleRecord").Name,
                              'Operating_Account__c' : component.get("v.recordId"),
                              'Phone__c' : component.get("v.simpleRecord").Phone__c,
                              'Primary_Service__c' : component.find("selectid").get("v.value"),
                              'Rating__c' : component.get("v.simpleRecord").Rating,
                              'Registered_Name__c' : component.get("v.simpleRecord").Registered_Name__c ,
                              'Status__c' : 'Draft',
                              'StageName' : 'Proposal Shared',
                              'Type' : 'New Business',
                              'Website__c' : component.get("v.simpleRecord").Website,
                               'Client_Category__c' : component.get("v.simpleRecord").Client_Category__c                              
                          }
                    });
                    }
                    else if(recordTypeLabel!='C2C')
                    {
                     	           createRecordEvent.setParams({
                        "entityApiName": 'Opportunity',
                        "recordTypeId": RecTypeID,
                          'defaultFieldValues': {                              
                              'AccountId' : component.get("v.recordId"),
                              'CurrencyIsoCode' : 'INR',
                              'Company__c' : component.get("v.simpleRecord").Registered_Name__c,
                              'Email__c': component.get("v.simpleRecord").Email__c,
                              'LeadSource': 'Self',
                              'Name' : component.get("v.simpleRecord").Name,
                              'Operating_Account__c' : component.get("v.recordId"),
                              'Phone__c' : component.get("v.simpleRecord").Phone__c,
                              'Primary_Service__c' : component.find("selectid").get("v.value"),
                              'Rating__c' : component.get("v.simpleRecord").Rating,
                              'Registered_Name__c' : component.get("v.simpleRecord").Registered_Name__c ,
                              'Status__c' : 'Draft',
                              'StageName' : 'Proposal Shared',
                              'Type' : 'New Business',
                              'Website__c' : component.get("v.simpleRecord").Website
                             
                          }
                    });   
                    }
                    createRecordEvent.fire();
                    
                } else if (state == "INCOMPLETE") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Oops!",
                        "message": "No Internet Connection"
                    });
                    toastEvent.fire();
                    
                } else if (state == "ERROR") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please contact your administrator"
                    });
                    toastEvent.fire();
                }
            });
            $A.enqueueAction(action);
        }
        
    })