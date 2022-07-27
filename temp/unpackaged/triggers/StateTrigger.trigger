/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Trigger Name: StateTrigger
* Created Date: 04-June-2018
* Description: State Trigger
*******************************************************************/
trigger StateTrigger on State__c (after insert, after update) {
    
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        Map <Id, State__c> stateAccountMap = new Map<Id, State__c>();
        List <Account> accountList = new List <Account>();
        List <Account> accUpdateList = new List <Account>();
        Set <Id> idSet = new Set <Id>();
        idSet = trigger.newMap.keySet();
        
        List<State__c> listStateOnboarding = new List<State__c>();
        DescribeSObjectResult describeResultState = State__c.getSObjectType().getDescribe();
        List<String> fieldNamesState = new List<String>(describeResultState.fields.getMap().keySet());
        system.debug('fieldNamesState****** '+fieldNamesState);
        String queryState = 'SELECT ' + String.join( fieldNamesState, ',' );
        queryState += ', Customer_Onboarding__r.Name, Customer_Onboarding__r.Account__c, Customer_Onboarding__r.Account__r.External_ID__c  ';
        queryState += ' FROM '+ describeResultState.getName() + ' WHERE Id IN: idSet';
        system.debug('queryState>>'+queryState);
        system.debug('OnboardingSendToHQ_Ctl.isHQUpdate>>'+ OnboardingSendToHQ_Ctl.isHQUpdate);
        try{
            listStateOnboarding = Database.query(queryState);
            if(!listStateOnboarding.isEmpty()){
                for(State__c st : listStateOnboarding){
                    stateAccountMap.put(st.Customer_Onboarding__r.Account__c, st);
                }
            }
            
            Set <Id> idAccountSet = new Set <Id>();
            idAccountSet = stateAccountMap.keySet();
        
            DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();
            List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
            system.debug('fieldNames****** '+fieldNames);
            String query = 'SELECT ' + String.join( fieldNames, ',' );
            query += ' FROM '+ describeResult.getName() + ' WHERE Id IN:idAccountSet '; 
            accountList = Database.query(query);
            
            for(Account accRecUpdate : accountList){
                if(OnboardingSendToHQ_Ctl.isHQUpdate){
                    accRecUpdate.State__c = stateAccountMap.get(accRecUpdate.Id).Id;
                    accRecUpdate.State_Name__c = stateAccountMap.get(accRecUpdate.Id).State__c;
                    accRecUpdate.GST_Number__c = stateAccountMap.get(accRecUpdate.Id).GST_Number__c;
                    accRecUpdate.HQ_State__c = stateAccountMap.get(accRecUpdate.Id).HQ_State__c;
                    accUpdateList.add(accRecUpdate);
                }
            }
            
            if(!accUpdateList.isEmpty()){
                update accUpdateList;
            }
        }catch (Exception e){
            system.debug('Error caught>'+e);
        }
    }
    
}