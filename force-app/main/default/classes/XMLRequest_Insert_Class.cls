/*****************************************************************************************
* Author : Nikhil K. Tyagi
* Created Date : 8-07-2018
* Description : Helper Class for OnBoardingToOracle_Ctl Class.
* Dependencies : OnBoardingToOracle_Ctl Class [parent class]
* Test Class : covered from parent 
******************************************************************************************/

public class XMLRequest_Insert_Class {
    
    public static string XML_String(List<Customer_Onboarding__c> cob_oracle_data){
       
        String request = 
            '<soapenv:Envelope xmlns:cre="http://xmlns.oracle.com/apps/ar/soaprovider/plsql/xxdpl_ar_customer_wbs/create_customer/" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xxd="http://xmlns.oracle.com/apps/ar/soaprovider/plsql/xxdpl_ar_customer_wbs/">'+
  '<soapenv:Header>'+
     System.Label.Oracle_Token +
   '</soapenv:Header>'+
   '<soapenv:Body>'+
      '<cre:InputParameters>'+
         //<!--Optional:-->
         '<cre:PARTY_DETAILS>'+
            //<!--Zero or more repetitions:-->
            '<cre:PARTY_DETAILS_ITEM>'+
               //<!--Optional:-->
               '<cre:MAPPING_PARTY_ID>'+findOperatingAccount(cob_oracle_data).ID+'</cre:MAPPING_PARTY_ID>'+
               //<!--Optional:-->
               '<cre:HQ_ID>'+cob_oracle_data[0].Desired_HQ_Name__c+'</cre:HQ_ID>'+
               //<!--Optional:-->
               '<cre:PARTY_SOURCE>SALESFORCE</cre:PARTY_SOURCE>'+
               //<!--Optional:-->
               '<cre:PARTY_NAME>'+cob_oracle_data[0].Company_Registered_Name__c+'</cre:PARTY_NAME>'+
               //<!--Optional:-->
               '<cre:ACCOUNT_DESCRIPTION>'+cob_oracle_data[0].Desired_HQ_Name__c+'</cre:ACCOUNT_DESCRIPTION>'+
               //<!--Optional:-->	
               '<cre:PAN_NUMBER>'+cob_oracle_data[0].PAN_card__c.toUpperCase()+'</cre:PAN_NUMBER>'+
               //<!--Optional:-->
               '<cre:START_DATE>'+formatDate(cob_oracle_data[0].Account__r.Contract_Start_Date__c)+'</cre:START_DATE>'+
               //<!--Optional:-->
               '<cre:END_DATE/>'+// Client End Date Will Be inserted on Update after Manual Entry of End Date
               //<!--Optional:-->
               '<cre:BANK_DETAILS>'+
                  //<!--Zero or more repetitions:-->
                  '<cre:BANK_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<cre:BANK_NAME>'+cob_oracle_data[0].Bank_name__c+'</cre:BANK_NAME>'+
                     //<!--Optional:-->
                     '<cre:BENIFICARY_NAME>'+cob_oracle_data[0].Beneficiary_name__c+'</cre:BENIFICARY_NAME>'+
                     //<!--Optional:-->
                     '<cre:ACCOUNT_NUMBER>'+cob_oracle_data[0].Bank_A_c_Number__c+'</cre:ACCOUNT_NUMBER>'+
                     //<!--Optional:-->
                     '<cre:IFSC_CODE>'+cob_oracle_data[0].RTGS_IFSC_code__c+'</cre:IFSC_CODE>'+
                     //<!--Optional:-->
                     '<cre:HQ_ID>'+cob_oracle_data[0].Desired_HQ_Name__c+'</cre:HQ_ID>'+
                     //<!--Optional:-->
                     '<cre:SERVICE_ID>'+cob_oracle_data[0].Account__c+'</cre:SERVICE_ID>'+ // Contract End Date for this service
                     //<!--Optional:-->
                     '<cre:START_DATE>'+formatDate(cob_oracle_data[0].Account__r.Contract_Start_Date__c)+'</cre:START_DATE>'+
                     //<!--Optional:-->
                     '<cre:END_DATE>'+formatDate(cob_oracle_data[0].Account__r.Contract_End_Date__c)+'</cre:END_DATE>'+
                  '</cre:BANK_DETAILS_ITEM>'+
               '</cre:BANK_DETAILS>'+
               //<!--Optional:-->
               '<cre:CONTACT_DETAILS>'+
                  //<!--Zero or more repetitions:-->
                  '<cre:CONTACT_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<cre:TITLE/>'+
                     //<!--Optional:-->
                     '<cre:FIRST_NAME>'+cob_oracle_data[0].Contact_First_Name__c+'</cre:FIRST_NAME>'+
                     //<!--Optional:-->
                     '<cre:LAST_NAME>'+cob_oracle_data[0].Contact_Last_Name__c+'</cre:LAST_NAME>'+
                     //<!--Optional:-->
                     '<cre:EMAIL_ADDRESS>'+cob_oracle_data[0].Email__c+'</cre:EMAIL_ADDRESS>'+
                     //<!--Optional:-->
                     '<cre:PHONE>'+cob_oracle_data[0].Contact_number__c+'</cre:PHONE>'+
                     //<!--Optional:-->
                     '<cre:FAX_NO></cre:FAX_NO>'+
                  '</cre:CONTACT_DETAILS_ITEM>'+
               '</cre:CONTACT_DETAILS>'+
               //<!--Optional:-->
               '<cre:SITE_DETAILS>';
        System.debug('States-->>'+cob_oracle_data[0].States__r);
        if(cob_oracle_data[0].States__r != null && cob_oracle_data[0].States__r.size() > 0){
            for(State__c each_state : cob_oracle_data[0].States__r){
                
                String Address1 = each_state.Registered_Address_Line_1__c == null ? each_state.State__c : each_state.Registered_Address_Line_1__c;
                String City = each_state.Registered_Address_City__c == null ? 'NA' : each_state.Registered_Address_City__c;
                String PostalCode = each_state.Registered_Address_Postal_Code__c == null ? each_state.State__c : each_state.Registered_Address_Postal_Code__c;
                Integer Oracle_Site_ID = Integer.valueOf(each_state.Oracle_Site_ID__c) == null ? 0 : Integer.valueOf(each_state.Oracle_Site_ID__c); 
                
            request = request +
            
                  //<!--Zero or more repetitions:-->
                  '<cre:SITE_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<cre:PARTY_SITE_NAME>'+each_state.State__c+'</cre:PARTY_SITE_NAME>'+
                     //<!--Optional:-->
                     '<cre:OPERATING_UNIT>Delhivery -Transport</cre:OPERATING_UNIT>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS_TYPE>BILL TO</cre:ADDRESS_TYPE>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS1>'+Address1+'</cre:ADDRESS1>'+//Passing state if null
                     //<!--Optional:-->
                     '<cre:ADDRESS2/>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS3/>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS4/>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS5/>'+
                     //<!--Optional:-->
                     '<cre:CITY>'+City+'</cre:CITY>'+//Passing NA if null
                     //<!--Optional:-->
                     '<cre:STATE>'+each_state.State__c+'</cre:STATE>'+
                     //<!--Optional:-->
                     '<cre:COUNTRY>'+returnCountryCode(cob_oracle_data[0].Registered_Address_Country__c)+'</cre:COUNTRY>'+
                     //<!--Optional:-->
                     '<cre:COUNTY/>'+
                     //<!--Optional:-->
                     '<cre:PROVINCE/>'+
                     //<!--Optional:-->
                     '<cre:POSTAL_CODE>'+PostalCode+'</cre:POSTAL_CODE>'+//Passing state if null
                     //<!--Optional:-->
                      '<cre:GST_NUMBER>'+each_state.GST_Number__c+'</cre:GST_NUMBER>'+
                     //<!--Optional:-->
                     '<cre:ORA_SITE_ID>'+Oracle_Site_ID+'</cre:ORA_SITE_ID>'+
                     //<!--Optional:-->
                  //<!--Zero or more repetitions:-->
                      '<cre:BANK_DETAILS>'+
                        //<!--Zero or more repetitions:-->
                        '<cre:BANK_DETAILS_ITEM/>'+
                     '</cre:BANK_DETAILS>'+
                     //<!--Optional:-->
                    '<cre:CONTACT_DETAILS>'+
                        //<!--Zero or more repetitions:-->
                        '<cre:CONTACT_DETAILS_ITEM/>'+
                     '</cre:CONTACT_DETAILS>'+
                  '</cre:SITE_DETAILS_ITEM>';
                  
                }
            System.debug('IF request--'+request);
        	}
        else{
            Integer Oracle_Site_ID = Integer.valueOf(cob_oracle_data[0].Registered_Address_Oracle_ID__c) == null ? 0 : Integer.valueOf(cob_oracle_data[0].Registered_Address_Oracle_ID__c); 
            
             request = request +
            
                  //<!--Zero or more repetitions:-->
                  '<cre:SITE_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<cre:PARTY_SITE_NAME>'+cob_oracle_data[0].Registered_Address_State__c+'</cre:PARTY_SITE_NAME>'+
                     //<!--Optional:-->
                     '<cre:OPERATING_UNIT>Delhivery -Transport</cre:OPERATING_UNIT>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS_TYPE>BILL TO</cre:ADDRESS_TYPE>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS1>'+cob_oracle_data[0].Registered_Address_Line_1__c+'</cre:ADDRESS1>'+//Passing state if null
                     //<!--Optional:-->
                     '<cre:ADDRESS2/>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS3/>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS4/>'+
                     //<!--Optional:-->
                     '<cre:ADDRESS5/>'+
                     //<!--Optional:-->
                     '<cre:CITY>'+cob_oracle_data[0].Registered_Address_City__c+'</cre:CITY>'+//Passing NA if null
                     //<!--Optional:-->
                     '<cre:STATE>'+cob_oracle_data[0].Registered_Address_State__c+'</cre:STATE>'+
                     //<!--Optional:-->
                     '<cre:COUNTRY>'+returnCountryCode(cob_oracle_data[0].Registered_Address_Country__c)+'</cre:COUNTRY>'+
                     //<!--Optional:-->
                     '<cre:COUNTY/>'+
                     //<!--Optional:-->
                     '<cre:PROVINCE/>'+
                     //<!--Optional:-->
                     '<cre:POSTAL_CODE>'+cob_oracle_data[0].Registered_Address_Postal_Code__c+'</cre:POSTAL_CODE>'+//Passing state if null
                     //<!--Optional:-->
                     '<cre:GST_NUMBER/>'+
                     //<!--Optional:-->
                     '<cre:ORA_SITE_ID>'+Oracle_Site_ID+'</cre:ORA_SITE_ID>'+
                     //<!--Optional:-->
                  //<!--Zero or more repetitions:-->
                      '<cre:BANK_DETAILS>'+
                        //<!--Zero or more repetitions:-->
                        '<cre:BANK_DETAILS_ITEM/>'+
                     '</cre:BANK_DETAILS>'+
                     //<!--Optional:-->
                    '<cre:CONTACT_DETAILS>'+
                        //<!--Zero or more repetitions:-->
                        '<cre:CONTACT_DETAILS_ITEM/>'+
                     '</cre:CONTACT_DETAILS>'+
                  '</cre:SITE_DETAILS_ITEM>';
            System.debug('IF request--'+request);
        }
                request = request +
               '</cre:SITE_DETAILS>'+
            '</cre:PARTY_DETAILS_ITEM>'+
         '</cre:PARTY_DETAILS>'+
      '</cre:InputParameters>'+
   '</soapenv:Body>'+
'</soapenv:Envelope>';
            
          
        return request;
        
    }
    
