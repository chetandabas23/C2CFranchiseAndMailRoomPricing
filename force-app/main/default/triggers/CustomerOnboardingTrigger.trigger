/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Trigger Name: CustomerOnboardingTrigger
* Created Date: 18-May-2017
* Description: Trigger for populating recieve date on opportunity from related customer onboarding
*******************************************************************/

trigger CustomerOnboardingTrigger on Customer_Onboarding__c(after insert,before insert, before update, after update, before delete) {
    //SF-265 Custom setting to turn off or on the trigger.
    COB_Trigger_Stopper__c trigger_CustomSetting = COB_Trigger_Stopper__c.getInstance('ALL_TRIGGER');
    if(trigger_CustomSetting != null && trigger_CustomSetting.Active__c == true)
    {
        system.debug('--inside cob Trigger--');
        Set <Id> cobRecIdSet = new Set <Id>();
        try{
            Set<Id> opportunityIdSet = new Set<Id>();
            List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
            //Get Opportunity associated with Onboarding
            if(!Trigger.isDelete){
                System.debug('Customer Onboarding ->' + Trigger.New);
                for(Customer_Onboarding__c objCustomerOnboarding : Trigger.New){
                    if(objCustomerOnboarding.Opportunity__c != null){
                        opportunityIdSet.add(objCustomerOnboarding.Opportunity__c);
                    }
                }
                for(Opportunity objOpportunity : [SELECT Id, OnBoarding_Form_Receive_Date__c, Account.ParentId, Onboarding_form_submitted__c, Email__c, Phone__c, Invoicing_Mode__c, RecordTypeId, RecordType.Name FROM Opportunity WHERE Id IN : opportunityIdSet]){
                    opportunityMap.put(objOpportunity.Id, objOpportunity);
                }
            } 
            system.debug('IN:opportunityIdSet >>'+opportunityIdSet );
            Customer_Onboarding__c objBoarding = new Customer_Onboarding__c();
            objBoarding = [SELECT Id,Opportunity__c, Opportunity__r.AccountId, IsDraft__c, Is_Prepaid__c, Opportunity__r.Invoicing_Mode__c, Opportunity__r.Email__c, Opportunity__r.Phone__c, Wallet_Notification_Email__c, Wallet_Notification_Mobile__c, Invoicing_Mode__c, Wallet_Provider__c  FROM Customer_Onboarding__c WHERE Opportunity__c IN:opportunityIdSet LIMIT 1];
            
            if(objBoarding.IsDraft__c == false){
                if(Trigger.isAfter){
                    for(Customer_Onboarding__c objCustomerOnboarding : Trigger.New){
                        if(objCustomerOnboarding.Opportunity__c != null && objCustomerOnboarding.OnBoarding_Form_Receive_Date__c != null){
                            opportunityMap.get(objCustomerOnboarding.Opportunity__c).OnBoarding_Form_Receive_Date__c = objCustomerOnboarding.OnBoarding_Form_Receive_Date__c;
                            opportunityMap.get(objCustomerOnboarding.Opportunity__c).Onboarding_form_submitted__c = true;
                        }
                    }
                    if(opportunityMap.size()>0 && !FreshbookTokenBasedAuth_Cntrl.isFRSGeneration){
                        update opportunityMap.values();
                    }
                    
                    /* Start: Send an Email to COB Account Owner, whenever a new COB record is submitted to Salesforce*/
                    if(Trigger.isInsert){
                        system.debug('In after insert');
                        for(Customer_Onboarding__c cobRec : Trigger.new){
                            if(cobRec.Operating_Account__c!=null && cobRec.Contact__c!=null){
                                cobRecIdSet.add(cobRec.Id);
                            }
                        }
                    }
                    system.debug('cobRecIdSet >>'+cobRecIdSet);
                    if(cobRecIdSet.size()>0){
                        CustomerOnboardingTriggerHandler.sendEmailToAccountOwner(cobRecIdSet);
                    }
                    /* Stop : Send an Email to COB Account Owner, whenever a new COB record is submitted to Salesforce*/
                    
                }   
                if(Trigger.isBefore){
                     // Update Operating Account on Onboarding    
                    if(Trigger.isInsert ){
                            for(Customer_Onboarding__c objCustomerOnboarding : Trigger.New){
                                if(objCustomerOnboarding.Opportunity__c != null){
                                    if(opportunityMap.size()>0){
                                        if(opportunityMap.get(objCustomerOnboarding.Opportunity__c).Account.ParentId !=null ){
                                            System.debug(' test operating account ->'+ opportunityMap.get(objCustomerOnboarding.Opportunity__c).Account.ParentId );
                                            objCustomerOnboarding.Operating_Account__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Account.ParentId ;    
                                        }
                                    }
                                }
                            }
                    }
                    
                   /* if(profileList.size() > 0 ){
                        if(profileList[0].Name!='System Administrator' && Trigger.isUpdate){
                           for(Customer_Onboarding__c objCustomerOnboarding : Trigger.New){
                                System.debug('objCustomerOnboarding.Operating_Account__c>>>>>'+objCustomerOnboarding.Operating_Account__c);
                                if(objCustomerOnboarding.Client_Id__c !=null){
                                    objCustomerOnboarding.addError('Onboarding cannot be updated.Please contact System Administrator ');
                                }
                            }
                        }
                    }*/
                            
                    
                    
                    System.debug('Customer Onboarding ->' + Trigger.old);
                    if(Trigger.isDelete){
                    //to restrict users to delete the submitted form
                        for(Customer_Onboarding__c objOnboarding : Trigger.old){                      
                                //objOnboarding.addError('Onboarding form cannot be delete once submitted.');
                        }
                    }
                } 
            }
            
            //Start SF - 104 : Mapping Updated COB's FRS value to Account
            if(Trigger.isAfter && Trigger.isUpdate){
                Map <Id, String> cobAccountMap = new Map <Id, String> ();
                for(Customer_Onboarding__c cobRec : Trigger.new){
                    String oldFRSValue = Trigger.oldMap.get(cobRec.Id).FRS_Code__c;
                    if(cobRec.FRS_Code__c != oldFRSValue ){
                        cobAccountMap.put(cobRec.Account__c, cobRec.FRS_Code__c);
                    }
                }
                if(cobAccountMap.size()>0){
                    CustomerOnboardingTriggerHandler.updateAccountFRS(cobAccountMap);
                }
                
            }
            
            //End SF - 104 : Mapping Updated COB's FRS value to Account
            
            
            /*Start: SF-107 Copy Data from Customer Onboarding over associated Service Account record*/
            Set <String> fieldSet = new Set <String>();
            Set <String> changedFieldSet ; 
            Map <Id, Customer_Onboarding__c> mapAccountCOB = new Map <Id, Customer_Onboarding__c>();
            List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
            DescribeSObjectResult describeResultCOB = Customer_Onboarding__c.getSObjectType().getDescribe();
            List<String> fieldNamesCOB = new List<String>(describeResultCOB.fields.getMap().keySet());
            Set <Id> keys = Trigger.newMap.keySet();
            String queryCOB = 'SELECT ' + String.join( fieldNamesCOB, ',' );
            
            queryCOB += ', Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Email__c,Account__r.Phone__c,Account__r.Name,Opportunity__r.StageName, Opportunity__r.AccountId ';
            queryCOB += ' FROM '+ describeResultCOB.getName() + ' WHERE Id IN: keys'; 
            
            
            if(Trigger.isAfter){
                if(Trigger.isUpdate){
                    listOnboarding = Database.query(queryCOB);
                    //dynamically get the fields from the field set and then use the same for comparison in the trigger. 
                    for(Schema.FieldSetMember fields :Schema.SObjectType.Customer_Onboarding__c.fieldSets.getMap().get('HQFieldSet').getFields()){
                        fieldSet.add(fields.getFieldPath());
                    }
                    
                    if(objBoarding.Opportunity__r.AccountId!=null){
                        for(Customer_Onboarding__c objCustomerOnboarding : listOnboarding){
                            changedFieldSet = new Set<String>();
                            for(string s: fieldSet){
                                system.debug('trigger.oldMap.get(objCustomerOnboarding.Id).get(s) >>'+trigger.oldMap.get(objCustomerOnboarding.Id).get(s));
                                system.debug('objCustomerOnboarding.get(s) >>'+objCustomerOnboarding.get(s));
                                if(objCustomerOnboarding.get(s) != trigger.oldMap.get(objCustomerOnboarding.Id).get(s)){
                                    changedFieldSet.add(s);//adding fields whose value changed
                                }
                            }
                                        
                            if(changedFieldSet.size()>0){
                                mapAccountCOB.put(objCustomerOnboarding.Opportunity__r.AccountId, objCustomerOnboarding);
                            }
                        }
                        system.debug('AccountTriggerHandler.isAccountUpdate in COB Trigger >> '+ AccountTriggerHandler.isAccountUpdate);
                        system.debug('mapAccountCOB >> '+ mapAccountCOB);
                        system.debug('changedFieldSet >>'+changedFieldSet);
                        if(mapAccountCOB!=null){
                            if(!AccountTriggerHandler.isAccountUpdate && !OnboardingSendToHQ_Ctl.isHQUpdate){
                                system.debug('Calling cob trigger handler');
                                CustomerOnboardingTriggerHandler.copyDataToServiceAccount(mapAccountCOB);
                            }
                        }
                    }
                    
                    
                }   
            }
            if(Trigger.isAfter){
                if(Trigger.isInsert){
                    listOnboarding = Database.query(queryCOB);
                    if(objBoarding.Opportunity__r.AccountId!=null){
                        for(Customer_Onboarding__c objCustomerOnboarding : listOnboarding){
                            mapAccountCOB.put(objCustomerOnboarding.Opportunity__r.AccountId, objCustomerOnboarding);
                        }
                        
                        system.debug('AccountTriggerHandler.isAccountUpdate in COB Trigger >> '+ AccountTriggerHandler.isAccountUpdate);
                        system.debug('mapAccountCOB >> '+ mapAccountCOB);
                        if(mapAccountCOB!=null){
                            if(!AccountTriggerHandler.isAccountUpdate && !OnboardingSendToHQ_Ctl.isHQUpdate){
                                system.debug('Calling cob trigger handler');
                                CustomerOnboardingTriggerHandler.copyDataToServiceAccount(mapAccountCOB);
                            }
                        }
                    }
                    
                    
                }
            }
            /*End: SF-107 Copy Data from Customer Onboarding over associated Service Account record*/
            
            
            //Start: Add Wallet fields to Onboarding record
            if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
                for(Customer_Onboarding__c objCustomerOnboarding : Trigger.New){
                    if(objCustomerOnboarding.Is_Prepaid__c == false){
                        objCustomerOnboarding.Invoicing_Mode__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Invoicing_Mode__c;
                        objCustomerOnboarding.Wallet_Notification_Email__c = null ;
                        objCustomerOnboarding.Wallet_Notification_Mobile__c = null;
                    }else if(objCustomerOnboarding.Is_Prepaid__c == true && objCustomerOnboarding.Wallet_Notification_Email__c == null && objCustomerOnboarding.Wallet_Notification_Mobile__c == null){
                        objCustomerOnboarding.Invoicing_Mode__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Invoicing_Mode__c;
                        objCustomerOnboarding.Wallet_Notification_Email__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Email__c;
                        objCustomerOnboarding.Wallet_Notification_Mobile__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Phone__c;
                        objCustomerOnboarding.Wallet_Provider__c = 'Delhivery miles';
                    }else if(objCustomerOnboarding.Is_Prepaid__c == true && objCustomerOnboarding.Wallet_Notification_Email__c != null && objCustomerOnboarding.Wallet_Notification_Mobile__c != null){
                        if(objCustomerOnboarding.Wallet_Notification_Mobile__c.length()!=10 || !objCustomerOnboarding.Wallet_Notification_Mobile__c.isNumeric()){
                            objCustomerOnboarding.addError('Wallet Notification Mobile should be a 10 digit number');
                        }
                        objCustomerOnboarding.Invoicing_Mode__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Invoicing_Mode__c;
                    }else if(objCustomerOnboarding.Is_Prepaid__c == true && objCustomerOnboarding.Wallet_Notification_Email__c == null && objCustomerOnboarding.Wallet_Notification_Mobile__c != null){
                        if(objCustomerOnboarding.Wallet_Notification_Mobile__c.length()!=10 || !objCustomerOnboarding.Wallet_Notification_Mobile__c.isNumeric()){
                            objCustomerOnboarding.addError('Wallet Notification Mobile should be a 10 digit number');
                        }
                        objCustomerOnboarding.Invoicing_Mode__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Invoicing_Mode__c;
                        objCustomerOnboarding.Wallet_Notification_Email__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Email__c;
                    }else if(objCustomerOnboarding.Is_Prepaid__c == true && objCustomerOnboarding.Wallet_Notification_Email__c != null && objCustomerOnboarding.Wallet_Notification_Mobile__c == null){
                        objCustomerOnboarding.Invoicing_Mode__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Invoicing_Mode__c;
                        objCustomerOnboarding.Wallet_Notification_Mobile__c = opportunityMap.get(objCustomerOnboarding.Opportunity__c).Phone__c;
                    }
                    
                    system.debug('objBoarding Invoicing_Mode__c >>'+ objCustomerOnboarding.Invoicing_Mode__c);
                    system.debug('objBoarding Wallet_Notification_Email__c >>'+ objCustomerOnboarding.Wallet_Notification_Email__c);
                    system.debug('objBoarding Wallet_Notification_Mobile__c >>'+ objCustomerOnboarding.Wallet_Notification_Mobile__c);
                }
            }
            
            //Stop: Add Wallet fields to Onboarding record
            
            
            /*Start: SF-231 Only Opportunity record owner is eligible to update Bank Details on COB record*/
            List <Customer_Onboarding__c> cobOpptyRecordOwner = new List <Customer_Onboarding__c>();
            Map <Id, Customer_Onboarding__c> bankDetailsUpdateMap = new Map <Id, Customer_Onboarding__c>();
            Map <Id, Id> mapCustomerOwnerMap = new Map <Id, Id>();
            
            if(Trigger.isBefore && Trigger.isUpdate){
                
                for(Customer_Onboarding__c objCustomerOnboarding : Trigger.New){
                    if(objCustomerOnboarding.Bank_A_c_Number__c!= Trigger.oldMap.get(objCustomerOnboarding.Id).Bank_A_c_Number__c || objCustomerOnboarding.Bank_name__c!= Trigger.oldMap.get(objCustomerOnboarding.Id).Bank_name__c || objCustomerOnboarding.Beneficiary_name__c!= Trigger.oldMap.get(objCustomerOnboarding.Id).Beneficiary_name__c || objCustomerOnboarding.PAN_card__c!= Trigger.oldMap.get(objCustomerOnboarding.Id).PAN_card__c || objCustomerOnboarding.RTGS_IFSC_code__c!= Trigger.oldMap.get(objCustomerOnboarding.Id).RTGS_IFSC_code__c){
                        system.debug('bankDetailsUpdateMap added');
                        bankDetailsUpdateMap.put(objCustomerOnboarding.Id, objCustomerOnboarding);
                    }
                }
                if(bankDetailsUpdateMap.size()>0){
                    system.debug('bankDetailsUpdateMap added');
                    cobOpptyRecordOwner = [SELECT ID, Opportunity__r.OwnerId, Status__c FROM Customer_Onboarding__c WHERE ID IN: bankDetailsUpdateMap.keySet()];
                    for(Customer_Onboarding__c cobRec: cobOpptyRecordOwner){
                        mapCustomerOwnerMap.put(cobRec.Id, cobRec.Opportunity__r.OwnerId);
                    }
                }
                String currentUserProfile = '';
                currentUserProfile = [SELECT Id, ProfileId, Profile.Name FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1].Profile.Name;
                system.debug('---currentUserProfile---'+currentUserProfile);
                if(mapCustomerOwnerMap.size()>0){
                    for(Customer_Onboarding__c objCustomerOnboardingOwner : Trigger.New){
                        if(mapCustomerOwnerMap.containsKey(objCustomerOnboardingOwner.Id)){
                            if(mapCustomerOwnerMap.get(objCustomerOnboardingOwner.Id) == UserInfo.getUserId() || currentUserProfile== 'Customer Onboarding Profile'|| currentUserProfile == 'System Administrator' ){ //  // SF-339 // By Nikhil T.
                                if((objCustomerOnboardingOwner.Status__c=='Synced To HQ' || objCustomerOnboardingOwner.Status__c=='Completed') && (currentUserProfile != 'Customer Onboarding Profile' && currentUserProfile != 'System Administrator')){ // SF-339 // By Nikhil T.
                                    objCustomerOnboardingOwner.addError('Details cannot be updated when status is Synced or Completed');
                                }
                            }else{
                                objCustomerOnboardingOwner.addError('Only Opportunity Owner should update the Bank details.');
                            }
                        }
                    }
                }
                
            }
            /*Stop: SF-231 Only Opportunity record owner is eligible to update Bank Details on COB record*/
            
            /*Start: SF-273 Prevent users from updating SMS Services for B2B Clients*/
            String userProfile = [SELECT Id, Name FROM Profile WHERE Id=:UserInfo.getProfileId() LIMIT 1].Name;
            
            if(Trigger.isBefore && Trigger.isUpdate){
                
                for(Customer_Onboarding__c cobRecord: Trigger.new){
                    Customer_Onboarding__c cobOldRecord = Trigger.oldMap.get(cobRecord.Id);
                    if((cobOldRecord.send_sms_cash__c!=cobRecord.send_sms_cash__c ||cobOldRecord.Send_SMS_COD__c!=cobRecord.Send_SMS_COD__c ||cobOldRecord.Send_SMS_NDR__c!=cobRecord.Send_SMS_NDR__c ||cobOldRecord.Send_SMS_Prepaid__c!=cobRecord.Send_SMS_Prepaid__c ||cobOldRecord.Send_SMS_Reverse__c  !=cobRecord.Send_SMS_Reverse__c) && cobOldRecord.Status__c!='Draft' && userProfile!='System Administrator' && opportunityMap.get(cobRecord.Opportunity__c).RecordType.Name == 'B2B'){
                        cobRecord.addError('SMS Services can only be edited by System Administrator for B2B Clients');
                    }
                }
            }
            /*Stop: SF-273 Prevent users from updating SMS Services for B2B Clients*/
            
        }catch(Exception e){
            System.debug('Error Message -> '+ e.getMessage() );
            System.debug('Line Number -> '+ e.getLineNumber() );
        }
        
       //********* SF-215 **************
       //Custom setting to turn off or on the trigger.
       COB_Trigger_Stopper__c trigger_CustomSetting = COB_Trigger_Stopper__c.getInstance('Generate_Desired_HQ');
       if(trigger_CustomSetting != null && trigger_CustomSetting.Active__c == true)
        {
            if(Trigger.isBefore && (Trigger.isInsert )) //|| Trigger.isUpdate
            {
                COB_TriggerHandler.insertHqNameMethod(Trigger.new);
            }
            if(Trigger.isBefore && (Trigger.isUpdate)) //|| Trigger.isUpdate
            {
                COB_TriggerHandler.updateHqNameMethod(Trigger.new,Trigger.oldMap);
            }
        }
       //******** End : SF-215 *************** 
         if(Trigger.isAfter && Trigger.isInsert)
           {
               for(Customer_Onboarding__c eachCOBID:Trigger.new)
               {
               clsPOCAssignment.PocAssignment(eachCOBID.id);   
               } 
               
           }
       
    }
}