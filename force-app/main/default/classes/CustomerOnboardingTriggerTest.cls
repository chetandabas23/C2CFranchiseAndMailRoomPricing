@isTest
public class CustomerOnboardingTriggerTest {
    static testMethod void executeCustomerOnboardingTrigger(){
        
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
            
       
        Id expressRT=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Express_Shipping' LIMIT 1].Id;
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;       
        objOpportunity.OwnerId= u.Id;       
        objOpportunity.Create_Opportunity__c= true;   
        Insert objOpportunity;

         Test.startTest();
        
        Customer_Onboarding__c objcustomeronboarding = new Customer_Onboarding__c();
        objcustomeronboarding.Contact_number__c = '7894563210';
        objcustomeronboarding.Product_Type__c = 'B2B';
        objcustomeronboarding.CurrencyIsoCode = 'INR';
        objcustomeronboarding.Company_Registered_Name__c = 'Test';
        objcustomeronboarding.Return_Address_City__c = 'Pune';
        objcustomeronboarding.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding.Return_Address_Country__c = 'India';
        objcustomeronboarding.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding.Invoice_Address_Country__c = 'England';
        objcustomeronboarding.Bank_name__c = 'AXIS';
        objcustomeronboarding.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding.Opportunity__c = objOpportunity.Id;
        objcustomeronboarding.Desired_HQ_Name__c='Test';
        objcustomeronboarding.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding.Contact__c = conRecord.Id;
        objcustomeronboarding.Account__c = objAccount.Id;
        objcustomeronboarding.FRS_Code__c = '54789';   
        objcustomeronboarding.Is_Prepaid__c = false;
        objcustomeronboarding.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding;
        
        
        objcustomeronboarding.Billing_Mode__c = 'Express';
        update objcustomeronboarding;
        Test.stopTest();
        objcustomeronboarding.FRS_Code__c = '12345';
        update objcustomeronboarding;
        
        Database.DeleteResult result = Database.delete(objcustomeronboarding,false);
        //System.assert(!result.isSuccess());
       // System.assert(result.getErrors().size() > 0);
         //System.assertEquals('Onboarding form cannot be delete once submitted.',result.getErrors()[0].getMessage());
        
    }
    
    
    static testMethod void prepaidTrueConditionCheck(){
        
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
            
       
        Id expressRT=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Express_Shipping' LIMIT 1].Id;
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;       
        objOpportunity.OwnerId= u.Id;       
        objOpportunity.Invoicing_Mode__c = 'Delhivery miles';       
        objOpportunity.Create_Opportunity__c = true;       
        Insert objOpportunity;

        Test.startTest();
        
        Customer_Onboarding__c objcustomeronboarding = new Customer_Onboarding__c();
        objcustomeronboarding.Contact_number__c = '7894563210';
        objcustomeronboarding.Product_Type__c = 'B2B';
        objcustomeronboarding.CurrencyIsoCode = 'INR';
        objcustomeronboarding.Company_Registered_Name__c = 'Test';
        objcustomeronboarding.Return_Address_City__c = 'Pune';
        objcustomeronboarding.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding.Return_Address_Country__c = 'India';
        objcustomeronboarding.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding.Invoice_Address_Country__c = 'England';
        objcustomeronboarding.Bank_name__c = 'AXIS';
        objcustomeronboarding.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding.Opportunity__c = objOpportunity.Id;
        objcustomeronboarding.Desired_HQ_Name__c='Test';
        objcustomeronboarding.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding.Contact__c = conRecord.Id;
        objcustomeronboarding.Account__c = objAccount.Id;
        objcustomeronboarding.FRS_Code__c = '54789';        
        objcustomeronboarding.Is_Prepaid__c = true;
        objcustomeronboarding.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding.Wallet_Notification_Mobile__c  = null;                
        Insert objcustomeronboarding;
        
        objcustomeronboarding.Billing_Mode__c = 'Express';
        update objcustomeronboarding;
        
        Test.stopTest();
    }
    
