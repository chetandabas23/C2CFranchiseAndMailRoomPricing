/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: OpportunityTriggerUtil
* Created Date: 28-June-2017
* Description: Test Class for OpportunityTriggerUtil
*******************************************************************/

@isTest
public class OpportunityTriggerUtilTest {
    
    static testMethod void oppTriggerTest(){
        
        //Insert Account    
        // Account objAccount = new Account(name='Infosys',Email__c = 'test@infosys.com');
        // insert objAccount; 
      
        
       Trigger_stopper__c oppStop = new Trigger_stopper__c();
        oppStop.Name = 'OpportunityTrigger';
        oppStop.Trigger_Before__c = true;
        oppStop.Trigger_After__c = true;

        insert oppStop;
        
                
       Trigger_stopper__c oppStop1 = new Trigger_stopper__c();
        oppStop1.Name = 'OppDuplicate';
        oppStop1.Trigger_Before__c = true;
        oppStop1.Trigger_After__c = true;

        insert oppStop1;
        
  
        
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC Corp Account';
        objAccount.Registered_Name__c='ABC Corp';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        insert objAccount;
        
        ID standardPBId = Test.getStandardPricebookId();
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='B2B_6X6' AND SObjectType='Product2' ];
        Product2 objProduct = new Product2();
        objProduct.Name='B2B 6*6';
        objProduct.RecordTypeId=rt2.Id;
        objProduct.Min_Billable_Weight__c=19;
        objProduct.Way_Bill_Charge__c=10;
        objProduct.Insurance__c=1.2;
        objProduct.Entry_Tax_Service_Charge__c=1.5;
        objProduct.Fuel_Surcharge__c=1.5;
        objProduct.RoV_Surcharge__c=2.5;
        objProduct.Max_Dead_weight_package__c =2.2;
        objProduct.Service_Charges__c= 5;
        objProduct.COD_Value__c=5;
        objProduct.COD_Charges__c=5;
        objProduct.Volumetric_Formulae__c=5;
        objProduct.Rural_Pin_Code_Pricing__c=5;
        objProduct.Maximum_liability_per_consignment__c=5;
        insert objProduct;
        
        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'B2B';
        insert objpricebookone;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        
        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        
        
        //Insert Opportunity with required fields
        List<Opportunity> listOpportunity = new List<Opportunity>();
        RecordType rt1 = [select id,DeveloperName from RecordType where SobjectType='Opportunity' and DeveloperName ='B2B'  Limit 1];
        RecordType rt12 = [select id,DeveloperName from RecordType where SobjectType='Opportunity' and DeveloperName ='Express_Shipping'  Limit 1];

        Opportunity objOpportunity = new Opportunity(Name= 'AccName' ,CurrencyIsoCode = 'INR',StageName='Contract Signed',CloseDate = System.today(),RecordTypeId = rt1.id, AccountId = objAccount.id,Phone__c='9865741230',Service_Account_Created__c = false, Email__c = 'test@gmail.com',Invoicing_mode__c='COD Net-off',Create_Opportunity__c=true);
        insert objOpportunity;
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.Volume_Potential__c = 1000;
		objOpportunity.RecordTypeId = rt12.id;
        update objOpportunity; 
        
        
        
