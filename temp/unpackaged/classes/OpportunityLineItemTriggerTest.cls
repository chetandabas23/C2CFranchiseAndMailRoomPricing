/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: OpportunityLineItemTriggerTest
* Created Date: 29-June-2017
* Description: Test class for OpportunityLineItemTrigger
*******************************************************************/


@isTest
public class OpportunityLineItemTriggerTest {
    public static testMethod void toTestTriggerOnDelete()
    {
        //Pricebook
        Id pricebookId = Test.getStandardPricebookId();
        
        //Create product
        Product2 prod = new Product2(
            Name = 'Hyperlocal',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        RecordType rt = [select id,Name from RecordType where Name=:'Hyperlocal' limit 1];
        
        // Inserting opportunity
        Opportunity opp = new Opportunity(Name='testOpp',Email__c='testOpp@testOpp.com',StageName='Proposal Shared',
                                          RecordTypeId=rt.id,CloseDate=system.today(),Create_Opportunity__c=True);
        insert opp;
        
        //create opportunity line item
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 100
        );
        insert oli;
        delete oli;
    }
    public static testMethod void testSurface() {
    
        RecordType  rt1=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Standard_Shipping' AND SObjectType='Opportunity' limit 1 ];
        Opportunity objOpportunity=TestDataUtility.crtActOppCont(rt1.Id);
       
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Standard_shipping' AND SObjectType='Product2' ];
        
        Product2 SurfaceProduct = new Product2();
        SurfaceProduct.Name='Standard Shipping';
        SurfaceProduct.RecordTypeId=rt2.Id;
        SurfaceProduct.Maximum_liability_per_consignment__c=5;
        insert SurfaceProduct;
        
        
        
        
        ID standardPBId = Test.getStandardPricebookId();

        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'Standard Shipping';
        insert objpricebookone;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=SurfaceProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;

        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=SurfaceProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        
        OpportunityLineItem objOLI= TestDataUtility.crtOLI(objOpportunity, objPBE2);
        objOLI.Description__c= 'Test';
        objOLI.Maximum_liability_per_consignment__c=15;
        objOLI.Status__c='Draft';
        objOLI.Quantity=100;
        objOLI.TotalPrice =1000;
        update objOLI;
        
        delete objOLI;
    
    }
    public static testMethod void testB2b15by15(){
        Opportunity objOpportunity=new Opportunity(Name='Test',StageName='Proposal Shared',CloseDate=system.today(),Create_Opportunity__c=True);
        Insert objOpportunity;
        
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
        insert objoli;
        
        delete objoli;
    }
}