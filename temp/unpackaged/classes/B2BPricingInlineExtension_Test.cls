/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: B2BPricingInlineExtension_Test
* Created Date: 29-June-2017
* Description: Primary test class for B2BPricingInlineExtension
*******************************************************************/


@isTest
public class B2BPricingInlineExtension_Test {
    static testMethod void executePriceTest()
    {
        
  Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
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

        
        Contact objContact = new Contact();
        objContact.LastName = 'Test';
        objContact.AccountId = objAccount.id;
        insert objContact;
        
        
        /*List<B2B_Price__c> b2bpriceList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice = new B2B_Price__c();
	    objB2BPrice.Source__c='sourceString';
	    insert objB2BPrice;
        b2bpriceList.add(objB2BPrice);*/
        
        
        
        Contract__c objContract = new Contract__c();
	    objContract.Start_Date__c=system.today();
	    insert objContract;
        
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Volume_Potential__c= 100;
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
       
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 5*5',
            ProductCode = 'Pro-X',
            isActive = true);        
        insert objproduct;
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        objoli.IsActive__c = true;
        
        insert objoli;
        
   
        // Insert B2B
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        List<String> sourceList = new List<String>();
        sourceList.add('North');
        sourceList.add('West');
        sourceList.add('South');
        sourceList.add('East');
        sourceList.add('North East');
        
        for(Integer i=0;i<5;i++){
            for(Integer j=0;j<5;j++){
                B2B_Price__c objB2Bprice= new B2B_Price__c();
                objB2Bprice.Amount__c=15;
                objB2Bprice.Product__c=objProduct.Id;
                objB2Bprice.Source__c=sourceList[i];    
                objB2Bprice.Destination__c=sourceList[j];   
                objB2Bprice.Opportunity_Line_Item_Id__c=objoli.Id;
                B2BpriceList.add(objB2Bprice);
            }
            
        }
        insert B2BpriceList;
       
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        B2BPricingInlineExtension objcontroller=new B2BPricingInlineExtension(sc);
        objcontroller.downloadContractAgreement();
        objcontroller.downloadAddendum();
        objcontroller.generatePricingPDFB2B();
        objcontroller.getPrintView();
        
        ApexPages.currentPage().getParameters().put('ContactId',objContact.Id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(objContact);
        B2BPricingInlineExtension objcontroller2=new B2BPricingInlineExtension(sc2);
        
        ApexPages.currentPage().getParameters().put('ContractId',objContract.Id);
        ApexPages.StandardController sc3 = new ApexPages.StandardController(objContract);
        B2BPricingInlineExtension objcontroller3=new B2BPricingInlineExtension(sc3);
    }    
    
    static testMethod void executePriceTestone()
    {
         Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
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

        
        Contact objContact = new Contact();
        objContact.LastName = 'Test';
        objContact.AccountId = objAccount.id;
        insert objContact;
        
        
        /*List<B2B_Price__c> b2bpriceList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice = new B2B_Price__c();
	    objB2BPrice.Source__c='sourceString';
	    insert objB2BPrice;
        b2bpriceList.add(objB2BPrice);*/
        
        
        
        Contract__c objContract = new Contract__c();
	    objContract.Start_Date__c=system.today();
	    insert objContract;
        
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Volume_Potential__c= 100;
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 15*15',
            ProductCode = 'Pro-X',
            isActive = true);
        insert objproduct;
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        //objoli.Divisor__c = 8;
        objoli.IsActive__c = true;
        // objoli.Updated_Product_Name__c=objproduct.Name;
        insert objoli;
        
        // Insert B2B
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        List<String> sourceList = new List<String>();
        sourceList.add('North');
        sourceList.add('West');
        sourceList.add('South');
        sourceList.add('East');
        sourceList.add('North East');
        
