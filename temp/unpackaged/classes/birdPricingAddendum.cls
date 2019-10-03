/*****************************************************************************************
* Author : Prakhar Goyal
* Created Date : 09-01-2019
* Description : Synced to Bird button on Opportinity Page send the product details to AWS for Bird in case of Addendum
* Test Class : 
******************************************************************************************/

public class birdPricingAddendum {
    
    public Customer_Onboarding__c objOnboarding{get;set;} 
    public List<Customer_Onboarding__c> listOnBoarding ;
    public List<Opportunity> lstOpp;
    public Id oppid{get;set;}
    public String jsonfile = '';
    
    public birdPricingAddendum(Apexpages.StandardController Controller)
    {
        //get the record from the page
        objOnboarding = (Customer_Onboarding__c) controller.getRecord();
        listOnBoarding =  getOnBoardingRecord(objOnboarding.Id);
        
    }
    
    public List<Customer_Onboarding__c> getOnBoardingRecord(Id recId)
    {
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        //get on boarding details of the record from the page
        try{
            listOnboarding = [select Opportunity__c,Synced_to_Bird_As_Addendum__c,Desired_HQ_Name__c,Id,Opportunity__r.RecordType.Name,Opportunity__r.Sub_Category_Formula__c,Opportunity__r.Status__c from Customer_Onboarding__c where Id =:recId ];
            System.debug('Success');
            
        }catch(Exception e){
            system.debug('Error caught >>'+e);
        }
        return listOnboarding;
        
    }
    
    public pageReference backLink()
    {
        PageReference nextPage = new PageReference('/'+listOnBoarding[0].id);
        return nextPage;
    }
    