    static testMethod void prepaidTrueConditionCheck_1(){
        
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
            
       
        Id expressRT=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Express_Shipping' LIMIT 1].Id;
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;       
        objOpportunity.OwnerId= u.Id;       
        objOpportunity.Invoicing_Mode__c = 'Delhivery miles';
        objOpportunity.Create_Opportunity__c = true;
        Insert objOpportunity;

        Test.startTest();
        
        Customer_Onboarding__c objcustomeronboarding = new Customer_Onboarding__c();
        objcustomeronboarding.Contact_number__c = '7894563210';
        objcustomeronboarding.Product_Type__c = 'B2B';
        objcustomeronboarding.CurrencyIsoCode = 'INR';
        objcustomeronboarding.Company_Registered_Name__c = 'Test';
        objcustomeronboarding.Return_Address_City__c = 'Pune';
        objcustomeronboarding.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding.Return_Address_Country__c = 'India';
        objcustomeronboarding.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding.Invoice_Address_Country__c = 'England';
        objcustomeronboarding.Bank_name__c = 'AXIS';
        objcustomeronboarding.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding.Opportunity__c = objOpportunity.Id;
        objcustomeronboarding.Desired_HQ_Name__c='Test';
        objcustomeronboarding.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding.Contact__c = conRecord.Id;
        objcustomeronboarding.Account__c = objAccount.Id;
        objcustomeronboarding.FRS_Code__c = '54789';        
        objcustomeronboarding.Is_Prepaid__c = true;        
        objcustomeronboarding.Wallet_Notification_Email__c  = 'test@tech.com';        
        objcustomeronboarding.Wallet_Notification_Mobile__c  = '9874563210';        
        Insert objcustomeronboarding;
        system.debug('objcustomeronboarding in test class>>'+objcustomeronboarding);
        
        objcustomeronboarding.Billing_Mode__c = 'Express';
        update objcustomeronboarding;
        Test.stopTest();
    }
    
    
    static testMethod void prepaidTrueConditionCheck_2(){
        
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1;

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        objAccount.External_ID__c = 'ABCDE';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
            
       
        Id expressRT=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'Express_Shipping' LIMIT 1].Id;
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;       
        objOpportunity.OwnerId= u.Id;       
        objOpportunity.Invoicing_Mode__c = 'Delhivery miles';       
        objOpportunity.Create_Opportunity__c = true;
        Insert objOpportunity;
        
