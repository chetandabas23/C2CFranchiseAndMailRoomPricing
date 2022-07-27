@isTest
public class clsPOCAssignment_Test {
    public static testMethod void unitTest(){
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operating Account').getRecordTypeId();
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
        
        Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
        objAccount.Operating_Account__c =objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express Test';
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
        
        Id expressRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Express Shipping').getRecordTypeId();
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;  
        objOpportunity.Create_Opportunity__c=true;
        Insert objOpportunity;
        
        Customer_Onboarding__c customer_onboarding = new Customer_Onboarding__c(
            //OwnerId = '0050I000008E3q6QAC',
            CL_PANEL_User_Name__c = 'test user',
            CL_PANEL_Password__c = '123456',
            CurrencyIsoCode = 'INR',
            Account__c = objAccount.id,
            Company_Registered_Name__c = 'Test',
            Contact_number__c = '90989879',
            Email__c = 'saurabh.rastogi@delhivery.com',
            Fulfilment_Service__c = false,
            Invoice_Address_City__c = 't',
            Invoice_Address_Country__c = 'india',
            Invoice_Address_Line_2__c = 'lmp',
            Invoice_Address_Postal_Code__c = '787878',
            Invoice_Address_State__c = 'HR',
            Invoicing_Mode__c = 'COD Net-off',
            Is_Prepaid__c = false,
            MPS_Service__c = false,
            Opportunity__c = objOpportunity.id,
            Pickup_Location_Pin_code__c = 798788.0,
            Send_SMS_COD__c = true,
            Send_SMS_NDR__c = true,
            Send_SMS_Prepaid__c = true,
            Send_SMS_Reverse__c = true,
            Send_mail_Pickup__c = false,
            Status__c = 'Submitted',
            X_Ray_Limit__c = 7000.0,
            GST_Not_Registered__c = false,
            Wallet_Provider__c = 'Delhivery miles',
            IsDraft__c = false,
            Send_to_Operating_Account__c = false,
            IsDocuments_Verified__c = false
            
        );
        insert customer_onboarding;
        
        POC_Team__c poc_team = new POC_Team__c(
            //OwnerId = '0050I000008E3q6QAC',
            Name = 'LT CSM',
            Directors__c = 'Saurabh Rastogi,Techila Admin',
            CurrencyIsoCode = 'INR',
            Type_of_business__c = 'Express/Surface',
            //Type_of_business__c = 'B2B',
            Volume_potential__c = 8.0,
            Round_Robin__c = 1.0);
        insert poc_team;
        
        POC_Team_Member__c poc_team_member = new POC_Team_Member__c(
            Name = '1',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member;
        
        Operating_Account_Poc__c objPoc = new Operating_Account_Poc__c();
        
        objPoc.Operating_Account__c = objOperatingAccount.id;
        objPoc.Service_Type__c = 'Express/Surface';
        objPoc.Name_POC1__c = 'ert';
        objPoc.Phone_POC1__c = '01234567890';
        objPoc.EMAIL_POC1__c = 'test@gmail.com';
        objPoc.Name_POC2__c = 'tre';
        objPoc.Phone_POC2__c = '01234567890';
        objPoc.EMAIL_POC2__c = 'test@gmail.com';
        objPoc.POC_Team__c =poc_team.id;
        objPoc.Poc_Team_Member_Id__c =poc_team_member.id;
        insert objPoc;
        
        
        
        clsPOCAssignment objclass = new clsPOCAssignment();
        clsPOCAssignment.PocAssignment(customer_onboarding.id);
        
        
        
    }
    public static testMethod void unitTestPOC(){
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operating Account').getRecordTypeId();
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
        
        Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
        objAccount.Operating_Account__c =objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express Test';
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
        
        Id expressRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Express Shipping').getRecordTypeId();
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;  
        objOpportunity.Create_Opportunity__c=true;
        Insert objOpportunity;
        
        Customer_Onboarding__c customer_onboarding = new Customer_Onboarding__c(
            //OwnerId = '0050I000008E3q6QAC',
            CL_PANEL_User_Name__c = 'test user',
            CL_PANEL_Password__c = '123456',
            CurrencyIsoCode = 'INR',
            Account__c = objAccount.id,
            Company_Registered_Name__c = 'Test',
            Contact_number__c = '90989879',
            Email__c = 'saurabh.rastogi@delhivery.com',
            Fulfilment_Service__c = false,
            Invoice_Address_City__c = 't',
            Invoice_Address_Country__c = 'india',
            Invoice_Address_Line_2__c = 'lmp',
            Invoice_Address_Postal_Code__c = '787878',
            Invoice_Address_State__c = 'HR',
            Invoicing_Mode__c = 'COD Net-off',
            Is_Prepaid__c = false,
            MPS_Service__c = false,
            Opportunity__c = objOpportunity.id,
            Pickup_Location_Pin_code__c = 798788.0,
            Send_SMS_COD__c = true,
            Send_SMS_NDR__c = true,
            Send_SMS_Prepaid__c = true,
            Send_SMS_Reverse__c = true,
            Send_mail_Pickup__c = false,
            Status__c = 'Submitted',
            X_Ray_Limit__c = 7000.0,
            GST_Not_Registered__c = false,
            Wallet_Provider__c = 'Delhivery miles',
            IsDraft__c = false,
            Send_to_Operating_Account__c = false,
            IsDocuments_Verified__c = false
            
        );
        insert customer_onboarding;
        
        POC_Team__c poc_team = new POC_Team__c(
            //OwnerId = '0050I000008E3q6QAC',
            Name = 'LT CSM',
            Directors__c = 'Saurabh Rastogi,Techila Admin,Sujay Mayekar',
            CurrencyIsoCode = 'INR',
            Type_of_business__c = 'Express/Surface',
            //Type_of_business__c = 'B2B',
            Volume_potential__c = 8.0,
            Round_Robin__c = 1.0);
        insert poc_team;
        
        POC_Team_Member__c poc_team_member = new POC_Team_Member__c(
            Name = '1',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member;
        
        
        clsPOCAssignment objclass = new clsPOCAssignment();
        clsPOCAssignment.PocAssignment(customer_onboarding.id);
        
        
        
    }
    public static testMethod void unitTest1(){
        
        
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operating Account').getRecordTypeId();
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
        
        Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
        objAccount.Operating_Account__c=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express Test';
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
        
        Id expressRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId();
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;  
        objOpportunity.Create_Opportunity__c=true;
        objOpportunity.Volume_Potential_Tonnes_Month__c =15;
        Insert objOpportunity;
        
        Customer_Onboarding__c customer_onboarding = new Customer_Onboarding__c(
            //OwnerId = '0050I000008E3q6QAC',
            CurrencyIsoCode = 'INR',
            Account__c = objAccount.id,
            Company_Registered_Name__c = 'Test',
            Contact_number__c = '90989879',
            Email__c = 'saurabh.rastogi@delhivery.com',
            Fulfilment_Service__c = false,
            Invoice_Address_City__c = 't',
            Invoice_Address_Country__c = 'india',
            Invoice_Address_Line_2__c = 'lmp',
            Invoice_Address_Postal_Code__c = '787878',
            Invoice_Address_State__c = 'HR',
            Invoicing_Mode__c = 'COD Net-off',
            Is_Prepaid__c = false,
            MPS_Service__c = false,
            Opportunity__c = objOpportunity.id,
            Pickup_Location_Pin_code__c = 798788.0,
            Send_SMS_COD__c = true,
            Send_SMS_NDR__c = true,
            Send_SMS_Prepaid__c = true,
            Send_SMS_Reverse__c = true,
            Send_mail_Pickup__c = false,
            Status__c = 'Submitted',
            X_Ray_Limit__c = 7000.0,
            GST_Not_Registered__c = false,
            Wallet_Provider__c = 'Delhivery miles',
            IsDraft__c = false,
            Send_to_Operating_Account__c = false,
            IsDocuments_Verified__c = false
            
        );
        insert customer_onboarding;
        
        POC_Team__c poc_team = new POC_Team__c(
            //OwnerId = '0050I000008E3q6QAC',
            Name = 'South Poc',
            Directors__c = 'Saurabh Rastogi,Techila Admin,Sujay Mayekar',
            CurrencyIsoCode = 'INR',
            //Type_of_business__c = 'Express/Surface',
            Type_of_business__c = 'B2B',
            Volume_potential__c = 8.0,
            Round_Robin__c = 1.0);
        insert poc_team;
        
        POC_Team_Member__c poc_team_member = new POC_Team_Member__c(
            Name = '1',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member;
        POC_Team_Member__c poc_team_member1 = new POC_Team_Member__c(
            Name = '2',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test123@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test32@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member1;
        
        
        clsPOCAssignment objclass = new clsPOCAssignment();
        clsPOCAssignment.PocAssignment(customer_onboarding.id);
        
        
    }
    Public static testMethod void UnitTest7(){
           
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operating Account').getRecordTypeId();
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
        
        Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
        objAccount.Operating_Account__c=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express Test';
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
        
        Id expressRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('C2C').getRecordTypeId();
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;  
        objOpportunity.Create_Opportunity__c=true;
        objOpportunity.Volume_Potential_Tonnes_Month__c =15;
        Insert objOpportunity;
        
        Customer_Onboarding__c customer_onboarding = new Customer_Onboarding__c(
            //OwnerId = '0050I000008E3q6QAC',
            CurrencyIsoCode = 'INR',
            Account__c = objAccount.id,
            Company_Registered_Name__c = 'Test',
            Contact_number__c = '90989879',
            Email__c = 'saurabh.rastogi@delhivery.com',
            Fulfilment_Service__c = false,
            Invoice_Address_City__c = 't',
            Invoice_Address_Country__c = 'india',
            Invoice_Address_Line_2__c = 'lmp',
            Invoice_Address_Postal_Code__c = '787878',
            Invoice_Address_State__c = 'HR',
            Invoicing_Mode__c = 'COD Net-off',
            Is_Prepaid__c = false,
            MPS_Service__c = false,
            Opportunity__c = objOpportunity.id,
            Pickup_Location_Pin_code__c = 798788.0,
            Send_SMS_COD__c = true,
            Send_SMS_NDR__c = true,
            Send_SMS_Prepaid__c = true,
            Send_SMS_Reverse__c = true,
            Send_mail_Pickup__c = false,
            Status__c = 'Submitted',
            X_Ray_Limit__c = 7000.0,
            GST_Not_Registered__c = false,
            Wallet_Provider__c = 'Delhivery miles',
            IsDraft__c = false,
            Send_to_Operating_Account__c = false,
            IsDocuments_Verified__c = false
            
        );
        insert customer_onboarding;
        
        POC_Team__c poc_team = new POC_Team__c(
            //OwnerId = '0050I000008E3q6QAC',
            Name = 'South Poc',
            Directors__c = 'Saurabh Rastogi,Techila Admin,Sujay Mayekar',
            CurrencyIsoCode = 'INR',
            //Type_of_business__c = 'Express/Surface',
            Type_of_business__c = 'C2C',
            Volume_potential__c = 8.0,
            Round_Robin__c = 1.0);
        insert poc_team;
        
        POC_Team_Member__c poc_team_member = new POC_Team_Member__c(
            Name = '1',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member;
        POC_Team_Member__c poc_team_member1 = new POC_Team_Member__c(
            Name = '2',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test123@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test32@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member1;
        
        
        clsPOCAssignment objclass = new clsPOCAssignment();
        clsPOCAssignment.PocAssignment(customer_onboarding.id);
        
        

    }
    /*  public static testMethod void unitTest2(){
Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operating Account').getRecordTypeId();
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

Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
Account objAccount= new Account();    
objAccount.Name='ABC Express For Rishabh';
objAccount.Operating_Account__c=objOperatingAccount.Id;
objAccount.Registered_Name__c='ABC Express Test';
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

Id expressRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId();
Opportunity objOpportunity=new Opportunity();
objOpportunity.Name = 'Test222';
objOpportunity.StageName = 'Proposal Shared';
objOpportunity.AccountId =objAccount.Id;
objOpportunity.RecordTypeId=expressRT;
//objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
objOpportunity.CloseDate = system.today(); 
objOpportunity.Volume_Potential__c=100;  
objOpportunity.Create_Opportunity__c=true;
objOpportunity.Volume_Potential_Tonnes_Month__c =6;
Insert objOpportunity;

Customer_Onboarding__c customer_onboarding = new Customer_Onboarding__c(
//OwnerId = '0050I000008E3q6QAC',
CurrencyIsoCode = 'INR',
Account__c = objAccount.id,
Company_Registered_Name__c = 'Test',
Contact_number__c = '90989879',
Email__c = 'saurabh.rastogi@delhivery.com',
Fulfilment_Service__c = false,
Invoice_Address_City__c = 't',
Invoice_Address_Country__c = 'india',
Invoice_Address_Line_2__c = 'lmp',
Invoice_Address_Postal_Code__c = '787878',
Invoice_Address_State__c = 'HR',
Invoicing_Mode__c = 'COD Net-off',
Is_Prepaid__c = false,
MPS_Service__c = false,
Opportunity__c = objOpportunity.id,
Pickup_Location_Pin_code__c = 798788.0,
Send_SMS_COD__c = true,
Send_SMS_NDR__c = true,
Send_SMS_Prepaid__c = true,
Send_SMS_Reverse__c = true,
Send_mail_Pickup__c = false,
Status__c = 'Submitted',
X_Ray_Limit__c = 7000.0,
GST_Not_Registered__c = false,
Wallet_Provider__c = 'Delhivery miles',
IsDraft__c = false,
Send_to_Operating_Account__c = false,
IsDocuments_Verified__c = false

);
insert customer_onboarding;

POC_Team__c poc_team = new POC_Team__c(
//OwnerId = '0050I000008E3q6QAC',
Name = 'South Poc',
Directors__c = 'Saurabh Rastogi,Techila Admin',
CurrencyIsoCode = 'INR',
//Type_of_business__c = 'Express/Surface',
Type_of_business__c = 'B2B',
Volume_potential__c = 8.0,
Round_Robin__c = 1.0);
insert poc_team;

POC_Team_Member__c poc_team_member = new POC_Team_Member__c(
Name = '1',
CurrencyIsoCode = 'INR',
Name_POC1__c = 'ert',
Phone_POC1__c = '01234567890',
EMAIL_POC1__c = 'test@gmail.com',
Name_POC2__c = 'tre',
Phone_POC2__c = '01234567890',
EMAIL_POC2__c = 'test@gmail.com',
POC_Team__c = poc_team.id);
insert poc_team_member;
POC_Team_Member__c poc_team_member1 = new POC_Team_Member__c(
Name = '2',
CurrencyIsoCode = 'INR',
Name_POC1__c = 'ert',
Phone_POC1__c = '01234567890',
EMAIL_POC1__c = 'test123@gmail.com',
Name_POC2__c = 'tre',
Phone_POC2__c = '01234567890',
EMAIL_POC2__c = 'test32@gmail.com',
POC_Team__c = poc_team.id);
insert poc_team_member1;



clsPOCAssignment objclass = new clsPOCAssignment();
clsPOCAssignment.PocAssignment(customer_onboarding.id);
}
*/
    public static testMethod void unitTest3(){
        Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Operating Account').getRecordTypeId();
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
        
        Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
        objAccount.Operating_Account__c=objOperatingAccount.Id;
        objAccount.Registered_Name__c='ABC Express Test';
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
        
        Id expressRT = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('B2B').getRecordTypeId();
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.RecordTypeId=expressRT;
        //objOpportunity.OnBoarding_Form_Receive_Date__c = system.today();
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Volume_Potential__c=100;  
        objOpportunity.Create_Opportunity__c=true;
        objOpportunity.Volume_Potential_Tonnes_Month__c =6;
        Insert objOpportunity;
        
        Customer_Onboarding__c customer_onboarding = new Customer_Onboarding__c(
            //OwnerId = '0050I000008E3q6QAC',
            CurrencyIsoCode = 'INR',
            Account__c = objAccount.id,
            Company_Registered_Name__c = 'Test',
            Contact_number__c = '90989879',
            Email__c = 'saurabh.rastogi@delhivery.com',
            Fulfilment_Service__c = false,
            Invoice_Address_City__c = 't',
            Invoice_Address_Country__c = 'india',
            Invoice_Address_Line_2__c = 'lmp',
            Invoice_Address_Postal_Code__c = '787878',
            Invoice_Address_State__c = 'HR',
            Invoicing_Mode__c = 'COD Net-off',
            Is_Prepaid__c = false,
            MPS_Service__c = false,
            Opportunity__c = objOpportunity.id,
            Pickup_Location_Pin_code__c = 798788.0,
            Send_SMS_COD__c = true,
            Send_SMS_NDR__c = true,
            Send_SMS_Prepaid__c = true,
            Send_SMS_Reverse__c = true,
            Send_mail_Pickup__c = false,
            Status__c = 'Submitted',
            X_Ray_Limit__c = 7000.0,
            GST_Not_Registered__c = false,
            Wallet_Provider__c = 'Delhivery miles',
            IsDraft__c = false,
            Send_to_Operating_Account__c = false,
            IsDocuments_Verified__c = false
            
        );
        insert customer_onboarding;
        
        POC_Team__c poc_team = new POC_Team__c(
            //OwnerId = '0050I000008E3q6QAC',
            Name = 'LT CSM',
            Directors__c = 'Saurabh Rastogi,Techila Admin,Sujay Mayekar',
            CurrencyIsoCode = 'INR',
            //Type_of_business__c = 'Express/Surface',
            Type_of_business__c = 'B2B',
            Volume_potential__c = 8.0,
            Round_Robin__c = 1.0);
        insert poc_team;
        
        POC_Team_Member__c poc_team_member = new POC_Team_Member__c(
            Name = '1',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member;
        POC_Team_Member__c poc_team_member1 = new POC_Team_Member__c(
            Name = '2',
            CurrencyIsoCode = 'INR',
            Name_POC1__c = 'ert',
            Phone_POC1__c = '01234567890',
            EMAIL_POC1__c = 'test123@gmail.com',
            Name_POC2__c = 'tre',
            Phone_POC2__c = '01234567890',
            EMAIL_POC2__c = 'test32@gmail.com',
            POC_Team__c = poc_team.id);
        insert poc_team_member1;
        
        
        
        clsPOCAssignment objclass = new clsPOCAssignment();
        clsPOCAssignment.PocAssignment(customer_onboarding.id);
        
    }
    
}