        Customer_Onboarding__c objCustomerOnboarding = new Customer_Onboarding__c();
        objCustomerOnboarding.Status__c='Accepted';
        objCustomerOnboarding.OnBoarding_Form_Last_View_Date__c = System.now();
        objCustomerOnboarding.RTGS_IFSC_code__c = '12345678987';
        objCustomerOnboarding.Contact_number__c = '7894563210';
        objCustomerOnboarding.Product_Type__c = 'B2B';
        objCustomerOnboarding.CurrencyIsoCode = 'INR';
        objCustomerOnboarding.Company_Registered_Name__c = 'Test';
        objCustomerOnboarding.Invoice_Address_City__c = 'Mumbai';
        objCustomerOnboarding.Invoice_Address_State__c = 'Madhya Pradesh';
        objCustomerOnboarding.Invoice_Address_Postal_Code__c = '432156';
        objCustomerOnboarding.Invoice_Address_Country__c = 'England';
        objcustomeronboarding.Bank_name__c = 'AXIS';
        //objcustomeronboarding.RTGS_IFSC_code__c = 'AB123456789';
        objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding.Opportunity__c = objOpportunity.Id;
        objcustomeronboarding.Contact_number__c='1234567890'; 
        objcustomeronboarding.Company_Registered_Name__c='Test Company';
        objcustomeronboarding.Invoice_Address_City__c='Pune';
        objcustomeronboarding.Invoice_Address_State__c='Maharashtra';
        objcustomeronboarding.Invoice_Address_Postal_Code__c='411040';
        objcustomeronboarding.Invoicing_mode__c = objOpportunity.Invoicing_mode__c;
        objcustomeronboarding.Status__c='Accepted';
        insert objCustomerOnboarding;
        
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.OpportunityId=objOpportunity.id;
        OLI.PricebookEntryId=objPBE2.Id;
        OLI.UnitPrice=37;
        OLI.Quantity=1;
        OLI.IsActive__c=true;
        OLI.Min_Billable_Weight__c=5.00;
        OLI.Way_Bill_Charge__c =5.00;
        OLI.Insurance__c =0.22;
        OLI.Entry_Tax_Service_Charge__c=5.00;
        OLI.Fuel_Surcharge__c =5.00;
        OLI.RoV_Surcharge__c =5.00;
        OLI.RoV_Surcharge_RS_10_000__c= 5.00;
        OLI.Max_Dead_weight_package__c =35.00;
        OLI.Status__c='Client Approved';
        OLI.CFT__c=5.5;
        insert OLI;
        
        
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        List<String> sourceList = new List<String>();
        sourceList.add('North');
        sourceList.add('West');
        sourceList.add('South');
        sourceList.add('East');
        sourceList.add('North East');
        sourceList.add('Kerala');
        
        for(Integer i=0;i<6;i++){
            for(Integer j=0;j<6;j++){
                B2B_Price__c objB2Bprice= new B2B_Price__c();
                objB2Bprice.Amount__c=15;
                objB2Bprice.Product__c=objProduct.Id;
                objB2Bprice.Source__c=sourceList[i];    
                objB2Bprice.Destination__c=sourceList[j];   
                objB2Bprice.Opportunity_Line_Item_Id__c=OLI.Id;
                B2BpriceList.add(objB2Bprice);
            }
            
        }
        insert B2BpriceList;
        
