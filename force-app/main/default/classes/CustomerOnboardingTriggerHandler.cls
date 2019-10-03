/*****************************************************************
* Author: Techila
* Class Name: CustomerOnboardingTriggerHandler
* Updated Date: 2nd Jan 2018
* Description: Handler class for CustomerOnboardingTrigger
*****************************************************************/

public class CustomerOnboardingTriggerHandler{
    
    /*Start: Send Email Notification to COB Operating Owner on form submission*/
    public static void sendEmailToAccountOwner (Set <Id> cobRecIdSet){
        system.debug('cobRecIdSet >>'+ cobRecIdSet);
        List <Customer_Onboarding__c> cobRecList = new List <Customer_Onboarding__c>();
        cobRecList = [SELECT Id, Name, Operating_Account__c, Operating_Account__r.Owner.Email, Operating_Account__r.Owner.Name, Operating_Account__r.Name, Contact__c, Contact__r.Name, Opportunity__r.Operating_Account__r.Owner.Email, Opportunity__r.Operating_Account__r.Owner.Name FROM Customer_Onboarding__c WHERE Id IN: cobRecIdSet];
        String BaseUrl=  URL.getSalesforceBaseUrl().getHost();

        if(!cobRecList.isEmpty()){  
            for(Customer_Onboarding__c cobRecord : cobRecList){
                //Creating instance of email template for sending email
                Messaging.SingleEmailMessage mail_COB = new Messaging.SingleEmailMessage();
                String linkURL ='https://'+BaseUrl+'/'+cobRecord.Id;
                List < String > toAddresses = new List < String > {cobRecord.Opportunity__r.Operating_Account__r.Owner.Email};
                mail_COB.setToAddresses(toAddresses);
                mail_COB.setSubject('New Customer Onboarding added '+cobRecord.Name);
                mail_COB.saveAsActivity = false;
                
                //mail_COB.setHTMLBody ( 'Hello '+cobRecord.Opportunity__r.Operating_Account__r.Owner.Name+', <br/>'+'<br/>'+cobRecord.Contact__r.Name+' has submitted an '+ '<a href='+linkURL+'>onboarding form</a>' +'<br/>'+'<br/>'+'Thanks and regards,<br/>Delhivery');
                mail_COB.setHTMLBody ( 'Hello '+cobRecord.Opportunity__r.Operating_Account__r.Owner.Name+', <br/>'+'<br/>'+cobRecord.Contact__r.Name+' has submitted an onboarding form - ' +cobRecord.Name+'<br/>'+'<br/>'+'Thanks and regards,<br/>Delhivery');
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail_COB});
            }
        }
    }
    /*End: Send Email Notification to COB Operating Owner on form submission*/
    
    /*Start: SF - 107 Copy Data from Customer Onboarding over associated Service Account record*/
    public static void copyDataToServiceAccount (Map <Id, Customer_Onboarding__c> mapAccountCOB){
        Set <Id> keys = new Set <Id>();
        Id stateIdAccount;
        keys = mapAccountCOB.keySet();
        system.debug('mapAccountCOB COB >>'+mapAccountCOB.values());
        
        Set <Id> cobIdSet = new Set <Id>();
        for(Customer_Onboarding__c cobRec : mapAccountCOB.values()){
            cobIdSet.add(cobRec.Id);
        }
        
        List<Account> accountList = new List<Account>();
        List<Account> accRecUpdateList = new List<Account>();
        Map <Id, Customer_Onboarding__c> mapCOBData = new Map <Id, Customer_Onboarding__c>();
        Map <Id, List<State__c>> mapCOBState = new Map <Id, List<State__c>>();
        
        DescribeSObjectResult describeResult = Account.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        system.debug('fieldNames****** '+fieldNames);
        String query = 'SELECT ' + String.join( fieldNames, ',' );
        query += ' FROM '+ describeResult.getName() + ' WHERE Id IN: keys'; 
        
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        DescribeSObjectResult describeResultCOB = Customer_Onboarding__c.getSObjectType().getDescribe();
        List<String> fieldNamesCOB = new List<String>(describeResultCOB.fields.getMap().keySet());
        system.debug('fieldNamesCOB****** '+fieldNamesCOB);
        String queryCOB = 'SELECT ' + String.join( fieldNamesCOB, ',' );
        queryCOB += ', Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Email__c,Account__r.Phone__c,Account__r.Name,Opportunity__r.StageName, Account__r.External_ID__c, Opportunity__r.AccountId, (select id, GST_Number__c, HQ_State__c, State__c from States__r)  ';
        queryCOB += ' FROM '+ describeResultCOB.getName() + ' WHERE Id IN: cobIdSet'; 
        
        
        try{
            accountList = Database.query(query);
            listOnboarding = Database.query(queryCOB);
            
            if(!listOnboarding.isEmpty()){
                for(Customer_Onboarding__c cobRec : listOnboarding){
                    mapCOBData.put(cobRec.Account__c, cobRec);
                    mapCOBState.put(cobRec.Account__c, cobRec.States__r);
                }
                system.debug('listOnboarding in copyDataToServiceAccount>>'+listOnboarding);
                if(!accountList.isEmpty() && !listOnboarding.isEmpty()){
                    for(Account accRecUpdate : accountList){
                        system.debug('mapCOBData.get(accRecUpdate.Id) >>'+mapCOBData.get(accRecUpdate.Id));
                        system.debug('mapCOBData.get(accRecUpdate.Id).Account__r.External_ID__c >>'+mapCOBData.get(accRecUpdate.Id).Account__r.External_ID__c);
                        if(mapCOBData.get(accRecUpdate.Id).Account__r.External_ID__c!=null && !OnboardingSendToHQ_Ctl.isHQUpdate){
                            if(mapCOBData.get(accRecUpdate.Id).NDR_report_recipients__c!=null){
                                accRecUpdate.NDR_report_recipients__c = mapCOBData.get(accRecUpdate.Id).NDR_report_recipients__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Report_Recipients__c!=null){
                                accRecUpdate.Report_Recipients__c = mapCOBData.get(accRecUpdate.Id).Report_Recipients__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).RTO_email_recipients__c!=null){
                                accRecUpdate.RTO_email_recipients__c = mapCOBData.get(accRecUpdate.Id).RTO_email_recipients__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).DTO_email_recipients__c!=null){
                                accRecUpdate.DTO_email_recipients__c = mapCOBData.get(accRecUpdate.Id).DTO_email_recipients__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).REM_email__c!=null){
                                accRecUpdate.REM_email__c = mapCOBData.get(accRecUpdate.Id).REM_email__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Upload_Recipients__c!=null){
                                accRecUpdate.Upload_Recipients__c = mapCOBData.get(accRecUpdate.Id).Upload_Recipients__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).VAT_Number__c!=null){
                                accRecUpdate.VAT_Number__c = mapCOBData.get(accRecUpdate.Id).VAT_Number__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).CST_Number__c!=null){
                                accRecUpdate.CST_Number__c = mapCOBData.get(accRecUpdate.Id).CST_Number__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Eco_Code__c!=null){
                                accRecUpdate.Eco_Code__c = mapCOBData.get(accRecUpdate.Id).Eco_Code__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Return_Address__c!=null){
                                accRecUpdate.Return_Address__c = mapCOBData.get(accRecUpdate.Id).Return_Address__c;
                            }
                            //accRecUpdate.FRS_Code__c = mapCOBData.get(accRecUpdate.Id).FRS_Code__c;
                            
                            if(mapCOBData.get(accRecUpdate.Id).Registered_Address_Line_1__c!=null){
                                accRecUpdate.Registered_Address_Line_1__c = mapCOBData.get(accRecUpdate.Id).Registered_Address_Line_1__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Registered_Address_Line_2__c!=null){
                                accRecUpdate.Registered_Address_Line_2__c = mapCOBData.get(accRecUpdate.Id).Registered_Address_Line_2__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Registered_Address_City__c!=null){
                                accRecUpdate.Registered_Address_City__c = mapCOBData.get(accRecUpdate.Id).Registered_Address_City__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Registered_Address_State__c!=null){
                                accRecUpdate.Registered_Address_State__c = mapCOBData.get(accRecUpdate.Id).Registered_Address_State__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Registered_Address_Postal_Code__c!=null){
                                accRecUpdate.Registered_Address_Postal_Code__c = mapCOBData.get(accRecUpdate.Id).Registered_Address_Postal_Code__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Registered_Address_Country__c!=null){
                                accRecUpdate.Registered_Address_Country__c = mapCOBData.get(accRecUpdate.Id).Registered_Address_Country__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Push_url__c!=null){
                                accRecUpdate.Push_url__c = mapCOBData.get(accRecUpdate.Id).Push_url__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Product_Type__c!=null){
                                accRecUpdate.Product_Type__c = mapCOBData.get(accRecUpdate.Id).Product_Type__c;
                            }
                            
                            //accRecUpdate.Is_Prepaid__c = mapCOBData.get(accRecUpdate.Id).Is_Prepaid__c;
                            if(mapCOBData.get(accRecUpdate.Id).Wallet_Notification_Mobile__c!=null){
                                accRecUpdate.Wallet_Notification_Mobile__c = mapCOBData.get(accRecUpdate.Id).Wallet_Notification_Mobile__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Wallet_Notification_Email__c!=null){
                                accRecUpdate.Wallet_Notification_Email__c = mapCOBData.get(accRecUpdate.Id).Wallet_Notification_Email__c;
                            }
                            
                            accRecUpdate.MPS_Service__c = mapCOBData.get(accRecUpdate.Id).MPS_Service__c;
                            accRecUpdate.Send_mail_Pickup__c = mapCOBData.get(accRecUpdate.Id).Send_mail_Pickup__c;
                            accRecUpdate.Send_SMS_Prepaid__c = mapCOBData.get(accRecUpdate.Id).Send_SMS_Prepaid__c;
                            accRecUpdate.send_sms_cash__c = mapCOBData.get(accRecUpdate.Id).send_sms_cash__c;
                            accRecUpdate.Send_SMS_COD__c = mapCOBData.get(accRecUpdate.Id).Send_SMS_COD__c;
                            accRecUpdate.Send_SMS_Reverse__c = mapCOBData.get(accRecUpdate.Id).Send_SMS_Reverse__c;
                            accRecUpdate.Send_SMS_NDR__c = mapCOBData.get(accRecUpdate.Id).Send_SMS_NDR__c;
                            accRecUpdate.auto_pickup__c = mapCOBData.get(accRecUpdate.Id).auto_pickup__c;
                            accRecUpdate.allow_no_data__c = mapCOBData.get(accRecUpdate.Id).allow_no_data__c;
                            
                            if(mapCOBData.get(accRecUpdate.Id).Billing_Mode__c!=null){
                                accRecUpdate.Billing_Mode__c = mapCOBData.get(accRecUpdate.Id).Billing_Mode__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Postal_Cat1__c!=null){
                                accRecUpdate.Postal_Cat__c = mapCOBData.get(accRecUpdate.Id).Postal_Cat1__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).X_Ray_Limit__c!=null){
                                accRecUpdate.X_Ray_Limit__c = mapCOBData.get(accRecUpdate.Id).X_Ray_Limit__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Contact_number__c!=null){
                                accRecUpdate.Contact_number__c = mapCOBData.get(accRecUpdate.Id).Contact_number__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Billing_Client_Config__c!=null){
                                accRecUpdate.Billing_Client_Config__c = mapCOBData.get(accRecUpdate.Id).Billing_Client_Config__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Movement_Config__c!=null){
                                accRecUpdate.Movement_Config__c = mapCOBData.get(accRecUpdate.Id).Movement_Config__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Client_User_Id__c!=null){
                                accRecUpdate.Client_User_Id__c = mapCOBData.get(accRecUpdate.Id).Client_User_Id__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Client_Id__c!=null){
                                accRecUpdate.Client_Id__c = mapCOBData.get(accRecUpdate.Id).Client_Id__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Company_Registered_Name__c!=null){
                                accRecUpdate.Company_Registered_Name__c= mapCOBData.get(accRecUpdate.Id).Company_Registered_Name__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Bank_A_c_Number__c!=null){
                                accRecUpdate.Bank_A_c_Number__c = mapCOBData.get(accRecUpdate.Id).Bank_A_c_Number__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Bank_name__c!=null){
                                accRecUpdate.Bank_name__c= mapCOBData.get(accRecUpdate.Id).Bank_name__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Beneficiary_name__c!=null){
                                accRecUpdate.Beneficiary_name__c= mapCOBData.get(accRecUpdate.Id).Beneficiary_name__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).PAN_card__c!=null){
                                accRecUpdate.PAN_card__c= mapCOBData.get(accRecUpdate.Id).PAN_card__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).RTGS_IFSC_code__c!=null){
                                accRecUpdate.RTGS_IFSC_code__c= mapCOBData.get(accRecUpdate.Id).RTGS_IFSC_code__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Invoice_Address_Line_1__c!=null){
                                accRecUpdate.BillingStreet = mapCOBData.get(accRecUpdate.Id).Invoice_Address_Line_1__c;
                            }
                            if(mapCOBData.get(accRecUpdate.Id).Invoice_Address_Line_2__c!=null){
                                accRecUpdate.BillingStreet+=  ' ' +mapCOBData.get(accRecUpdate.Id).Invoice_Address_Line_2__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Invoice_Address_City__c!=null){
                                accRecUpdate.BillingCity = mapCOBData.get(accRecUpdate.Id).Invoice_Address_City__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Invoice_Address_State__c!=null){
                                accRecUpdate.BillingState = mapCOBData.get(accRecUpdate.Id).Invoice_Address_State__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Invoice_Address_Country__c!=null){
                                accRecUpdate.BillingCountry = mapCOBData.get(accRecUpdate.Id).Invoice_Address_Country__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Invoice_Address_Postal_Code__c!=null){
                                accRecUpdate.BillingPostalCode = mapCOBData.get(accRecUpdate.Id).Invoice_Address_Postal_Code__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Wallet_Provider__c!=null){
                                accRecUpdate.Wallet_Provider__c = mapCOBData.get(accRecUpdate.Id).Wallet_Provider__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Contract_Start_Date__c!=null){
                                accRecUpdate.Contract_Start_Date__c = mapCOBData.get(accRecUpdate.Id).Contract_Start_Date__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Contract_End_Date__c!=null){
                                accRecUpdate.Contract_End_Date__c = mapCOBData.get(accRecUpdate.Id).Contract_End_Date__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Product_category__c!=null){
                                accRecUpdate.Product_category__c = mapCOBData.get(accRecUpdate.Id).Product_category__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Services__c!=null){
                                accRecUpdate.Services__c = mapCOBData.get(accRecUpdate.Id).Services__c;
                            }
                            
                            if(mapCOBData.get(accRecUpdate.Id).Invoicing_Mode__c!=null){
                                accRecUpdate.Invoicing_Mode__c = mapCOBData.get(accRecUpdate.Id).Invoicing_Mode__c;
                            }
                            accRecUpdate.GST_not_registered__c = mapCOBData.get(accRecUpdate.Id).GST_not_registered__c;
                            
                            
                            for(State__c st : mapCOBState.get(accRecUpdate.Id)){
                                system.debug('state Id>>'+st.Id);
                                accRecUpdate.State__c = st.Id;
                                accRecUpdate.GST_Number__c = st.GST_Number__c;
                                accRecUpdate.HQ_State__c = st.HQ_State__c;
                                accRecUpdate.State_Name__c = st.State__c;
                            }
                            
                            accRecUpdateList.add(accRecUpdate);
                            system.debug('accRecUpdateList >>'+accRecUpdateList);
                        }
                    }
                }
               
                if(!accRecUpdateList.isEmpty()){
                    update accRecUpdateList;
                }
                
            }
            
        }catch (Exception e){
            system.debug('Exception caught >>'+ e);
        }
    }
    /*End: SF - 107 Copy Data from Customer Onboarding over associated Service Account record*/
    
    
    //Start SF - 104 : Mapping Customer Onboarding's FRS Code to Accounts
    public static void updateAccountFRS (Map <Id, String> cobAccountMap){
        system.debug('cobAccountMap >>'+cobAccountMap);
        
        List <Account> accountList = new List <Account>();
        List <Account> updateOperatingAccFRSList = new List <Account>();
        List <Account> updateAccFRSList = new List <Account>();
        Set <Id> serviceAccountId = new Set <Id>();
        
        accountList = [SELECT Id, ParentId, FRS_Code__c, Parent.FRS_Code__c FROM Account WHERE Id IN: cobAccountMap.keySet()];
        
        if(!accountList.isEmpty()){
            for(Account acc : accountList){
                serviceAccountId.add(acc.Id);
                acc.FRS_Code__c = cobAccountMap.get(acc.Id);
                acc.Parent.FRS_Code__c = cobAccountMap.get(acc.Id);
                
                updateAccFRSList.add(acc);
                updateOperatingAccFRSList.add(acc.Parent);
            }
        }
        
        if(!updateAccFRSList.isEmpty()){
            try{
                update updateAccFRSList;
            }catch (Exception e){
                system.debug('Exception caught while updating COBs Service Account >> '+e);
            }
        }
        
        if(!updateOperatingAccFRSList.isEmpty()){
            try{
                update updateOperatingAccFRSList;
            }catch (Exception e){
                system.debug('Exception caught while updating COBs Operating Account >> '+e);
            }
        }
        
        
        
    }
    //End SF - 104 : Mapping Customer Onboarding's FRS Code to Accounts
}