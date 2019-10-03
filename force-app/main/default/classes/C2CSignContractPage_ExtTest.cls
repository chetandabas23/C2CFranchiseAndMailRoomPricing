/*****************************************************************
* Author: Chetan Dabas.
* Class Name: SignContractPage_Ext
* Created Date: 28-June-2017
* Description: Test Class for SignContractPage_Ext
*******************************************************************/
@isTest
public class C2CSignContractPage_ExtTest {
    static testMethod void testSignContractFunctionality(){
        test.startTest();
        
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduserS101@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, division = '877',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserS101@testorg.com');
        insert u;
        Account objAccount = new Account(Name = 'Test767737', OwnerId=u.Id,Phone__c='7798989898');
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Test68968',AccountId = objAccount.id , Email = 'test@gmail.com');
        insert objContact;
        
        Opportunity objOpp = new Opportunity(Name='Test6e827897289',Volume_Potential__c=1,Email__c='Test@test.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = false, Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        //Create different type of Contracts
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Viewed',CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Type__c = 'B2B',Contact__c =objContact.id );
        insert objContract;
        
        
        /*ApexPages.currentPage().getParameters().put('id', String.valueOf(objOpp.Id));
ApexPages.currentPage().getParameters().put('contactId', String.valueOf(objContact.Id));
ApexPages.currentPage().getParameters().put('ContractId', String.valueOf(objContract.Id));*/
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);
        PageReference pageRef = Page.SignContractPage; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(objOpp.Id));
        pageRef.getParameters().put('contactId', String.valueOf(objContact.Id) );
        pageRef.getParameters().put('ContractId', String.valueOf(objContract.Id));
        Test.setCurrentPage(pageRef);
        
