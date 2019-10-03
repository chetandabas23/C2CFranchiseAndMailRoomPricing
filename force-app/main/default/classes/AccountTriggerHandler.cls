/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: AccountTriggerHandler
* Created Date: 21-march-2018
* Description: Handler class for AccountTrigger
*******************************************************************/
public class AccountTriggerHandler{
    
    public static boolean isAccountUpdate = false;
    
    /*SF - 107 Starts
           Copy Account's data to associated COB
    
    public static void copyCOBData( Map <Id, List <Customer_Onboarding__c>> mapAccountCOB){
        
        system.debug('mapAccountCOB >>'+mapAccountCOB);
        Set <Id> cobIdSet = new Set <Id>();
        Map <Id, Account> mapAccountData = new Map <Id, Account>();
        for(Id key : mapAccountCOB.keySet()){
            if(mapAccountCOB.containsKey(key)){
                for(Customer_Onboarding__c cobRec : mapAccountCOB.get(key)){
                    cobIdSet.add(cobRec.Id);
                }
            }
        }
        
        
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        DescribeSObjectResult describeResultCOB = Customer_Onboarding__c.getSObjectType().getDescribe();
        List<String> fieldNamesCOB = new List<String>(describeResultCOB.fields.getMap().keySet());
        system.debug('fieldNamesCOB****** '+fieldNamesCOB);
        String queryCOB = 'SELECT ' + String.join( fieldNamesCOB, ',' );
        queryCOB += ', Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Email__c,Account__r.Phone__c,Account__r.Name,Opportunity__r.StageName, Opportunity__r.AccountId ';
        queryCOB += ' FROM '+ describeResultCOB.getName() + ' WHERE Id IN: cobIdSet'; 
        
        List<Account> listAccount = new List<Account>();
        List<Customer_Onboarding__c> cobRecUpdateList = new List<Customer_Onboarding__c>();
        SET<ID> keys = mapAccountCOB.keySet();
        
        DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        system.debug('fieldNames****** '+fieldNames);
        String queryAccount = 'SELECT ' + String.join( fieldNames, ',' );
        queryAccount += ', RecordType.Name FROM '+ describeResult.getName() + ' WHERE Id IN: keys'; 
        
        system.debug('queryCOB >>'+queryCOB);
        system.debug('queryAccount >>'+queryAccount);
        
        try{
            listOnboarding = Database.query(queryCOB);
            listAccount = Database.query(queryAccount);
            
            system.debug('listOnboarding >>'+listOnboarding);
            system.debug('listAccount >>'+listAccount);
            
            if(!listAccount.isEmpty()){
                for(Account acc : listAccount){
                    mapAccountData.put(acc.Id, acc);
                }
            }
            
            system.debug('isAccountUpdate in AccountTriggerHandler >>'+isAccountUpdate);
            if(!listAccount.isEmpty() && !listOnboarding.isEmpty()){
                for(Customer_Onboarding__c cobRecUpdate : listOnboarding){
                    if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).RecordType.Name == 'Service Account'){
                        system.debug('mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId) >>'+mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId));
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).NDR_report_recipients__c!=null){
                            cobRecUpdate.NDR_report_recipients__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).NDR_report_recipients__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Report_Recipients__c!=null){
                            cobRecUpdate.Report_Recipients__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Report_Recipients__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).RTO_email_recipients__c!=null){
                            cobRecUpdate.RTO_email_recipients__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).RTO_email_recipients__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).DTO_email_recipients__c!=null){
                            cobRecUpdate.DTO_email_recipients__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).DTO_email_recipients__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).REM_email__c!=null){
                            cobRecUpdate.REM_email__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).REM_email__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Upload_Recipients__c!=null){
                            cobRecUpdate.Upload_Recipients__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Upload_Recipients__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).VAT_Number__c!=null){
                            cobRecUpdate.VAT_Number__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).VAT_Number__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).CST_Number__c!=null){
                            cobRecUpdate.CST_Number__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).CST_Number__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Eco_Code__c!=null){
                            cobRecUpdate.Eco_Code__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Eco_Code__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Return_Address__c!=null){
                            cobRecUpdate.Return_Address__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Return_Address__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Line_1__c!=null){
                            cobRecUpdate.Registered_Address_Line_1__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Line_1__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Line_2__c!=null){
                            cobRecUpdate.Registered_Address_Line_2__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Line_2__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_City__c!=null){
                            cobRecUpdate.Registered_Address_City__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_City__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_State__c!=null){
                            cobRecUpdate.Registered_Address_State__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_State__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Postal_Code__c!=null){
                            cobRecUpdate.Registered_Address_Postal_Code__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Postal_Code__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Country__c!=null){
                            cobRecUpdate.Registered_Address_Country__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Registered_Address_Country__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Push_url__c!=null){
                            cobRecUpdate.Push_url__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Push_url__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Product_Type__c!=null){
                            cobRecUpdate.Product_Type__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Product_Type__c;
                        }
                        
                        //cobRecUpdate.Is_Prepaid__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Is_Prepaid__c;
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Wallet_Notification_Mobile__c!=null){
                            cobRecUpdate.Wallet_Notification_Mobile__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Wallet_Notification_Mobile__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Wallet_Notification_Email__c!=null){
                            cobRecUpdate.Wallet_Notification_Email__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Wallet_Notification_Email__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Wallet_Provider__c!=null){
                            cobRecUpdate.Wallet_Provider__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Wallet_Provider__c;
                        }
                        
                        
                        //cobRecUpdate.MPS_Service__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).MPS_Service__c;
                        //cobRecUpdate.Send_mail_Pickup__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Send_mail_Pickup__c;
                        //cobRecUpdate.Send_SMS_Prepaid__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Send_SMS_Prepaid__c;
                        //cobRecUpdate.send_sms_cash__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).send_sms_cash__c;
                        //cobRecUpdate.Send_SMS_COD__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Send_SMS_COD__c;
                        //cobRecUpdate.Send_SMS_Reverse__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Send_SMS_Reverse__c;
                        //cobRecUpdate.Send_SMS_NDR__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Send_SMS_NDR__c;
                        //cobRecUpdate.auto_pickup__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).auto_pickup__c;
                        //cobRecUpdate.allow_no_data__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).allow_no_data__c;
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Billing_Mode__c!=null){
                            cobRecUpdate.Billing_Mode__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Billing_Mode__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Postal_Cat__c!=null){
                            cobRecUpdate.Postal_Cat1__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Postal_Cat__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).X_Ray_Limit__c!=null){
                            cobRecUpdate.X_Ray_Limit__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).X_Ray_Limit__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Contact_number__c!=null){
                            cobRecUpdate.Contact_number__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Contact_number__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Billing_Client_Config__c!=null){
                            cobRecUpdate.Billing_Client_Config__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Billing_Client_Config__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Movement_Config__c!=null){
                            cobRecUpdate.Movement_Config__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Movement_Config__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Client_User_Id__c!=null){
                            cobRecUpdate.Client_User_Id__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Client_User_Id__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Client_Id__c!=null){
                            cobRecUpdate.Client_Id__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Client_Id__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Company_Registered_Name__c!=null){
                            cobRecUpdate.Company_Registered_Name__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Company_Registered_Name__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Bank_A_c_Number__c!=null){
                            cobRecUpdate.Bank_A_c_Number__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Bank_A_c_Number__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Bank_name__c!=null){
                            cobRecUpdate.Bank_name__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Bank_name__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Beneficiary_name__c!=null){
                            cobRecUpdate.Beneficiary_name__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Beneficiary_name__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).PAN_card__c!=null){
                            cobRecUpdate.PAN_card__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).PAN_card__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).RTGS_IFSC_code__c!=null){
                            cobRecUpdate.RTGS_IFSC_code__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).RTGS_IFSC_code__c;
                        }
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Product_category__c!=null){
                            cobRecUpdate.Product_category__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Product_category__c;
                        }
                        
                        // if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).GST_not_registered__c!=false){
                        //    cobRecUpdate.GST_not_registered__c= mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).GST_not_registered__c;
                        //} 
                        
                        if(mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Services__c!=null){
                            cobRecUpdate.Services__c = mapAccountData.get(cobRecUpdate.Opportunity__r.AccountId).Services__c;
                        }
                        
                        
                        cobRecUpdateList.add(cobRecUpdate);
                    }
                    
                    system.debug('cobRecUpdateList >>'+cobRecUpdateList);
                }
                
                if(isAccountUpdate && !cobRecUpdateList.isEmpty()){
                    update cobRecUpdateList;
                }
                
            }
        }catch(Exception e){
            system.debug('Error caught >>'+e);
        }
    }*/
    
