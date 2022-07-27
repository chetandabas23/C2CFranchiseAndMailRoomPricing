@isTest
public class OnboardingSendToHQ_CtlTest 
{
    static testMethod void testOnboardingSendToHQ_Ctl  ()
    {
               
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        /* Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        insert objOpportunity; */
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        /* Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.Client_Id__c =null;
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Desired_HQ_Name__c = 'test';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.Is_Prepaid__c =true;
        objOnboarding.Wallet_Notification_Email__c = null;
        objOnboarding.Status__c = 'Draft';
        insert objOnboarding; */
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = null;
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Contact__c = null;
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = null;
        objOnboarding1.Wallet_Notification_Mobile__c = '91234567890';
        objOnboarding1.Status__c = 'Draft';
        objOnboarding1.Client_Id__c =null;
        objOnboarding1.X_Ray_Limit__c =  5102;
        insert objOnboarding1;
        
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Andaman and Nicobar Islands';
        insert Objstate;
        
        State__c Objstate2 = new State__c();
        Objstate2.Customer_Onboarding__c = objOnboarding1.id;
        Objstate2.State__c = 'Chhattisgarh';
        insert Objstate2;
        
        State__c Objstate3 = new State__c();
        Objstate3.Customer_Onboarding__c = objOnboarding1.id;
        Objstate3.State__c = 'Tamil Nadu';
        insert Objstate3;
        
        State__c Objstate4 = new State__c();
        Objstate4.Customer_Onboarding__c = objOnboarding1.id;
        Objstate4.State__c = 'Sikkim';
        insert Objstate4;
        
        State__c Objstate5 = new State__c();
        Objstate5.Customer_Onboarding__c = objOnboarding1.id;
        Objstate5.State__c = 'Rajasthan';
        insert Objstate5;
        
        State__c Objstate6 = new State__c();
        Objstate6.Customer_Onboarding__c = objOnboarding1.id;
        Objstate6.State__c = 'Punjab';
        insert Objstate6;
        
        
        State__c Objstate7 = new State__c();
        Objstate7.Customer_Onboarding__c = objOnboarding1.id;
        Objstate7.State__c = 'Pondicherry';
        insert Objstate7;
        
        
        State__c Objstate8 = new State__c();
        Objstate8.Customer_Onboarding__c = objOnboarding1.id;
        Objstate8.State__c = 'Delhi';
        insert Objstate8;
        
        
        State__c Objstate9 = new State__c();
        Objstate9.Customer_Onboarding__c = objOnboarding1.id;
        Objstate9.State__c = 'Nagaland';
        insert Objstate9;
        
        State__c Objstate10 = new State__c();
        Objstate10.Customer_Onboarding__c = objOnboarding1.id;
        Objstate10.State__c = 'Goa';
        insert Objstate10;
        
        
        State__c Objstat11 = new State__c();
        Objstat11.Customer_Onboarding__c = objOnboarding1.id;
        Objstat11.State__c = 'Gujarat';
        insert Objstat11;
        
        State__c Objstate12 = new State__c();
        Objstate12.Customer_Onboarding__c = objOnboarding1.id;
        Objstate12.State__c = 'Haryana';
        insert Objstate12;
        
        
        State__c Objstate13 = new State__c();
        Objstate13.Customer_Onboarding__c = objOnboarding1.id;
        Objstate13.State__c = 'Himachal Pradesh';
        insert Objstate13;
        
        State__c Objstate14 = new State__c();
        Objstate14.Customer_Onboarding__c = objOnboarding1.id;
        Objstate14.State__c = 'Jammu and Kashmir';
        insert Objstate14;
        
        State__c Objstate15 = new State__c();
        Objstate15.Customer_Onboarding__c = objOnboarding1.id;
        Objstate15.State__c = 'Jharkhand';
        insert Objstate15;
        
        State__c Objstate16 = new State__c();
        Objstate16.Customer_Onboarding__c = objOnboarding1.id;
        Objstate16.State__c = 'Kerala';
        insert Objstate16;
        
        State__c Objstate17 = new State__c();
        Objstate17.Customer_Onboarding__c = objOnboarding1.id;
        Objstate17.State__c = 'Lakshadweep Islands';
        insert Objstate17;
        
        State__c Objstate18 = new State__c();
        Objstate18.Customer_Onboarding__c = objOnboarding1.id;
        Objstate18.State__c = 'Madhya Pradesh';
        insert Objstate18;
        State__c Objstate19 = new State__c();
        Objstate19.Customer_Onboarding__c = objOnboarding1.id;
        Objstate19.State__c = 'Delhi';
        insert Objstate19;
        
        State__c Objstate20 = new State__c();
        Objstate20.Customer_Onboarding__c = objOnboarding1.id;
        Objstate20.State__c = 'Daman and Diu';
        insert Objstate20;
        
        
        State__c Objstate21 = new State__c();
        Objstate21.Customer_Onboarding__c = objOnboarding1.id;
        Objstate21.State__c = 'Dadra and Nagar Haveli';
        insert Objstate21;
        
        State__c Objstate22 = new State__c();
        Objstate22.Customer_Onboarding__c = objOnboarding1.id;
        Objstate22.State__c = 'Chandigarh';
        insert Objstate22;
        
        State__c Objstate23 = new State__c();
        Objstate23.Customer_Onboarding__c = objOnboarding1.id;
        Objstate23.State__c = 'Assam';
        insert Objstate23;
        
        State__c Objstate24 = new State__c();
        Objstate24.Customer_Onboarding__c = objOnboarding1.id;
        Objstate24.State__c = 'Andhra Pradesh';
        insert Objstate24;
        
        
        State__c Objstate25 = new State__c();
        Objstate25.Customer_Onboarding__c = objOnboarding1.id;
        Objstate25.State__c = 'Maharashtra';
        insert Objstate25;
        
        State__c Objstate26 = new State__c();
        Objstate26.Customer_Onboarding__c = objOnboarding1.id;
        Objstate26.State__c = 'Manipur';
        insert Objstate26;
        
        State__c Objstate27 = new State__c();
        Objstate27.Customer_Onboarding__c = objOnboarding1.id;
        Objstate27.State__c = 'Mizoram';
        insert Objstate27;
        
        
        State__c Objstate28 = new State__c();
        Objstate28.Customer_Onboarding__c = objOnboarding1.id;
        Objstate28.State__c = 'Tripura';
        insert Objstate28;
        
        
        State__c Objstate29 = new State__c();
        Objstate29.Customer_Onboarding__c = objOnboarding1.id;
        Objstate29.State__c = 'Uttar Pradesh';
        insert Objstate29;
        
        
        State__c Objstate30 = new State__c();
        Objstate30.Customer_Onboarding__c = objOnboarding1.id;
        Objstate30.State__c = 'Delhi';
        insert Objstate30;
        
        
        State__c Objstate31 = new State__c();
        Objstate31.Customer_Onboarding__c = objOnboarding1.id;
        Objstate31.State__c = 'West Bengal';
        insert Objstate31;
        
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        hqAPI.URL__c = 'Test';
        //hqAPI.CreatedById  = objOnboarding1.id;
        insert hqAPI;
        State__c Objstate1 = new State__c();
        Objstate1.Customer_Onboarding__c = objOnboarding1.id;
        Objstate1.State__c = 'Arunachal Pradesh';
        insert Objstate1;
        
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        Test.StartTest();
            objonboardingsendtohq.sendToHQ();
            objonboardingsendtohq.updateToHQ();
            string client = '';
            string clientUser = '';
            string UserName = '';
            objonboardingsendtohq.UpdatingHQ(client,UserName,clientUser);
        Test.StopTest();
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl2  ()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Status__c = 'Draft';
        objOnboarding.Contact__c = objContact.Id;
        insert objOnboarding;
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Services__c = 'REPL';
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        //objOnboarding1.Email__c = null;
        //objOnboarding1.Contact__c = null;
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = 'test1@test.com';
        objOnboarding1.Wallet_Notification_Mobile__c = null;
        objOnboarding1.X_Ray_Limit__c =  5102;
        objOnboarding1.Desired_HQ_Name__c =  'Test1DesiredName';
        insert objOnboarding1;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        // hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        String UserName ='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.updateToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName);
        Test.StopTest();
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl3()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        objAccount.Email__c = 'nagraj.techila@gmail.com';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Contact__c = objContact.Id;
        insert objOnboarding;
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'nagraj.techila@gmail.com';
        objOnboarding1.Services__c = 'Pre-paid';
        objOnboarding1.Contact__c = objContact.ID;
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Mobile__c = '9850240092';
        objOnboarding1.Billing_Mode__c = 'Express';
        objOnboarding1.X_Ray_Limit__c =  5102;
        insert objOnboarding1;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName); 
        Test.StopTest();
        
    }
    static testMethod void testOnboardingSendToHQ_Ctl4  ()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.X_Ray_Limit__c =  5102;
        insert objOnboarding;
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'test3@test.com';
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.Contact__c = null;
        objOnboarding1.Services__c = 'DTO'; 
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = 'test1@test.com';
        objOnboarding1.Wallet_Notification_Mobile__c = '9850240092';
        objOnboarding1.Client_Id__c = 'Test';
        objOnboarding1.X_Ray_Limit__c =  5102;
        objOnboarding1.Desired_HQ_Name__c =  'Test1DesiredName';
        insert objOnboarding1;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Chandigarh';
        Objstate.HQ_State__c = true; 
        insert Objstate;
        
        Objstate.State__c = 'Karnataka';
        update Objstate;
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        hqAPI.URL__c = 'Test';
        insert hqAPI;
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName ='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.updateToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName) ;
        Test.StopTest();
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl5 ()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;     
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.Opportunity__c = objOpportunity.Id;
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'test3@test.com';
        objOnboarding1.VAT_Number__c = '123';
        objOnboarding1.CST_Number__c = '1234';
        objOnboarding1.Eco_Code__c = '12334';
        objOnboarding1.FRS_Code__c = '123';
        objOnboarding1.Return_Address__c = 'In Center' ;
        objOnboarding1.Registered_Address_City__c = 'Test';
        objOnboarding1.Registered_Address_Country__c = 'Test2';
        objOnboarding1.Registered_Address_Line_1__c = '';
        objOnboarding1.Registered_Address_Line_2__c = 'Test4';
        objOnboarding1.Registered_Address_Postal_Code__c = 'Test5';
        objOnboarding1.Registered_Address_State__c = 'Test6';
        objOnboarding1.Company_Registered_Name__c = 'TGS';
        objOnboarding1.push_url__c = 'Test1213';
        objOnboarding1.Services__c = 'COD';
        objOnboarding1.Desired_HQ_Name__c='Test Shipping';
        objOnboarding1.Contact__c = objContact.Id ;
        objOnboarding1.X_Ray_Limit__c =  5102;
        system.debug('Contact__c -->'+objContact.Id);
        
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = 'test1@test.com';
        objOnboarding1.Wallet_Notification_Mobile__c = '9850240092';
        objOnboarding1.Client_Id__c = null;
        insert objOnboarding1;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Bihar';
        insert Objstate;
        
        Objstate.State__c = 'Jharkhand';
        update Objstate;
        
        System.debug('objOnboarding1.Id ->'+ objOnboarding1.Id);
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName); 
        //CallOutUtil calltemp = new CallOutUtil();
        CallOutUtil.calloutMethod('test', 'test');
        //OnBoardingWrapper owrap = new OnBoardingWrapper();
        //OnBoardingWrapper.parse('{"wallet_provider":"DEL-MILES","wallet_notification_mobile":null,"wallet_notification_email":null,"vat_number":null,"upload_recipients":null,"services":{"REPL":true,"Pre-paid":true,"Pickup":true,"COD":true},"send_sms_reverse":true,"send_sms_prepaid":true,"send_sms_ndr":true,"send_sms_cod":true,"send_sms_cash":false,"send_mail_pickup":false,"rto_email_recipients":null,"return_add":"Client Warehouse","report_recipients":null,"rem_email":"tst","reg_name":"Johnsons and sons","push_url":null,"product_type":null,"postal_cat":null,"phone":"7798552200","ndr_report_recipients":"dest","mps_service":false,"movement_config":"warehouse_state_gstin","is_prepaid":false,"ho_state":"Maharashtra","gst_states":{"Maharashtra":"22AAAAA0000A1Z6","Karnataka":"22AAAAA0000A1Z7","Gujarat":"22AAAAA0000A1Z8","Chandigarh":"22AAAAA0000A1Z9","Andhra Pradesh":"22AAAAA0000A1Z0"},"frs_code":null,"eco_code":null,"dto_email_recipients":null,"cst_number":null,"billing_mode":null,"billing_client_config":"client_ho","auto_pickup":false,"allow_no_data":false,"address":"Demo road, Hadapsar, Maharashtra, 412582, India."}');
        OnBoardingWrapper.parse('test');
        Test.StopTest();
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl6  ()
    {
        RecordType rt1=[SELECT Id FROM RecordType WHERE DeveloperName = 'Service_Account' LIMIT 1];
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.RecordTypeId=rt1.Id;
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Email__c = 'Testing@test.com';
        objAccount.Phone__c='7788888232';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        /* Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        insert objOpportunity; */
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        /* Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.Client_Id__c =null;
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Desired_HQ_Name__c = 'test';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.Is_Prepaid__c =true;
        objOnboarding.Wallet_Notification_Email__c = null;
        objOnboarding.Status__c = 'Draft';
        insert objOnboarding; */
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Billing_Mode__c = 'Express';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'Test@Test.com';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Contact__c = objContact.Id;
        objOnboarding1.Is_Prepaid__c = False;
        objOnboarding1.Account__c = objAccount.Id;
        objOnboarding1.Wallet_Notification_Email__c = null;
        objOnboarding1.Wallet_Notification_Mobile__c = '91234567890';
        //objOnboarding1.Status__c = ;
        objOnboarding1.Client_Id__c =null;
        objOnboarding1.X_Ray_Limit__c =  5102;
        objOnboarding1.Desired_HQ_Name__c =  'Test1DesiredName';
        insert objOnboarding1;
        
        Customer_Onboarding__c objOnboarding2 = new Customer_Onboarding__c();
        objOnboarding2.Contact_number__c = '123456879';
        objOnboarding2.Product_Type__c = 'B2B';
        objOnboarding2.CurrencyIsoCode = 'INR';
        objOnboarding2.Company_Registered_Name__c = 'test';
        objOnboarding2.Billing_Mode__c = 'Express';
        objOnboarding2.Opportunity__c = objOpportunity1.Id;
        objOnboarding2.Pickup_Location_Pin_code__c = 431689;
        objOnboarding2.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding2.Report_Recipients__c = 'test@gmail.com';
        objOnboarding2.Invoice_Address_City__c = 'testing';
        objOnboarding2.Invoice_Address_Country__c = 'test';
        objOnboarding2.IsDocuments_Verified__c = true;
        objOnboarding2.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding2.Invoice_Address_State__c = 'test';
        objOnboarding2.Bank_name__c = 'AXIS';
        objOnboarding2.RTGS_IFSC_code__c = '12345678923';
        objOnboarding2.Email__c = 'Test@Test.com';
        objOnboarding2.Contact__c = objContact.Id;
        objOnboarding2.Is_Prepaid__c = True;
        objOnboarding2.Account__c = objAccount.Id;
        objOnboarding2.Wallet_Notification_Email__c = 'rishabh.sharma1@delhivery.com';
        objOnboarding2.Wallet_Notification_Mobile__c = '91234567890';
        //objOnboarding1.Status__c = ;
        objOnboarding2.Client_Id__c =null;
        objOnboarding2.X_Ray_Limit__c =  5102;
        objOnboarding2.Desired_HQ_Name__c =  'Test1DesiredName';
        objOnboarding2.Invoicing_Mode__c = 'Delhivery Miles';
        insert objOnboarding2;
        
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Andaman and Nicobar Islands';
        insert Objstate;
        
        State__c Objstate2 = new State__c();
        Objstate2.Customer_Onboarding__c = objOnboarding1.id;
        Objstate2.State__c = 'Chhattisgarh';
        insert Objstate2;
        
        State__c Objstate3 = new State__c();
        Objstate3.Customer_Onboarding__c = objOnboarding1.id;
        Objstate3.State__c = 'Tamil Nadu';
        insert Objstate3;
        
        State__c Objstate4 = new State__c();
        Objstate4.Customer_Onboarding__c = objOnboarding1.id;
        Objstate4.State__c = 'Sikkim';
        insert Objstate4;
        
        State__c Objstate5 = new State__c();
        Objstate5.Customer_Onboarding__c = objOnboarding1.id;
        Objstate5.State__c = 'Rajasthan';
        insert Objstate5;
        
        State__c Objstate6 = new State__c();
        Objstate6.Customer_Onboarding__c = objOnboarding1.id;
        Objstate6.State__c = 'Punjab';
        insert Objstate6;
        
        
        State__c Objstate7 = new State__c();
        Objstate7.Customer_Onboarding__c = objOnboarding1.id;
        Objstate7.State__c = 'Pondicherry';
        insert Objstate7;
        
        
        State__c Objstate8 = new State__c();
        Objstate8.Customer_Onboarding__c = objOnboarding1.id;
        Objstate8.State__c = 'Delhi';
        insert Objstate8;
        
        
        State__c Objstate9 = new State__c();
        Objstate9.Customer_Onboarding__c = objOnboarding1.id;
        Objstate9.State__c = 'Nagaland';
        insert Objstate9;
        
        State__c Objstate10 = new State__c();
        Objstate10.Customer_Onboarding__c = objOnboarding1.id;
        Objstate10.State__c = 'Goa';
        insert Objstate10;
        
        
        State__c Objstat11 = new State__c();
        Objstat11.Customer_Onboarding__c = objOnboarding1.id;
        Objstat11.State__c = 'Gujarat';
        insert Objstat11;
        
        State__c Objstate12 = new State__c();
        Objstate12.Customer_Onboarding__c = objOnboarding1.id;
        Objstate12.State__c = 'Haryana';
        insert Objstate12;
        
        
        State__c Objstate13 = new State__c();
        Objstate13.Customer_Onboarding__c = objOnboarding1.id;
        Objstate13.State__c = 'Himachal Pradesh';
        insert Objstate13;
        
        State__c Objstate14 = new State__c();
        Objstate14.Customer_Onboarding__c = objOnboarding1.id;
        Objstate14.State__c = 'Jammu and Kashmir';
        insert Objstate14;
        
        State__c Objstate15 = new State__c();
        Objstate15.Customer_Onboarding__c = objOnboarding1.id;
        Objstate15.State__c = 'Jharkhand';
        insert Objstate15;
        
        State__c Objstate16 = new State__c();
        Objstate16.Customer_Onboarding__c = objOnboarding1.id;
        Objstate16.State__c = 'Kerala';
        insert Objstate16;
        
        State__c Objstate17 = new State__c();
        Objstate17.Customer_Onboarding__c = objOnboarding1.id;
        Objstate17.State__c = 'Lakshadweep Islands';
        insert Objstate17;
        
        State__c Objstate18 = new State__c();
        Objstate18.Customer_Onboarding__c = objOnboarding1.id;
        Objstate18.State__c = 'Madhya Pradesh';
        insert Objstate18;
        State__c Objstate19 = new State__c();
        Objstate19.Customer_Onboarding__c = objOnboarding1.id;
        Objstate19.State__c = 'Delhi';
        insert Objstate19;
        
        State__c Objstate20 = new State__c();
        Objstate20.Customer_Onboarding__c = objOnboarding1.id;
        Objstate20.State__c = 'Daman and Diu';
        insert Objstate20;
        
        
        State__c Objstate21 = new State__c();
        Objstate21.Customer_Onboarding__c = objOnboarding1.id;
        Objstate21.State__c = 'Dadra and Nagar Haveli';
        insert Objstate21;
        
        State__c Objstate22 = new State__c();
        Objstate22.Customer_Onboarding__c = objOnboarding1.id;
        Objstate22.State__c = 'Chandigarh';
        insert Objstate22;
        
        State__c Objstate23 = new State__c();
        Objstate23.Customer_Onboarding__c = objOnboarding1.id;
        Objstate23.State__c = 'Assam';
        insert Objstate23;
        
        State__c Objstate24 = new State__c();
        Objstate24.Customer_Onboarding__c = objOnboarding1.id;
        Objstate24.State__c = 'Andhra Pradesh';
        insert Objstate24;
        
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        hqAPI.URL__c = 'Test';
        //hqAPI.CreatedById  = objOnboarding1.id;
        insert hqAPI;
        State__c Objstate1 = new State__c();
        Objstate1.Customer_Onboarding__c = objOnboarding1.id;
        Objstate1.State__c = 'Arunachal Pradesh';
        insert Objstate1;
        
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        
            objonboardingsendtohq.sendToHQ();
            objonboardingsendtohq.updateToHQ();
            string client = '';
            string clientUser = ''; 
            string UserName='';
            objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName);
        ApexPages.StandardController sc1 = new ApexPages.StandardController(objOnboarding2);
        OnboardingSendToHQ_Ctl objonboardingsendtohq1 = new OnboardingSendToHQ_Ctl(sc1);     //Instantiate the Class
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        
            objonboardingsendtohq1.sendToHQ();
        Test.StopTest();
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl7()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        objAccount.Email__c = 'nagraj.techila@gmail.com';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.X_Ray_Limit__c =  5102;
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        insert objOnboarding;
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Services__c = 'Pre-paid';
        objOnboarding1.Contact__c = objContact.ID;
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.Is_Prepaid__c = false;
        objOnboarding1.Status__c = 'Final';
        objOnboarding1.Wallet_Notification_Mobile__c = '9850240092';
        objOnboarding1.Billing_Mode__c = 'Express';
        objOnboarding1.X_Ray_Limit__c =  5102;
        insert objOnboarding1;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName); 
        Test.StopTest();
        
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl8()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        objAccount.Email__c = 'nagraj.techila@gmail.com';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.X_Ray_Limit__c =  5102;
        insert objOnboarding;
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Services__c = 'Pre-paid';
        objOnboarding1.Email__c = 'nagraj.techila@gmail.com';
        objOnboarding1.Contact__c = objContact.ID;
        objOnboarding1.Is_Prepaid__c = false;
        objOnboarding1.Status__c = 'Final';
        objOnboarding1.Wallet_Notification_Mobile__c = '9850240092';
        objOnboarding1.Account__c = objAccount.Id;
        objOnboarding1.X_Ray_Limit__c =  5102;
        //objOnboarding1.Billing_Mode__c = 'Express';
        insert objOnboarding1;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName); 
        Test.StopTest();
        
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl9  ()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7894561230';
        objAccount.Email__c='testAccount@test.com';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Status__c = 'Draft';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.X_Ray_Limit__c =  5102;
        insert objOnboarding;
        
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpportunity1.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Services__c = 'REPL';
        objOnboarding1.Email__c = 'test@test.com';
        objOnboarding1.Contact__c = objContact.Id;
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = 'test1@test.com';
        objOnboarding1.Wallet_Notification_Mobile__c = '9876541230';
        objOnboarding1.Billing_Mode__c = 'Express';
        objOnboarding1.Account__c =  objAccount.Id;
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.X_Ray_Limit__c =  5102;
        objOnboarding1.Desired_HQ_Name__c =  'Test2DesiredName';
        insert objOnboarding1;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding1.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        // hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName ='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.updateToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName);
        Test.StopTest();
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl10  (){
        RecordType serviceRT =[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType='Account' AND DeveloperName='Service_Account' LIMIT 1];
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7894561230';
        objAccount.Email__c='testAccount@test.com';
        objAccount.RecordTypeId = serviceRT.id;
        insert objAccount;
        
        RecordType operatingRT =[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType='Account' AND DeveloperName='Operating_Account' LIMIT 1];
        Account objAccountOperating = new Account();    
        objAccountOperating.Name='Test Operating Account';
        objAccountOperating.Registered_Name__c='Test';
        objAccountOperating.BillingStreet='Test Street';
        objAccountOperating.BillingCity='Pune';
        objAccountOperating.BillingState='Maharashtra';
        objAccountOperating.BillingPostalCode='411040';
        objAccountOperating.BillingCountry='India';
        objAccountOperating.Invoicing_Mode__c='Prepaid';
        objAccountOperating.Phone__c='7894561230';
        objAccountOperating.Email__c='testAccount@test.com';
        objAccountOperating.RecordTypeId = operatingRT.Id;
        insert objAccountOperating;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Status__c = 'Accepted';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.Account__c =  objAccount.Id;
        objOnboarding.X_Ray_Limit__c =  null;
        objOnboarding.Billing_Mode__c =  'Express';
        objOnboarding.Operating_Account__c =  objAccountOperating.Id;
        objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        objOnboarding.Client_Id__c =  '1234';
        objOnboarding.Send_to_Operating_Account__c = true;
        insert objOnboarding;
        
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        // hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName='';
        //objonboardingsendtohq.objOnboarding = objOnboarding;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.updateToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName);
        Test.StopTest();
    }
    
    static testMethod void testOnboardingSendToHQ_Ctl11  (){
        RecordType serviceRT =[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType='Account' AND DeveloperName='Service_Account' LIMIT 1];
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7894561230';
        objAccount.Email__c='testAccount@test.com';
        objAccount.RecordTypeId = serviceRT.id;
        insert objAccount;
        
        RecordType operatingRT =[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType='Account' AND DeveloperName='Operating_Account' LIMIT 1];
        Account objAccountOperating = new Account();    
        objAccountOperating.Name='Test Operating Account';
        objAccountOperating.Registered_Name__c='Test';
        objAccountOperating.BillingStreet='Test Street';
        objAccountOperating.BillingCity='Pune';
        objAccountOperating.BillingState='Maharashtra';
        objAccountOperating.BillingPostalCode='411040';
        objAccountOperating.BillingCountry='India';
        objAccountOperating.Invoicing_Mode__c='Prepaid';
        objAccountOperating.Phone__c='7894561230';
        objAccountOperating.Email__c='testAccount@test.com';
        objAccountOperating.RecordTypeId = operatingRT.Id;
        objAccountOperating.Bank_A_c_Number__c = '12312';
        insert objAccountOperating;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Operating_Account__c=objAccountOperating.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        /* Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        insert objOpportunity1; */
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Status__c = 'Accepted';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.Account__c =  objAccount.Id;
        objOnboarding.X_Ray_Limit__c =  null;
        objOnboarding.Billing_Mode__c =  'Express';
        objOnboarding.Operating_Account__c =  objAccountOperating.Id;
        //objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        objOnboarding.Client_Id__c =  '1234';
        objOnboarding.Send_to_Operating_Account__c = true;
        insert objOnboarding;
        
        Customer_Onboarding__c objOnboarding2 = new Customer_Onboarding__c();
        objOnboarding2.Contact_number__c = '123456879';
        objOnboarding2.Product_Type__c = 'B2B';
        objOnboarding2.Opportunity__c = objOpportunity.Id;
        objOnboarding2.CurrencyIsoCode = 'INR';
        objOnboarding2.Company_Registered_Name__c = 'test';
        objOnboarding2.Pickup_Location_Pin_code__c = 431689;
        objOnboarding2.Invoice_Address_City__c = 'testing';
        objOnboarding2.IsDocuments_Verified__c = true;
        objOnboarding2.Invoice_Address_Country__c = 'test';
        objOnboarding2.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding2.Report_Recipients__c = 'test@gmail.com';
        objOnboarding2.Invoice_Address_State__c = 'test';
        objOnboarding2.Bank_name__c = 'AXIS';
        objOnboarding2.RTGS_IFSC_code__c = '12345678923';
        objOnboarding2.Email__c = 'test@test.com';
        objOnboarding2.Status__c = 'Accepted';
        objOnboarding2.Contact__c = objContact.Id;
        objOnboarding2.Account__c =  objAccount.Id;
        objOnboarding2.Invoicing_Mode__c = 'COD Net-off';
        objOnboarding.X_Ray_Limit__c =  null;
        objOnboarding2.Billing_Mode__c =  'Express';
        objOnboarding2.Operating_Account__c =  objAccountOperating.Id;
        //objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        objOnboarding2.Client_Id__c =  '1234';
        objOnboarding2.Send_to_Operating_Account__c = true;
        insert objOnboarding2;
        
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        // hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName='';
        //objonboardingsendtohq.objOnboarding = objOnboarding;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.updateToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName);
        
        objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        update objOnboarding;
        OnboardingSendToHQ_Ctl objonboardingsendtohq1 = new OnboardingSendToHQ_Ctl(sc); 
        objonboardingsendtohq1.objOnboarding = objOnboarding;
        objonboardingsendtohq1.sendToHQ();
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(objOnboarding2);
        OnboardingSendToHQ_Ctl objonboardingsendtohq3 = new OnboardingSendToHQ_Ctl(sc2);
        objonboardingsendtohq3.sendToHQ();
        Test.StopTest();
    }
    static testMethod void testOnboardingSendToHQ_Ctl12  (){
                
        RecordType serviceRT =[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType='Account' AND DeveloperName='Service_Account' LIMIT 1];
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7894561230';
        objAccount.Email__c='testAccount@test.com';
        objAccount.RecordTypeId = serviceRT.id;
        insert objAccount;
        
        RecordType operatingRT =[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType='Account' AND DeveloperName='Operating_Account' LIMIT 1];
        Account objAccountOperating = new Account();    
        objAccountOperating.Name='Test Operating Account';
        objAccountOperating.Registered_Name__c='Test';
        objAccountOperating.BillingStreet='Test Street';
        objAccountOperating.BillingCity='Pune';
        objAccountOperating.BillingState='Maharashtra';
        objAccountOperating.BillingPostalCode='411040';
        objAccountOperating.BillingCountry='India';
        objAccountOperating.Invoicing_Mode__c='Prepaid';
        objAccountOperating.Phone__c='7894561230';
        objAccountOperating.Email__c='testAccount@test.com';
        objAccountOperating.RecordTypeId = operatingRT.Id;
        objAccountOperating.Bank_A_c_Number__c = '12312';
        insert objAccountOperating;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Operating_Account__c=objAccountOperating.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        /* Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        insert objOpportunity1; */
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Status__c = 'Accepted';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.Account__c =  objAccount.Id;
        objOnboarding.Invoicing_Mode__c = 'COD Net-off';
        //objOnboarding.X_Ray_Limit__c =  null;
        //objOnboarding.Billing_Mode__c =  'Express';
        objOnboarding.Operating_Account__c =  objAccountOperating.Id;
        //objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        objOnboarding.Client_Id__c =  '1234';
        objOnboarding.Send_to_Operating_Account__c = true;
        objOnboarding.FRS_Code__c = '3234';
        objOnboarding.Is_Prepaid__c = true;
        objOnboarding.Wallet_Notification_Email__c = 'test@gmail.com';
        
        insert objOnboarding;
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '123456879';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.Opportunity__c = objOpportunity.Id;
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.IsDocuments_Verified__c = true;
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Report_Recipients__c = 'test@gmail.com';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '12345678923';
        objOnboarding1.Email__c = 'test@test.com';
        objOnboarding1.Status__c = 'Accepted';
        objOnboarding1.Contact__c = objContact.Id;
        objOnboarding1.Account__c =  objAccount.Id;
        objOnboarding1.Invoicing_Mode__c = 'COD Net-off';
        //objOnboarding.X_Ray_Limit__c =  null;
        objOnboarding.Billing_Mode__c =  'Express';
        objOnboarding1.Operating_Account__c =  objAccountOperating.Id;
        //objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        objOnboarding1.Client_Id__c =  '1234';
        objOnboarding1.Send_to_Operating_Account__c = true;
        insert objOnboarding1;
        
        Customer_Onboarding__c objOnboarding2 = new Customer_Onboarding__c();
        objOnboarding2.Contact_number__c = '123456879';
        objOnboarding2.Product_Type__c = 'B2B';
        objOnboarding2.Opportunity__c = objOpportunity.Id;
        objOnboarding2.CurrencyIsoCode = 'INR';
        objOnboarding2.IsDocuments_Verified__c = true;
        objOnboarding2.Company_Registered_Name__c = 'test';
        objOnboarding2.Pickup_Location_Pin_code__c = 431689;
        objOnboarding2.Invoice_Address_City__c = 'testing';
        objOnboarding2.Invoice_Address_Country__c = 'test';
        objOnboarding2.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding2.Report_Recipients__c = 'test@gmail.com';
        objOnboarding2.Invoice_Address_State__c = 'test';
        objOnboarding2.Bank_name__c = 'AXIS';
        objOnboarding2.RTGS_IFSC_code__c = '12345678923';
        objOnboarding2.Email__c = 'test@test.com';
        objOnboarding2.Status__c = 'Accepted';
        objOnboarding2.Contact__c = objContact.Id;
        //objOnboarding2.Account__c =  objAccount.Id;
        objOnboarding2.Invoicing_Mode__c = 'COD Net-off';
        objOnboarding.X_Ray_Limit__c =  null;
        objOnboarding2.Billing_Mode__c =  'Express';
        objOnboarding2.Operating_Account__c =  objAccountOperating.Id;
        //objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        objOnboarding2.Client_Id__c =  '1234';
        objOnboarding2.Send_to_Operating_Account__c = true;
        insert objOnboarding2;
        
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        // hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        string UserName='';
        //objonboardingsendtohq.objOnboarding = objOnboarding;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.updateToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName);
        
        objOnboarding.Desired_HQ_Name__c =  'OpptyName';
        update objOnboarding;
        OnboardingSendToHQ_Ctl objonboardingsendtohq1 = new OnboardingSendToHQ_Ctl(sc); 
        objonboardingsendtohq1.objOnboarding = objOnboarding;
        objonboardingsendtohq1.sendToHQ();
        
         ApexPages.StandardController sc1 = new ApexPages.StandardController(objOnboarding1);
        OnboardingSendToHQ_Ctl objonboardingsendtohq2 = new OnboardingSendToHQ_Ctl(sc1);
        objonboardingsendtohq2.sendToHQ();
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(objOnboarding2);
        OnboardingSendToHQ_Ctl objonboardingsendtohq3 = new OnboardingSendToHQ_Ctl(sc2);
        objonboardingsendtohq3.sendToHQ();
        
        CallOutUtil.calloutPutMethod('test.com', '{Hii}');
        Test.StopTest();
    }
    static testMethod void testOnboardingSendToHQ_Ctl2Clone()
    {
        Account objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Registered_Name__c='Test';
        objAccount.BillingStreet='Test Street';
        objAccount.BillingCity='Pune';
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='411040';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7788888232';
        insert objAccount;
        
        Contact objContact= new Contact();
        objContact.FirstName='Test ';
        objContact.LastName='LastName ';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        objContact.Phone='1234567890';
        insert objContact;
        
        RecordType rt=[SELECT Id,DeveloperName FROM RecordType WHERe sObjectType='Opportunity' LIMIT 1];
        Date stdt = Date.newInstance(2019, 1, 1);
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=rt.Id;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=stdt;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '123456';
        objOpportunity.Create_Opportunity__c = true;
        //objOpportunity.Opportunity_Record_Type__c = 'Standard Shipping';
        insert objOpportunity;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity2';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.RecordTypeId=rt.Id;
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=stdt;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Email__c = 'test@test.com';
        objOpportunity1.Phone__c = '123456';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
        objOnboarding.Contact_number__c = '123456879';
        objOnboarding.Product_Type__c = 'B2B';
        objOnboarding.Opportunity__c = objOpportunity.Id;
        objOnboarding.CurrencyIsoCode = 'INR';
        objOnboarding.Company_Registered_Name__c = 'test';
        objOnboarding.Pickup_Location_Pin_code__c = 431689;
        objOnboarding.Invoice_Address_City__c = 'testing';
        objOnboarding.Invoice_Address_Country__c = 'test';
        objOnboarding.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding.Invoice_Address_State__c = 'test';
        objOnboarding.Bank_name__c = 'AXIS';
        objOnboarding.IsDocuments_Verified__c = true;
        objOnboarding.RTGS_IFSC_code__c = '12345678923';
        objOnboarding.Report_Recipients__c = 'test@gmail.com';
        objOnboarding.Email__c = 'test@test.com';
        objOnboarding.Status__c = 'Submitted';
        objOnboarding.Contact__c = objContact.Id;
        objOnboarding.FRS_Code__c = '3422';
        objOnboarding.Is_Prepaid__c = false;
        objOnboarding.Billing_Mode__c = 'Express';
        objOnboarding.X_Ray_Limit__c =  5102;
        objOnboarding.Desired_HQ_Name__c =  'Test2DesiredName';
        objOnboarding.Invoicing_Mode__c = 'Prepaid';
        objOnboarding.Account__c = objAccount.id;
        //objOpportunity.Opportunity_Record_Type__c = 'Standard Shipping';
        insert objOnboarding;
        
        State__c Objstate = new State__c();
        Objstate.Customer_Onboarding__c = objOnboarding.id;
        Objstate.State__c = 'Arunachal Pradesh';
        insert Objstate;
        
        HQ_API__c hqAPI = new HQ_API__c();
        hqAPI.Name = 'Update';
        // hqAPI.URL__c = 'Test';
        insert hqAPI;
        
        PageReference pageRef = Page.OnboardingSendToHQ;
        Test.setCurrentPage(pageRef);
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(objOnboarding);
        OnboardingSendToHQ_Ctl objonboardingsendtohq = new OnboardingSendToHQ_Ctl(sc);     //Instantiate the Class
        string client = '';
        string clientUser = '';
        String UserName ='';
        //objonboardingsendtohq.objOnboarding = objOnboarding1;
        objonboardingsendtohq.sendToHQ();
        objonboardingsendtohq.updateToHQ();
        objonboardingsendtohq.UpdatingHQ(client,clientUser,UserName);
        Test.StopTest();
    }
}