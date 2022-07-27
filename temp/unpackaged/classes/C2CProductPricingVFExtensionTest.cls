@isTest
public class C2CProductPricingVFExtensionTest {         
     public static testMethod void testExpressDifferentRecord2(){
        
        Contact objContact = new Contact(LastName='Test',Email='Test@Test11.com');
        insert objContact;
        
        RecordType rt1=[SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Opportunity' AND DeveloperName ='C2C'];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Opportunity objOpp2=TestDataUtility.crtActOppCont(rt1.Id);  
        objOpp2.Client_Category__c='C2C';
         objOpp2.Sub_Category__c='Mail-Room';
         Update objOpp2;
       
        ID standardPBId = Test.getStandardPricebookId();
        PriceBook2 objpricebook = new PriceBook2();
        objpricebook.Name = 'C2C Pricing Model';
        insert objpricebook;
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Mail_Room' AND SObjectType='Product2' ];
      
         Product2 objProduct = new Product2();
        objProduct.Name='Delhivery Commercial Standard - C2C MailRoom';
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
        objProduct.Wallet_Transaction_Charge__c = 24;
        objProduct.Wallet_Transaction_Rate__c = 24;
        objProduct.Credit_Card_Transaction_Charge__c = 24;
        objProduct.Transaction_Charge__c = 24;
        objProduct.Threshold_Charge__c = 24;
        objProduct.Debit_After_Rates__c = 0.9;
        objProduct.Debit_Before_Rates__c = 1;
            
        objProduct.Volumetric_Formulae__c=5;
        objProduct.Rural_Pin_Code_Pricing__c=5;
        objProduct.Maximum_liability_per_consignment__c=5;
        insert objProduct;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;

        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebook.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
    
          Product2 objProduct1 = new Product2();
        objProduct1.Name='Delhivery Commercial Express - C2C MailRoom';
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
        objProduct1.Wallet_Transaction_Charge__c = 24;
        objProduct1.Wallet_Transaction_Rate__c = 24;
        objProduct1.Credit_Card_Transaction_Charge__c = 24;
        objProduct1.Transaction_Charge__c = 24;
        objProduct1.Threshold_Charge__c = 24;
        objProduct1.Debit_After_Rates__c = 0.9;
        objProduct1.Debit_Before_Rates__c = 1;
            
        objProduct1.Volumetric_Formulae__c=5;
        objProduct1.Rural_Pin_Code_Pricing__c=5;
        objProduct1.Maximum_liability_per_consignment__c=5;
        insert objProduct1;
        
        PricebookEntry objPBE1=new PricebookEntry();
        objPBE1.Product2Id=objProduct1.Id;
        objPBE1.PriceBook2Id=standardPBId;
        objPBE1.IsActive=true;
        objPBE1.UnitPrice=37;
        insert objPBE1;

        PricebookEntry objPBE21=new PricebookEntry();
        objPBE21.Product2Id=objProduct1.Id;
        objPBE21.PriceBook2Id=objpricebook.Id;
        objPBE21.IsActive=true;
        objPBE21.UnitPrice=37;
        insert objPBE21;
          OpportunityLineItem objOLI1= new OpportunityLineItem();
        objOLI1.Description__c='Test';
        objOLI1.COD_Charges__c=12;
         ObjOLI1.Credit_Card_Rates__c = 13;
         objOLI1.Frieght_Value_Factor__c = 12;
        objOLI1.Wallet_Transaction_Charge__c = 24;
        objOLI1.Wallet_Transaction_Rate__c = 24;
        objOLI1.Credit_Card_Transaction_Charge__c = 24;
        objOLI1.Transaction_Charge__c = 24;
        objOLI1.Threshold_Charge__c = 24;
        objOLI1.Debit_After_Rates__c = 0.9;
        objOLI1.Debit_Before_Rates__c = 1;
        objOLI1.Volumetric_Formulae__c=12;
        objOLI1.Service_Charges__c=12;
        objOLI1.Fuel_Surcharge__c=10;
        objOLI1.Maximum_liability_per_consignment__c=10; 
        objOLI1.IsActive__c=TRUE;
        objOLI1.OpportunityId=objOpp2.Id;  
        objOLI1.PricebookEntryId=objPBE21.Id; 
         objOLI1.Maximum_Liability_for_Reverse__c =10;
         ObjOLI1.Maximum_Liability_for_Reverse_Percent__c = null;
         
        objOLI1.Quantity=10;
        objOLI1.TotalPrice=100;
        insert objOLI1;

        OpportunityLineItem objOLI= new OpportunityLineItem();
        objOLI.Description__c='Test';
        objOLI.COD_Charges__c=12;
         ObjOLI.Credit_Card_Rates__c = 13;
         objOLI.Frieght_Value_Factor__c = 12;
        objOLI.Wallet_Transaction_Charge__c = 24;
        objOLI.Wallet_Transaction_Rate__c = 24;
        objOLI.Credit_Card_Transaction_Charge__c = 24;
        objOLI.Transaction_Charge__c = 24;
        objOLI.Threshold_Charge__c = 24;
        objOLI.Debit_After_Rates__c = 0.9;
        objOLI.Debit_Before_Rates__c = 1;
        objOLI.Volumetric_Formulae__c=12;
        objOLI.Service_Charges__c=12;
        objOLI.Fuel_Surcharge__c=10;
        objOLI.Maximum_liability_per_consignment__c=10; 
        objOLI.IsActive__c=TRUE;
        objOLI.OpportunityId=objOpp2.Id;  
        objOLI.PricebookEntryId=objPBE2.Id; 
         objOLI.Maximum_Liability_for_Reverse__c =10;
         ObjOLI.Maximum_Liability_for_Reverse_Percent__c = null;
         
        objOLI.Quantity=10;
        objOLI.TotalPrice=100;
        insert objOLI;
        
        
        Contract__c objContract = new Contract__c();
        
        insert objContract;
                
        ApexPages.currentPage().getParameters().put('Id',objOpp2.id);
        ApexPages.currentPage().getParameters().put('ContractId',objContract.id);
        ApexPages.currentPage().getParameters().put('ContactId',objContact.id);
        ApexPages.StandardController objStdController2 = new ApexPages.StandardController(objOpp2);
        C2CProductPricingVFExtension objExtension = new C2CProductPricingVFExtension(objStdController2); 
        objExtension.directToPricing();
        objExtension.getPrintView();
        objExtension.description = 'Test description';
    }
    public static testMethod void toTestProductPricing()
    {
        
        RecordType rt=[SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Opportunity' AND DeveloperName ='Standard_Shipping'];
        Opportunity objOpp=TestDataUtility.crtActOppCont(rt.Id);
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Test.startTest();
        //Pass essential parameters to page
        PageReference pageRef = Page.ProductPricingVFNew;
        pageRef.getParameters().put('Id',objOpp.id);
        Test.setCurrentPage(pageRef);     

        //Create controller instance and specify type of standard controller  
        ApexPages.StandardController objStdController = new ApexPages.StandardController(objOpp);
        C2CProductPricingVFExtension objProductPricing = new C2CProductPricingVFExtension(objStdController);
        objProductPricing.downloadContract();
        objProductPricing.redirectToOpp();
        objProductPricing.generatePricingPDF();
        Test.stopTest();
    }
    public static testMethod void testExpress(){
         
        RecordType rt2=[SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Opportunity' AND DeveloperName ='Express_Shipping'];
        Opportunity objOpp2=TestDataUtility.crtActOppCont(rt2.Id);
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        ApexPages.currentPage().getParameters().put('Id',objOpp2.id);
        ApexPages.StandardController objStdController2 = new ApexPages.StandardController(objOpp2);
        C2CProductPricingVFExtension objExtension = new C2CProductPricingVFExtension(objStdController2);
    }
    public static testMethod void testExpresswithSlabs(){
        
        Contact objContact = new Contact(LastName='Test',Email='Test@Test11.com');
        insert objContact;
        
        RecordType rt1=[SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Opportunity' AND DeveloperName ='Express_Shipping'];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Opportunity objOpp2=TestDataUtility.crtActOppCont(rt1.Id);
        
        ID standardPBId = Test.getStandardPricebookId();
        PriceBook2 objpricebook = new PriceBook2();
        objpricebook.Name = 'Express Shipping';
        insert objpricebook;
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Express_Shipping' AND SObjectType='Product2' ];
        Product2 objProduct = new Product2();
        objProduct.Name='Express Shipping';
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
        objProduct.Wallet_Transaction_Charge__c = 24;
        objProduct.Wallet_Transaction_Rate__c = 24;
        objProduct.Credit_Card_Transaction_Charge__c = 24;
        objProduct.Transaction_Charge__c = 24;
        objProduct.Threshold_Charge__c = 24;
        objProduct.Debit_After_Rates__c = 0.9;
        objProduct.Debit_Before_Rates__c = 1;
            
        objProduct.Volumetric_Formulae__c=5;
        objProduct.Rural_Pin_Code_Pricing__c=5;
        objProduct.Maximum_liability_per_consignment__c=5;
        insert objProduct;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;

        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebook.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
    
        OpportunityLineItem objOLI= new OpportunityLineItem();
        objOLI.Description__c='Test';
        objOLI.COD_Charges__c=12;
        objOLI.COD_Value__c=12;
        objOLI.Wallet_Transaction_Charge__c = 24;
        objOLI.Wallet_Transaction_Rate__c = 24;
        objOLI.Credit_Card_Transaction_Charge__c = 24;
        objOLI.Transaction_Charge__c = 24;
        objOLI.Threshold_Charge__c = 24;
        objOLI.Debit_After_Rates__c = 0.9;
        objOLI.Debit_Before_Rates__c = 1;
        objOLI.Volumetric_Formulae__c=12;
        objOLI.Service_Charges__c=12;
        objOLI.Fuel_Surcharge__c=10;
        objOLI.Maximum_liability_per_consignment__c=10; 
        objOLI.IsActive__c=TRUE;
        objOLI.OpportunityId=objOpp2.Id;  
        objOLI.PricebookEntryId=objPBE2.Id; 
        objOLI.Quantity=10;
        objOLI.TotalPrice=100;
        insert objOLI;
        
        List<Slab_Price__c> slabList= new List<Slab_Price__c>();
        Slab_Price__c objForwardSlab = new Slab_Price__c();
        objForwardSlab.Opportunity__c=objOpp2.Id;
        objForwardSlab.Opportunity_Line_Item_Id__c=objOLI.Id;
        objForwardSlab.Start_Range__c=10;   
        objForwardSlab.End_Range__c=20;
        objForwardSlab.Slab__c=15;
        objForwardSlab.Type__c='Base';
        slabList.add(objForwardSlab);
        
        Slab_Price__c objRTOSlab = new Slab_Price__c();
        objRTOSlab.Opportunity__c=objOpp2.Id;
        objRTOSlab.Opportunity_Line_Item_Id__c=objOLI.Id;
        objRTOSlab.Start_Range__c=10;   
        objRTOSlab.End_Range__c=20;
        objRTOSlab.Slab__c=15;
        objRTOSlab.Type__c='RTO';
        slabList.add(objRTOSlab);
        
        Slab_Price__c objDTOSlab = new Slab_Price__c();
        objDTOSlab.Opportunity__c=objOpp2.Id;
        objDTOSlab.Opportunity_Line_Item_Id__c=objOLI.Id;
        objDTOSlab.Start_Range__c=10;   
        objDTOSlab.End_Range__c=20;
        objDTOSlab.Slab__c=15;
        objDTOSlab.Type__c='DTO';
        slabList.add(objDTOSlab);
        insert slabList;
        
        Contract__c objContract = new Contract__c();
        
        insert objContract;
                
        ApexPages.currentPage().getParameters().put('Id',objOpp2.id);
        ApexPages.currentPage().getParameters().put('ContractId',objContract.id);
        ApexPages.currentPage().getParameters().put('ContactId',objContact.id);
        ApexPages.StandardController objStdController2 = new ApexPages.StandardController(objOpp2);
        C2CProductPricingVFExtension objExtension = new C2CProductPricingVFExtension(objStdController2); 
        objExtension.directToPricing();
        objExtension.getPrintView();
        objExtension.description = 'Test description';
    }
    public static testMethod void testExpressDifferentRecord(){
        
        Contact objContact = new Contact(LastName='Test',Email='Test@Test11.com');
        insert objContact;
        
        RecordType rt1=[SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Opportunity' AND DeveloperName ='Express_Shipping'];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Opportunity objOpp2=TestDataUtility.crtActOppCont(rt1.Id);
        
        ID standardPBId = Test.getStandardPricebookId();
        PriceBook2 objpricebook = new PriceBook2();
        objpricebook.Name = 'Express Shipping';
        insert objpricebook;
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Express_Shipping' AND SObjectType='Product2' ];
        Product2 objProduct = new Product2();
        objProduct.Name='Express Shipping';
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
        objProduct.Wallet_Transaction_Charge__c = 24;
        objProduct.Wallet_Transaction_Rate__c = 24;
        objProduct.Credit_Card_Transaction_Charge__c = 24;
        objProduct.Transaction_Charge__c = 24;
        objProduct.Threshold_Charge__c = 24;
        objProduct.Debit_After_Rates__c = 0.9;
        objProduct.Debit_Before_Rates__c = 1;
            
        objProduct.Volumetric_Formulae__c=5;
        objProduct.Rural_Pin_Code_Pricing__c=5;
        objProduct.Maximum_liability_per_consignment__c=5;
        insert objProduct;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;

        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebook.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
    
        OpportunityLineItem objOLI= new OpportunityLineItem();
        objOLI.Description__c='Test';
        objOLI.COD_Value__c=12;
        objOLI.Wallet_Transaction_Charge__c = 24;
        objOLI.Wallet_Transaction_Rate__c = 24;
        objOLI.Credit_Card_Transaction_Charge__c = 24;
        objOLI.Transaction_Charge__c = 24;
        objOLI.Threshold_Charge__c = 24;
        objOLI.Debit_After_Rates__c = 0.9;
        objOLI.Debit_Before_Rates__c = 1;
        objOLI.Volumetric_Formulae__c=12;
        objOLI.Service_Charges__c=12;
        objOLI.Fuel_Surcharge__c=10;
        objOLI.Maximum_liability_per_consignment__c=10; 
        objOLI.IsActive__c=TRUE;
        objOLI.OpportunityId=objOpp2.Id;  
        ObjOLI.Frieght_Value_Factor__c =0;
        objOLI.PricebookEntryId=objPBE2.Id; 
        objOLI.Quantity=10;
        objOLI.TotalPrice=100;
        ObjOLI.Maximum_Liability_for_Reverse__c = null;
        ObjOLI.Maximum_Liability_for_Reverse_Percent__c = 12;
        insert objOLI;         
        List<Slab_Price__c> slabList= new List<Slab_Price__c>();
        Slab_Price__c objForwardSlab = new Slab_Price__c();
        objForwardSlab.Opportunity__c=objOpp2.Id;
        objForwardSlab.Opportunity_Line_Item_Id__c=objOLI.Id;
        objForwardSlab.Start_Range__c=10;   
        objForwardSlab.End_Range__c=20;
        objForwardSlab.Slab__c=15;
        objForwardSlab.Type__c='Base';
        slabList.add(objForwardSlab);
        
        Slab_Price__c objRTOSlab = new Slab_Price__c();
        objRTOSlab.Opportunity__c=objOpp2.Id;
        objRTOSlab.Opportunity_Line_Item_Id__c=objOLI.Id;
        objRTOSlab.Start_Range__c=10;   
        objRTOSlab.End_Range__c=20;
        objRTOSlab.Slab__c=15;
        objRTOSlab.Type__c='RTO';
        slabList.add(objRTOSlab);
        
        Slab_Price__c objDTOSlab = new Slab_Price__c();
        objDTOSlab.Opportunity__c=objOpp2.Id;
        objDTOSlab.Opportunity_Line_Item_Id__c=objOLI.Id;
        objDTOSlab.Start_Range__c=10;   
        objDTOSlab.End_Range__c=20;
        objDTOSlab.Slab__c=15;
        objDTOSlab.Type__c='DTO';
        slabList.add(objDTOSlab);
        insert slabList;
        
        Contract__c objContract = new Contract__c();
        
        insert objContract;
                 
        ApexPages.currentPage().getParameters().put('Id',objOpp2.id);
        ApexPages.currentPage().getParameters().put('ContractId',objContract.id);
        ApexPages.currentPage().getParameters().put('ContactId',objContact.id);
        ApexPages.StandardController objStdController2 = new ApexPages.StandardController(objOpp2);
        C2CProductPricingVFExtension objExtension = new C2CProductPricingVFExtension(objStdController2); 
        objExtension.directToPricing();
        objExtension.getPrintView();
        objExtension.description = 'Test description';
    }
     public static testMethod void testExpressDifferentRecord1(){
        
        Contact objContact = new Contact(LastName='Test',Email='Test@Test11.com');
        insert objContact;
        
        RecordType rt1=[SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Opportunity' AND DeveloperName ='C2C'];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Opportunity objOpp2=TestDataUtility.crtActOppCont(rt1.Id);
        objOpp2.Client_Category__c='C2C';
         objOpp2.Sub_Category__c='Franchise';
         Update objOpp2;
        ID standardPBId = Test.getStandardPricebookId();
        PriceBook2 objpricebook = new PriceBook2();
        objpricebook.Name = 'C2C Pricing Model';
        insert objpricebook;
        
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName='Franchise_Shipping' AND SObjectType='Product2' ];
      
         Product2 objProduct = new Product2();
        objProduct.Name='Delhivery Commercial Standard - C2C';
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
        objProduct.Wallet_Transaction_Charge__c = 24;
        objProduct.Wallet_Transaction_Rate__c = 24;
        objProduct.Credit_Card_Transaction_Charge__c = 24;
        objProduct.Transaction_Charge__c = 24;
        objProduct.Threshold_Charge__c = 24;
        objProduct.Debit_After_Rates__c = 0.9;
        objProduct.Debit_Before_Rates__c = 1;
            
        objProduct.Volumetric_Formulae__c=5;
        objProduct.Rural_Pin_Code_Pricing__c=5;
        objProduct.Maximum_liability_per_consignment__c=5;
        insert objProduct;
        
        PricebookEntry objPBE=new PricebookEntry();
        objPBE.Product2Id=objProduct.Id;
        objPBE.PriceBook2Id=standardPBId;
        objPBE.IsActive=true;
        objPBE.UnitPrice=37;
        insert objPBE;

        PricebookEntry objPBE2=new PricebookEntry();
        objPBE2.Product2Id=objProduct.Id;
        objPBE2.PriceBook2Id=objpricebook.Id;
        objPBE2.IsActive=true;
        objPBE2.UnitPrice=37;
        insert objPBE2;
    
          Product2 objProduct1 = new Product2();
        objProduct1.Name='Delhivery Commercial Express - C2C';
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
        objProduct1.Wallet_Transaction_Charge__c = 24;
        objProduct1.Wallet_Transaction_Rate__c = 24;
        objProduct1.Credit_Card_Transaction_Charge__c = 24;
        objProduct1.Transaction_Charge__c = 24;
        objProduct1.Threshold_Charge__c = 24;
        objProduct1.Debit_After_Rates__c = 0.9;
        objProduct1.Debit_Before_Rates__c = 1;
            
        objProduct1.Volumetric_Formulae__c=5;
        objProduct1.Rural_Pin_Code_Pricing__c=5;
        objProduct1.Maximum_liability_per_consignment__c=5;
        insert objProduct1;
        
        PricebookEntry objPBE1=new PricebookEntry();
        objPBE1.Product2Id=objProduct1.Id;
        objPBE1.PriceBook2Id=standardPBId;
        objPBE1.IsActive=true;
        objPBE1.UnitPrice=37;
        insert objPBE1;

        PricebookEntry objPBE21=new PricebookEntry();
        objPBE21.Product2Id=objProduct1.Id;
        objPBE21.PriceBook2Id=objpricebook.Id;
        objPBE21.IsActive=true;
        objPBE21.UnitPrice=37;
        insert objPBE21;
          OpportunityLineItem objOLI1= new OpportunityLineItem();
        objOLI1.COD_Value__c = null;
        objOLI1.Description__c='Test';
        objOLI1.COD_Charges__c=12;
         ObjOLI1.Credit_Card_Rates__c = 13;
         objOLI1.Frieght_Value_Factor__c = 12;
        objOLI1.Wallet_Transaction_Charge__c = 24;
        objOLI1.Wallet_Transaction_Rate__c = 24;
        objOLI1.Credit_Card_Transaction_Charge__c = 24;
        objOLI1.Transaction_Charge__c = 24;
        objOLI1.Threshold_Charge__c = 24;
        objOLI1.Debit_After_Rates__c = 0.9;
        objOLI1.Debit_Before_Rates__c = 1;
        objOLI1.Volumetric_Formulae__c=12;
        objOLI1.Service_Charges__c=12;
        objOLI1.Fuel_Surcharge__c=10;
        objOLI1.Maximum_liability_per_consignment__c=10; 
        objOLI1.IsActive__c=TRUE;
        objOLI1.OpportunityId=objOpp2.Id;  
        objOLI1.PricebookEntryId=objPBE21.Id; 
         objOLI1.Maximum_Liability_for_Reverse__c =10;
         ObjOLI1.Maximum_Liability_for_Reverse_Percent__c = null;
         
        objOLI1.Quantity=10;
        objOLI1.TotalPrice=100;
        insert objOLI1;

        OpportunityLineItem objOLI= new OpportunityLineItem();
         objOLI.COD_Value__c=null;
        objOLI.Description__c='Test';
        objOLI.COD_Charges__c=12;
         ObjOLI.Credit_Card_Rates__c = 13;
         objOLI.Frieght_Value_Factor__c = 12;
        objOLI.Wallet_Transaction_Charge__c = 24;
        objOLI.Wallet_Transaction_Rate__c = 24;
        objOLI.Credit_Card_Transaction_Charge__c = 24;
        objOLI.Transaction_Charge__c = 24;
        objOLI.Threshold_Charge__c = 24;
        objOLI.Debit_After_Rates__c = 0.9;
        objOLI.Debit_Before_Rates__c = 1;
        objOLI.Volumetric_Formulae__c=12;
        objOLI.Service_Charges__c=12;
        objOLI.Fuel_Surcharge__c=10;
        objOLI.Maximum_liability_per_consignment__c=10; 
        objOLI.IsActive__c=TRUE;
        objOLI.OpportunityId=objOpp2.Id;  
        objOLI.PricebookEntryId=objPBE2.Id; 
         objOLI.Maximum_Liability_for_Reverse__c =10;
         ObjOLI.Maximum_Liability_for_Reverse_Percent__c = null;
         
        objOLI.Quantity=10;
        objOLI.TotalPrice=100;
        insert objOLI;
        
        
        Contract__c objContract = new Contract__c();
        
        insert objContract;
                
        ApexPages.currentPage().getParameters().put('Id',objOpp2.id);
        ApexPages.currentPage().getParameters().put('ContractId',objContract.id);
        ApexPages.currentPage().getParameters().put('ContactId',objContact.id);
        ApexPages.StandardController objStdController2 = new ApexPages.StandardController(objOpp2);
        C2CProductPricingVFExtension objExtension = new C2CProductPricingVFExtension(objStdController2); 
        objExtension.directToPricing();
        objExtension.getPrintView();
        objExtension.description = 'Test description';
    }

}