/***********************************************************************
* Author: Techila Global Services Pvt Ltd.
* Trigger Name: ContractTrigger
* Created Date: 11-July-2017
* Description: To restrict user to edit or delete the accepted Contract    
************************************************************************/
trigger ContractTrigger on Contract__c (before update,before delete, after update) {
    //Check if Current User is System Administrator or not
    Profile sys_adm_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    Profile site_guest_user_profile = [SELECT Id FROM Profile WHERE Name = 'SignContractPage Profile'];
    
    Profile site_guest_user_profile2 = [SELECT Id FROM Profile WHERE Name = 'C2CSignContractEmail Profile'];
    User currentUser = [SELECT Id,ProfileId FROM User WHERE Id=: UserInfo.getUserId()];
    Set <Id> acceptedContractSet = new Set <Id>();
    Set<Id> setOfContract=new Set<Id>();
    List<Opportunity> lstOfOpptoUpdate=new List<Opportunity>();
    Contract__c oldContract;
    //Trigger will not throw error if current user is System Administrator
    if(currentUser.ProfileId != sys_adm_profile.id && currentUser.ProfileId != site_guest_user_profile.Id &&  currentUser.ProfileId != site_guest_user_profile2.Id){
        if(Trigger.isBefore){
            if(Trigger.isUpdate){
                for(Contract__c objContract : Trigger.New){
                    if(objContract.Accepted_Time__c!=null) 
                        objContract.addError('Contract cannot be updated since it is accepted.');
                }
            }
            if(Trigger.isDelete){
                for(Contract__c objContract : Trigger.old){
                    if(objContract.Accepted_Time__c!=null)   
                        objContract.addError('Contract cannot be deleted since it is accepted.');
                }
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        system.debug('Inside After Update');
        for(Contract__c objContract : Trigger.New){
            oldContract= System.Trigger.oldMap.get(objContract.Id);
            if(objContract.Status__c == 'Accepted' && objContract.Status__c!=oldContract.Status__c){
                acceptedContractSet.add(objContract.Id);
            }
            //added by rishabh for Ftl contract approved action
            if(objContract.FTL_Status__c=='Accepted' && objContract.FTL_Status__c!=oldContract.FTL_Status__c){
                setOfContract.add(objContract.Id);
            }
        }
        
        if(acceptedContractSet.size()>0){
            ContractTriggerHandler.sendEmailForAcceptedContract(acceptedContractSet);
        }
        //added by rishabh for Ftl contract approved action
        if(setOfContract.size()>0){
            List <Contract__c> lstContract=[select id,Opportunity__r.Id,Opportunity__r.Orion_Client_Id__c from Contract__c where Id IN :setOfContract];
            If(lstContract!=null){
                for(Contract__c objContract : lstContract){
                    if(objContract.Opportunity__r.Orion_Client_Id__c !=null && objContract.Opportunity__r.Orion_Client_Id__c!=''){
                        Opportunity objOpp= new Opportunity(Id = objContract.Opportunity__r.Id);
                        objOpp.StageName='Live (Outbound)';
                        objOpp.Orion_Status__c='Active';
                        objOpp.Is_cont_not_available_for_FTL__c=false;
                        lstOfOpptoUpdate.add(objOpp);
                    }else{
                        Opportunity objOpp= new Opportunity(Id = objContract.Opportunity__r.Id);
                        //objOpp.Orion_Status__c='Active';
                        objOpp.Is_cont_not_available_for_FTL__c=false;
                        lstOfOpptoUpdate.add(objOpp);
                    }
                }
            }

        }
        if(lstOfOpptoUpdate.size()>0){
            Update lstOfOpptoUpdate;
        }
        
        
        
        //Sazid's Changes
        
        trigger_stopper__c trstpr = trigger_stopper__c.getInstance('ContractTrigger');
        Boolean AfterUpdate = trstpr.Trigger_After__c;
        if(AfterUpdate)
        {
            for(Contract__c objContract : Trigger.New){
                oldContract= System.Trigger.oldMap.get(objContract.Id);
                if(objContract.Status__c == 'Accepted' && objContract.Status__c!=oldContract.Status__c){
                    acceptedContractSet.add(objContract.Id);
                }
            }
            if(!Test.isRunningTest())
            {
                if(acceptedContractSet.size()>0){
                    ContractTriggerHandler.sendEmailForAcceptedContract(acceptedContractSet);
                }
            }
            else{
                System.debug('Test only');
            }
        }
    }
    
}