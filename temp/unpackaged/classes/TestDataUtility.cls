/*------------------------------------------------------------------
* Author: Techila Global Services Pvt Ltd.
* Apex Class Name: TestDataUtility
* Created Date: 19-June-2016
* Description: Test Data Creation for TestClass
-------------------------------------------------------------------*/

@isTest
public Class TestDataUtility{
    
    public static Account objAccount; 
    public static Contact objContact;
    public static Opportunity objOpportunity;
    public static OpportunityContactRole objOCR;   
    public static Contract__c objContract; 
    public static PricebookEntry objPBE;
    public static Product2 objProduct;
    public static OpportunityLineItem OLI;
    
    // Method to create Account, its associated contacts and Opportunity
    public static Opportunity crtActOppCont(Id recType){
        objAccount= new Account();    
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.RecordTypeId=recType;
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today();
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Email__c = 'test@test.com';
        objOpportunity.Phone__c = '1234567890';
        objOpportunity.Volume_Potential__c = 1;
        objOpportunity.Create_Opportunity__c=true;
        objOpportunity.Co_Loader__c = 'NO';
        insert objOpportunity;
        
        objOCR= new OpportunityContactRole();
        objOCR.ContactId=objContact.Id;
        objOCR.OpportunityId=objOpportunity.Id;
        objOCR.Role='Signing Authority';
        objOCR.IsPrimary=true;
        insert objOCR;
        
        return objOpportunity;    
    }
    
    // Create Contract with associated Opportunity Id
    public static Contract__c crtContract(String type,Id OpportunityId){
        
        objContract = new Contract__c();
        objContract.Type__c= type;
        objContract.Opportunity__c=OpportunityId;
        objContract.Start_Date__c=System.today();
        objContract.Effective_Date__c=Date.Today().addDays(1);
        objContract.End_Date__c=Date.Today().addDays(5);
        objcontract.CurrencyIsoCode = 'INR';
        insert objContract;
        return objContract;
    }
    
    // Create Product with asscoiated PriceBookEntry
    public static PriceBookEntry crtProductwithPBE(String ProductName){
        ID standardPBId = Test.getStandardPricebookId();
        
        PriceBook2 objpricebookone = new PriceBook2();
        objpricebookone.Name = 'Hyperlocal';
        insert objpricebookone;
        
        objProduct = new Product2(Name=ProductName,isActive=true,Intra_City__c = 7);
        insert objProduct;
        
        objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        //objPBE.Name = 'Hyperlocal';
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;
        
        return objPBE;
    }
    
    // Create OLI with associated opportunity and PriceBookEntry
    public static OpportunityLineItem crtOLI(Opportunity objOpportunity2 ,PricebookEntry objPBE){
        OLI=new OpportunityLineItem();
        OLI.OpportunityId=objOpportunity2.id;
        OLI.PricebookEntryId=objPBE.Id;
        OLI.UnitPrice=37;
        OLI.Quantity=1;
        OLI.IsActive__c=true;
        OLI.Status__c='Draft';
        insert OLI;
        
        return OLI;
    }
    
    //Method to create B2B Price
    public static B2B_Price__c crtB2BPrice(OpportunityLineItem OLI){
        B2B_Price__c objB2Bprice = new B2B_Price__c();
        objB2Bprice.Source__c='North';
        objB2Bprice.Destination__c='North';
        objB2Bprice.Amount__c=15;
        objB2Bprice.Opportunity_Line_Item_Id__c=OLI.Id;
        insert objB2Bprice;
        
        return objB2Bprice ;
    }
    public static void productCreation(Product2 objProduct,Opportunity opportunity,Pricebook2 customPB,Category__c objCategory){        
               
        
        objCategory.Sort_Order__c=2;
        insert objCategory;
        
        objProduct.Category__c = objCategory.id;
        insert objProduct;
        
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        // Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = objProduct.Id, UnitPrice = 10000, IsActive = true);
        insert standardPrice;        
        
        // Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = objProduct.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;                  
        
        OpportunityLineItem OLI=new OpportunityLineItem();
        OLI.OpportunityId=opportunity.id;
        OLI.PricebookEntryId=customPrice.Id;
        OLI.UnitPrice=37;
        OLI.Quantity=1;       
        OLI.IsActive__c=false;
        OLI.Status__c='Draft';        
        insert OLI;
        OLI = [SELECT Id, Name FROM OpportunityLineItem WHERE Id =: OLI.Id];
        
        System.debug('OLI.Name-------->'+OLI.Name);
        
    }
    
}