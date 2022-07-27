/*****************************************************************
* Author: Chetan Dabas.
* Class Name: SignContractEmail_ExtTest
* Created Date: 28-June-2017
* Description: To test the use cases of SignContractEmail_Ext class
*******************************************************************/
@isTest(SeeAllData=true)
public class C2CSignContractEmail_ExtTest{
    
    //Method for testing when the contract is already send
    public static testMethod void testOppWithContract(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'B2B';//'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+9;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today();
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        SignContractEmail_Ext objController= new SignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedValue = 'Soft Approval';
        objController.isSoftApproval = true;
        objController.objContract1 = objContract1;
        objController.selectedContactId=objContact1.Id;
        objController.isContractPresent=false;
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        objController.changeRadio();
        objController.getSelectedContact();
        objController.effectiveDate=System.today();
        objController.endDate=System.today();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        ////system.assertEquals(true, objController.renderSendEmailMessage);
    }
    
    public static testMethod void testOppWithContractB2BEff(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.Create_Opportunity__c = true;
        
        insert objOpportunity1;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'B2B';//'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        SignContractEmail_Ext objController= new SignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedValue = 'Soft Approval';
        objController.isSoftApproval = true;
        objController.objContract1 = objContract1;
        objController.selectedContactId=objContact1.Id;
        objController.isContractPresent=false;
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        objController.changeRadio();
        objController.getSelectedContact();
        objController.effectiveDate=System.today();
        objController.endDate=System.today();
        Test.stopTest();    
        system.assertEquals(true, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    
    public static testMethod void testOppWithContractB2BEffic(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.Create_Opportunity__c = true;
        
        insert objOpportunity1;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'B2B';//'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        Contract__c objContract4 = new Contract__c();
        objContract4.Type__c= 'B2B';
        objContract4.Opportunity__c=objOpportunity1.Id;
        objContract4.Start_Date__c=System.today();
        objContract4.Effective_Date__c=null;
        objContract4.End_Date__c=System.today()+10;
        ContractList.add(objContract4);
        insert ContractList;
        System.assertEquals(4, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedValue = 'Soft Approval';
        objController.isSoftApproval = true;
        objController.objContract = objContract2;
        objController.objContract1 = objContract1;
        objController.selectedContactId=objContact1.Id;
        objController.isContractPresent=false;
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        objController.changeRadio();
        objController.getSelectedContact();
        objController.effectiveDate=System.today();
        objController.endDate=System.today();
        Test.stopTest();    
        //system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    
    public static testMethod void testOppWithContractB2B(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        insert objOpportunity1;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'B2B';//'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Status__c = 'Accepted';
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedValue = 'Soft Approval';
        objController.isSoftApproval = true;
        objController.selectedContactId=objContact1.Id;
        objController.isContractPresent=false;
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        objController.changeRadio();
        objController.getSelectedContact();
        objController.effectiveDate=System.today();
        objController.endDate=System.today();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    
    public static testMethod void testOppWithContractB2B1(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        insert objOpportunity1;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        OpportunityContactRole objOCR2= new OpportunityContactRole();
        objOCR2.ContactId=objContact2.Id;
        objOCR2.OpportunityId=objOpportunity1.Id;
        objOCR2.Role='Signing Authority';
        objOCR2.IsPrimary=true;
        insert objOCR2;
        
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=null;
        objContract1.Status__c = 'Accepted';
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objcontact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedValue = 'Soft Approval';
        objController.isSoftApproval = true;
        objController.selectedContactId=null;
        objController.isContractPresent=false;
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        objController.changeRadio();
        objController.getSelectedContact();
        objController.effectiveDate=null;
        objController.endDate=System.today();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    
    public static testMethod void testOppWithDifferentContractType(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        
        Contact objContact= new Contact();
        objContact.FirstName='Test';
        objContact.LastName='Test Name`';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=System.today()+1;
        objContract1.Effective_Date__c=System.today()+3;
        objContract1.End_Date__c=System.today();
        ContractList.add(objContract1);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=System.today()+1;
        objContract3.Effective_Date__c=System.today()+2;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(true, objContract3.Start_Date__c<objContract3.End_Date__c);
        System.assertEquals(true, objContract3.Start_Date__c<objContract3.Effective_Date__c);
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.selectedValue = 'Signed Contract';
        objController.objContract1.Start_Date__c=System.today();
        objController.objContract1.Effective_Date__c=null;
        objController.objContract1.End_Date__c=System.today()+10;
        
        objController.selectedConID = objContact.Id;
        objController.selectedContactId=objContact.Id;
        objController.toSendEmail();
        objController.toSendB2B();
        objController.backLink();
        objController.changeRadio();
        objController.toSendAddendum(); 
        objController.getSelectedContact();
        objController.getSelected();
        Test.stopTest();     
    }
    
    //Method for testing when the contract is not created and must be sent initially
    public static testMethod void testOppWithoutContract(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today();
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.selectedValue = '';
        objController.objContract1.Start_Date__c=System.today();
        objController.objContract1.Effective_Date__c=System.today()+1;
        objController.objContract1.End_Date__c=System.today()+10;
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail(); 
        objController.changeRadio();
        Test.stopTest();
    }
    // Test method to cover catch exceptions
    public static testMethod void testOppWithoutContract2(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Country__c = 'India';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
        public static testMethod void testOppWithContractx(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Corporate Rejected';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.City__c = null;
        insert objOpportunity;
        
             List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
            
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
    public static testMethod void testOppWithContractx1(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Corporate Rejected';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Zip_Postal_Code__c='231223';
        objOpportunity.Create_Opportunity__c = true;
        //objOpportunity.City__c = null;
        objOpportunity.Country__c = null;
        insert objOpportunity;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
            
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
    public static testMethod void testOppWithContractx2(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Corporate Rejected';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Zip_Postal_Code__c = '122456';
        objOpportunity.City__c = 'sd';
        objOpportunity.state_province__c = null;
        insert objOpportunity;
        
             List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
            
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
    public static testMethod void testOppWithContractx3(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Corporate Rejected';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Zip_Postal_Code__c = '122456';
        objOpportunity.City__c = 'sd';
        objOpportunity.state_province__c='1wq';
        objOpportunity.Street__c = null;
        insert objOpportunity;
        
             List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
            
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
    public static testMethod void testOppWithContractx4(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Corporate Rejected';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Zip_Postal_Code__c = '122456';
        objOpportunity.City__c = 'sd';
        objOpportunity.state_province__c='1wq';
        objOpportunity.Street__c = 'fgt';
        insert objOpportunity;
        
             List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
            
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
    public static testMethod void testOppWithContractx5(){
         Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Corporate Rejected';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Zip_Postal_Code__c = '122456';
        objOpportunity.City__c = 'sd';
        objOpportunity.state_province__c='1wq';
        objOpportunity.Street__c = 'fgt';
        insert objOpportunity;
        
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityID = objOpportunity.Id;
        oli.PriceBookEntryID = [select id from PriceBookEntry limit 1].ID;
        //oli.Converted_to_Asset__c = false;
        oli.UnitPrice = 10;
        oli.Quantity = 2;
        insert oli;
        
             List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
            
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
    public static testMethod void testOppWithoutcity(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Corporate Rejected';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Zip_Postal_Code__c = '1220002';
        insert objOpportunity;
        
             List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
            
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.End_Date__c= System.today()+1;
        objController.toSendB2B();  
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
    
    
    // Method to test Opportunity without Contact   
    public static testMethod void testOppWithoutContact(){
        Date startDate = Date.newInstance(2017, 6, 29);
        
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        //Opportunity created where no contact is associated with it 
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();
        Test.stopTest();
    }
    
    
    // Test method to cover end date else part
    public static testMethod void testOppCheckDate(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';
        objOpportunity1.Create_Opportunity__c = true;
        
        insert objOpportunity1;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=null;
        objContract1.Effective_Date__c=null;
        objContract1.End_Date__c=null;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=null;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=null;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=null;
        objContract3.Effective_Date__c=null;
        objContract3.End_Date__c=null;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        //objController.selectedContactId=objContact1.Id;
        
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        ////system.assertEquals(true, objController.renderSendEmailMessage);
    }
    
    //To check effective date else part
    public static testMethod void testOppCheckEffective(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today();
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=System.today()+1;
        objController.objContract1.Effective_Date__c=System.today();
        objController.objContract1.End_Date__c=System.today()+10;
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();        
        Test.stopTest();
    }
    
    //To check effective date else part
    public static testMethod void testOppCheckStartDate(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today();
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        //objController.objContract1.Start_Date__c=System.today();
        objController.objContract1.Effective_Date__c=System.today()+1;
        objController.objContract1.End_Date__c=System.today()+10;
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();        
        Test.stopTest();
    }
    public static testMethod void testOppWithContract1(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 5*5',
            ProductCode = 'Pro-X',
            isActive = true);        
        insert objproduct;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Draft';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity1.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        objoli.IsActive__c = true;
        
        insert objoli;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    public static testMethod void testOppWithContract2(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 5*5',
            ProductCode = 'Pro-X',
            isActive = true);        
        insert objproduct;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Approved';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity1.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        objoli.IsActive__c = true;
        
        insert objoli;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    public static testMethod void testOppWithContract3(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 5*5',
            ProductCode = 'Pro-X',
            isActive = true);        
        insert objproduct;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Approved';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity1.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        objoli.IsActive__c = true;
        
        insert objoli;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    public static testMethod void testOppWithContract4(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 5*5',
            ProductCode = 'Pro-X',
            isActive = true);        
        insert objproduct;
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='On Hold';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Approved';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity1.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        objoli.IsActive__c = true;
        
        insert objoli;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today();
        objContract2.Effective_Date__c=System.today()+9;
        objContract2.End_Date__c=System.today()+10;
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today();
        objContract3.Effective_Date__c=System.today()+8;
        objContract3.End_Date__c=System.today()+10;
        ContractList.add(objContract3);
        insert ContractList;
        System.assertEquals(3, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        
        objController.getSelected();
        objController.toSendEmail();        
        objController.toSendB2B();
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
    }
    //Method for testing when the contract is not created and must be sent initially
    public static testMethod void testOppWithoutContractForStartDate(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today();
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Contract__c objContract = new Contract__c();
        objContract.Type__c= 'Services Agreement';
        objContract.Opportunity__c=objOpportunity.Id;
        //objContract.Start_Date__c=null;
        objContract.Effective_Date__c=System.today()+1;
        objContract.End_Date__c=System.today()+8;
        insert objContract;
        //ContractList.add(objContract1);
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=System.today();
        objController.objContract1.Effective_Date__c=System.today()+1;
        objController.objContract1.End_Date__c=System.today()+10;
        
        objController.toSendB2B();
        objController.toSendAddendum();
        objController.toSendEmail();        
        Test.stopTest();
    }
          public static testMethod void testOppWithContract5(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Approved';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
       /* Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1); */
        
        
        Contract__c objContract4 = new Contract__c();
        objContract4.Type__c= 'B2B';
        objContract4.Opportunity__c=objOpportunity1.Id;
        objContract4.Start_Date__c=System.today();
        objContract4.Effective_Date__c=null;
        objContract4.End_Date__c=System.today()+10;
        ContractList.add(objContract4);
        Contract__c objContract5 = new Contract__c();
        objContract5.Type__c= 'B2B';
        objContract5.Opportunity__c=objOpportunity1.Id;
        objContract5.Start_Date__c=System.today()+9;
        objContract5.Effective_Date__c=null;
        objContract5.End_Date__c=System.today()+10;
        ContractList.add(objContract5);
        insert ContractList;
        System.assertEquals(2, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        objController.toSendB2B();
        objController.getSelected();
        objController.toSendEmail();        
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
        
            }
              public static testMethod void testOppWithContract9(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        
        RecordType RecType = [Select id from recordtype where sobjecttype='Opportunity' and name='C2C' limit 1];
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.Description='test';
        objOpportunity1.RecordTypeId=RecType.id;
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Approved';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
       /* Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1); */
        
        
        Contract__c objContract4 = new Contract__c();
        objContract4.Type__c= 'B2B';
        objContract4.Opportunity__c=objOpportunity1.Id;
        objContract4.Start_Date__c=System.today();
        objContract4.Effective_Date__c=null;
        objContract4.End_Date__c=System.today()+10;
        ContractList.add(objContract4);
        Contract__c objContract5 = new Contract__c();
        objContract5.Type__c= 'B2B';
        objContract5.Opportunity__c=objOpportunity1.Id;
        objContract5.Start_Date__c=System.today()+9;
        objContract5.Effective_Date__c=null;
        objContract5.End_Date__c=System.today()+10;
        ContractList.add(objContract5);
        insert ContractList;
        System.assertEquals(2, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        objController.toSendB2B();
        objController.getSelected();
        objController.toSendEmail();        
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
        
            }
                  public static testMethod void testOppWithContract10(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        
        RecordType RecType = [Select id from recordtype where sobjecttype='Opportunity' and name='C2C' limit 1];
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.Description='test';
        objOpportunity1.RecordTypeId=RecType.id;
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Approved';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
       /* Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1); */
        
        
        Contract__c objContract4 = new Contract__c();
        objContract4.Type__c= 'Services Agreement';
        objContract4.Opportunity__c=objOpportunity1.Id;
        objContract4.Start_Date__c=System.today();
        objContract4.Effective_Date__c=System.today()-10;
        objContract4.End_Date__c=System.today()-10;
        ContractList.add(objContract4);
        Contract__c objContract5 = new Contract__c();
        objContract5.Type__c= 'Addendum';
        objContract5.Opportunity__c=objOpportunity1.Id;
        objContract5.Start_Date__c=System.today()+9;
        objContract5.Effective_Date__c=System.today()-10;
        objContract5.End_Date__c=System.today()-10;
        ContractList.add(objContract5);
        insert ContractList;
        System.assertEquals(2, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        objController.toSendB2B();
        objController.getSelected();
        objController.toSendEmail();        
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
        
            }
                      public static testMethod void testOppWithContract11(){
        Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        
        RecordType RecType = [Select id from recordtype where sobjecttype='Opportunity' and name='C2C' limit 1];
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Contract Signed';
        objOpportunity1.Description='test';
        objOpportunity1.RecordTypeId=RecType.id;
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.Email__c='Test@test.com';
        objOpportunity1.Phone__c='999999';
        objOpportunity1.City__c='Gurgaon';
        objOpportunity1.State_Province__c='Haryana';
        objOpportunity1.Country__c='India';  
        objOpportunity1.Create_Opportunity__c = true;
        
        // objOpportunity1.HasOpportunityLineItem = true;
        insert objOpportunity1;
        
        
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
       /* Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1); */
        
        
        Contract__c objContract4 = new Contract__c();
        objContract4.Type__c= 'Services Agreement';
        objContract4.Opportunity__c=objOpportunity1.Id;
        objContract4.Start_Date__c=System.today();
        objContract4.Effective_Date__c=System.today()-10;
        objContract4.End_Date__c=System.today()-10;
        ContractList.add(objContract4);
        Contract__c objContract5 = new Contract__c();
        objContract5.Type__c= 'Addendum';
        objContract5.Opportunity__c=objOpportunity1.Id;
        objContract5.Start_Date__c=System.today()+9;
        objContract5.Effective_Date__c=System.today()-10;
        objContract5.End_Date__c=System.today()-10;
        ContractList.add(objContract5);
        insert ContractList;
        System.assertEquals(2, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedContactId=objContact1.Id;
        objController.toSendB2B();
        objController.getSelected();
        objController.toSendEmail();        
        objController.backLink();
        objController.toSendAddendum();
        objController.getContacts();
        objController.sendContract();
        Test.stopTest();    
        system.assertEquals(false, objController.setBack);
        //system.assertEquals(true, objController.renderSendEmailMessage);
        
            }
    public static testMethod void testvalidateContractSigned(){
           Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today()+1;
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c='Test@test.com';
        objOpportunity.Phone__c='999999';
        objOpportunity.Country__c = 'India';
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.state_province__c = null;
        objOpportunity.Street__c = null;
        insert objOpportunity;
          List<Contract__c> ContractList= new List<Contract__c>();
       /* Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today();
        objContract1.Effective_Date__c=System.today()+1;
        objContract1.End_Date__c=System.today()+8;
        ContractList.add(objContract1); */
        
        
        Contract__c objContract4 = new Contract__c();
        objContract4.Type__c= 'B2B';
        objContract4.Opportunity__c=objOpportunity.Id;
        objContract4.Start_Date__c=System.today()+5;
        objContract4.Effective_Date__c=System.today()+4;
        objContract4.End_Date__c=System.today();
        ContractList.add(objContract4);
        Contract__c objContract5 = new Contract__c();
        objContract5.Type__c= 'B2B';
        objContract5.Opportunity__c=objOpportunity.Id;
        objContract5.Start_Date__c=System.today()+9;
        objContract5.Effective_Date__c=System.today()+5;
        objContract5.End_Date__c=System.today();
        ContractList.add(objContract5);
        insert ContractList;
        System.assertEquals(2, ContractList.size());
        
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        objController.objContract1.Start_Date__c=null;
        objController.toSendB2B();
        
        C2CSignContractEmail_Ext objController2= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Effective_Date__c=null;
        objController.toSendB2B();  
        
        C2CSignContractEmail_Ext objController3= new C2CSignContractEmail_Ext(sc); 
        objController.objContract1.Start_Date__c= System.today()+5;
        objController.objContract1.Effective_Date__c= System.today()+3;
          
        //objController.toSendB2B();
        objController.toSendAddendum();
        objController.objContract1.End_Date__c= System.today();
        objController.selectedValue = 'Soft Approval';
        objController.toSendB2B();
        objController.toSendEmail();   
        objController.validateContractSigned();
        Test.stopTest();
    }
     public static testMethod void testvalidateContractSigned1(){
   Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        List<Contact> contactList= new List<Contact>();
        Contact objContact1= new Contact();
        objContact1.FirstName='Test';
        objContact1.LastName='Test Last Name';
        objContact1.Email='test1@techilaservices.com';
        objContact1.AccountId=objAccount.Id;
        contactList.add(objContact1);   
        
        Contact objContact2= new Contact();
        objContact2.FirstName='Darshana';
        objContact2.LastName='Pawar';
        objContact2.Email='test2@techilaservices.com';
        contactList.add(objContact2);   
        
        insert contactList;     
        System.assertEquals(2, contactList.size());
        
        Opportunity objOpportunity1 = new Opportunity();
        objOpportunity1.Name='Test opportunity1';
        objOpportunity1.StageName='Commercials Agreed';
        objOpportunity1.Description='test';
        objOpportunity1.Sites_Listed_On__c='test1';
        objOpportunity1.CloseDate=System.today()+1;
        objOpportunity1.Forward_Base__c=500;
        objOpportunity1.AccountId=objAccount.Id;
        objOpportunity1.Volume_Potential__c=23.3;
        objOpportunity1.Status__c ='Corporate Rejected';
        objOpportunity1.Create_Opportunity__c = true;
        
        insert objOpportunity1;
        
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact1.Id;
        objOCR1.OpportunityId=objOpportunity1.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        insert objOCR1;
        
        List<Contract__c> ContractList= new List<Contract__c>();
        Contract__c objContract1 = new Contract__c();
        objContract1.Type__c= 'B2B';//'Services Agreement';
        objContract1.Opportunity__c=objOpportunity1.Id;
        objContract1.Start_Date__c=System.today()+10;
        objContract1.Effective_Date__c=System.today()-1;
        objContract1.End_Date__c=System.today();
        ContractList.add(objContract1);
        
        Contract__c objContract2 = new Contract__c();
        objContract2.Type__c= 'Addendum';
        objContract2.Opportunity__c=objOpportunity1.Id;
        objContract2.Start_Date__c=System.today()+10;
        objContract2.Effective_Date__c=null;
        objContract2.End_Date__c=System.today();
        ContractList.add(objContract2);
        
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity1.Id;
        objContract3.Start_Date__c=System.today()+10;
        objContract3.Effective_Date__c=System.today()-1;
        objContract3.End_Date__c=System.today();
        ContractList.add(objContract3);
        Contract__c objContract4 = new Contract__c();
        objContract4.Type__c= 'B2B';
        objContract4.Opportunity__c=objOpportunity1.Id;
        objContract4.Start_Date__c=System.today()+10;
        objContract4.Effective_Date__c=System.today()-1;
        objContract4.End_Date__c=System.today();
        ContractList.add(objContract4);
        insert ContractList;
        System.assertEquals(4, ContractList.size());
        
        Test.startTest();        
        ApexPages.currentpage().getParameters().put('id',objOpportunity1.Id);
        ApexPages.currentPage().getParameters().put('accid',objContact2.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity1);
        C2CSignContractEmail_Ext objController= new C2CSignContractEmail_Ext(sc);
        
        System.debug(' contractObjAddendum ->>'+ objController.contractObjAddendum);
        System.debug(' contractObj ->>'+ objController.contractObj);
        objController.selectedValue = 'Soft Approval';
        objController.isSoftApproval = true;
        //objController.objContract = objContract2;
        //objController.objContract1 = objContract1;
        //objController.selectedContactId=objContact1.Id;
        //objController.isContractPresent=false;
        //objController.getSelected();
        //objController.toSendEmail();        
        objController.toSendB2B();
        //objController.backLink();
        //objController.toSendAddendum();
        //objController.getContacts();
        ///objController.sendContract();
        //objController.changeRadio();
        //objController.getSelectedContact();
        //objController.effectiveDate=System.today();
        //objController.endDate=System.today();
        Test.stopTest();    
    }
}