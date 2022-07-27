/*
 * Author Name: Chetan Dabas
* Description: Test Class for FranchisePricingExt
* Created Date: 12-08-2019
*/
@isTest
public class FranchisePricingExt_Test {
    
    
    public static Product2 crtProduct(String RecTypeDeveloperName, String ProductName){
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName=:RecTypeDeveloperName AND SObjectType='Product2' ];
        
        Product2 objProduct = new Product2();
        objProduct.Name=ProductName;
        objProduct.RecordTypeId=rt2.Id;
        objProduct.Maximum_liability_per_consignment__c=5;
        return objProduct;
    }
       
     public static testMethod void FranchiseTest(){
       
       // For Surface Testing
        RecordType  rt1=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='C2C' AND SObjectType='Opportunity' limit 1 ];
        Opportunity objOpportunity=TestDataUtility.crtActOppCont(rt1.Id);
         objOpportunity.Sub_Category__c='Franchise';
         update objOpportunity;
        
        Product2 FranchiseExpressProduct = crtProduct('Franchise_Shipping','Delhivery Commercial Express - C2C');
        FranchiseExpressProduct.Maximum_liability_per_consignment__c=5;
        insert FranchiseExpressProduct;
        
        Product2 HyperlocalProduct = crtProduct('Hyperlocal','Hyperlocal');
        HyperlocalProduct.Maximum_liability_per_consignment__c=5;
        insert  HyperlocalProduct;
        
        Product2 FranchiseSurfaceProduct = crtProduct('Franchise_Shipping','Delhivery Commercial Standard - C2C');
        FranchiseSurfaceProduct.Maximum_liability_per_consignment__c=5;
        insert FranchiseSurfaceProduct;
        
        ID standardPBId = Test.getStandardPricebookId();

        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'C2C Pricing Model';
        insert objpricebookone;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=FranchiseExpressProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        PricebookEntry objPBE1=new PricebookEntry();
        objPBE1.Product2Id=FranchiseSurfaceProduct.Id;
        objPBE1.PriceBook2Id=standardPBId;
        objPBE1.IsActive=true;
        objPBE1.UnitPrice=37;
        insert objPBE1;
        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=FranchiseExpressProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        PricebookEntry objPBE21=new PricebookEntry();
        objPBE21.Product2Id=FranchiseSurfaceProduct.Id;
        objPBE21.PriceBook2Id=objpricebookone.Id;
        objPBE21.IsActive=true;
        objPBE21.UnitPrice=37;
        insert objPBE21;
        OpportunityLineItem objOLI= TestDataUtility.crtOLI(objOpportunity, objPBE2);
        objOLI.Description__c= 'Test';
        objOLI.Maximum_liability_per_consignment__c=15;
        objOLI.Status__c='Draft';
        objOLI.Quantity=100;
        objOLI.TotalPrice =1000;
        update objOLI;
         OpportunityLineItem objOLI1= TestDataUtility.crtOLI(objOpportunity, objPBE21);
        objOLI1.Description__c= 'Test';
        objOLI1.Maximum_liability_per_consignment__c=15;
        objOLI1.Status__c='Draft';
        objOLI1.Quantity=100;
        objOLI1.TotalPrice =1000;
         objOLI1.IsCustom__c=true;
        update objOLI1;
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id',objOpportunity.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        FranchisePricingExt objController= new FranchisePricingExt(sc);   
        objController.saveOLI();
        objOLI.Status__c='Corporate Approved';
        update objOLI;
         System.assertEquals('Corporate Approved',objOLI.Status__c);
          objOLI1.Status__c='Corporate Approved';
        update objOLI1;
                  System.assertEquals('Corporate Approved',objOLI1.Status__c);
        objController.saveOLI();
         objController.deleteOLI();
        objController.cancelOLI();
        objController.redirectToCustomPricing();
        objController.redirectToCustom();
        
        Test.stopTest();
    }
  public static testMethod void FranchiseTest1(){
       
       // For Surface Testing
        RecordType  rt1=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='C2C' AND SObjectType='Opportunity' limit 1 ];
        Opportunity objOpportunity=TestDataUtility.crtActOppCont(rt1.Id);
         objOpportunity.Sub_Category__c='Franchise';
         update objOpportunity;
        
        Product2 FranchiseExpressProduct = crtProduct('Franchise_Shipping','Delhivery Commercial Express - C2C');
        FranchiseExpressProduct.Maximum_liability_per_consignment__c=5;
        insert FranchiseExpressProduct;
        
        Product2 HyperlocalProduct = crtProduct('Hyperlocal','Hyperlocal');
        HyperlocalProduct.Maximum_liability_per_consignment__c=5;
        insert  HyperlocalProduct;
        
        Product2 FranchiseSurfaceProduct = crtProduct('Franchise_Shipping','Delhivery Commercial Standard - C2C');
        FranchiseSurfaceProduct.Maximum_liability_per_consignment__c=5;
        insert FranchiseSurfaceProduct;
        
        ID standardPBId = Test.getStandardPricebookId();

        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'C2C Pricing Model';
        insert objpricebookone;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=FranchiseExpressProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        PricebookEntry objPBE1=new PricebookEntry();
        objPBE1.Product2Id=FranchiseSurfaceProduct.Id;
        objPBE1.PriceBook2Id=standardPBId;
        objPBE1.IsActive=true;
        objPBE1.UnitPrice=37;
        insert objPBE1;
        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=FranchiseExpressProduct.Id;
        objPBE2.PriceBook2Id=objpricebookone.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
        PricebookEntry objPBE21=new PricebookEntry();
        objPBE21.Product2Id=FranchiseSurfaceProduct.Id;
        objPBE21.PriceBook2Id=objpricebookone.Id;
        objPBE21.IsActive=true;
        objPBE21.UnitPrice=37;
        insert objPBE21;
        OpportunityLineItem objOLI= TestDataUtility.crtOLI(objOpportunity, objPBE2);
        objOLI.Description__c= 'Test';
        objOLI.Maximum_liability_per_consignment__c=15;
        objOLI.Status__c='Corporate Approved';
        objOLI.Quantity=100;
        objOLI.TotalPrice =1000;
        update objOLI;
         OpportunityLineItem objOLI1= TestDataUtility.crtOLI(objOpportunity, objPBE21);
        objOLI1.Description__c= 'Test';
        objOLI1.Maximum_liability_per_consignment__c=15;
        objOLI1.Status__c='Corporate Approved';
        objOLI1.Quantity=100;
        objOLI1.TotalPrice =1000;
         objOLI1.IsCustom__c=true;
        update objOLI1;
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('Id',objOpportunity.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        FranchisePricingExt objController= new FranchisePricingExt(sc);   
        objController.saveOLI();
        objOLI.Status__c='Corporate Approved';
        update objOLI;
         System.assertEquals('Corporate Approved',objOLI.Status__c);
          objOLI1.Status__c='Corporate Approved';
        update objOLI1;
                  System.assertEquals('Corporate Approved',objOLI1.Status__c);
        objController.saveOLI();
         objController.deleteOLI();
        objController.cancelOLI();
        objController.redirectToCustomPricing();
        objController.redirectToCustom();
        
        Test.stopTest();
    }

    
    
}