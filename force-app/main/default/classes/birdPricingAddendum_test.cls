/*****************************************************************************************
* Author : Prakhar Goyal
* Created Date : 10-01-2019
* Description : Test class for Bird Pricing Addendum class and bird JSON Response class
* Class : birdPricingAddendum && birdJsonResponse
******************************************************************************************/

@isTest
public class birdPricingAddendum_test {
    
    public static void customSetting()
    {
         AmazonS3Key__c objAmazonS3Key = new AmazonS3Key__c();
        objAmazonS3Key.Name='BirdAwsKey';
        objAmazonS3Key.accessKeyId__c='abc';
        objAmazonS3Key.secretKey__c='xyz';
        insert objAmazonS3Key ;
        system.assertNotEquals(null, objAmazonS3Key.id);
        
        Bird_bucket_url__c objBirdbucket = new Bird_bucket_url__c();
        objBirdbucket.Name = 'birdDevBucket'; 
        objBirdbucket.Bucket__c = 'https://bird-delhivery-salesforce';
        objBirdbucket.Host__c = 's3.amazonaws.com';  
        insert objBirdbucket;
        system.assertNotEquals(null, objBirdbucket.id);
    }
    
    public static testMethod void testBirdPricingCtrl()
    {
        
        RecordType Ort=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Operating Account'];
        RecordType Srt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Service Account'];
        
        customSetting();
        
        Account OpAccount= new Account();    
        OpAccount.Name='Test Account2';
        OpAccount.RecordTypeId=Ort.Id;
        OpAccount.Registered_Name__c='Test ';
        OpAccount.BillingStreet='Test Street ';
        OpAccount.BillingCity='Mumbai';
        OpAccount.BillingState='Maharashtra';
        OpAccount.BillingPostalCode='411040';
        OpAccount.BillingCountry='India';
        OpAccount.Invoicing_Mode__c='Prepaid';
        OpAccount.Phone__c='7042832255';
        OpAccount.Company_Registered_Name__c='Test Operating';
        insert OpAccount;
        system.assertNotEquals(null, OpAccount.id);
        
        Account SrAccount= new Account();    
        SrAccount.Name='Test Account12673';
        SrAccount.ParentId=OpAccount.Id;
        SrAccount.RecordTypeId=Srt.Id;
        SrAccount.Registered_Name__c='TestMe';
        SrAccount.BillingStreet='Test StreetMe';
        SrAccount.BillingCity='Mumbai';
        SrAccount.BillingState='Maharashtra';
        SrAccount.BillingPostalCode='411040';
        SrAccount.BillingCountry='India';
        SrAccount.Invoicing_Mode__c='Prepaid';
        SrAccount.Phone__c='7042832255';
        SrAccount.Company_Registered_Name__c='Test Service';
        SrAccount.Client_Id__c = '12345';
        SrAccount.Contract_Start_Date__c = system.today();
        SrAccount.Contract_End_Date__c = system.today().adddays(5);
        insert SrAccount;
        system.assertNotEquals(null, SrAccount.id);
        
        
        RecordType Exprt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='Express Shipping'];
        RecordType Stdrt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='Standard Shipping'];
        Date stdt2 = Date.newInstance(2019, 1, 1);
        
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.RecordTypeId=Exprt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt2;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId= SrAccount.Id;
        objOpportunity1.Operating_Account__c= OpAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '1234567891';
        objOpportunity1.status__c = 'Corporate Approved';
        objOpportunity1.Volume_Potential__c=1200;
        objOpportunity1.Create_Opportunity__c=true;
        objOpportunity1.Agreement_Start_Date__c = system.today();
        objOpportunity1.Agreement_End_Date__c = system.today().adddays(5);
        objOpportunity1.Addendum_Start_Date__c = system.today().adddays(3);
        objOpportunity1.Addendum_End_Date__c = system.today().adddays(8);
        insert objOpportunity1;
        system.assertNotEquals(null, objOpportunity1.id);
        
        Contract__c objContract = new Contract__c();
        objContract.Start_Date__c = system.today();
        objContract.End_Date__c = system.today().adddays(5);
        objContract.Description__c = 'Contract description1';
        objContract.is_Latest_Contract__c = True;
        objContract.Opportunity__c = objOpportunity1.id;
        objContract.Type__c = 'Addendum';
        insert objContract;
        
        
        
        
        ID standardPBId = Test.getStandardPricebookId();
        
        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'Express Shipping';
        insert objpricebookone;
        system.assertNotEquals(null, objpricebookone.id);
        
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Express_Shipping' AND SObjectType='Product2' ];
        Product2 objProduct = new Product2();
        objProduct.Name='B2B Lanewise';
        objProduct.RecordTypeId=rt2.Id;
        objProduct.Min_Billable_Weight__c=1;
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
        objProduct.CFT__c=5.5;
        insert objProduct;
        system.assertNotEquals(null, objProduct.id);
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        system.assertNotEquals(null, objPBE.id);
        
        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        system.assertNotEquals(null, objPBE2.id);
        
        
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.OpportunityId=objOpportunity1.id;
        OLI.PricebookEntryId=objPBE2.Id;
        OLI.UnitPrice=37;
        OLI.Quantity=1;
        OLI.IsActive__c=true;
        OLI.Min_Billable_Weight__c=5.00;
        OLI.Way_Bill_Charge__c =5.00;
        OLI.Entry_Tax_Service_Charge__c=5.00;
        OLI.RoV_Surcharge__c =5.00;
        OLI.RoV_Surcharge_RS_10_000__c= 5.00;
        OLI.Max_Dead_weight_package__c =35.00;
        OLI.Status__c='Client Approved';
        OLI.Insurance__c=0.10;
        OLI.Fuel_Surcharge__c=1; 
        OLI.CFT__c=5.0 ;
        OLI.Free_Storage_Period__c=6 ;
        OLI.Demurrage_Charges_Per_Kg_Per_day__c=1.5 ;
        OLI.Public_holiday_SundayPickup_Delivery_Rs__c=500 ;
        OLI.Liability_per_consignment__c=500; 
        OLI.Minimum_Chargeable_Weight__c=6; 
        OLI.AWB_Charges__c=1; 
        OLI.Minimum_Chargeable_Amount__c=6; 
        OLI.Delivery_re_attempt_charge_Per_Kg__c=1; 
        OLI.Delivery_re_attempt_charge_Per_MAwb__c=1; 
        OLI.Mall_Deliveries_Per_Kg__c=1; 
        OLI.Mall_Deliveries_Per_Mawb__c=1; 
        OLI.DemurrageCharges_Per_awb_per_consignment__c=1; 
        OLI.ODA_Per_Kg__c=1; 
        OLI.ODA_Per_MAwb__c=1; 
        OLI.CSD_Army_Deliveries_Rs_Per_MAwb__c=1; 
        OLI.Time_specific_deliveries_Per_KG__c=1; 
        OLI.Time_specific_deliveries_Per_MAwb__c=1; 
        OLI.ROV_on_invoice_value__c=1;
        insert OLI;
        system.assertNotEquals(null, OLI.id);
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Account__c = SrAccount.id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'test@test.com';
        //objOnboarding1.Contact__c = '9874561230';
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = null;
        objOnboarding1.Wallet_Notification_Mobile__c = '91234567890';
        objOnboarding1.Status__c = 'Draft';
        objOnboarding1.Client_Id__c =null;
        objOnboarding1.Desired_HQ_Name__c = 'Test Hq Name';
        insert objOnboarding1;
        system.assertNotEquals(null, objOnboarding1.id);
        
        
        ApexPages.StandardController COB = new ApexPages.StandardController(objOnboarding1);
        birdPricingAddendum birdPricingctrl = new birdPricingAddendum(COB);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new AmazonCalloutMock());
        birdPricingctrl.birdPricingAddendumUpload();
        birdJsonResponse.doPost(objOnboarding1.id, True, Null, 'TestRequestId');
        Test.StopTest();
        
    } 
    
    public static testMethod void testBirdPricingCtrl2()
    {
        customSetting();
        RecordType Ort=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Operating Account'];
        RecordType Srt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Service Account'];
       
        Account OpAccount= new Account();    
        OpAccount.Name='Test Account2';
        OpAccount.RecordTypeId=Ort.Id;
        OpAccount.Registered_Name__c='Test ';
        OpAccount.BillingStreet='Test Street ';
        OpAccount.BillingCity='Mumbai';
        OpAccount.BillingState='Maharashtra';
        OpAccount.BillingPostalCode='411040';
        OpAccount.BillingCountry='India';
        OpAccount.Invoicing_Mode__c='Prepaid';
        OpAccount.Phone__c='7042832255';
        OpAccount.Company_Registered_Name__c='Test Operating';
        insert OpAccount;
        system.assertNotEquals(null, OpAccount.id);
        
        Account SrAccount= new Account();    
        SrAccount.Name='Test Account12673';
        SrAccount.ParentId=OpAccount.Id;
        SrAccount.RecordTypeId=Srt.Id;
        SrAccount.Registered_Name__c='TestMe';
        SrAccount.BillingStreet='Test StreetMe';
        SrAccount.BillingCity='Mumbai';
        SrAccount.BillingState='Maharashtra';
        SrAccount.BillingPostalCode='411040';
        SrAccount.BillingCountry='India';
        SrAccount.Invoicing_Mode__c='Prepaid';
        SrAccount.Phone__c='7042832255';
        SrAccount.Company_Registered_Name__c='Test Service';
        SrAccount.Client_Id__c = '12345';
        SrAccount.Contract_Start_Date__c = system.today();
        SrAccount.Contract_End_Date__c = system.today().adddays(5);
        insert SrAccount;
        system.assertNotEquals(null, SrAccount.id);
        
        
        RecordType Exprt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='Express Shipping'];
        RecordType Stdrt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='Standard Shipping'];
        Date stdt2 = Date.newInstance(2019, 1, 1);
        
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.RecordTypeId=Stdrt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt2;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId= SrAccount.Id;
        objOpportunity1.Operating_Account__c= OpAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '1234567891';
        objOpportunity1.status__c = 'Corporate Approved';
        objOpportunity1.Volume_Potential__c=1200;
        objOpportunity1.Create_Opportunity__c=true;
        objOpportunity1.Agreement_Start_Date__c = system.today(); 
        objOpportunity1.Agreement_End_Date__c = system.today().adddays(5);
        objOpportunity1.Addendum_Start_Date__c = system.today().adddays(3);
        objOpportunity1.Addendum_End_Date__c = system.today().adddays(8);
        insert objOpportunity1;
        system.assertNotEquals(null, objOpportunity1.id);
        
        Contract__c objContract = new Contract__c();
        objContract.Start_Date__c = system.today();
        objContract.End_Date__c = system.today().adddays(5);
        objContract.Description__c = 'Contract description';
        objContract.is_Latest_Contract__c = True;
        objContract.Opportunity__c = objOpportunity1.id;
        insert objContract;

        ID standardPBId = Test.getStandardPricebookId();
        
        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'Express Shipping';
        insert objpricebookone;
        system.assertNotEquals(null, objpricebookone.id);
        
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Express_Shipping' AND SObjectType='Product2' ];
        Product2 objProduct = new Product2();
        objProduct.Name='B2B Lanewise';
        objProduct.RecordTypeId=rt2.Id;
        objProduct.Min_Billable_Weight__c=1;
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
        objProduct.CFT__c=5.5;
        insert objProduct;
        system.assertNotEquals(null, objProduct.id);
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        system.assertNotEquals(null, objPBE.id);
        
        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        system.assertNotEquals(null, objPBE2.id);
        
        
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.OpportunityId=objOpportunity1.id;
        OLI.PricebookEntryId=objPBE2.Id;
        OLI.UnitPrice=37;
        OLI.Quantity=1;
        OLI.IsActive__c=true;
        OLI.Min_Billable_Weight__c=5.00;
        OLI.Way_Bill_Charge__c =5.00;
        OLI.Entry_Tax_Service_Charge__c=5.00;
        OLI.RoV_Surcharge__c =5.00;
        OLI.RoV_Surcharge_RS_10_000__c= 5.00;
        OLI.Max_Dead_weight_package__c =35.00;
        OLI.Status__c='Client Approved';
        OLI.Insurance__c=0.10;
        OLI.Fuel_Surcharge__c=1; 
        OLI.CFT__c=5.0 ;
        OLI.Free_Storage_Period__c=6 ;
        OLI.Demurrage_Charges_Per_Kg_Per_day__c=1.5 ;
        OLI.Public_holiday_SundayPickup_Delivery_Rs__c=500 ;
        OLI.Liability_per_consignment__c=500; 
        OLI.Minimum_Chargeable_Weight__c=6; 
        OLI.AWB_Charges__c=1; 
        OLI.Minimum_Chargeable_Amount__c=6; 
        OLI.Delivery_re_attempt_charge_Per_Kg__c=1; 
        OLI.Delivery_re_attempt_charge_Per_MAwb__c=1; 
        OLI.Mall_Deliveries_Per_Kg__c=1; 
        OLI.Mall_Deliveries_Per_Mawb__c=1; 
        OLI.DemurrageCharges_Per_awb_per_consignment__c=1; 
        OLI.ODA_Per_Kg__c=1; 
        OLI.ODA_Per_MAwb__c=1; 
        OLI.CSD_Army_Deliveries_Rs_Per_MAwb__c=1; 
        OLI.Time_specific_deliveries_Per_KG__c=1; 
        OLI.Time_specific_deliveries_Per_MAwb__c=1; 
        OLI.ROV_on_invoice_value__c=1;
        insert OLI;
        system.assertNotEquals(null, OLI.id);
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Account__c = SrAccount.id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'test@test.com';
        //objOnboarding1.Contact__c = '9874561230';
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = null;
        objOnboarding1.Wallet_Notification_Mobile__c = '91234567890';
        objOnboarding1.Status__c = 'Draft';
        objOnboarding1.Client_Id__c =null;
        objOnboarding1.Desired_HQ_Name__c = 'test hq name';
        objOnboarding1.File_Uploaded__c = true;
        insert objOnboarding1;
        system.assertNotEquals(null, objOnboarding1.id);
        
        ApexPages.StandardController COB = new ApexPages.StandardController(objOnboarding1);
        birdPricingAddendum birdPricingctrl = new birdPricingAddendum(COB);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new AmazonCalloutMock());
        birdPricingctrl.birdPricingAddendumUpload();
        birdJsonResponse.doPost(objOnboarding1.id, True, 'Message', 'TestRequestId');
        Test.StopTest();
              

        
    } 
    
    public static testMethod void testBirdPricingCtrl3()
    {
        customSetting();
        
        RecordType Ort=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Operating Account'];
        RecordType Srt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Service Account'];
        
        Account OpAccount= new Account();    
        OpAccount.Name='Test Account2';
        OpAccount.RecordTypeId=Ort.Id;
        OpAccount.Registered_Name__c='Test ';
        OpAccount.BillingStreet='Test Street ';
        OpAccount.BillingCity='Mumbai';
        OpAccount.BillingState='Maharashtra';
        OpAccount.BillingPostalCode='411040';
        OpAccount.BillingCountry='India';
        OpAccount.Invoicing_Mode__c='Prepaid';
        OpAccount.Phone__c='7042832255';
        OpAccount.Company_Registered_Name__c='Test Operating';
        insert OpAccount;
        system.assertNotEquals(null, OpAccount.id);
        
        Account SrAccount= new Account();    
        SrAccount.Name='Test Account12673';
        SrAccount.ParentId=OpAccount.Id;
        SrAccount.RecordTypeId=Srt.Id;
        SrAccount.Registered_Name__c='TestMe';
        SrAccount.BillingStreet='Test StreetMe';
        SrAccount.BillingCity='Mumbai';
        SrAccount.BillingState='Maharashtra';
        SrAccount.BillingPostalCode='411040';
        SrAccount.BillingCountry='India';
        SrAccount.Invoicing_Mode__c='Prepaid';
        SrAccount.Phone__c='7042832255';
        SrAccount.Company_Registered_Name__c='Test Service';
        SrAccount.Client_Id__c = '12345';
        SrAccount.Contract_Start_Date__c = system.today();
        SrAccount.Contract_End_Date__c = system.today().adddays(5);
        insert SrAccount;
        system.assertNotEquals(null, SrAccount.id);
        
        
        RecordType Exprt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='Express Shipping'];
        RecordType Stdrt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='Standard Shipping'];
        Date stdt2 = Date.newInstance(2019, 1, 1);
        
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.RecordTypeId=Stdrt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt2;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId= SrAccount.Id;
        objOpportunity1.Operating_Account__c= OpAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '1234567891';
        objOpportunity1.status__c = 'Corporate Approved';
        objOpportunity1.Volume_Potential__c=1200;
        objOpportunity1.Create_Opportunity__c=true;
        objOpportunity1.Agreement_Start_Date__c = system.today(); 
        objOpportunity1.Agreement_End_Date__c = system.today().adddays(5);
        insert objOpportunity1;
        system.assertNotEquals(null, objOpportunity1.id);
        
        Contract__c objContract = new Contract__c();
        objContract.Start_Date__c = system.today();
        objContract.End_Date__c = system.today().adddays(5);
        objContract.Description__c = 'Contract description';
        objContract.is_Latest_Contract__c = True;
        objContract.Opportunity__c = objOpportunity1.id;
        insert objContract;

        ID standardPBId = Test.getStandardPricebookId();
        
        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'Express Shipping';
        insert objpricebookone;
        system.assertNotEquals(null, objpricebookone.id);
        
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Express_Shipping' AND SObjectType='Product2' ];
        Product2 objProduct = new Product2();
        objProduct.Name='B2B Lanewise';
        objProduct.RecordTypeId=rt2.Id;
        objProduct.Min_Billable_Weight__c=1;
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
        objProduct.CFT__c=5.5;
        insert objProduct;
        system.assertNotEquals(null, objProduct.id);
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        system.assertNotEquals(null, objPBE.id);
        
        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        system.assertNotEquals(null, objPBE2.id);
        
        
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.OpportunityId=objOpportunity1.id;
        OLI.PricebookEntryId=objPBE2.Id;
        OLI.UnitPrice=37;
        OLI.Quantity=1;
        OLI.IsActive__c=true;
        OLI.Min_Billable_Weight__c=5.00;
        OLI.Way_Bill_Charge__c =5.00;
        OLI.Entry_Tax_Service_Charge__c=5.00;
        OLI.RoV_Surcharge__c =5.00;
        OLI.RoV_Surcharge_RS_10_000__c= 5.00;
        OLI.Max_Dead_weight_package__c =35.00;
        OLI.Status__c='Client Approved';
        OLI.Insurance__c=0.10;
        OLI.Fuel_Surcharge__c=1; 
        OLI.CFT__c=5.0 ;
        OLI.Free_Storage_Period__c=6 ;
        OLI.Demurrage_Charges_Per_Kg_Per_day__c=1.5 ;
        OLI.Public_holiday_SundayPickup_Delivery_Rs__c=500 ;
        OLI.Liability_per_consignment__c=500; 
        OLI.Minimum_Chargeable_Weight__c=6; 
        OLI.AWB_Charges__c=1; 
        OLI.Minimum_Chargeable_Amount__c=6; 
        OLI.Delivery_re_attempt_charge_Per_Kg__c=1; 
        OLI.Delivery_re_attempt_charge_Per_MAwb__c=1; 
        OLI.Mall_Deliveries_Per_Kg__c=1; 
        OLI.Mall_Deliveries_Per_Mawb__c=1; 
        OLI.DemurrageCharges_Per_awb_per_consignment__c=1; 
        OLI.ODA_Per_Kg__c=1; 
        OLI.ODA_Per_MAwb__c=1; 
        OLI.CSD_Army_Deliveries_Rs_Per_MAwb__c=1; 
        OLI.Time_specific_deliveries_Per_KG__c=1; 
        OLI.Time_specific_deliveries_Per_MAwb__c=1; 
        OLI.ROV_on_invoice_value__c=1;
        insert OLI;
        system.assertNotEquals(null, OLI.id);
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Account__c = SrAccount.id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'test@test.com';
        //objOnboarding1.Contact__c = '9874561230';
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = null;
        objOnboarding1.Wallet_Notification_Mobile__c = '91234567890';
        objOnboarding1.Status__c = 'Draft';
        objOnboarding1.Client_Id__c =null;
        objOnboarding1.Desired_HQ_Name__c = 'test hq name';
        insert objOnboarding1;
        system.assertNotEquals(null, objOnboarding1.id);
        
        ApexPages.StandardController COB = new ApexPages.StandardController(objOnboarding1);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new AmazonCalloutMock());
        birdJsonResponse.doPost('', True, '', 'TestRequestId');
        Test.StopTest();
              

        
    } 
    public static testMethod void testBirdPricingCtrl4()
    {
        
        RecordType Ort=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Operating Account'];
        RecordType Srt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Account' AND  Name='Service Account'];
        
        customSetting();
        
        Account OpAccount= new Account();    
        OpAccount.Name='Test Account2';
        OpAccount.RecordTypeId=Ort.Id;
        OpAccount.Registered_Name__c='Test ';
        OpAccount.BillingStreet='Test Street ';
        OpAccount.BillingCity='Mumbai';
        OpAccount.BillingState='Maharashtra';
        OpAccount.BillingPostalCode='411040';
        OpAccount.BillingCountry='India';
        OpAccount.Invoicing_Mode__c='Prepaid';
        OpAccount.Phone__c='7042832255';
        OpAccount.Company_Registered_Name__c='Test Operating';
        insert OpAccount;
        system.assertNotEquals(null, OpAccount.id);
        
        Account SrAccount= new Account();    
        SrAccount.Name='Test Account12673';
        SrAccount.ParentId=OpAccount.Id;
        SrAccount.RecordTypeId=Srt.Id;
        SrAccount.Registered_Name__c='TestMe';
        SrAccount.BillingStreet='Test StreetMe';
        SrAccount.BillingCity='Mumbai';
        SrAccount.BillingState='Maharashtra';
        SrAccount.BillingPostalCode='411040';
        SrAccount.BillingCountry='India';
        SrAccount.Invoicing_Mode__c='Prepaid';
        SrAccount.Phone__c='7042832255';
        SrAccount.Company_Registered_Name__c='Test Service';
        SrAccount.Client_Id__c = '12345';
        SrAccount.Contract_Start_Date__c = system.today();
        SrAccount.Contract_End_Date__c = system.today().adddays(5);
        insert SrAccount;
        system.assertNotEquals(null, SrAccount.id);
        
        
        RecordType Exprt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='C2C'];
       // RecordType Stdrt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' AND Name='Standard Shipping'];
        Date stdt2 = Date.newInstance(2019, 1, 1);
        
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.Client_Category__c='C2C';
        objOpportunity1.Sub_Category__c='Franchise';
        objOpportunity1.RecordTypeId=Exprt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt2;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId= SrAccount.Id;
        objOpportunity1.Operating_Account__c= OpAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '1234567891';
        objOpportunity1.status__c = 'Corporate Approved';
        objOpportunity1.Volume_Potential__c=1200;
        objOpportunity1.Create_Opportunity__c=true;
        objOpportunity1.Agreement_Start_Date__c = system.today();
        objOpportunity1.Agreement_End_Date__c = system.today().adddays(5);
        objOpportunity1.Addendum_Start_Date__c = system.today().adddays(3);
        objOpportunity1.Addendum_End_Date__c = system.today().adddays(8);
        insert objOpportunity1;
        system.assertNotEquals(null, objOpportunity1.id);
        
        Contract__c objContract = new Contract__c();
        objContract.Start_Date__c = system.today();
        objContract.End_Date__c = system.today().adddays(5);
        objContract.Description__c = 'Contract description1';
        objContract.is_Latest_Contract__c = True;
        objContract.Opportunity__c = objOpportunity1.id;
        objContract.Type__c = 'Addendum';
        insert objContract;
        
        
        
        
        ID standardPBId = Test.getStandardPricebookId();
        
        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'C2C Pricing Model';
        insert objpricebookone;
        system.assertNotEquals(null, objpricebookone.id);
        
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Franchise_Shipping' AND SObjectType='Product2' ];
        Product2 objProduct = new Product2();
        objProduct.Name='Delhivery Commercial Express - C2C';
        objProduct.RecordTypeId=rt2.Id;
        objProduct.Min_Billable_Weight__c=1;
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
        objProduct.CFT__c=5.5;
        insert objProduct;
        system.assertNotEquals(null, objProduct.id);
        
         Product2 objProduct1 = new Product2();
        objProduct1.Name='Delhivery Commercial Standard - C2C';
        objProduct1.RecordTypeId=rt2.Id;
        objProduct1.Min_Billable_Weight__c=1;
        objProduct1.Way_Bill_Charge__c=10;
        objProduct1.Insurance__c=1.2;
        objProduct1.Entry_Tax_Service_Charge__c=1.5;
        objProduct1.Fuel_Surcharge__c=1.5;
        objProduct1.RoV_Surcharge__c=2.5;
        objProduct1.Max_Dead_weight_package__c =2.2;
        objProduct1.Service_Charges__c= 5;
        objProduct1.COD_Value__c=5;
        objProduct1.COD_Charges__c=5;
        objProduct1.Volumetric_Formulae__c=5;
        objProduct1.Rural_Pin_Code_Pricing__c=5;
        objProduct1.Maximum_liability_per_consignment__c=5;
        objProduct1.CFT__c=5.5;
        insert objProduct1;
        system.assertNotEquals(null, objProduct1.id);
          PricebookEntry objPBE1=new PricebookEntry();
        objPBE1.Product2Id=objProduct1.Id;
        objPBE1.PriceBook2Id=standardPBId;
        objPBE1.IsActive=true;
        objPBE1.UnitPrice=37;
        insert objPBE1;
        system.assertNotEquals(null, objPBE1.id);
         PricebookEntry objPBE21=new PricebookEntry();
        objPBE21.Product2Id=objProduct1.Id;
        objPBE21.PriceBook2Id=objpricebookone.Id;
        objPBE21.IsActive=true;
        objPBE21.UnitPrice=37;
        insert objPBE21;
        system.assertNotEquals(null, objPBE21.id);
        
          OpportunityLineItem OLI1=new OpportunityLineItem();
        OLI1.OpportunityId=objOpportunity1.id;
        OLI1.PricebookEntryId=objPBE21.Id;
        OLI1.UnitPrice=37;
        OLI1.Quantity=1;
        OLI1.IsActive__c=true;
        OLI1.Min_Billable_Weight__c=5.00;
        OLI1.Way_Bill_Charge__c =5.00;
        OLI1.Entry_Tax_Service_Charge__c=5.00;
        OLI1.RoV_Surcharge__c =5.00;
        OLI1.RoV_Surcharge_RS_10_000__c= 5.00;
        OLI1.Max_Dead_weight_package__c =35.00;
        OLI1.Status__c='Client Approved';
        OLI1.Insurance__c=0.10;
        OLI1.Fuel_Surcharge__c=1; 
        OLI1.CFT__c=5.0 ;
        OLI1.Free_Storage_Period__c=6 ;
        OLI1.Demurrage_Charges_Per_Kg_Per_day__c=1.5 ;
        OLI1.Public_holiday_SundayPickup_Delivery_Rs__c=500 ;
        OLI1.Liability_per_consignment__c=500; 
        OLI1.Minimum_Chargeable_Weight__c=6; 
        OLI1.AWB_Charges__c=1; 
        OLI1.Minimum_Chargeable_Amount__c=6; 
        OLI1.Delivery_re_attempt_charge_Per_Kg__c=1; 
        OLI1.Delivery_re_attempt_charge_Per_MAwb__c=1; 
        OLI1.Mall_Deliveries_Per_Kg__c=1; 
        OLI1.Mall_Deliveries_Per_Mawb__c=1; 
        OLI1.DemurrageCharges_Per_awb_per_consignment__c=1; 
        OLI1.ODA_Per_Kg__c=1; 
        OLI1.ODA_Per_MAwb__c=1; 
        OLI1.CSD_Army_Deliveries_Rs_Per_MAwb__c=1; 
        OLI1.Time_specific_deliveries_Per_KG__c=1; 
        OLI1.Time_specific_deliveries_Per_MAwb__c=1; 
        OLI1.ROV_on_invoice_value__c=1;
        insert OLI1;
        system.assertNotEquals(null, OLI1.id);
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        system.assertNotEquals(null, objPBE.id);
        
        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        system.assertNotEquals(null, objPBE2.id);
        
        
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.OpportunityId=objOpportunity1.id;
        OLI.PricebookEntryId=objPBE2.Id;
        OLI.UnitPrice=37;
        OLI.Quantity=1;
        OLI.IsActive__c=true;
        OLI.Min_Billable_Weight__c=5.00;
        OLI.Way_Bill_Charge__c =5.00;
        OLI.Entry_Tax_Service_Charge__c=5.00;
        OLI.RoV_Surcharge__c =5.00;
        OLI.RoV_Surcharge_RS_10_000__c= 5.00;
        OLI.Max_Dead_weight_package__c =35.00;
        OLI.Status__c='Client Approved';
        OLI.Insurance__c=0.10;
        OLI.Fuel_Surcharge__c=1; 
        OLI.CFT__c=5.0 ;
        OLI.Free_Storage_Period__c=6 ;
        OLI.Demurrage_Charges_Per_Kg_Per_day__c=1.5 ;
        OLI.Public_holiday_SundayPickup_Delivery_Rs__c=500 ;
        OLI.Liability_per_consignment__c=500; 
        OLI.Minimum_Chargeable_Weight__c=6; 
        OLI.AWB_Charges__c=1; 
        OLI.Minimum_Chargeable_Amount__c=6; 
        OLI.Delivery_re_attempt_charge_Per_Kg__c=1; 
        OLI.Delivery_re_attempt_charge_Per_MAwb__c=1; 
        OLI.Mall_Deliveries_Per_Kg__c=1; 
        OLI.Mall_Deliveries_Per_Mawb__c=1; 
        OLI.DemurrageCharges_Per_awb_per_consignment__c=1; 
        OLI.ODA_Per_Kg__c=1; 
        OLI.ODA_Per_MAwb__c=1; 
        OLI.CSD_Army_Deliveries_Rs_Per_MAwb__c=1; 
        OLI.Time_specific_deliveries_Per_KG__c=1; 
        OLI.Time_specific_deliveries_Per_MAwb__c=1; 
        OLI.ROV_on_invoice_value__c=1;
        insert OLI;
        system.assertNotEquals(null, OLI.id);
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Account__c = SrAccount.id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'test@test.com';
        //objOnboarding1.Contact__c = '9874561230';
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = null;
        objOnboarding1.Wallet_Notification_Mobile__c = '91234567890';
        objOnboarding1.Status__c = 'Draft';
        objOnboarding1.Client_Id__c =null;
        objOnboarding1.Desired_HQ_Name__c = 'Test Hq Name';
        insert objOnboarding1;
        system.assertNotEquals(null, objOnboarding1.id);
        
        
        ApexPages.StandardController COB = new ApexPages.StandardController(objOnboarding1);
        birdPricingAddendum birdPricingctrl = new birdPricingAddendum(COB);
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new AmazonCalloutMock());
        birdPricingctrl.birdPricingAddendumUpload();
        birdJsonResponse.doPost(objOnboarding1.id, True, Null, 'TestRequestId');
        Test.StopTest();
        
    } 
}