      public static String returnCountryCode(String Country_Name){
        
        String Country_Code = 'IN' ;
        if(!Country_Name.equalsIgnoreCase('India')){ // Most of the time it will be india.
            Map<String,Countries__c> mapCodes = Countries__c.getAll();  
            for(String each_Country : mapCodes.keySet()){
                if(each_Country.equalsIgnoreCase(Country_Name)){
                    Country_Code = mapCodes.get(each_Country).Country_Code__c;
                    break;
                }
            } 
        }
        System.debug('Country_Code-->>'+Country_Code);
        
        return Country_Code;
    }
    
    
    public static String formatDate(DateTime pass_Date){
        DateTime dt = DateTime.newInstance(pass_Date.year(), pass_Date.month(),pass_Date.day());
        return dt.format('dd-MMM-yyyy');
    }
    
    public static Boolean GSTDeclarationCheck(ID COB_ID){
        List<Attachment__c> listOf_Attach  = new List<Attachment__c>();
        listOf_Attach = [Select id ,Type__c,Verified__c 
                         From Attachment__c 
                         Where Customer_Onboarding__c =: COB_ID 
                         AND Type__c = 'GST Declaration Form' 
                         AND Verified__c = true]; 
        if(listOf_Attach != null && listOf_Attach.size() > 0)
            return true;
        else
            return false;
    }
    
    public static Account findOperatingAccount(List<Customer_Onboarding__c> cob_list){
        List<Account> operatingAcc = new list<Account>();
        try{
            operatingAcc = [Select id,Oracle_ID__c from Account where ID IN  (Select Operating_Account__c from Opportunity where id =: cob_list[0].Opportunity__c)];
            return operatingAcc[0];
        }catch(Exception E){
            System.debug('Please Fill The Opportunity On this COB and Opperating Account on the same Opportunity');
        }
        return null; // should never reach here.
    }
    
    
}