    public void birdPricingAddendumUpload()
    {
        //check if the file is already present in the Bird system related to the on boarding
        if(listOnBoarding[0].Synced_to_Bird_As_Addendum__c == true)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, 'File is already present in the System'));
        }
        else
        {
            List<Opportunity> lstOpp = new List<Opportunity>();
            
            if(listOnBoarding[0].opportunity__c != null)
            {
                oppid= listOnBoarding[0].opportunity__r.Id;
                lstOpp = [select id,name,Addendum_Start_Date__c,Addendum_End_Date__c from Opportunity where id =: oppid];
            }
            
            //if file is not present then find the related details of the system to sync to bird
            system.debug('listOnBoarding[0].Desired_HQ_Name__c' + listOnBoarding[0].Desired_HQ_Name__c);
            system.debug('lstOpp[0].Addendum_Start_Date__c' + lstOpp[0].Addendum_Start_Date__c);
            system.debug('lstOpp[0].Addendum_End_Date__c' + lstOpp[0].Addendum_End_Date__c);
            
            if(listOnBoarding[0].Desired_HQ_Name__c != null && lstOpp[0].Addendum_Start_Date__c != null && lstOpp[0].Addendum_End_Date__c != null )
            {
                if(listOnBoarding[0].opportunity__c != null)
                {                    
                    String RecordTypeName =listOnBoarding[0].opportunity__r.RecordType.Name;
                    String SubCategoryName = listOnBoarding[0].Opportunity__r.Sub_Category_Formula__c;
                    STRING MODE='';
                    STRING SURFACEMODE='';
                    STRING EXPRESSMODE='';
                    if((RecordTypeName == 'Standard Shipping')|| (RecordTypeName == 'Express Shipping'))
                    MODE = RecordTypeName == 'Standard Shipping' ? '\'S\'' : '\'E\',\'S\'' ;  
                    else if(RecordTypeName == 'C2C' && (SubCategoryName == 'Franchise' || SubCategoryName == 'Mail-Room	'))
                    {
                        MODE = '\'S\',\'E\'';
                        SURFACEMODE='\'S\'';
                        EXPRESSMODE='\'E\'';
                    }
                   // STRING MODE = RecordTypeName == 'Standard Shipping' ? '\'S\'' : '\'E\',\'S\'' ;  
                    
                    list <Opportunitylineitem> lstoppitem = new List<Opportunitylineitem>();
                    
                    DescribeSObjectResult describeResult = Opportunitylineitem.getSObjectType().getDescribe();
                    List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
                    
                    String query = 'SELECT ' + String.join( fieldNames, ',' );
                    query += ' FROM '+ describeResult.getName() + 
                        ' WHERE OpportunityId = '+ '\''+ oppid + '\'' + 
                        ' AND IsActive__c = true ORDER BY NAME'; 
                    
                    Datetime dateTimetemp = (Datetime)lstOpp[0].Addendum_Start_Date__c;
                    String addendumStartDate = dateTimetemp.format('yyyy-MM-dd');
                    
                    Datetime dateTimetemp1 = (Datetime)lstOpp[0].Addendum_End_Date__c;
                    String addendumEndDate = dateTimetemp1.format('yyyy-MM-dd');
                    
                    lstoppitem = Database.query(query);
                    if(lstoppitem != null && lstoppitem.size() > 0)
                    {
                        if(MODE == '\'S\'') // if record type is Standard Shipping
                        {
                            jsonfile = +'{'+
                                +'"client": "'+ listOnBoarding[0].Desired_HQ_Name__c +'",'+
                                +'"valid_from": "'+ addendumStartDate +'",'+
                                +'"valid_to":"'+ addendumEndDate +'",'+
                                +'"cod_limit": '+ string.valueof(lstoppitem[0].COD_Charges__c != null ? lstoppitem[0].COD_Charges__c : 0.00 )+','+
                                +'"cod_factor": '+ string.valueof(lstoppitem[0].COD_Value__c != null ? lstoppitem[0].COD_Value__c : 0.00) +','+
                                +'"cod_max_limit":'+ string.valueof(lstoppitem[0].COD_Charges__c != null ? lstoppitem[0].COD_Charges__c : 0.00) +','+
                                +'"fuel_surcharge": '+ string.valueof(lstoppitem[0].Fuel_Surcharge__c != null ? lstoppitem[0].Fuel_Surcharge__c : 0.00) +','+
                                +'"wod_flat": '+ string.valueof(lstoppitem[0].Wallet_Transaction_Charge__c != null ? lstoppitem[0].Wallet_Transaction_Charge__c : 0.00) +','+
                                +'"wod_factor": '+ string.valueof(lstoppitem[0].Wallet_Transaction_Rate__c != null ? lstoppitem[0].Wallet_Transaction_Rate__c : 0.00) +','+
                                 +'"pod_charges":['+
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lcc",'+
                                +'"lower_amt":0.0,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].CC_Flat__c != null ? lstoppitem[0].CC_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].CC_percentage__c != null ? lstoppitem[0].CC_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"ldc",'+
                                +'"lower_amt":0.0,'+
                                +'"upper_amt":1999.0,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].DC_Flat__c != null ? lstoppitem[0].DC_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].DC_percentage__c != null ? lstoppitem[0].DC_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"ldc",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].DC_Flat_Greater_then_2k__c != null ? lstoppitem[0].DC_Flat_Greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].DC_Percent_Greater_then_2k__c != null ? lstoppitem[0].DC_Percent_Greater_then_2k__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"HDFB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"ICIB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"SBIB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"162B",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"YESB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"other",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat_for_other_bank__c != null ? lstoppitem[0].NB_Flat_for_other_bank__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percent_For_Other_Bank__c != null ? lstoppitem[0].NB_Percent_For_Other_Bank__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lupi",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":1999.00,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].UPI_Flat__c != null ? lstoppitem[0].UPI_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].UPI_percentage__c != null ? lstoppitem[0].UPI_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lupi",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].UPI_Flat_greater_then_2k__c != null ? lstoppitem[0].UPI_Flat_greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].UPI_Percent_for_greater_then_2k__c != null ? lstoppitem[0].UPI_Percent_for_greater_then_2k__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lwlt",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].Wallet_Flat__c != null ? lstoppitem[0].Wallet_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].Wallet_percentage__c != null ? lstoppitem[0].Wallet_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrdc",'+
                                +'"lower_amt":0.0,'+
                                +'"upper_amt":1999.0,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_DC_Flat__c != null ? lstoppitem[0].QR_DC_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_DC_percentage__c != null ? lstoppitem[0].QR_DC_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrdc",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_DC_Flat_Greater_then_2k__c != null ? lstoppitem[0].QR_DC_Flat_Greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_DC_Percent_Greater_then_2k__c != null ? lstoppitem[0].QR_DC_Percent_Greater_then_2k__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrupi",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":1999.00,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_UPI_Flat__c != null ? lstoppitem[0].QR_UPI_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_UPI_percentage__c != null ? lstoppitem[0].QR_UPI_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrupi",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_UPI_Flat_greater_then_2k__c != null ? lstoppitem[0].QR_UPI_Flat_greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_UPI_Percent_for_greater_then_2k__c != null ? lstoppitem[0].QR_UPI_Percent_for_greater_then_2k__c : 0.00 )+''+
                                +'}'+
                                +'],'+
                                
                             
                                +'"ccod_charges": ['+
                                +'{'+
                                +'"type": "cc",'+
                                +'"lower_amt": 0.0, '+
                                +'"upper_amt": -1,'+
                                +'"ccod_flat":'+ string.valueof(lstoppitem[0].Credit_Card_Transaction_Charge__c != null ? lstoppitem[0].Credit_Card_Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor":'+ string.valueof(lstoppitem[0].Credit_Card_Rates__c != null ? lstoppitem[0].Credit_Card_Rates__c : 0.00)+''+
                                +'},'+
                                +'{'+
                                +'"type": "dc",'+
                                +'"lower_amt": 0.0, '+
                                +'"upper_amt": '+ string.valueof(lstoppitem[0].Threshold_Charge__c != null ? lstoppitem[0].Threshold_Charge__c : 0.00) +','+
                                +'"ccod_flat": '+ string.valueof(lstoppitem[0].Transaction_Charge__c != null ? lstoppitem[0].Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor": '+ string.valueof(lstoppitem[0].Debit_Before_Rates__c != null ? lstoppitem[0].Debit_Before_Rates__c : 0.00) +''+
                                +'},'+
                                +'{'+
                                +'"type": "dc",'+
                                +'"lower_amt": '+ string.valueof(lstoppitem[0].Threshold_Charge__c != null ? lstoppitem[0].Threshold_Charge__c : 0.00) +','+
                                +'"upper_amt": -1,'+
                                +'"ccod_flat": '+ string.valueof(lstoppitem[0].Transaction_Charge__c != null ? lstoppitem[0].Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor": '+ string.valueof(lstoppitem[0].Debit_After_Rates__c != null ? lstoppitem[0].Debit_After_Rates__c : 0.00) +
                                +'}'+
                                + '],'+
                                +' "pricing": ['+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 3000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_A_Every_Add_500_gms_upto_3_kgs__c+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 3000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_A_Every_Additional_Slab_1_Kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_RTO_every_1_kg__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_A_RTO_every_1_kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_A_DTO_every_add_500gm__c+''+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 3000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_B_Every_Add_500_gms_upto_3_kgs__c+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 3000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_B_Every_Additional_Slab_1_Kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +' "lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_RTO_every_1_kg__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_B_RTO_every_1_kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_B_DTO_every_add_500gm__c+''+
                                +'},'+
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N1_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 3000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N1_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c+
                                +
                                +'},'+
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 3000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N1_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N1_Every_Additional_Slab_1_Kg__c+
                                +
                                +'},'+
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N1_RTO_every_1_kg__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N1_RTO_every_1_kg__c+''+
                                +'},'+
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N1_DTO_Upto_500gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N1_DTO_Upto_500gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N1_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N2_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 3000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N2_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 3000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N2_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N2_Every_Additional_Slab_1_Kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N2_RTO_every_1_kg__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N2_RTO_every_1_kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N2_DTO_Upto_500gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_N2_DTO_Upto_500gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_N2_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N1_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 3000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N1_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c+
                                +
                                +'},'+
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 3000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N1_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N1_Every_Additional_Slab_1_Kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N1_RTO_every_1_kg__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N1_RTO_every_1_kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N1_DTO_Upto_500gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N1_DTO_Upto_500gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N1_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +' "lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N2_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +' "lower_wt": 500.0,'+
                                +'"upper_wt": 3000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N2_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 3000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N2_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N2_Every_Additional_Slab_1_Kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N2_RTO_every_1_kg__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N2_RTO_every_1_kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N2_DTO_Upto_500gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_N2_DTO_Upto_500gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_N2_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 3000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_Every_additional_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 3000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_Every_Additional_Slab_1_Kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_RTO_every_1_kg__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_RTO_every_1_kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_DTO_every_add_500gm__c+
                                +'}'+
                                +']'+
                                '}';
                        }
                        else if(MODE == '\'E\',\'S\'')// if record type is Express Shipping
                        {
                            jsonfile = +'{'+
                                +'"client": "'+ listOnBoarding[0].Desired_HQ_Name__c +'",'+
                                +'"valid_from": "'+ addendumStartDate +'",'+
                                +'"valid_to":"'+ addendumEndDate +'",'+
                                +'"cod_limit": '+ string.valueof(lstoppitem[0].COD_Charges__c != null ? lstoppitem[0].COD_Charges__c : 0.00 )+','+
                                +'"cod_factor": '+ string.valueof(lstoppitem[0].COD_Value__c != null ? lstoppitem[0].COD_Value__c : 0.00) +','+
                                +'"cod_max_limit":'+ string.valueof(lstoppitem[0].COD_Charges__c != null ? lstoppitem[0].COD_Charges__c : 0.00) +','+
                                +'"fuel_surcharge":'+ string.valueof(lstoppitem[0].Fuel_Surcharge__c != null ? lstoppitem[0].Fuel_Surcharge__c : 0.00) +','+
                                +'"wod_flat": '+ string.valueof(lstoppitem[0].Wallet_Transaction_Charge__c != null ? lstoppitem[0].Wallet_Transaction_Charge__c : 0.00) +','+
                                +'"wod_factor": '+ string.valueof(lstoppitem[0].Wallet_Transaction_Rate__c != null ? lstoppitem[0].Wallet_Transaction_Rate__c : 0.00) +','+
                                 +'"pod_charges":['+
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lcc",'+
                                +'"lower_amt":0.0,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].CC_Flat__c != null ? lstoppitem[0].CC_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].CC_percentage__c != null ? lstoppitem[0].CC_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"ldc",'+
                                +'"lower_amt":0.0,'+
                                +'"upper_amt":1999.0,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].DC_Flat__c != null ? lstoppitem[0].DC_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].DC_percentage__c != null ? lstoppitem[0].DC_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"ldc",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].DC_Flat_Greater_then_2k__c != null ? lstoppitem[0].DC_Flat_Greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].DC_Percent_Greater_then_2k__c != null ? lstoppitem[0].DC_Percent_Greater_then_2k__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"HDFB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"ICIB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"SBIB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"162B",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"YESB",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat__c != null ? lstoppitem[0].NB_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percentage__c != null ? lstoppitem[0].NB_Percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lnb",'+
                                +'"bank":"other",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].NB_Flat_for_other_bank__c != null ? lstoppitem[0].NB_Flat_for_other_bank__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].NB_Percent_For_Other_Bank__c != null ? lstoppitem[0].NB_Percent_For_Other_Bank__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lupi",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":1999.00,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].UPI_Flat__c != null ? lstoppitem[0].UPI_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].UPI_percentage__c != null ? lstoppitem[0].UPI_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lupi",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].UPI_Flat_greater_then_2k__c != null ? lstoppitem[0].UPI_Flat_greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].UPI_Percent_for_greater_then_2k__c != null ? lstoppitem[0].UPI_Percent_for_greater_then_2k__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"link",'+
                                +'"subtype":"lwlt",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].Wallet_Flat__c != null ? lstoppitem[0].Wallet_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].Wallet_percentage__c != null ? lstoppitem[0].Wallet_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrdc",'+
                                +'"lower_amt":0.0,'+
                                +'"upper_amt":1999.0,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_DC_Flat__c != null ? lstoppitem[0].QR_DC_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_DC_percentage__c != null ? lstoppitem[0].QR_DC_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrdc",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_DC_Flat_Greater_then_2k__c != null ? lstoppitem[0].QR_DC_Flat_Greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_DC_Percent_Greater_then_2k__c != null ? lstoppitem[0].QR_DC_Percent_Greater_then_2k__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrupi",'+
                                +'"lower_amt":0.00,'+
                                +'"upper_amt":1999.00,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_UPI_Flat__c != null ? lstoppitem[0].QR_UPI_Flat__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_UPI_percentage__c != null ? lstoppitem[0].QR_UPI_percentage__c : 0.00 )+''+
                                +'},'+
                                
                                +'{'+
                                +'"type":"qrcode",'+
                                +'"subtype":"qrupi",'+
                                +'"lower_amt":2000,'+
                                +'"upper_amt":-1,'+
                                +'"pod_flat":'+string.valueof(lstoppitem[0].QR_UPI_Flat_greater_then_2k__c != null ? lstoppitem[0].QR_UPI_Flat_greater_then_2k__c : 0.00 )+','+
                                +'"pod_factor":'+string.valueof(lstoppitem[0].QR_UPI_Percent_for_greater_then_2k__c != null ? lstoppitem[0].QR_UPI_Percent_for_greater_then_2k__c : 0.00 )+''+
                                +'}'+
                                +'],'+
                              
                                +'"ccod_charges": ['+
                                +'{'+
                                +'"type": "cc",'+
                                +'"lower_amt": 0.0, '+
                                +'"upper_amt": -1,'+
                                +'"ccod_flat":'+ string.valueof(lstoppitem[0].Credit_Card_Transaction_Charge__c != null ? lstoppitem[0].Credit_Card_Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor":'+ string.valueof(lstoppitem[0].Credit_Card_Rates__c != null ? lstoppitem[0].Credit_Card_Rates__c : 0.00)+''+
                                +'},'+
                                +'{'+
                                +'"type": "dc",'+
                                +'"lower_amt": 0.0, '+
                                +'"upper_amt": '+ string.valueof(lstoppitem[0].Threshold_Charge__c != null ? lstoppitem[0].Threshold_Charge__c : 0.00) +','+
                                +'"ccod_flat": '+ string.valueof(lstoppitem[0].Transaction_Charge__c != null ? lstoppitem[0].Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor": '+ string.valueof(lstoppitem[0].Debit_Before_Rates__c != null ? lstoppitem[0].Debit_Before_Rates__c : 0.00) +''+
                                +'},'+
                                +'{'+
                                +'"type": "dc",'+
                                +'"lower_amt": '+ string.valueof(lstoppitem[0].Threshold_Charge__c != null ? lstoppitem[0].Threshold_Charge__c : 0.00) +','+
                                +'"upper_amt": -1,'+
                                +'"ccod_flat": '+ string.valueof(lstoppitem[0].Transaction_Charge__c != null ? lstoppitem[0].Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor": '+ string.valueof(lstoppitem[0].Debit_After_Rates__c != null ? lstoppitem[0].Debit_After_Rates__c : 0.00)+
                                +'}'+
                                + '],'+
                                +' "pricing": ['+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_A_Every_additional_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_RTO_every_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_A_RTO_every_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_A_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_A_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_B_Every_additional_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_RTO_every_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_B_RTO_every_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_B_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_B_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_Every_additional_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_RTO_every_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_RTO_every_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_C_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_C_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_Every_additional_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_RTO_every_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_RTO_every_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_D_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_D_DTO_every_add_500gm__c+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_Upto_500_gms__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_Upto_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_Every_additional_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "RTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_RTO_every_500_gms__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_RTO_every_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_DTO_Upto_500gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +MODE+'",'+
                                +'"status": "DTO",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_DTO_Upto_500gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_DTO_every_add_500gm__c+
                                +'}'+
                                +']'+
                                '}';
                        }
                         else if(MODE == '\'S\',\'E\'')// if record Type is C2C and sub Category is Franchise
                        {
                              jsonfile = +'{'+
                                +'"client": "'+ listOnBoarding[0].Desired_HQ_Name__c +'",'+
                                +'"valid_from": "'+ addendumStartDate +'",'+
                                +'"valid_to":"'+ addendumEndDate +'",'+
                                +'"cod_limit": '+ string.valueof(lstoppitem[0].COD_Charges__c != null ? lstoppitem[0].COD_Charges__c : 0.00 )+','+
                                +'"cod_factor": '+ string.valueof(lstoppitem[0].COD_Value__c != null ? lstoppitem[0].COD_Value__c : 0.00) +','+
                                +'"cod_max_limit":'+ string.valueof(lstoppitem[0].COD_Charges__c != null ? lstoppitem[0].COD_Charges__c : 0.00) +','+
                                +'"fuel_surcharge":'+ string.valueof(lstoppitem[0].Fuel_Surcharge__c != null ? lstoppitem[0].Fuel_Surcharge__c : 0.00) +','+
                                +'"wod_flat": '+ string.valueof(lstoppitem[0].Wallet_Transaction_Charge__c != null ? lstoppitem[0].Wallet_Transaction_Charge__c : 0.00) +','+
                                +'"wod_factor": '+ string.valueof(lstoppitem[0].Wallet_Transaction_Rate__c != null ? lstoppitem[0].Wallet_Transaction_Rate__c : 0.00) +','+
                                +'"pod_charges": ['+
                                + '],'+
                                +'"ccod_charges": ['+
                                +'{'+
                                +'"type": "cc",'+
                                +'"lower_amt": 0.0, '+
                                +'"upper_amt": -1,'+
                                +'"ccod_flat":'+ string.valueof(lstoppitem[0].Credit_Card_Transaction_Charge__c != null ? lstoppitem[0].Credit_Card_Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor":'+ string.valueof(lstoppitem[0].Credit_Card_Rates__c != null ? lstoppitem[0].Credit_Card_Rates__c : 0.00)+''+
                                +'},'+
                                +'{'+
                                +'"type": "dc",'+
                                +'"lower_amt": 0.0, '+
                                +'"upper_amt": '+ string.valueof(lstoppitem[0].Threshold_Charge__c != null ? lstoppitem[0].Threshold_Charge__c : 0.00) +','+
                                +'"ccod_flat": '+ string.valueof(lstoppitem[0].Transaction_Charge__c != null ? lstoppitem[0].Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor": '+ string.valueof(lstoppitem[0].Debit_Before_Rates__c != null ? lstoppitem[0].Debit_Before_Rates__c : 0.00) +''+
                                +'},'+
                                +'{'+
                                +'"type": "dc",'+
                                +'"lower_amt": '+ string.valueof(lstoppitem[0].Threshold_Charge__c != null ? lstoppitem[0].Threshold_Charge__c : 0.00) +','+
                                +'"upper_amt": -1,'+
                                +'"ccod_flat": '+ string.valueof(lstoppitem[0].Transaction_Charge__c != null ? lstoppitem[0].Transaction_Charge__c : 0.00) +','+
                                +'"ccod_factor": '+ string.valueof(lstoppitem[0].Debit_After_Rates__c != null ? lstoppitem[0].Debit_After_Rates__c : 0.00)+
                                +'}'+
                                + '],'+
                               +' "pricing": ['+
                               
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_A_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                               
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_A_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_A_Additional_250_gms_till_500_gms__c+
                                +'},'+
                              
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_A_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_A_Additional_500_gm_till_5kg__c+
                                +'},'+
                               
                                +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_A_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_A_Additional_1kg_Above_5kg__c+
                                +'},'+  
                             
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_B_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                           
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+ lstoppitem[1].Zone_B_0_250gm__c+','+
                                +'"price_inc": '+ lstoppitem[1].Zone_B_Additional_250_gms_till_500_gms__c+
                                +'},'+
                              
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_B_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_B_Additional_500_gm_till_5kg__c+
                                +'},'+
                              
                                +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_B_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_B_Additional_1kg_Above_5kg__c+
                                +'},'+  
                               
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                  +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                              
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_C_Additional_250_gms_till_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_C_Additional_250_gms_till_500_gms__c+
                                +'},'+
                               
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_C_Additional_500_gm_till_5kg__c+
                                +'},'+
                                 +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_C_Additional_500_gm_till_5kg__c+
                                +'},'+
                                
                                +' {'+
                                +'"zone": "C1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_C_Additional_1kg_Above_5kg__c+
                                +'},'+ 
                                +' {'+
                                +'"zone": "C2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_C_Additional_1kg_Above_5kg__c+
                                +'},'+ 
                               
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                                 +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                              
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_D_Additional_250_gms_till_500_gms__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_D_Additional_250_gms_till_500_gms__c+
                                +'},'+
                               
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_D_Additional_500_gm_till_5kg__c+
                                +'},'+
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_D_Additional_500_gm_till_5kg__c+
                                +'},'+
                                
                                +' {'+
                                +'"zone": "D1",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_D_Additional_1kg_Above_5kg__c+
                                +'},'+     
                                +' {'+
                                +'"zone": "D2",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_D_Additional_1kg_Above_5kg__c+
                                +'},'+     
                               
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_E_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
                              
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_E_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_E_Additional_250_gms_till_500_gms__c+
                                +'},'+
                              
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_E_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_E_Additional_500_gm_till_5kg__c+
                                +'},'+
                               
                                +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +SURFACEMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[1].Zone_E_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[1].Zone_E_Additional_1kg_Above_5kg__c+
                                +'},'+  
                                   +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_A_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
								 +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_A_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_A_Additional_250_gms_till_500_gms__c+
                                +'},'+
								  +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_A_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_A_Additional_500_gm_till_5kg__c+
                                +'},'+
								  +' {'+
                                +'"zone": "A",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_A_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_A_Additional_1kg_Above_5kg__c+
                                +'},'+
								   +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_B_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
								     +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_B_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_B_Additional_250_gms_till_500_gms__c+
                                +'},'+
								  +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_B_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_B_Additional_500_gm_till_5kg__c+
                                +'},'+
								   +' {'+
                                +'"zone": "B",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_B_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_B_Additional_1kg_Above_5kg__c+
                                +'},'+
								 +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_C_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
								  +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_C_Additional_250_gms_till_500_gms__c+
                                +'},'+
								 +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_C_Additional_500_gm_till_5kg__c+
                                +'},'+
								 +' {'+
                                +'"zone": "C",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_C_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_C_Additional_1kg_Above_5kg__c+
                                +'},'+
								 +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_D_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
								  +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_D_Additional_250_gms_till_500_gms__c+
                                +'},'+
								 +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_D_Additional_500_gm_till_5kg__c+
                                +'},'+
								 +' {'+
                                +'"zone": "D",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_D_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_D_Additional_1kg_Above_5kg__c+
                                +'},'+
								 +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 0.0,'+
                                +'"upper_wt": 250.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_E_0_250gm__c+','+
                                +'"price_inc": 0.0'+
                                +'},'+
								  +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 250.0,'+
                                +'"upper_wt": 500.0,'+
                                +'"wt_slab": 250.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_E_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_E_Additional_250_gms_till_500_gms__c+
                                +'},'+
								  +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 500.0,'+
                                +'"upper_wt": 5000.0,'+
                                +'"wt_slab": 500.0,'+
                                +'"base_price": '+ lstoppitem[0].Zone_E_0_250gm__c+','+
                                +'"price_inc": '+ lstoppitem[0].Zone_E_Additional_500_gm_till_5kg__c+
                                +'},'+
								  +' {'+
                                +'"zone": "E",'+
                                +'"mode": "' +EXPRESSMODE+'",'+
                                +'"status": "DL",'+
                                +'"lower_wt": 5000.0,'+
                                +'"upper_wt": -1,'+
                                +'"wt_slab": 1000.0,'+
                                +'"base_price": '+lstoppitem[0].Zone_E_0_250gm__c+','+
                                +'"price_inc": '+lstoppitem[0].Zone_E_Additional_1kg_Above_5kg__c+
                                +'}'+								
                                +']'+
                                '}';


                        }                        
                        system.debug('Json string ------ >' +jsonfile);
                        blob csvBlob = Blob.valueOf(jsonfile);
                        
                        String key='';    
                        String secret='';
                        // Custom setting to access the key and secret key to send file to AWS
                        AmazonS3Key__c objAmazonS3Key = AmazonS3Key__c.getValues('BirdAwsKey');
                        if(objAmazonS3Key!=null)
                        {
                            key=objAmazonS3Key.accessKeyId__c;    
                            secret=objAmazonS3Key.secretKey__c;
                        }
                        
                        System.debug('Key'+key);
                        System.debug('secret'+secret);
                        String Date1 = Datetime.now().formatGMT('EEE,   dd MMM yyyy HH:mm:ss z');
                        system.debug('Date1----->'+ Date1);
                        String bucketname = '';
                        String host = '';
                        //custom setting to access bucket name and host name to set end point URL
                        Bird_bucket_url__c objBirdbucket = Bird_bucket_url__c.getValues('birdDevBucket');
                        if(objBirdbucket!=null)
                        {
                            bucketname = objBirdbucket.bucket__c;
                            host = objBirdbucket.host__c;
                        }
                        
                        
                        String method = 'PUT';
                        String csv=EncodingUtil.base64Encode(csvBlob);
                        String dateToday =string.valueof(system.now());
                        String newDateToday = dateToday.replaceAll(' ','-');
                        string csvname= listOnBoarding[0].id+'-'+newDateToday+'.json';
                        
                        system.debug('filename'+csvname);
                        
                        System.debug('dateToday '+newDateToday);
                        // HTTP request to send file to AWS
                        HttpRequest req = new HttpRequest();
                        req.setMethod(method);
                        req.setTimeout(120000);
                        // req.setEndpoint('https://' + bucketname +'.' + host + '/' +csvname);
                        req.setEndpoint('https://' + bucketname +'.' + host + '/salesforce/pricingrequest/' +csvname);
                        
                        
                        req.setHeader('Host', bucketname + '.' + host);
                        req.setHeader('Content-Length', string.valueOf(csv.length()));
                        req.setHeader('Content-Encoding', 'base64');
                        req.setHeader('Content-Type', 'text/csv');
                        req.setHeader('Connection', 'keep-alive');
                        req.setHeader('Date', Date1);
                        req.setHeader('ACL', 'public-read-write');
                        
                        
                        //get signature string
                        String stringToSign = 'PUT\n\ntext/csv\n'+Date1+'\n/'+bucketname+'/salesforce/pricingrequest/'+csvname;
                        system.debug('bucketname--> '+ bucketname);
                        system.debug('stringToSign--> '+ stringToSign);
                        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
                        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret));
                        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringToSign),blob.valueof(secret)); 
                        String signed = EncodingUtil.base64Encode(mac); 
                        system.debug('Signature-->'+signed);
                        
                        String authHeader = 'AWS' + ' ' + key + ':' + signed;
                        System.debug('authHeader '+authHeader);
                        
                        req.setHeader('Authorization',authHeader);
                        String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');
                        System.debug('decoded '+decoded);
                        
                        Blob csvblob1 = EncodingUtil.base64Decode(csv);
                        req.setBodyasBlob(csvblob1);
                        system.debug('Body-->'+req.getBody());
                        Http http = new Http();
                        system.debug('HTTP Request created');
                        
                        try {
                            //Execute web service call
                            HTTPResponse res = http.send(req);
                            System.debug('RESPONSE STRING: ' + res.toString());
                            System.debug('RESPONSE STATUS: '+res.getStatus());
                            System.debug('STATUS_CODE: '+res.getStatusCode());
                            System.debug('Body: '+res.getBody());
                            
                            if(res.getStatusCode() == 200)
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'File Uploaded Successfully'));
                                listOnBoarding[0].Synced_to_Bird_As_Addendum__c = true;
                                
                                if(listOnBoarding != null)
                                    update listOnBoarding;
                            }
                            else
                            {
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Something went wrong. Please connect with Admin team.'));
                            }
                            
                        } catch(System.CalloutException e)
                        {
                            system.debug('AWS Service Callout Exception: ' + e.getMessage());
                        }
                    }
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please create the Pricing for this service.'));
                        
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Update the Opportunity Information on Customer Onboarding.'));
                    
                }
            }
            else
            {
                if(listOnBoarding[0].Desired_HQ_Name__c == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Insert the Desired Hq name for respective Service.'));
                }
                
                if(lstOpp[0].Addendum_Start_Date__c == null && lstOpp[0].Addendum_End_Date__c == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Insert the Addendum Date for respective Service.'));
                    
                }
            }
        }
    }
}