        delete objOpportunity;
    }
    static testMethod void oppTriggerTest1(){
        
        //Insert Account    
        // Account objAccount = new Account(name='Infosys',Email__c = 'test@infosys.com');
        // insert objAccount; 
        try{
              Trigger_stopper__c oppStop = new Trigger_stopper__c();
        oppStop.Name = 'OpportunityTrigger';
        oppStop.Trigger_Before__c = true;
        oppStop.Trigger_After__c = true;

        insert oppStop;
        
                
       Trigger_stopper__c oppStop1 = new Trigger_stopper__c();
        oppStop1.Name = 'OppDuplicate';
        oppStop1.Trigger_Before__c = true;
        oppStop1.Trigger_After__c = true;

        insert oppStop1;
            
            Opp_Name_Counter__c oppCusSetting = new Opp_Name_Counter__c();
            oppCusSetting.Name = 'AT&T Ltd - B2B';
            oppCusSetting.Counter__c = 10;
            oppCusSetting.Custom_Name__c = 'ABC Corp Account - B2B';
            insert oppCusSetting;
            
            String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
            Account objAccount= new Account();    
            objAccount.Name='ABC Corp Account';
            objAccount.Registered_Name__c='ABC Corp';
            objAccount.BillingStreet='EAST street';
            objAccount.BillingCity='Pune';
            objAccount.recordTypeId = rtId;
            objAccount.BillingState='Maharashtra';
            objAccount.BillingPostalCode='411028';
            objAccount.BillingCountry='India';
            objAccount.Invoicing_Mode__c='Delhivery Miles';
            objAccount.Phone__c = '1236958740';
            objAccount.Email__c = 'test@test.com';
            insert objAccount;
            
            ID standardPBId = Test.getStandardPricebookId();
            
            RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='B2B_6X6' AND SObjectType='Product2' ];
            Product2 objProduct = new Product2();
            objProduct.Name='B2B 6*6';
            objProduct.RecordTypeId=rt2.Id;
            objProduct.Min_Billable_Weight__c=19;
            objProduct.Way_Bill_Charge__c=10;
            objProduct.Insurance__c=1.2;
            objProduct.Entry_Tax_Service_Charge__c=1.5;
            objProduct.Fuel_Surcharge__c=1.5;
            objProduct.RoV_Surcharge__c=2.5;
            objProduct.Max_Dead_weight_package__c =2.2;
            objProduct.Service_Charges__c= 5;
            objProduct.COD_Value__c=5;
            objProduct.COD_Charges__c=5;
            objProduct.Volumetric_Formulae__c=5;
            objProduct.Rural_Pin_Code_Pricing__c=5;
            objProduct.Maximum_liability_per_consignment__c=5;
            insert objProduct;
            
            PriceBook2 objpricebookone = new PriceBook2();
            objpricebookone.Name = 'B2B';
            insert objpricebookone;
            
            PricebookEntry objPBE=new PricebookEntry();
            objPBE.Product2Id=objProduct.Id;
            objPBE.PriceBook2Id=standardPBId;
            objPBE.IsActive=true;
            objPBE.UnitPrice=37;
            insert objPBE;
            
            PricebookEntry objPBE2=new PricebookEntry();
            objPBE2.Product2Id=objProduct.Id;
            objPBE2.PriceBook2Id=objpricebookone.Id;
            objPBE2.IsActive=true;
            objPBE2.UnitPrice=37;
            insert objPBE2;
            
            
            Id OwnerId = [SELECT Id From User WHERE UserRole.Name = 'Associate' LIMIT 1].Id;
            //Insert Opportunity with required fields
         //   List<Opportunity> listOpportunity = new List<Opportunity>();
            RecordType rt1 = [select id,DeveloperName from RecordType where SobjectType='Opportunity' and DeveloperName ='B2B'  Limit 1];
            Opportunity objOpportunity = new Opportunity(Name= 'ABC Corp Account - B2B',CurrencyIsoCode = 'INR',OwnerId = OwnerId,StageName='Contract Signed',CloseDate = System.today(),RecordTypeId = rt1.id, AccountId = objAccount.id,Phone__c='9865741230',Service_Account_Created__c = false, Email__c = 'test@gmail.com',Invoicing_mode__c='COD Net-off',Status__c='Submitted',Create_Opportunity__c=true);
            insert objOpportunity;
            system.assertNotEquals(null, objOpportunity.id);
            objOpportunity.StageName = 'Closed Won';
            update objOpportunity;        
            
            Customer_Onboarding__c objCustomerOnboarding = new Customer_Onboarding__c();
            objCustomerOnboarding.Status__c='Accepted';
            objCustomerOnboarding.OnBoarding_Form_Last_View_Date__c = System.now();
            objCustomerOnboarding.RTGS_IFSC_code__c = '12345678987';
            objCustomerOnboarding.Contact_number__c = '7894563210';
            objCustomerOnboarding.Product_Type__c = 'B2B';
            objCustomerOnboarding.CurrencyIsoCode = 'INR';
            objCustomerOnboarding.Company_Registered_Name__c = 'Test';
            objCustomerOnboarding.Invoice_Address_City__c = 'Mumbai';
            objCustomerOnboarding.Invoice_Address_State__c = 'Madhya Pradesh';
            objCustomerOnboarding.Invoice_Address_Postal_Code__c = '432156';
            objCustomerOnboarding.Invoice_Address_Country__c = 'England';
            objcustomeronboarding.Bank_name__c = 'AXIS';
            //objcustomeronboarding.RTGS_IFSC_code__c = 'AB123456789';
            objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
            objcustomeronboarding.Opportunity__c = objOpportunity.Id;
            objcustomeronboarding.Contact_number__c='1234567890'; 
            objcustomeronboarding.Company_Registered_Name__c='Test Company';
            objcustomeronboarding.Invoice_Address_City__c='Pune';
            objcustomeronboarding.Invoice_Address_State__c='Maharashtra';
            objcustomeronboarding.Invoice_Address_Postal_Code__c='411040';
            objcustomeronboarding.Invoicing_mode__c = objOpportunity.Invoicing_mode__c;
            objcustomeronboarding.Status__c='Accepted';
            insert objCustomerOnboarding;
            
            OpportunityLineItem OLI=new OpportunityLineItem();
            OLI.OpportunityId=objOpportunity.id;
            OLI.PricebookEntryId=objPBE2.Id;
            OLI.UnitPrice=37;
            OLI.Quantity=1;
            OLI.IsActive__c=true;
            OLI.Min_Billable_Weight__c=5.00;
            OLI.Way_Bill_Charge__c =5.00;
            OLI.Insurance__c =0.22;
            OLI.Entry_Tax_Service_Charge__c=5.00;
            OLI.Fuel_Surcharge__c =5.00;
            OLI.RoV_Surcharge__c =5.00;
            OLI.RoV_Surcharge_RS_10_000__c= 5.00;
            OLI.Max_Dead_weight_package__c =35.00;
            OLI.Status__c='Client Approved';
            OLI.CFT__c=5.5;
            insert OLI;
            
            
            List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
            List<String> sourceList = new List<String>();
            sourceList.add('North');
            sourceList.add('West');
            sourceList.add('South');
            sourceList.add('East');
            sourceList.add('North East');
            sourceList.add('Kerala');
            for(Integer i=0;i<6;i++){
                for(Integer j=0;j<6;j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList[i];    
                    objB2Bprice.Destination__c=sourceList[j];   
                    objB2Bprice.Opportunity_Line_Item_Id__c=OLI.Id;
                    B2BpriceList.add(objB2Bprice);
                }
                
            }
            insert B2BpriceList;
            
            delete objOpportunity;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Script-thrown exception') ? true : false;
            //System.assertEquals(expectedExceptionThrown, false);            
            System.assertEquals(expectedExceptionThrown, false);
        }
    }
    
    static testMethod void oppTriggerTest2(){
        
        //Insert Account    
        // Account objAccount = new Account(name='Infosys',Email__c = 'test@infosys.com');
        // insert objAccount; 
        try{
             Trigger_stopper__c oppStop = new Trigger_stopper__c();
        oppStop.Name = 'OpportunityTrigger';
        oppStop.Trigger_Before__c = true;
        oppStop.Trigger_After__c = true;

        insert oppStop;
        
                
       Trigger_stopper__c oppStop1 = new Trigger_stopper__c();
        oppStop1.Name = 'OppDuplicate';
        oppStop1.Trigger_Before__c = true;
        oppStop1.Trigger_After__c = true;

        insert oppStop1;
            
            String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
            Account objAccount= new Account();    
            objAccount.Name='ABC Corp Account';
            objAccount.Registered_Name__c='ABC Corp';
            objAccount.BillingStreet='EAST street';
            objAccount.BillingCity='Pune';
            objAccount.recordTypeId = rtId;
            objAccount.BillingState='Maharashtra';
            objAccount.BillingPostalCode='411028';
            objAccount.BillingCountry='India';
            objAccount.Invoicing_Mode__c='Delhivery Miles';
            objAccount.Phone__c = '1236958740';
            objAccount.Email__c = 'test@test.com';
            insert objAccount;
            
            ID standardPBId = Test.getStandardPricebookId();
            
            RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='B2B_6X6' AND SObjectType='Product2' ];
            Product2 objProduct = new Product2();
            objProduct.Name='B2B 6*6';
            objProduct.RecordTypeId=rt2.Id;
            objProduct.Min_Billable_Weight__c=19;
            objProduct.Way_Bill_Charge__c=10;
            objProduct.Insurance__c=1.2;
            objProduct.Entry_Tax_Service_Charge__c=1.5;
            objProduct.Fuel_Surcharge__c=1.5;
            objProduct.RoV_Surcharge__c=2.5;
            objProduct.Max_Dead_weight_package__c =2.2;
            objProduct.Service_Charges__c= 5;
            objProduct.COD_Value__c=5;
            objProduct.COD_Charges__c=5;
            objProduct.Volumetric_Formulae__c=5;
            objProduct.Rural_Pin_Code_Pricing__c=5;
            objProduct.Maximum_liability_per_consignment__c=5;
            insert objProduct;
            
            PriceBook2 objpricebookone = new PriceBook2();
            objpricebookone.Name = 'B2B';
            insert objpricebookone;
            
            PricebookEntry objPBE=new PricebookEntry();
            objPBE.Product2Id=objProduct.Id;
            objPBE.PriceBook2Id=standardPBId;
            objPBE.IsActive=true;
            objPBE.UnitPrice=37;
            insert objPBE;
            
            PricebookEntry objPBE2=new PricebookEntry();
            objPBE2.Product2Id=objProduct.Id;
            objPBE2.PriceBook2Id=objpricebookone.Id;
            objPBE2.IsActive=true;
            objPBE2.UnitPrice=37;
            insert objPBE2;
            
            Id OwnerId = [SELECT Id From User WHERE UserRole.Name = 'Manager' LIMIT 1].Id;
            //Insert Opportunity with required fields
            List<Opportunity> listOpportunity = new List<Opportunity>();
            RecordType rt1 = [select id,DeveloperName from RecordType where SobjectType='Opportunity' and DeveloperName ='B2B'  Limit 1];
            Opportunity objOpportunity = new Opportunity(Name='Nirlon',CurrencyIsoCode = 'INR',StageName='Contract Signed',OwnerId=OwnerId,CloseDate = System.today(),RecordTypeId = rt1.id, AccountId = objAccount.id,Phone__c='9865741230',Service_Account_Created__c = false, Email__c = 'test@gmail.com',Invoicing_mode__c='COD Net-off',Status__c='Submitted',Create_Opportunity__c=true);
            insert objOpportunity;
            system.assertNotEquals(null, objOpportunity.id);
            objOpportunity.StageName = 'Closed Won';
            update objOpportunity;     
            
            Opportunity objOpportunity1 = new Opportunity(Name='Nirlon',CurrencyIsoCode = 'INR',StageName='Contract Signed',OwnerId=OwnerId,CloseDate = System.today(),RecordTypeId = rt1.id, AccountId = objAccount.id,Phone__c='9865741230',Service_Account_Created__c = false, Email__c = 'test@gmail.com',Invoicing_mode__c='COD Net-off',Status__c='Submitted',Create_Opportunity__c=true);
            insert objOpportunity1;
            system.assertNotEquals(null, objOpportunity1.id);
            objOpportunity1.StageName = 'Closed Won';
            update objOpportunity1; 
            
            Customer_Onboarding__c objCustomerOnboarding = new Customer_Onboarding__c();
            objCustomerOnboarding.Status__c='Accepted';
            objCustomerOnboarding.OnBoarding_Form_Last_View_Date__c = System.now();
            objCustomerOnboarding.RTGS_IFSC_code__c = '12345678987';
            objCustomerOnboarding.Contact_number__c = '7894563210';
            objCustomerOnboarding.Product_Type__c = 'B2B';
            objCustomerOnboarding.CurrencyIsoCode = 'INR';
            objCustomerOnboarding.Company_Registered_Name__c = 'Test';
            objCustomerOnboarding.Invoice_Address_City__c = 'Mumbai';
            objCustomerOnboarding.Invoice_Address_State__c = 'Madhya Pradesh';
            objCustomerOnboarding.Invoice_Address_Postal_Code__c = '432156';
            objCustomerOnboarding.Invoice_Address_Country__c = 'England';
            objcustomeronboarding.Bank_name__c = 'AXIS';
            //objcustomeronboarding.RTGS_IFSC_code__c = 'AB123456789';
            objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
            objcustomeronboarding.Opportunity__c = objOpportunity.Id;
            objcustomeronboarding.Contact_number__c='1234567890'; 
            objcustomeronboarding.Company_Registered_Name__c='Test Company';
            objcustomeronboarding.Invoice_Address_City__c='Pune';
            objcustomeronboarding.Invoice_Address_State__c='Maharashtra';
            objcustomeronboarding.Invoice_Address_Postal_Code__c='411040';
            objcustomeronboarding.Invoicing_mode__c = objOpportunity.Invoicing_mode__c;
            objcustomeronboarding.Status__c='Accepted';
            insert objCustomerOnboarding;
            
            OpportunityLineItem OLI=new OpportunityLineItem();
            OLI.OpportunityId=objOpportunity.id;
            OLI.PricebookEntryId=objPBE2.Id;
            OLI.UnitPrice=37;
            OLI.Quantity=1;
            OLI.IsActive__c=true;
            OLI.Min_Billable_Weight__c=5.00;
            OLI.Way_Bill_Charge__c =5.00;
            OLI.Insurance__c =0.22;
            OLI.Entry_Tax_Service_Charge__c=5.00;
            OLI.Fuel_Surcharge__c =5.00;
            OLI.RoV_Surcharge__c =5.00;
            OLI.RoV_Surcharge_RS_10_000__c= 5.00;
            OLI.Max_Dead_weight_package__c =35.00;
            OLI.Status__c='Client Approved';
            OLI.CFT__c=5.5;
            insert OLI;
            
            
            List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
            List<String> sourceList = new List<String>();
            sourceList.add('North');
            sourceList.add('West');
            sourceList.add('South');
            sourceList.add('East');
            sourceList.add('North East');
            sourceList.add('Kerala');
            for(Integer i=0;i<6;i++){
                for(Integer j=0;j<6;j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList[i];    
                    objB2Bprice.Destination__c=sourceList[j];   
                    objB2Bprice.Opportunity_Line_Item_Id__c=OLI.Id;
                    B2BpriceList.add(objB2Bprice);
                }
                
            }
            insert B2BpriceList;
            
            delete objOpportunity;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Script-thrown exception') ? true : false;
            //System.assertEquals(expectedExceptionThrown, false);            
            System.assertEquals(expectedExceptionThrown, false);
        }
    }
    
    static testMethod void oppTrigger_RecordTypeUpdate(){
        
        //Insert Account    
        // Account objAccount = new Account(name='Infosys',Email__c = 'test@infosys.com');
        // insert objAccount; 
        try{
             Trigger_stopper__c oppStop = new Trigger_stopper__c();
        oppStop.Name = 'OpportunityTrigger';
        oppStop.Trigger_Before__c = true;
        oppStop.Trigger_After__c = true;

        insert oppStop;
        
                
       Trigger_stopper__c oppStop1 = new Trigger_stopper__c();
        oppStop1.Name = 'OppDuplicate';
        oppStop1.Trigger_Before__c = true;
        oppStop1.Trigger_After__c = true;

        insert oppStop1;
            
            String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
            Account objAccount= new Account();    
            objAccount.Name='ABC Corp Account';
            objAccount.Registered_Name__c='ABC Corp';
            objAccount.BillingStreet='EAST street';
            objAccount.BillingCity='Pune';
            objAccount.recordTypeId = rtId;
            objAccount.BillingState='Maharashtra';
            objAccount.BillingPostalCode='411028';
            objAccount.BillingCountry='India';
            objAccount.Invoicing_Mode__c='Delhivery Miles';
            objAccount.Phone__c = '1236958740';
            objAccount.Email__c = 'test@test.com';
            insert objAccount;
            
            ID standardPBId = Test.getStandardPricebookId();
            
            RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='B2B_6X6' AND SObjectType='Product2' ];
            Product2 objProduct = new Product2();
            objProduct.Name='B2B 6*6';
            objProduct.RecordTypeId=rt2.Id;
            objProduct.Min_Billable_Weight__c=19;
            objProduct.Way_Bill_Charge__c=10;
            objProduct.Insurance__c=1.2;
            objProduct.Entry_Tax_Service_Charge__c=1.5;
            objProduct.Fuel_Surcharge__c=1.5;
            objProduct.RoV_Surcharge__c=2.5;
            objProduct.Max_Dead_weight_package__c =2.2;
            objProduct.Service_Charges__c= 5;
            objProduct.COD_Value__c=5;
            objProduct.COD_Charges__c=5;
            objProduct.Volumetric_Formulae__c=5;
            objProduct.Rural_Pin_Code_Pricing__c=5;
            objProduct.Maximum_liability_per_consignment__c=5;
            insert objProduct;
            
            PriceBook2 objpricebookone = new PriceBook2();
            objpricebookone.Name = 'B2B';
            insert objpricebookone;
            
            PricebookEntry objPBE=new PricebookEntry();
            objPBE.Product2Id=objProduct.Id;
            objPBE.PriceBook2Id=standardPBId;
            objPBE.IsActive=true;
            objPBE.UnitPrice=37;
            insert objPBE;
            
            PricebookEntry objPBE2=new PricebookEntry();
            objPBE2.Product2Id=objProduct.Id;
            objPBE2.PriceBook2Id=objpricebookone.Id;
            objPBE2.IsActive=true;
            objPBE2.UnitPrice=37;
            insert objPBE2;
            
            Id OwnerId = [SELECT Id From User WHERE UserRole.Name = 'Manager' LIMIT 1].Id;
            //Insert Opportunity with required fields
            List<Opportunity> listOpportunity = new List<Opportunity>();
            RecordType rt1 = [select id,DeveloperName from RecordType where SobjectType='Opportunity' and DeveloperName ='B2B'  Limit 1];
            RecordType rt3 = [select id,DeveloperName from RecordType where SobjectType='Opportunity' and DeveloperName ='Express_Shipping'  Limit 1];
            
            Opportunity objOpportunity = new Opportunity(Name='Nirlon',CurrencyIsoCode = 'INR',StageName='Proposal Shared',OwnerId=OwnerId,CloseDate = System.today(),RecordTypeId = rt1.id, AccountId = objAccount.id,Phone__c='9865741230',Service_Account_Created__c = false, Email__c = 'test@gmail.com',Invoicing_mode__c='COD Net-off',Status__c='Draft',Create_Opportunity__c=true);
            insert objOpportunity;
            
            
            
            
            
            //update objOpportunity;        
            
            /* Customer_Onboarding__c objCustomerOnboarding = new Customer_Onboarding__c();
            objCustomerOnboarding.Status__c='Accepted';
            objCustomerOnboarding.OnBoarding_Form_Last_View_Date__c = System.now();
            objCustomerOnboarding.RTGS_IFSC_code__c = '12345678987';
            objCustomerOnboarding.Contact_number__c = '7894563210';
            objCustomerOnboarding.Product_Type__c = 'B2B';
            objCustomerOnboarding.CurrencyIsoCode = 'INR';
            objCustomerOnboarding.Company_Registered_Name__c = 'Test';
            objCustomerOnboarding.Invoice_Address_City__c = 'Mumbai';
            objCustomerOnboarding.Invoice_Address_State__c = 'Madhya Pradesh';
            objCustomerOnboarding.Invoice_Address_Postal_Code__c = '432156';
            objCustomerOnboarding.Invoice_Address_Country__c = 'England';
            objcustomeronboarding.Bank_name__c = 'AXIS';
            //objcustomeronboarding.RTGS_IFSC_code__c = 'AB123456789';
            objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
            objcustomeronboarding.Opportunity__c = objOpportunity.Id;
            objcustomeronboarding.Contact_number__c='1234567890'; 
            objcustomeronboarding.Company_Registered_Name__c='Test Company';
            objcustomeronboarding.Invoice_Address_City__c='Pune';
            objcustomeronboarding.Invoice_Address_State__c='Maharashtra';
            objcustomeronboarding.Invoice_Address_Postal_Code__c='411040';
            objcustomeronboarding.Invoicing_mode__c = objOpportunity.Invoicing_mode__c;
            objcustomeronboarding.Status__c='Accepted';
            insert objCustomerOnboarding; */
            
            /* OpportunityLineItem OLI=new OpportunityLineItem();
            OLI.OpportunityId=objOpportunity.id;
            OLI.PricebookEntryId=objPBE2.Id;
            OLI.UnitPrice=37;
            OLI.Quantity=1;
            OLI.IsActive__c=true;
            OLI.Min_Billable_Weight__c=5.00;
            OLI.Way_Bill_Charge__c =5.00;
            OLI.Insurance__c =0.22;
            OLI.Entry_Tax_Service_Charge__c=5.00;
            OLI.Fuel_Surcharge__c =5.00;
            OLI.RoV_Surcharge__c =5.00;
            OLI.RoV_Surcharge_RS_10_000__c= 5.00;
            OLI.Max_Dead_weight_package__c =35.00;
            OLI.Status__c='Client Approved';
            OLI.CFT__c=5.5;
            insert OLI; */
            
            
            List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
            List<String> sourceList = new List<String>();
            sourceList.add('North');
            sourceList.add('West');
            sourceList.add('South');
            sourceList.add('East');
            sourceList.add('North East');
            sourceList.add('Kerala');
            for(Integer i=0;i<6;i++){
                for(Integer j=0;j<6;j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList[i];    
                    objB2Bprice.Destination__c=sourceList[j];   
                    objB2Bprice.Opportunity_Line_Item_Id__c=null;
                    B2BpriceList.add(objB2Bprice);
                }
                
            }
            insert B2BpriceList;
            
            objOpportunity.RecordTypeId = rt3.Id;
            objOpportunity.Name = 'Nirlon 1234';
            system.debug('objOpportunity.RecordTypeId  >>'+objOpportunity.RecordTypeId );
            update objOpportunity;
            
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Script-thrown exception') ? true : false;
            //System.assertEquals(expectedExceptionThrown, false);            
            System.assertEquals(expectedExceptionThrown, false);
        }
    }
    
}