        for(Integer i=0;i<5;i++){
            for(Integer j=0;j<5;j++){
                B2B_Price__c objB2Bprice= new B2B_Price__c();
                objB2Bprice.Amount__c=15;
                objB2Bprice.Product__c=objProduct.Id;
                objB2Bprice.Source__c=sourceList[i];    
                objB2Bprice.Destination__c=sourceList[j];   
                objB2Bprice.Opportunity_Line_Item_Id__c=objoli.Id;
                B2BpriceList.add(objB2Bprice);
            }
            
        }
        insert B2BpriceList;
        
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        B2BPricingInlineExtension objcontroller=new B2BPricingInlineExtension(sc);
        
    }    
    
    static testMethod void executePriceTestoneB2B()
    {
         Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
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

        
        Contact objContact = new Contact();
        objContact.LastName = 'Test';
        objContact.AccountId = objAccount.id;
        insert objContact;
        
        
        /*List<B2B_Price__c> b2bpriceList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice = new B2B_Price__c();
	    objB2BPrice.Source__c='sourceString';
	    insert objB2BPrice;
        b2bpriceList.add(objB2BPrice);*/
        
        
        
        Contract__c objContract = new Contract__c();
	    objContract.Start_Date__c=system.today();
	    insert objContract;
        
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Volume_Potential__c= 100;
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 6*6',
            ProductCode = 'Pro-X',
            isActive = true);
        insert objproduct;
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        //objoli.Divisor__c = 8;
        objoli.IsActive__c = true;
        // objoli.Updated_Product_Name__c=objproduct.Name;
        insert objoli;
        
        // Insert B2B
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        List<String> sourceList = new List<String>();
        sourceList.add('North');
        sourceList.add('West');
        sourceList.add('South');
        sourceList.add('East');
        sourceList.add('North East');
        
        for(Integer i=0;i<5;i++){
            for(Integer j=0;j<5;j++){
                B2B_Price__c objB2Bprice= new B2B_Price__c();
                objB2Bprice.Amount__c=15;
                objB2Bprice.Product__c=objproduct.Id;
                objB2Bprice.Source__c=sourceList[i];    
                objB2Bprice.Destination__c=sourceList[j];   
                objB2Bprice.Opportunity_Line_Item_Id__c=objoli.Id;
                B2BpriceList.add(objB2Bprice);
            }
            
        }
        insert B2BpriceList;
        
        
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        B2BPricingInlineExtension objcontroller=new B2BPricingInlineExtension(sc);
        
    }
    //for B2B 14*14
    static testMethod void executePriceTestoneB2B14()
    {
         Id rtId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service Account').getRecordTypeId();
        Account objAccount= new Account();    
        objAccount.Name='ABC Express For Rishabh';
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

        
        Contact objContact = new Contact();
        objContact.LastName = 'Test';
        objContact.AccountId = objAccount.id;
        insert objContact;
        
        
        /*List<B2B_Price__c> b2bpriceList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice = new B2B_Price__c();
	    objB2BPrice.Source__c='sourceString';
	    insert objB2BPrice;
        b2bpriceList.add(objB2BPrice);*/
        
        
        
        Contract__c objContract = new Contract__c();
	    objContract.Start_Date__c=system.today();
	    insert objContract;
        
        Opportunity objOpportunity=new Opportunity();
        objOpportunity.Name = 'Test222';
        objOpportunity.StageName = 'Proposal Shared';
        objOpportunity.AccountId =objAccount.Id;
        objOpportunity.CloseDate = system.today(); 
        objOpportunity.Create_Opportunity__c = true;
        objOpportunity.Volume_Potential__c= 100;
        objOpportunity.Create_Opportunity__c = true;
        insert objOpportunity;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 objproduct = new Product2(
            Name = 'B2B 14*14',
            ProductCode = 'Pro-X',
            isActive = true);
        insert objproduct;
        
        PricebookEntry objpbEntry = new PricebookEntry( 
            Pricebook2Id = pricebookId,
            Product2Id = objproduct.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert objpbEntry;
        
        OpportunityLineItem objoli = new OpportunityLineItem();
        objoli.OpportunityId = objOpportunity.Id;
        objoli.Quantity = 5;
        objoli.PricebookEntryId = objpbEntry.Id;
        objoli.TotalPrice = objpbEntry.UnitPrice * objpbEntry.UnitPrice;
        objoli.Maximum_liability_per_consignment__c = 10;
        objoli.Insurance__c = 15;
        objoli.CFT__c = 5;
        //objoli.Divisor__c = 8;
        objoli.IsActive__c = true;
        // objoli.Updated_Product_Name__c=objproduct.Name;
        insert objoli;
        
        // Insert B2B
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        List<String> sourceList = new List<String>();
        sourceList.add('North');
        sourceList.add('West');
        sourceList.add('South');
        sourceList.add('East');
        sourceList.add('North East');
        
        for(Integer i=0;i<5;i++){
            for(Integer j=0;j<5;j++){
                B2B_Price__c objB2Bprice= new B2B_Price__c();
                objB2Bprice.Amount__c=15;
                objB2Bprice.Product__c=objProduct.Id;
                objB2Bprice.Source__c=sourceList[i];    
                objB2Bprice.Destination__c=sourceList[j];   
                objB2Bprice.Opportunity_Line_Item_Id__c=objoli.Id;
                B2BpriceList.add(objB2Bprice);
            }
            
        }
        insert B2BpriceList;
        
        ApexPages.currentPage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(objOpportunity);
        B2BPricingInlineExtension objcontroller=new B2BPricingInlineExtension(sc);
        
    }
    
}