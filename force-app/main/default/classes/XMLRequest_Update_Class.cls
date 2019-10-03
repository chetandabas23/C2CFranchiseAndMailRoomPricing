/*****************************************************************************************
* Author : Nikhil K. Tyagi
* Created Date : 21-09-2018
* Description : Helper Class for OnBoardingToOracle_Ctl Class.
* Dependencies : OnBoardingToOracle_Ctl Class [parent class]
* Test Class : covered from parent 
******************************************************************************************/

public class XMLRequest_Update_Class {

    
     public static string XML_String(List<Customer_Onboarding__c> cob_oracle_data){
        
        String request = 
          '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:upd="http://xmlns.oracle.com/apps/ar/soaprovider/plsql/xxdpl_ar_customer_wbs/update_customer/" xmlns:xxd="http://xmlns.oracle.com/apps/ar/soaprovider/plsql/xxdpl_ar_customer_wbs/">'+
   '<soapenv:Header>'+
      System.Label.Oracle_Token +
   '</soapenv:Header>'+
   '<soapenv:Body>'+
      '<upd:InputParameters>'+
         //<!--Optional:-->
         '<upd:PARTY_DETAILS>'+
            //<!--Zero or more repetitions:-->
            '<upd:PARTY_DETAILS_ITEM>'+
               //<!--Optional:-->
               '<upd:MAPPING_PARTY_ID>'+findOperatingAccount(cob_oracle_data).ID+'</upd:MAPPING_PARTY_ID>'+
               //<!--Optional:-->
               '<upd:ORA_PARTY_ID>'+XMLRequest_Update_Class.findOperatingAccount(cob_oracle_data).Oracle_ID__c+'</upd:ORA_PARTY_ID>'+
               //<!--Optional:-->
               '<upd:HQ_ID>'+cob_oracle_data[0].Desired_HQ_Name__c+'</upd:HQ_ID>'+
               //<!--Optional:-->
               '<upd:PARTY_SOURCE>SALESFORCE</upd:PARTY_SOURCE>'+
               //<!--Optional:-->
               '<upd:ACCOUNT_DESCRIPTION>'+cob_oracle_data[0].Company_Registered_Name__c+'</upd:ACCOUNT_DESCRIPTION>'+
               //<!--Optional:-->
               '<upd:PAN_NUMBER>'+cob_oracle_data[0].PAN_card__c.toUpperCase()+'</upd:PAN_NUMBER>'+
               //<!--Optional:-->
               '<upd:START_DATE/>'+ //Client's insert process will provide Start Date
               //<!--Optional:-->
               '<upd:END_DATE/>'+
               //<!--Optional:-->
               '<upd:BANK_DETAILS>'+
                  //<!--Zero or more repetitions:-->
                  '<upd:BANK_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<upd:BANK_NAME>'+cob_oracle_data[0].Bank_name__c+'</upd:BANK_NAME>'+
                     //<!--Optional:-->
                     '<upd:BENIFICARY_NAME>'+cob_oracle_data[0].Beneficiary_name__c+'</upd:BENIFICARY_NAME>'+
                     //<!--Optional:-->
                     '<upd:ACCOUNT_NUMBER>'+cob_oracle_data[0].Bank_A_c_Number__c+'</upd:ACCOUNT_NUMBER>'+
                     //<!--Optional:-->
                     '<upd:IFSC_CODE>'+cob_oracle_data[0].RTGS_IFSC_code__c+'</upd:IFSC_CODE>'+
                     //<!--Optional:-->
                     '<upd:HQ_ID>'+cob_oracle_data[0].Desired_HQ_Name__c+'</upd:HQ_ID>'+
                     //<!--Optional:-->
                     '<upd:SERVICE_ID>'+cob_oracle_data[0].Account__c+'</upd:SERVICE_ID>'+
                     //<!--Optional:-->
                     '<upd:START_DATE>'+formatDate(cob_oracle_data[0].Account__r.Contract_Start_Date__c)+'</upd:START_DATE>'+
                     //<!--Optional:-->
                    '<upd:END_DATE>'+formatDate(cob_oracle_data[0].Account__r.Contract_End_Date__c)+'</upd:END_DATE>'+
                  '</upd:BANK_DETAILS_ITEM>'+
               '</upd:BANK_DETAILS>'+
               //<!--Optional:-->
               '<upd:CONTACT_DETAILS>'+
                  //<!--Zero or more repetitions:-->
                  '<upd:CONTACT_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<upd:TITLE/>'+
                     //<!--Optional:-->
                     '<upd:FIRST_NAME>'+cob_oracle_data[0].Contact_First_Name__c+'</upd:FIRST_NAME>'+
                     //<!--Optional:-->
                     '<upd:LAST_NAME>'+cob_oracle_data[0].Contact_Last_Name__c+'</upd:LAST_NAME>'+
                     //<!--Optional:-->
                     '<upd:EMAIL_ADDRESS>'+cob_oracle_data[0].Email__c+'</upd:EMAIL_ADDRESS>'+
                     //<!--Optional:-->
                     '<upd:PHONE>'+cob_oracle_data[0].Contact_number__c+'</upd:PHONE>'+
                     //<!--Optional:-->
                     '<upd:FAX_NO/>'+
                  '</upd:CONTACT_DETAILS_ITEM>'+
               '</upd:CONTACT_DETAILS>'+
               //<!--Optional:-->
               '<upd:SITE_DETAILS>';
          System.debug('States-->>'+cob_oracle_data[0].States__r);
        if(cob_oracle_data[0].States__r != null && cob_oracle_data[0].States__r.size() > 0){
            for(State__c each_state : cob_oracle_data[0].States__r){
                
                String Address1 = each_state.Registered_Address_Line_1__c == null ? each_state.State__c : each_state.Registered_Address_Line_1__c;
                String City = each_state.Registered_Address_City__c == null ? 'NA' : each_state.Registered_Address_City__c;
                String PostalCode = each_state.Registered_Address_Postal_Code__c == null ? each_state.State__c : each_state.Registered_Address_Postal_Code__c;
                Integer Oracle_Site_ID = Integer.valueOf(each_state.Oracle_Site_ID__c) == null ? 0 : Integer.valueOf(each_state.Oracle_Site_ID__c); 
                
            request = request +
                  //<!--Zero or more repetitions:-->
                  '<upd:SITE_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<upd:PARTY_SITE_NAME>'+each_state.State__c+'</upd:PARTY_SITE_NAME>'+
                     //<!--Optional:-->
                     '<upd:OPERATING_UNIT>Delhivery -Transport</upd:OPERATING_UNIT>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS_TYPE>BILL TO</upd:ADDRESS_TYPE>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS1>'+Address1+'</upd:ADDRESS1>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS2>NEW DELHI</upd:ADDRESS2>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS3></upd:ADDRESS3>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS4></upd:ADDRESS4>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS5></upd:ADDRESS5>'+
                     //<!--Optional:-->
                     '<upd:CITY>'+City+'</upd:CITY>'+
                     //<!--Optional:-->
                     '<upd:STATE>'+each_state.State__c+'</upd:STATE>'+
                     //<!--Optional:-->
                     '<upd:COUNTRY>'+returnCountryCode(cob_oracle_data[0].Registered_Address_Country__c)+'</upd:COUNTRY>'+
                     //<!--Optional:-->
                     '<upd:COUNTY/>'+
                     //<!--Optional:-->
                     '<upd:PROVINCE/>'+
                     //<!--Optional:-->
                     '<upd:POSTAL_CODE>'+PostalCode+'</upd:POSTAL_CODE>'+
                     //<!--Optional:-->
                     '<upd:GST_NUMBER>'+each_state.GST_Number__c+'</upd:GST_NUMBER>'+
                     //<!--Optional:-->
                     '<upd:ORA_SITE_ID>'+Oracle_Site_ID+'</upd:ORA_SITE_ID>'+
                     //<!--Optional:-->
                     '<upd:BANK_DETAILS/>'+
                     //<!--Optional:-->
                     '<upd:CONTACT_DETAILS/>'+
                  '</upd:SITE_DETAILS_ITEM>';
                
                   }
            System.debug('IF request--'+request);
        	}
        else{
            Integer Oracle_Site_ID = Integer.valueOf(cob_oracle_data[0].Registered_Address_Oracle_ID__c) == null ? 0 : Integer.valueOf(cob_oracle_data[0].Registered_Address_Oracle_ID__c); 
            
             request = request +
                 
                  '<upd:SITE_DETAILS_ITEM>'+
                     //<!--Optional:-->
                     '<upd:PARTY_SITE_NAME>'+cob_oracle_data[0].Registered_Address_State__c+'</upd:PARTY_SITE_NAME>'+
                     //<!--Optional:-->
                     '<upd:OPERATING_UNIT>Delhivery -Transport</upd:OPERATING_UNIT>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS_TYPE>BILL TO</upd:ADDRESS_TYPE>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS1>'+cob_oracle_data[0].Registered_Address_Line_1__c+'</upd:ADDRESS1>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS2>NEW DELHI</upd:ADDRESS2>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS3></upd:ADDRESS3>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS4></upd:ADDRESS4>'+
                     //<!--Optional:-->
                     '<upd:ADDRESS5></upd:ADDRESS5>'+
                     //<!--Optional:-->
                     '<upd:CITY>'+cob_oracle_data[0].Registered_Address_City__c+'</upd:CITY>'+
                     //<!--Optional:-->
                     '<upd:STATE>'+cob_oracle_data[0].Registered_Address_State__c+'</upd:STATE>'+
                     //<!--Optional:-->
                     '<upd:COUNTRY>'+returnCountryCode(cob_oracle_data[0].Registered_Address_Country__c)+'</upd:COUNTRY>'+
                     //<!--Optional:-->
                     '<upd:COUNTY/>'+
                     //<!--Optional:-->
                     '<upd:PROVINCE/>'+
                     //<!--Optional:-->
                     '<upd:POSTAL_CODE>'+cob_oracle_data[0].Registered_Address_Postal_Code__c+'</upd:POSTAL_CODE>'+
                     //<!--Optional:-->
                     '<upd:GST_NUMBER/>'+
                     //<!--Optional:-->
                     '<upd:ORA_SITE_ID>'+Oracle_Site_ID+'</upd:ORA_SITE_ID>'+
                     //<!--Optional:-->
                     '<upd:BANK_DETAILS/>'+
                     //<!--Optional:-->
                     '<upd:CONTACT_DETAILS/>'+
                  '</upd:SITE_DETAILS_ITEM>';
        }
            request = request +
               '</upd:SITE_DETAILS>'+
            '</upd:PARTY_DETAILS_ITEM>'+
         '</upd:PARTY_DETAILS>'+
      '</upd:InputParameters>'+
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