        objsign.UpdateContract();
        objsign.ViewTrack();
        test.stopTest();
    }
    
    static testMethod void executeSignContractPage_ExtOne(){
        test.startTest();
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduserS101@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, division = '877',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserS101@testorg.com');
        insert u;
        Account objAccount = new Account(Name = 'Test', OwnerId=u.Id,Phone__c='7798989898');
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Test',AccountId = objAccount.id , Email = 'test@gmail.com');
        insert objContact;
        Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('C2C').getRecordTypeId();
        Opportunity objOpp = new Opportunity(Name='Test',RecordTypeId=RecordTypeIdOpp,Volume_Potential__c=1,Email__c='Test@test.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true,Phone__c='787878', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Viewed',CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Type__c='Addendum',Contact__c =objContact.id );
        insert objContract;
        
        Customer_Onboarding__c objOnboarding1 = new Customer_Onboarding__c();
        objOnboarding1.Contact_number__c = '1234568790';
        objOnboarding1.Product_Type__c = 'B2B';
        objOnboarding1.CurrencyIsoCode = 'INR';
        objOnboarding1.Account__c = objAccount.id;
        objOnboarding1.Company_Registered_Name__c = 'test';
        objOnboarding1.Opportunity__c = objOpp.Id;
        objOnboarding1.Pickup_Location_Pin_code__c = 431689;
        objOnboarding1.Registered_Address_Line_1__c = 'Test Registered Address Line';
        objOnboarding1.Invoice_Address_City__c = 'testing';
        objOnboarding1.Invoice_Address_Country__c = 'test';
        objOnboarding1.Invoice_Address_Postal_Code__c = '415245';
        objOnboarding1.Invoice_Address_State__c = 'test';
        objOnboarding1.Bank_name__c = 'AXIS';
        objOnboarding1.RTGS_IFSC_code__c = '2345678923';
        objOnboarding1.Email__c = 'test@test.com';
        //objOnboarding1.Contact__c = '9874561230';
        objOnboarding1.Is_Prepaid__c = true;
        objOnboarding1.Wallet_Notification_Email__c = null;
        objOnboarding1.Wallet_Notification_Mobile__c = '9123456789';
        objOnboarding1.Status__c = 'Draft';
        objOnboarding1.Client_Id__c =null;
        //objOnboarding1.Desired_HQ_Name__c = 'Test Hq Name';
        insert objOnboarding1;
        system.assertNotEquals(null, objOnboarding1.id);
        
        
        Blob content = Blob.valueOf('UNIT.TEST');
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(objOpp.Id));
        ApexPages.currentPage().getParameters().put('contactId', String.valueOf(objContact.Id));
        ApexPages.currentPage().getParameters().put('ContractId', String.valueOf(objContract.Id));
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);
        
        objsign.UpdateContract(); 
        test.stopTest();
    }
    
    static testMethod void executeSignContractPage_ExtTwo(){
        test.startTest();
        
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduserS101@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, division = '877',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserS101@testorg.com');
        insert u;
        //Account objAccount = new Account(Name = 'Test');
        //insert objAccount;
        
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='Motorola';
        objAccount.Registered_Name__c='Motorola Corp';
        objAccount.BillingStreet='Mg Road';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='511030';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.OwnerId= u.Id;
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Steve',AccountId = objAccount.id , Email = 'Steve@motorola.com');
        insert objContact;
        
        Opportunity objOpp = new Opportunity(Name='Milton',Volume_Potential__c=1,Email__c='Steve@milton.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true, Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Viewed',CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Type__c='Services Agreement',Contact__c =objContact.id );
        insert objContract;
        
        //Pass essential parameters and test current page
        /*PageReference pageRef = Page.SignContractPage;
Test.setCurrentPage(pageRef);*/
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(objOpp.Id));
        ApexPages.currentPage().getParameters().put('contactId', String.valueOf(objContact.Id));
        ApexPages.currentPage().getParameters().put('ContractId', String.valueOf(objContract.Id));
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);
        objsign.UpdateContract();
        //objsign.ViewTrack();
        test.stopTest();
    }
    
    static testMethod void executeSignContractPage_ExtThree(){
        //Account objAccount = new Account(Name = 'Test');
        //insert objAccount;
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduserS101@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, division = '877',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserS101@testorg.com');
        insert u;
        system.debug('user >>'+u);  
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='Motorola';
        objAccount.Registered_Name__c='Motorola Corp';
        objAccount.BillingStreet='Mg Road';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='511030';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.OwnerId= u.Id;
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Steve',AccountId = objAccount.id , Email = 'Steve@motorola.com');
        insert objContact;
        
        Opportunity objOpp = new Opportunity(Name='Milton',Volume_Potential__c=1,Email__c='Steve@milton.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true,  Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Accepted',Type__c = 'B2B', CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Contact__c =objContact.id );
        insert objContract;
        
        //objContract.Type__c = 'B2B';
        //update objContract;
        
        
        Test.startTest();
        //Pass essential parameters and test current page
        PageReference pageRef = Page.B2BAgreementPDF;
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        pageRef.getParameters().put('isSoftApproval', 'false');
        pageRef.getParameters().put('ContractId', String.valueOf(objContract.Id));
        Test.setCurrentPage(pageRef);
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);
        objsign.attachmentUpload = new Attachment(body=Blob.valueOf('Unit Test Attachment Body'), name='test attachment');
        objsign.UpdateContract();
        //objsign.submitSignedContract();
        Test.stopTest(); 
    }
    
    static testMethod void executeSignContractPage_ExtWithNullContract(){        
        
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;
        
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='Motorola';
        objAccount.Registered_Name__c='Motorola Corp';
        objAccount.BillingStreet='Mg Road';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='511030';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c='7798989898';
        //objAccount.OwnerId= u.Id;
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Steve',AccountId = objAccount.id , Email = 'Steve@motorola.com');
        insert objContact;
        
        Opportunity objOpp = new Opportunity(Name='Milton',Volume_Potential__c=1,Email__c='Steve@milton.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true,  Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        Test.startTest();
        //Pass essential parameters and test current page
        PageReference pageRef = Page.B2BAgreementPDF;
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        pageRef.getParameters().put('isSoftApproval', 'false');
        pageRef.getParameters().put('ContractId', String.valueOf('null'));
        Test.setCurrentPage(pageRef);
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);        
        Test.stopTest();
    }
    
    static testMethod void executeSignContractPage_ExtWithB2BContract(){
        
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;  
        
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='Motorola test test test test test test test test test test test test';
        objAccount.Registered_Name__c='Motorola Corp';
        objAccount.BillingStreet='Mg Road';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='511030';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c='7798989898';
        //objAccount.OwnerId= u.Id;
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Steve',AccountId = objAccount.id , Email = 'Steve@motorola.com');
        insert objContact;
        
        String rtIdOpp=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'B2B' LIMIT 1].Id;
        Opportunity objOpp = new Opportunity(RecordTypeId=rtIdOpp,Name='Motorola test test test test test test test test test test test test',Volume_Potential__c=1,Email__c='Steve@milton.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true,  Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Accepted',Type__c = 'B2B', CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Contact__c =objContact.id );
        insert objContract;
        
        Attachment__c objAttachment = new Attachment__c(Contract__c=objContract.id);
        insert objAttachment;
        
        Test.startTest();
        //Pass essential parameters and test current page
        PageReference pageRef = Page.B2BAgreementPDF;
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        pageRef.getParameters().put('isSoftApproval', 'false');
        pageRef.getParameters().put('ContractId', String.valueOf(objContract));
        Test.setCurrentPage(pageRef);
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);   
        objsign.UpdateContract(); 
        objsign.submitSignedContract();
        objsign.ViewTrack();
        Test.stopTest();
    }
    static testMethod void executeSignContractPage_ExtWithB2BContractNotAccepted(){
        
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper; 
        
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='Motorola';
        objAccount.Registered_Name__c='Motorola Corp';
        objAccount.BillingStreet='Mg Road';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='511030';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c='7798989898';
        //objAccount.OwnerId= u.Id;
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Steve',AccountId = objAccount.id , Email = 'Steve@motorola.com');
        insert objContact;
        
        String rtIdOpp=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'B2B' LIMIT 1].Id;
        Opportunity objOpp = new Opportunity(RecordTypeId=rtIdOpp,Name='Milton',Volume_Potential__c=1,Email__c='Steve@milton.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true,  Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Submitted',Type__c = 'B2B', CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Contact__c =objContact.id );
        insert objContract;
        
        Test.startTest();
        //Pass essential parameters and test current page
        PageReference pageRef = Page.B2BAgreementPDF;
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        pageRef.getParameters().put('isSoftApproval', 'false');
        pageRef.getParameters().put('ContractId', String.valueOf(objContract));
        Test.setCurrentPage(pageRef);
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);  
        objsign.submitSignedContract();
        objsign.ViewTrack();
        Test.stopTest();
    }
    static testMethod void executeSignContractPage_ExtWithB2BContractNotAccepted2(){ 
        
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;
        
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='Motorola';
        objAccount.Registered_Name__c='Motorola Corp';
        objAccount.BillingStreet='Mg Road';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='511030';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.Phone__c='7798989898';
        //objAccount.OwnerId= u.Id;
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Steve',AccountId = objAccount.id , Email = 'Steve@motorola.com');
        insert objContact;
        
        String rtIdOpp=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Opportunity' AND DeveloperName = 'B2B' LIMIT 1].Id;
        Opportunity objOpp = new Opportunity(RecordTypeId=rtIdOpp,Name='Milton',Volume_Potential__c=1,Email__c='Steve@milton.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true,  Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Submitted',Type__c = 'B2B', CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Contact__c =objContact.id );
        insert objContract;
        
        Test.startTest();
        //Pass essential parameters and test current page
        PageReference pageRef = Page.B2BAgreementPDF;
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        pageRef.getParameters().put('isSoftApproval', 'true');
        pageRef.getParameters().put('ContractId', String.valueOf('null'));
        Test.setCurrentPage(pageRef);
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);     
        objsign.submitSignedContract();
        objsign.ViewTrack();
        Test.stopTest();
    }
    static testMethod void executeSignContractPage_ExtThree_clone(){
        system.debug('--error 2 clone--');
        trigger_stopper__c objtrgStopper = new trigger_stopper__c();
        objtrgStopper.Name = 'ContractTrigger';
        objtrgStopper.Trigger_After__c = true;
        insert  objtrgStopper;
        //Account objAccount = new Account(Name = 'Test');
        //insert objAccount;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduserS101@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, division = '877',
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduserS101@testorg.com');
        insert u;
        system.debug('user >>'+u);  
        String rtId=[SELECT Id,DeveloperName FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Operating_Account' LIMIT 1].Id;
        Account objAccount= new Account();    
        objAccount.Name='MPQRS';
        objAccount.Registered_Name__c='Motorola Corp';
        objAccount.BillingStreet='Mg Road';
        objAccount.BillingCity='Pune';
        objAccount.recordTypeId = rtId;
        objAccount.BillingState='Maharashtra';
        objAccount.BillingPostalCode='511030';
        objAccount.BillingCountry='India';
        objAccount.Invoicing_Mode__c='Delhivery Miles';
        objAccount.OwnerId= u.Id;
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        Contact objContact = new Contact(LastName = 'Steve',AccountId = objAccount.id , Email = 'Steve@motorola.com');
        insert objContact;
        RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = 'B2B'];
        Opportunity objOpp = new Opportunity(Name='Milton',RecordTypeId=rt.Id,Volume_Potential__c=1,Email__c='Steve@milton.com',StageName='Proposal Shared',CloseDate=system.today(),Insurance__c = true,  Phone__c='9876543210', AccountId=objAccount.id, Operating_Account__c =objAccount.id,Create_Opportunity__c = true);
        insert objOpp;
        
        
        Contract__c objContract = new Contract__c(Opportunity__c = objOpp.id, Status__c = 'Expired',Type__c = 'Addendum', CurrencyIsoCode = 'INR',Accepted_Time__c = system.today(),Contact__c =objContact.id );
        insert objContract;
        
        //objContract.Type__c = 'B2B';
        //update objContract;
        
        
        Test.startTest();
        //Pass essential parameters and test current page
        PageReference pageRef = Page.B2BAgreementPDF;
        pageRef.getParameters().put('Id', String.valueOf(objOpp.Id));
        pageRef.getParameters().put('isSoftApproval', 'false');
        pageRef.getParameters().put('ContractId', String.valueOf(objContract.Id));
        Test.setCurrentPage(pageRef);
        
        //Specify type of Standard Controllers
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpp);
        C2CSignContractPage_Ext objsign = new C2CSignContractPage_Ext(sc);
        objsign.attachmentUpload = new Attachment(body=Blob.valueOf('Unit Test Attachment Body'), name='test attachment');
        objsign.ViewTrack();
        objsign.objContract.Status__c = 'Accepted';
        objsign.objContract.Type__c = 'Addendum';
        objsign.ViewTrack();
        objsign.objContract.Status__c = 'Viewed';
        //objsign.ViewTrack();
        objsign.objContract.Status__c = 'Accepted';
        objsign.objContract.Type__c = 'B2B';
        objsign.ViewTrack();
        //objsign.objContract.Status__c = 'Addendum';
        objsign.objContract.Type__c = 'Addendum';
        objsign.UpdateContract();
        // objsign.objOpp.RecordTypeId = rt.id;
        // objsign.submitSignedContract();
        Test.stopTest(); 
    }
}