        Id expressRT1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'SaaS' LIMIT 1].Id;
        Opportunity objOpportunity1=new Opportunity();
        objOpportunity1.Name = 'Test';
        objOpportunity1.StageName = 'Proposal Shared';
        objOpportunity1.AccountId =objAccount.Id;
        objOpportunity1.RecordTypeId=expressRT1;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity1.CloseDate = system.today(); 
        objOpportunity1.Volume_Potential__c=100;       
        objOpportunity1.OwnerId= u.Id;       
        objOpportunity1.Invoicing_Mode__c = 'Delhivery miles';       
        objOpportunity1.Create_Opportunity__c = true;
        Insert objOpportunity1;
        
        Id expressRT2=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'International' LIMIT 1].Id;
        Opportunity objOpportunity2=new Opportunity();
        objOpportunity2.Name = 'Test';
        objOpportunity2.StageName = 'Proposal Shared';
        objOpportunity2.AccountId =objAccount.Id;
        objOpportunity2.RecordTypeId=expressRT2;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity2.CloseDate = system.today(); 
        objOpportunity2.Volume_Potential__c=100;       
        objOpportunity2.OwnerId= u.Id;       
        objOpportunity2.Invoicing_Mode__c = 'Delhivery miles';       
        objOpportunity2.Create_Opportunity__c = true;
        Insert objOpportunity2;

        Test.startTest();
        
        Customer_Onboarding__c objcustomeronboarding = new Customer_Onboarding__c();
        objcustomeronboarding.Contact_number__c = '7894563210';
        objcustomeronboarding.Product_Type__c = 'B2B';
        objcustomeronboarding.CurrencyIsoCode = 'INR';
        objcustomeronboarding.Company_Registered_Name__c = 'Test';
        objcustomeronboarding.Return_Address_City__c = 'Pune';
        objcustomeronboarding.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding.Return_Address_Country__c = 'India';
        objcustomeronboarding.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding.Invoice_Address_Country__c = 'England';
        objcustomeronboarding.Bank_name__c = 'AXIS';
        objcustomeronboarding.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding.Opportunity__c = objOpportunity.Id;
        objcustomeronboarding.Desired_HQ_Name__c='Test';
        objcustomeronboarding.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding.Contact__c = conRecord.Id;
        objcustomeronboarding.Account__c = objAccount.Id;
        objcustomeronboarding.FRS_Code__c = '54789';        
        objcustomeronboarding.Is_Prepaid__c = true;        
        objcustomeronboarding.Wallet_Notification_Email__c  = 'test@tech.com';        
        objcustomeronboarding.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding;
        system.debug('objcustomeronboarding in test class>>'+objcustomeronboarding);
        
        objcustomeronboarding.Billing_Mode__c = 'Express';
        update objcustomeronboarding;
        
        Customer_Onboarding__c objcustomeronboarding1 = new Customer_Onboarding__c();
        objcustomeronboarding1.Contact_number__c = '7894563210';
        objcustomeronboarding1.Product_Type__c = 'B2B';
        objcustomeronboarding1.CurrencyIsoCode = 'INR';
        objcustomeronboarding1.Company_Registered_Name__c = 'Test';
        objcustomeronboarding1.Return_Address_City__c = 'Pune';
        objcustomeronboarding1.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding1.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding1.Return_Address_Country__c = 'India';
        objcustomeronboarding1.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding1.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding1.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding1.Invoice_Address_Country__c = 'England';
        objcustomeronboarding1.Bank_name__c = 'AXIS';
        objcustomeronboarding1.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding1.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding1.Opportunity__c = objOpportunity1.Id;
        objcustomeronboarding1.Desired_HQ_Name__c='Test';
        objcustomeronboarding1.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding1.Contact__c = conRecord.Id;
        objcustomeronboarding1.Account__c = objAccount.Id;
        objcustomeronboarding1.FRS_Code__c = '54789';        
        objcustomeronboarding1.Is_Prepaid__c = true;        
        objcustomeronboarding1.Wallet_Notification_Email__c  = 'test@tech.com';        
        objcustomeronboarding1.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding1;
        
        Customer_Onboarding__c objcustomeronboarding2 = new Customer_Onboarding__c();
        objcustomeronboarding2.Contact_number__c = '7894563210';
        objcustomeronboarding2.Product_Type__c = 'B2B';
        objcustomeronboarding2.CurrencyIsoCode = 'INR';
        objcustomeronboarding2.Company_Registered_Name__c = 'Test';
        objcustomeronboarding2.Return_Address_City__c = 'Pune';
        objcustomeronboarding2.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding2.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding2.Return_Address_Country__c = 'India';
        objcustomeronboarding2.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding2.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding2.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding2.Invoice_Address_Country__c = 'England';
        objcustomeronboarding2.Bank_name__c = 'AXIS';
        objcustomeronboarding2.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding2.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding2.Opportunity__c = objOpportunity2.Id;
        objcustomeronboarding2.Desired_HQ_Name__c='Test';
        objcustomeronboarding2.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding2.Contact__c = conRecord.Id;
        objcustomeronboarding2.Account__c = objAccount.Id;
        objcustomeronboarding2.FRS_Code__c = '54789';        
        objcustomeronboarding2.Is_Prepaid__c = true;        
        objcustomeronboarding2.Wallet_Notification_Email__c  = 'test@tech.com';        
        objcustomeronboarding2.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding2;
        
        Test.stopTest();
    }
    static testMethod void cashrecordtype()
    {
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1; 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC -Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        objAccount.Client_Status__c = 'Active';
        objAccount.External_ID__c = 'TEST 123';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
        
        Id expressRT5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Cash').getRecordTypeId();
        Opportunity objOpportunity5=new Opportunity();
        objOpportunity5.Name = 'Test';
        objOpportunity5.StageName = 'Proposal Shared';
        objOpportunity5.AccountId =objAccount.Id;
        objOpportunity5.RecordTypeId=expressRT5;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity5.CloseDate = system.today(); 
        objOpportunity5.Volume_Potential__c=100;       
        objOpportunity5.OwnerId= u.Id;       
        objOpportunity5.Create_Opportunity__c= true;   
        Insert objOpportunity5;
        
        Customer_Onboarding__c objcustomeronboarding5 = new Customer_Onboarding__c();
        objcustomeronboarding5.Contact_number__c = '7894563210';
        objcustomeronboarding5.Product_Type__c = 'B2B';
        objcustomeronboarding5.CurrencyIsoCode = 'INR';
        objcustomeronboarding5.Company_Registered_Name__c = 'Test';
        objcustomeronboarding5.Return_Address_City__c = 'Pune';
        objcustomeronboarding5.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding5.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding5.Return_Address_Country__c = 'India';
        objcustomeronboarding5.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding5.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding5.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding5.Invoice_Address_Country__c = 'England';
        objcustomeronboarding5.Bank_name__c = 'AXIS';
        objcustomeronboarding5.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding5.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding5.Opportunity__c = objOpportunity5.Id;
        //objcustomeronboarding.Desired_HQ_Name__c='';
        objcustomeronboarding5.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding5.Contact__c = conRecord.Id;
        objcustomeronboarding5.Account__c = objAccount.Id;
        objcustomeronboarding5.FRS_Code__c = '54789';   
        objcustomeronboarding5.Is_Prepaid__c = false;
        objcustomeronboarding5.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding5.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding5;


    }
    static testMethod void customerrecordtype()
    {
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC -Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        objAccount.Client_Status__c = 'Active';
        objAccount.External_ID__c = 'TEST 123';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
        
        Id expressRT5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Customer Acquisition').getRecordTypeId();
        Opportunity objOpportunity5=new Opportunity();
        objOpportunity5.Name = 'Test';
        objOpportunity5.StageName = 'Proposal Shared';
        objOpportunity5.AccountId =objAccount.Id;
        objOpportunity5.RecordTypeId=expressRT5;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity5.CloseDate = system.today(); 
        objOpportunity5.Volume_Potential__c=100;       
        objOpportunity5.OwnerId= u.Id;       
        objOpportunity5.Create_Opportunity__c= true;   
        Insert objOpportunity5;
        
        
        
        Customer_Onboarding__c objcustomeronboarding5 = new Customer_Onboarding__c();
        objcustomeronboarding5.Contact_number__c = '7894563210';
        objcustomeronboarding5.Product_Type__c = 'B2B';
        objcustomeronboarding5.CurrencyIsoCode = 'INR';
        objcustomeronboarding5.Company_Registered_Name__c = 'Test';
        objcustomeronboarding5.Return_Address_City__c = 'Pune';
        objcustomeronboarding5.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding5.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding5.Return_Address_Country__c = 'India';
        objcustomeronboarding5.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding5.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding5.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding5.Invoice_Address_Country__c = 'England';
        objcustomeronboarding5.Bank_name__c = 'AXIS';
        objcustomeronboarding5.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding5.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding5.Opportunity__c = objOpportunity5.Id;
        //objcustomeronboarding.Desired_HQ_Name__c='';
        objcustomeronboarding5.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding5.Contact__c = conRecord.Id;
        objcustomeronboarding5.Account__c = objAccount.Id;
        objcustomeronboarding5.FRS_Code__c = '54789';   
        objcustomeronboarding5.Is_Prepaid__c = false;
        objcustomeronboarding5.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding5.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding5;


    }
   /* static testMethod void DAFZArecordtype()
    {
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC -Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        objAccount.Client_Status__c = 'Active';
        objAccount.External_ID__c = 'TEST 123';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
        
        Id expressRT5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DAFZA').getRecordTypeId();
        Opportunity objOpportunity5=new Opportunity();
        objOpportunity5.Name = 'Test';
        objOpportunity5.StageName = 'Proposal Shared';
        objOpportunity5.AccountId =objAccount.Id;
        objOpportunity5.RecordTypeId=expressRT5;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity5.CloseDate = system.today(); 
        objOpportunity5.Volume_Potential__c=100;       
        objOpportunity5.OwnerId= u.Id;       
        objOpportunity5.Create_Opportunity__c= true;   
        Insert objOpportunity5;
        
        Id expressRT6 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International').getRecordTypeId();
        Opportunity objOpportunity6=new Opportunity();
        objOpportunity6.Name = 'Test';
        objOpportunity6.StageName = 'Proposal Shared';
        objOpportunity6.AccountId =objAccount.Id;
        objOpportunity6.RecordTypeId=expressRT6;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity6.CloseDate = system.today(); 
        objOpportunity6.Volume_Potential__c=100;       
        objOpportunity6.OwnerId= u.Id;       
        objOpportunity6.Create_Opportunity__c= true;   
        Insert objOpportunity6;
        
        
        Customer_Onboarding__c objcustomeronboarding5 = new Customer_Onboarding__c();
        objcustomeronboarding5.Contact_number__c = '7894563210';
        objcustomeronboarding5.Product_Type__c = 'B2B';
        objcustomeronboarding5.CurrencyIsoCode = 'INR';
        objcustomeronboarding5.Company_Registered_Name__c = 'Test';
        objcustomeronboarding5.Return_Address_City__c = 'Pune';
        objcustomeronboarding5.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding5.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding5.Return_Address_Country__c = 'India';
        objcustomeronboarding5.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding5.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding5.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding5.Invoice_Address_Country__c = 'England';
        objcustomeronboarding5.Bank_name__c = 'AXIS';
        objcustomeronboarding5.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding5.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding5.Opportunity__c = objOpportunity5.Id;
        //objcustomeronboarding.Desired_HQ_Name__c='';
        objcustomeronboarding5.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding5.Contact__c = conRecord.Id;
        objcustomeronboarding5.Account__c = objAccount.Id;
        objcustomeronboarding5.FRS_Code__c = '54789';   
        objcustomeronboarding5.Is_Prepaid__c = false;
        objcustomeronboarding5.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding5.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding5;
        
        Customer_Onboarding__c objcustomeronboarding6 = new Customer_Onboarding__c();
        objcustomeronboarding6.Contact_number__c = '7894563210';
        objcustomeronboarding6.Product_Type__c = 'B2B';
        objcustomeronboarding6.CurrencyIsoCode = 'INR';
        objcustomeronboarding6.Company_Registered_Name__c = 'Test';
        objcustomeronboarding6.Return_Address_City__c = 'Pune';
        objcustomeronboarding6.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding6.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding6.Return_Address_Country__c = 'India';
        objcustomeronboarding6.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding6.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding6.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding6.Invoice_Address_Country__c = 'England';
        objcustomeronboarding6.Bank_name__c = 'AXIS';
        objcustomeronboarding6.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding6.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding6.Opportunity__c = objOpportunity6.Id;
        //objcustomeronboarding.Desired_HQ_Name__c='';
        objcustomeronboarding6.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding6.Contact__c = conRecord.Id;
        objcustomeronboarding6.Account__c = objAccount.Id;
        objcustomeronboarding6.FRS_Code__c = '54789';   
        objcustomeronboarding6.Is_Prepaid__c = false;
        objcustomeronboarding6.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding6.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding6;



    }
    */
    static testMethod void Heavyrecordtype()
    {
        COB_Trigger_Stopper__c objcustom = new COB_Trigger_Stopper__c();
        objcustom.Name = 'ALL_TRIGGER' ;
        objcustom.Active__c = true;
        insert objcustom;
        
        COB_Trigger_Stopper__c objcustom1 = new COB_Trigger_Stopper__c();
        objcustom1.Name = 'Generate_Desired_HQ' ;
        objcustom1.Active__c = true;
        insert objcustom1;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',  EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,  TimeZoneSidKey='America/Los_Angeles', UserName='TestDelhiverey@testorg.com');
        insert u;
        
        Id rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objOperatingAccount= new Account();    
        objOperatingAccount.Name='ABC Corp Account';
        objOperatingAccount.Registered_Name__c='ABC Corp';
        objOperatingAccount.BillingStreet='EAST street';
        objOperatingAccount.BillingCity='Pune';
        objOperatingAccount.recordTypeId = rtId;
        objOperatingAccount.BillingState='Maharashtra';
        objOperatingAccount.BillingPostalCode='411028';
        objOperatingAccount.BillingCountry='India';
        objOperatingAccount.Invoicing_Mode__c='Delhivery Miles';
        objOperatingAccount.Phone__c = '1236958740';
        objOperatingAccount.Email__c = 'test@test.com';
        insert objOperatingAccount;
        
        Id rtId1=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='ABC -Express';
        objAccount.ParentId=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express';
        objAccount.BillingStreet='EAST street';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId1;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411028';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c = '1236958740';
        objAccount.Email__c = 'test@test.com';
        objAccount.Client_Status__c = 'Active';
        objAccount.External_ID__c = 'TEST 123';
        insert objAccount;  

        Contact conRecord = new Contact();
        conRecord.LastName = 'Test';
        conRecord.AccountId= objAccount.id;
        insert conRecord;
        
        Id expressRT5 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Heavy').getRecordTypeId();
        Opportunity objOpportunity5=new Opportunity();
        objOpportunity5.Name = 'Test';
        objOpportunity5.StageName = 'Proposal Shared';
        objOpportunity5.AccountId =objAccount.Id;
        objOpportunity5.RecordTypeId=expressRT5;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity5.CloseDate = system.today(); 
        objOpportunity5.Volume_Potential__c=100;       
        objOpportunity5.OwnerId= u.Id;       
        objOpportunity5.Create_Opportunity__c= true;   
        Insert objOpportunity5;
        
        Id expressRT6 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Hyperlocal').getRecordTypeId();
        Opportunity objOpportunity6=new Opportunity();
        objOpportunity6.Name = 'Test';
        objOpportunity6.StageName = 'Proposal Shared';
        objOpportunity6.AccountId =objAccount.Id;
        objOpportunity6.RecordTypeId=expressRT6;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity6.CloseDate = system.today(); 
        objOpportunity6.Volume_Potential__c=100;       
        objOpportunity6.OwnerId= u.Id;       
        objOpportunity6.Create_Opportunity__c= true;   
        Insert objOpportunity6;
        
        Customer_Onboarding__c objcustomeronboarding5 = new Customer_Onboarding__c();
        objcustomeronboarding5.Contact_number__c = '7894563210';
        objcustomeronboarding5.Product_Type__c = 'B2B';
        objcustomeronboarding5.CurrencyIsoCode = 'INR';
        objcustomeronboarding5.Company_Registered_Name__c = 'Test';
        objcustomeronboarding5.Return_Address_City__c = 'Pune';
        objcustomeronboarding5.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding5.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding5.Return_Address_Country__c = 'India';
        objcustomeronboarding5.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding5.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding5.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding5.Invoice_Address_Country__c = 'England';
        objcustomeronboarding5.Bank_name__c = 'AXIS';
        objcustomeronboarding5.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding5.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding5.Opportunity__c = objOpportunity5.Id;
        //objcustomeronboarding.Desired_HQ_Name__c='';
        objcustomeronboarding5.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding5.Contact__c = conRecord.Id;
        objcustomeronboarding5.Account__c = objAccount.Id;
        objcustomeronboarding5.FRS_Code__c = '54789';   
        objcustomeronboarding5.Is_Prepaid__c = false;
        objcustomeronboarding5.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding5.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding5;
        
        Customer_Onboarding__c objcustomeronboarding6 = new Customer_Onboarding__c();
        objcustomeronboarding6.Contact_number__c = '7894563210';
        objcustomeronboarding6.Product_Type__c = 'B2B';
        objcustomeronboarding6.CurrencyIsoCode = 'INR';
        objcustomeronboarding6.Company_Registered_Name__c = 'Test';
        objcustomeronboarding6.Return_Address_City__c = 'Pune';
        objcustomeronboarding6.Return_Address_State__c = 'Maharashtra';
        objcustomeronboarding6.Return_Address_Postal_Code__c = '431698';
        objcustomeronboarding6.Return_Address_Country__c = 'India';
        objcustomeronboarding6.Invoice_Address_City__c = 'Mumbai';
        objcustomeronboarding6.Invoice_Address_State__c = 'Madhya Pradesh';
        objcustomeronboarding6.Invoice_Address_Postal_Code__c = '432156';
        objcustomeronboarding6.Invoice_Address_Country__c = 'England';
        objcustomeronboarding6.Bank_name__c = 'AXIS';
        objcustomeronboarding6.RTGS_IFSC_code__c = 'T1235555555';
        objcustomeronboarding6.Pickup_Location_Pin_code__c = 411028;
        objcustomeronboarding6.Opportunity__c = objOpportunity6.Id;
        //objcustomeronboarding.Desired_HQ_Name__c='';
        objcustomeronboarding6.Operating_Account__c = objOperatingAccount.Id;
        objcustomeronboarding6.Contact__c = conRecord.Id;
        objcustomeronboarding6.Account__c = objAccount.Id;
        objcustomeronboarding6.FRS_Code__c = '54789';   
        objcustomeronboarding6.Is_Prepaid__c = false;
        objcustomeronboarding6.Wallet_Notification_Email__c  = null;        
        objcustomeronboarding6.Wallet_Notification_Mobile__c  = null;        
        Insert objcustomeronboarding6;


    }

    
}