    /*SF-170 Start: If Category and Subcategory changed at account level, it should get automatically changed in all corresponding opportunities*/
    public static void updateOpportunityData(Map <Id, Account> accRecordMap){
        system.debug('accRecordMap >>'+accRecordMap);
        List <Opportunity> opportunityServiceAccList = new List <Opportunity>();
        List <Opportunity> opportunityOperatingAccList = new List <Opportunity>();
        List <Opportunity> oppServiceList = new List <Opportunity>();
        List <Opportunity> oppOperaingList = new List <Opportunity>();
        
        opportunityServiceAccList = [SELECT Id, Client_Category__c, Sub_Category__c, AccountId FROM Opportunity WHERE AccountId=:accRecordMap.keySet()];
        opportunityOperatingAccList = [SELECT Id, Client_Category__c, Sub_Category__c, Operating_Account__c FROM Opportunity WHERE Operating_Account__c=:accRecordMap.keySet()];
        
        if(!opportunityServiceAccList.isEmpty()){
            for(Opportunity oppService : opportunityServiceAccList){
                oppService.Client_Category__c = accRecordMap.get(oppService.AccountId).Client_Category__c;
                oppService.Sub_Category__c = accRecordMap.get(oppService.AccountId).Sub_Category__c;
                oppServiceList.add(oppService);
            }
        }
        
        if(!opportunityOperatingAccList.isEmpty()){
            for(Opportunity oppOpearting : opportunityOperatingAccList){
                oppOpearting.Client_Category__c = accRecordMap.get(oppOpearting.Operating_Account__c).Client_Category__c;
                oppOpearting.Sub_Category__c = accRecordMap.get(oppOpearting.Operating_Account__c).Sub_Category__c;
                oppOperaingList.add(oppOpearting);
            }
        }
        
        if(!oppServiceList.isEmpty()){
            update oppServiceList;
        }
        if(!oppOperaingList.isEmpty()){
            update oppOperaingList;
        }
    }
    /*SF-170 Ends*/
}