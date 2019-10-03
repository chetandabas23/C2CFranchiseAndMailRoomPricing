public class FranchisePricingExt{
    public String oppId{get;set;}
    public Opportunity opp{get;set;}
    public Product2 product{get;set;}
    public Product2 productExp{get;set;}
    public Product2 productSur{get;set;}
    public OpportunityLineItem objOLI{get;set;}
    public String oliId{get;set;}
    public Product2 objProduct;
    public Product2 objProduct1;
    public OpportunityLineItem objectOLI{get; set;}
    public OpportunityLineItem objectOLI1{get; set;}
    public List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
    public List<OpportunityLineItem> oliList1 = new List<OpportunityLineItem>();
    public String productName;
    public String productName1;
    public String PricebookName;
    public String description{get;set;}
    public List<PriceBookEntry> listPriceBookEntry = new List<PriceBookEntry>();
    public String descString{get;set;}
    public String descString1{get;set;}
    public Integer counter;
    public List<Hyperlocal_Price__c> hpList{get;set;}
    public List<Hyperlocal_Price__c> hpListproduct{get;set;} 
    public Hyperlocal_Price__c objHyperLocal{get;set;}
    public List<Hyperlocal_Price__c> deleteHpList = new List<Hyperlocal_Price__c>();
    public List<Hyperlocal_Price__c> hpListproduct1{get;set;}
    public UserRole roleName{get;set;}
    public boolean isStatusSubmitted{get;set;} 
    public String successError{get;set;}
    public String msg{get;set;}
    public boolean showContent{get;set;}
    public String selectedOption {set;get;}
    public Decimal selectedPrice {set;get;}
    public list<Product2> listProductExpress{get;set;}
    public list<Decimal> listRackRateExpress{get;set;}
    public list<Product2> listProductStandard{get;set;}
    public list<Decimal> listRackRateStandard{get;set;}
    Public List<OpportunityLineItem> lstCmprOLI = new List<OpportunityLineItem>();
    Public List<String> lstStrInactive = new List<String>();
    Public Integer intMaxDiscount;
    Public Integer intMaxDiscount1;
    public FranchisePricingExt(ApexPages.StandardController stdController) {
        isStatusSubmitted = false;
        successError = '';
        msg ='';
        showContent= false;
        oppId = ApexPages.currentPage().getParameters().get('id');
         productName = '';
        productNAme1 = '';
         opp = [select id,Approval__c,RecordType.DeveloperName, Client_Category__c,Sub_Category__c,Status__c, Email__c, Phone__c, Counter__c, Maximum_Discount__c,Pricebook2Id, (Select Id, Description__c, Maximum_liability_per_consignment__c,Maximum_Liability_for_Reverse_Percent__c,Maximum_Liability_for_Reverse__c, Status__c From OpportunityLineItems Where IsActive__c=TRUE limit 1) from Opportunity where id =: oppId];
        System.debug('List of Opportunity is '+opp);
         objectOLI = new OpportunityLineItem();
        objectOLI1 = new OpportunityLineItem();
        objProduct = new Product2();
        objProduct1 = new Product2();
        counter = 0;
        listProductExpress = new list<Product2>();
        listRackRateExpress = new list<Decimal>();
        listProductStandard = new list<Product2>();
        listRackRateStandard = new list<Decimal>();
        if (opp.RecordType.DeveloperName == 'C2C' && oppId != null && opp.Sub_Category__c=='Franchise') {
            System.debug('If Opportunity Record Type is C2C and SubCategory is Franchise');
            productName1 = System.Label.Franchise_Express;
            System.debug('Value in ProductName1 is '+productName1);
            productName = System.Label.Franchise_Standard;
            System.debug('Value in productName is '+productName);
            PricebookName= System.Label.C2C_Pricebook;
            PopulateOLIValues(); 
        }
        
        if(opp.RecordType.DeveloperName == 'C2C' && oppId != null && opp.Sub_Category__c=='Mail-Room') {
            System.debug('If the Opportunity Record type is C2C and SubCategory is Mail Room');
            productName1 = System.Label.MailRoom_Express;
            System.debug('Value in ProductName1 is '+productName1);
            productName = System.Label.MailRoom_Standard;
            System.debug('Value in ProductName1 is '+productName);
            PricebookName=System.Label.C2C_Pricebook;
            PopulateOLIValues();
        }
        productExp = Database.Query('select id, Maximum_liability_per_consignment__c,Maximum_Liability_for_Reverse_Percent__c,Maximum_Liability_for_Reverse__c from Product2 where Name ='+ '\'' +productName1 +'\'' +' limit 1');
        System.debug('Express Product is '+productExp);
        productSur = Database.Query('select id, Maximum_liability_per_consignment__c,Maximum_Liability_for_Reverse_Percent__c,Maximum_Liability_for_Reverse__c from Product2 where Name ='+ '\'' +productName +'\'' +' limit 1');
        System.debug('Surface Product is '+productSur);      
         System.debug('ProductName is '+productName1);
        System.debug('Value is SELECT Id,Zone_A_0_250gm__c FROM Product2 where Name = '+ '\'' +productName1+'\'');
        listProductExpress = Database.query('SELECT Id,Zone_A_0_250gm__c,Zone_B_0_250gm__c,Zone_C_0_250gm__c,Zone_D_0_250gm__c,Zone_E_0_250gm__c,Zone_A_Additional_250_gms_till_500_gms__c,Zone_B_Additional_250_gms_till_500_gms__c,Zone_C_Additional_250_gms_till_500_gms__c,Zone_D_Additional_250_gms_till_500_gms__c,Zone_E_Additional_250_gms_till_500_gms__c,Zone_A_Additional_500_gm_till_5kg__c,Zone_B_Additional_500_gm_till_5kg__c,Zone_C_Additional_500_gm_till_5kg__c,Zone_D_Additional_500_gm_till_5kg__c,Zone_E_Additional_500_gm_till_5kg__c,Zone_A_Additional_1kg_Above_5kg__c,Zone_B_Additional_1kg_Above_5kg__c,Zone_C_Additional_1kg_Above_5kg__c,Zone_D_Additional_1kg_Above_5kg__c,Zone_E_Additional_1kg_Above_5kg__c FROM Product2 where Name = '+ '\'' +productName1+'\'');
        System.debug('List of Express Shipping Products are '+listProductExpress);
        for(Product2 objProd: listProductExpress){
            System.debug('Inside the for loop of Express Shipping Product');
            listRackRateExpress.add(objProd.Zone_A_0_250gm__c);
            listRackRateExpress.add(objProd.Zone_B_0_250gm__c);
            listRackRateExpress.add(objProd.Zone_C_0_250gm__c);
            listRackRateExpress.add(objProd.Zone_D_0_250gm__c);
            listRackRateExpress.add(objProd.Zone_E_0_250gm__c);
            
            listRackRateExpress.add(objProd.Zone_A_Additional_250_gms_till_500_gms__c);
            listRackRateExpress.add(objProd.Zone_B_Additional_250_gms_till_500_gms__c);
            listRackRateExpress.add(objProd.Zone_C_Additional_250_gms_till_500_gms__c);
            listRackRateExpress.add(objProd.Zone_D_Additional_250_gms_till_500_gms__c);
            listRackRateExpress.add(objProd.Zone_E_Additional_250_gms_till_500_gms__c);
            
            listRackRateExpress.add(objProd.Zone_A_Additional_500_gm_till_5kg__c);
            listRackRateExpress.add(objProd.Zone_B_Additional_500_gm_till_5kg__c);
            listRackRateExpress.add(objProd.Zone_C_Additional_500_gm_till_5kg__c);
            listRackRateExpress.add(objProd.Zone_D_Additional_500_gm_till_5kg__c);
            listRackRateExpress.add(objProd.Zone_E_Additional_500_gm_till_5kg__c);
            
            listRackRateExpress.add(objProd.Zone_A_Additional_1kg_Above_5kg__c);
            listRackRateExpress.add(objProd.Zone_B_Additional_1kg_Above_5kg__c);
            listRackRateExpress.add(objProd.Zone_C_Additional_1kg_Above_5kg__c);
            listRackRateExpress.add(objProd.Zone_D_Additional_1kg_Above_5kg__c);
            listRackRateExpress.add(objProd.Zone_E_Additional_1kg_Above_5kg__c);
       
        }
        
        
        System.debug('ProductName is '+productName);
        System.debug('Value is SELECT Id,Zone_A_0_250gm__c FROM Product2 where Name = '+ '\'' +productName+'\'');
        listProductStandard = Database.Query('SELECT Id,Zone_A_0_250gm__c,Zone_B_0_250gm__c,Zone_C_0_250gm__c,Zone_D_0_250gm__c,Zone_E_0_250gm__c,Zone_A_Additional_250_gms_till_500_gms__c,Zone_B_Additional_250_gms_till_500_gms__c,Zone_C_Additional_250_gms_till_500_gms__c,Zone_D_Additional_250_gms_till_500_gms__c,Zone_E_Additional_250_gms_till_500_gms__c,Zone_A_Additional_500_gm_till_5kg__c,Zone_B_Additional_500_gm_till_5kg__c,Zone_C_Additional_500_gm_till_5kg__c,Zone_D_Additional_500_gm_till_5kg__c,Zone_E_Additional_500_gm_till_5kg__c,Zone_A_Additional_1kg_Above_5kg__c,Zone_B_Additional_1kg_Above_5kg__c,Zone_C_Additional_1kg_Above_5kg__c,Zone_D_Additional_1kg_Above_5kg__c,Zone_E_Additional_1kg_Above_5kg__c FROM Product2 where Name = '+ '\'' +productName+'\'');
        System.debug('List of Standard Shipping Products are '+listProductStandard);
        for(Product2 objStdProd : listProductStandard){
            System.debug('Inside the for loop for standard shipping products');
            listRackRateStandard.add(objStdProd.Zone_A_0_250gm__c);
            listRackRateStandard.add(objStdProd.Zone_B_0_250gm__c);
            listRackRateStandard.add(objStdProd.Zone_C_0_250gm__c);
            listRackRateStandard.add(objStdProd.Zone_D_0_250gm__c);
            listRackRateStandard.add(objStdProd.Zone_E_0_250gm__c);
                     
            listRackRateStandard.add(objStdProd.Zone_A_Additional_250_gms_till_500_gms__c);
            listRackRateStandard.add(objStdProd.Zone_B_Additional_250_gms_till_500_gms__c);
            listRackRateStandard.add(objStdProd.Zone_C_Additional_250_gms_till_500_gms__c);
            listRackRateStandard.add(objStdProd.Zone_D_Additional_250_gms_till_500_gms__c);
            listRackRateStandard.add(objStdProd.Zone_E_Additional_250_gms_till_500_gms__c);
            
            listRackRateStandard.add(objStdProd.Zone_A_Additional_500_gm_till_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_B_Additional_500_gm_till_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_C_Additional_500_gm_till_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_D_Additional_500_gm_till_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_E_Additional_500_gm_till_5kg__c);
                      
            listRackRateStandard.add(objStdProd.Zone_A_Additional_1kg_Above_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_B_Additional_1kg_Above_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_C_Additional_1kg_Above_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_D_Additional_1kg_Above_5kg__c);
            listRackRateStandard.add(objStdProd.Zone_E_Additional_1kg_Above_5kg__c);
            
        }
        
    }
    
    
    public List<SelectOption> getOptions(){
        System.debug('Inside the getoptions method that will give Add and Subtract Value to a picklist');
        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption( ' ' ,'---Select---'));
        optionList.add(new SelectOption( 'Add' ,'Add'));
        optionList.add(new SelectOption( 'Subtract' ,'Subtract'));
        return optionList;
    }
    public PageReference redirectToCustom() {
        System.debug('Inside the RedirectToCustom Method');
        if (oppId != null) {
            List <Slab_Price__c> slabPriceList = new List < Slab_Price__c > ();
            slabPriceList = [SELECT Id FROM Slab_Price__c WHERE Opportunity__c =: oppId];
            System.debug('List of slab price if opportunity id is not equal to null');
            if (slabPriceList.size() > 0) {
                System.debug('If size of slab price list is not equal to null');
                PageReference pg = new pageReference('/apex/ProductCustomPricingEditableVF?id=' + oppId);
                pg.setRedirect(true);
                return pg;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }
    
    public void PopulateOLIValues() {
        System.debug('Inside the Populate Opportunity Line Item Method');
        Schema.DescribesObjectResult r = OpportunityLineItem.sObjectType.getDescribe();
        Map < String, Schema.SObjectField > mapFields = new Map < String, Schema.sObjectField > ();
        mapFields = r.fields.getMap();
        String OliQuery = 'Select ';
        String OliQuery1 = 'Select ';
        String FieldNames = '';
        for (String apiName: mapFields.KeySet()) {
            FieldNames += apiName + ',';
        }
        FieldNames = FieldNames.subString(0, FieldNames.length() - 1);
        System.debug('value of product name is '+productName);
        System.debug('Value of product name1 is '+productName1);
        OliQuery += FieldNames + ' FROM OpportunityLineItem WHERE OpportunityId ='+ '\'' +oppId +'\'' +' AND IsActive__c = true AND NAME LIKE '+ '\'%' +productName+'%'+'\' LIMIT 1';
        OliQuery1 += FieldNames + ' FROM OpportunityLineItem WHERE OpportunityId ='+ '\'' +oppId +'\'' +' AND IsActive__c = true AND NAME LIKE '+ '\'%' +productName1+'%'+'\' LIMIT 1' ;
        System.debug('Final Query for Opportunity Line ITem where Product Name is Express Shipping:- '+oliQuery1);
        System.debug('Final Query for Opportunity Line ITem where Product Name is Standard Shipping:- '+oliQuery);
        try {
            oliList1 = Database.Query(OliQuery1);
            System.debug('Value in oliList1 is '+oliList1);
             oliList = Database.Query(oliQuery);
            System.debug('Value in oliList is '+oliList);
        } catch (Exception e) {
            showContent = true;
            successError = 'error';
            msg =e.getMessage();
        }
        if (oliList1.size() == 0) {
            System.debug('If List of Opportunity Line item is equal to zero where product name is express shipping');
            System.debug('OLILIST1 is '+oliList1);
            CheckExistingProduct();
        } 
        if(oliList.size() == 0 ) {
            System.debug('If list of opportunity line item is equal to zero where product name is standard shipping');
            System.debug('OLILIST is '+oliList);
            CheckExistingProduct();
        }
        if(oliList.size() > 0){
            if(oliList[0].isCustom__c){
                System.debug('If list of opportunity line item is greater than zero where product name is standard shipping and that is a custom object');
                CheckExistingProduct();
            }
            if(!oliList[0].isCustom__c){
                System.debug('If list of opportunity line item is greater than zero where product name is standard shipping and that is not a custom object');
                objectOLI = oliList[0];
                System.debug('Value of objectOLI is '+objectOLI);
            }
        }
        if(oliList1.size() >0 ){
            if(oliList1[0].isCustom__c){
                System.debug('If list of opportunity line item is greater than zero where product name is express shipping and that is a custom object');
                CheckExistingProduct();
            }
            if(!oliList1[0].isCustom__c){
                System.debug('If list of opportunity line item is greater than zero where product name is express shipping and that is not a custom object');
                objectOLI1 = oliList1[0];
                System.debug('Value of objectOLI1 is '+objectOLI1);
            }
        }
    } 
   public void CheckExistingProduct() {       
        System.debug('Inside the CheckExisting Product Method');
       	System.debug('Value of ObjectOLI Status is '+ObjectOLI);
        System.debug('Value of ObjectOLI1 Status is '+ObjectOLI1);
        Schema.DescribesObjectResult r = Product2.sObjectType.getDescribe();
        Map < String, Schema.SObjectField > mapFields = new Map < String, Schema.sObjectField > ();
        mapFields = r.fields.getMap();
        String ProductQuery = 'Select ';
        String ProductQuery1 = 'Select ';
        String FieldNames = '';
        for (String apiName: mapFields.KeySet()) {
            FieldNames += apiName + ',';
        }
        FieldNames = FieldNames.subString(0, FieldNames.length() - 1);
        ProductQuery += FieldNames + ' FROM Product2 WHERE Name LIKE '+ '\'%' +productName+'%'+'\' LIMIT 1';
        System.debug('Final Generated query of Standard product is '+ProductQuery);
        ProductQuery1 += FieldNames + ' FROM Product2 WHERE Name LIKE '+ '\'%' +productName1+'%'+'\' LIMIT 1';
        System.debug('Final Generated query of Express product is '+ProductQuery1);
        try {
            objProduct = Database.Query(ProductQuery); 
            System.debug('Value of objProduct is '+objProduct);
            objProduct1 = Database.Query(ProductQuery1);       
            System.debug('Value of objProduct is '+objProduct1);
        }
        Catch(Exception e) {
            showContent = true;
            successError = 'error';
            msg = 'No Standard Shipping or express shipping Product Added';
        }
        if(productName !=null)
        {
        try {
           
            PriceBook2 objPB = [SELECT Id, Name, (SELECT Id, Name FROM PricebookEntries WHERE Name LIKE: productName limit 1) FROM PriceBook2 WHERE Name LIKE: PricebookName LIMIT 1];
            System.debug('Value of Pricebook list is '+objPB);
            objectOLI.PricebookEntryId = objPB.PricebookEntries[0].Id;
            System.debug('Value of PricebookEntry Name is '+objPB.PricebookEntries[0].Id);

                      
        }
        Catch(Exception e) {
            System.debug('Inside the catch method if there is any issue with the query of standard shipping product');
            System.debug('Cause of Exception is '+e.getCause());
            System.debug('Message of Exception is '+e.getMessage());
            showContent = true;
            successError = 'error';
            msg = 'Add PriceBook and PriceBookEntry to the Standard Shipping Product';
        }
        }
        if(productName1 != null)
        {
        try{
            PriceBook2 objPB1 = [Select Id,Name, (SELECT Id, Name FROM PricebookEntries WHERE Name LIKE: productName1) FROM PriceBook2 WHERE Name LIKE: PricebookName LIMIT 1];
            System.debug('Value of Priceboook list is '+objPB1);
            System.debug('Value of PricebookEntry Name is '+objPB1.PricebookEntries[0].Id);
            objectOLI1.PricebookEntryId = objPB1.PricebookEntries[0].Id;
        }
        Catch(Exception e)
        {
            System.debug('Inside the Catch method if there is any issue with the qurey of Express shipping Product');
            System.debug('Cause of Exception is '+e.getCause());
            System.debug('Message of Exception is '+e.getMessage());
            showContent = true;
            successError = 'error';
            msg= 'Add PriceBook and PriceBookEntry to the Express Shipping Product';
        }
        }
       objectOLI.Zone_A_0_250gm__c = ObjProduct.Zone_A_0_250gm__c;
       ObjectOLI.Zone_B_0_250gm__c = ObjProduct.Zone_B_0_250gm__c;
       objectOLI.Zone_C_0_250gm__c = objProduct.Zone_C_0_250gm__c;
       ObjectOLI.Zone_D_0_250gm__c = objProduct.Zone_D_0_250gm__c;
       ObjectOLI.Zone_E_0_250gm__c = objProduct.Zone_E_0_250gm__c;
       ObjectOLI.Zone_A_Additional_250_gms_till_500_gms__c = objProduct.Zone_A_Additional_250_gms_till_500_gms__c;
       ObjectOLI.Zone_B_Additional_250_gms_till_500_gms__c = ObjProduct.Zone_B_Additional_250_gms_till_500_gms__c;
       ObjectOLI.Zone_C_Additional_250_gms_till_500_gms__c = ObjProduct.Zone_C_Additional_250_gms_till_500_gms__c;
       ObjectOLI.Zone_D_Additional_250_gms_till_500_gms__c = ObjProduct.Zone_D_Additional_250_gms_till_500_gms__c;
       ObjectOLI.Zone_E_Additional_250_gms_till_500_gms__c = ObjProduct.Zone_E_Additional_250_gms_till_500_gms__c;
       ObjectOLI.Zone_A_Additional_500_gm_till_5kg__c = objProduct.Zone_A_Additional_500_gm_till_5kg__c;
       ObjectOLI.Zone_B_Additional_500_gm_till_5kg__c = objProduct.Zone_B_Additional_500_gm_till_5kg__c;
       ObjectOLI.Zone_C_Additional_500_gm_till_5kg__c = ObjProduct.Zone_C_Additional_500_gm_till_5kg__c;
       ObjectOLI.Zone_D_Additional_500_gm_till_5kg__c = objProduct.Zone_D_Additional_500_gm_till_5kg__c;
       ObjectOLI.Zone_E_Additional_500_gm_till_5kg__c =  ObjProduct.Zone_E_Additional_500_gm_till_5kg__c;
       ObjectOLI.Zone_A_Additional_1kg_Above_5kg__c = objProduct.Zone_A_Additional_1kg_Above_5kg__c;
       ObjectOLI.Zone_B_Additional_1kg_Above_5kg__c = ObjProduct.Zone_B_Additional_1kg_Above_5kg__c;
       ObjectOLI.Zone_C_Additional_1kg_Above_5kg__c = ObjPRoduct.Zone_C_Additional_1kg_Above_5kg__c;
       ObjectOLI.Zone_D_Additional_1kg_Above_5kg__c = ObjProduct.Zone_D_Additional_1Kg_Above_5kg__c;   
       ObjectOLI.Zone_E_Additional_1kg_Above_5kg__c = ObjProduct.Zone_E_Additional_1kg_Above_5kg__c;
       objectOLI.Zone_A_Upto_500_gms__c = objProduct.Zone_A_Upto_500_gms__c;
        objectOLI.Zone_B_Upto_500_gms__c = objProduct.Zone_B_Upto_500_gms__c;
        objectOLI.Zone_E_Upto_500_gms__c = objProduct.Zone_E_Upto_500_gms__c;
        objectOLI.Zone_E_Every_additional_500_gms__c = objProduct.Zone_E_Every_additional_500_gms__c;
        objectOLI.Zone_A_DTO_Upto_500gm__c = objProduct.Zone_A_DTO_Upto_500gm__c;
        objectOLI.Zone_B_DTO_Upto_500gm__c = objProduct.Zone_B_DTO_Upto_500gm__c;
        objectOLI.Zone_E_DTO_Upto_500gm__c = objProduct.Zone_E_DTO_Upto_500gm__c;
        objectOLI.Zone_A_DTO_every_add_500gm__c = objProduct.Zone_A_DTO_every_add_500gm__c;
        objectOLI.Zone_B_DTO_every_add_500gm__c = objProduct.Zone_B_DTO_every_add_500gm__c;
        objectOLI.Zone_E_DTO_every_add_500gm__c = objProduct.Zone_E_DTO_every_add_500gm__c;
        objectOLI.COD_Charges__c = objProduct.COD_Charges__c;
        objectOLI.COD_Value__c = objProduct.COD_Value__c;
       objectOLI.Wallet_Transaction_Charge__c = objProduct.Wallet_Transaction_Charge__c;
        objectOLI.Wallet_Transaction_Rate__c = objProduct.Wallet_Transaction_Rate__c;
        objectOLI.Transaction_Charge__c =  objProduct.Transaction_Charge__c;
        objectOLI.Credit_Card_Transaction_Charge__c =  objProduct.Credit_Card_Transaction_Charge__c;
        objectOLI.Credit_Card_Rates__c = objProduct.Credit_Card_Rates__c;
        objectOLI.Threshold_Charge__c =   objProduct.Threshold_Charge__c; 
        objectOLI.Debit_Before_Rates__c = objProduct.Debit_Before_Rates__c;
        objectOLI.Debit_After_Rates__c =  objProduct.Debit_After_Rates__c;
        objectOLI.Volumetric_Formulae__c = objProduct.Volumetric_Formulae__c;
        objectOLI.Service_Charges__c = objProduct.Service_Charges__c;
        objectOLI.Fuel_Surcharge__c = objProduct.Fuel_Surcharge__c;
        objectOLI.Rural_Pin_Code_Pricing__c = objProduct.Rural_Pin_Code_Pricing__c;
        objectOLI.Maximum_liability_per_consignment__c = objProduct.Maximum_liability_per_consignment__c;
        objectOLI.Maximum_Liability_for_Reverse_Percent__c=objProduct.Maximum_Liability_for_Reverse_Percent__c;
        objectOLI.Maximum_Liability_for_Forward_Percent__c = objProduct.Maximum_Liability_for_Forward_Percent__c;
        objectOLI.Maximum_Liability_for_Reverse__c=objProduct.Maximum_Liability_for_Reverse__c;
        objectOLI.COD_Remittance__c = objProduct.COD_Remittance__c;
        objectOLI.Quantity = 1;
        objectOLI.TotalPrice = 1;
        objectOLI.OpportunityId = oppId;
        objectOLI.Status__c = 'Draft';
        objectOLI.IsActive__c = true;        
        System.debug('Product ->'+objProduct);
          objectOLI.Zone_C_N1_Upto_500_gms__c = objProduct.Zone_C_N1_Upto_500_gms__c;
            objectOLI.Zone_C_N2_Upto_500_gms__c = objProduct.Zone_C_N2_Upto_500_gms__c;
            objectOLI.Zone_D_N1_Upto_500_gms__c = objProduct.Zone_D_N1_Upto_500_gms__c;
            objectOLI.Zone_D_N2_Upto_500_gms__c = objProduct.Zone_D_N2_Upto_500_gms__c;            
            objectOLI.Zone_A_Every_Add_500_gms_upto_3_kgs__c = objProduct.Zone_A_Every_Add_500_gms_upto_3_kgs__c;
            objectOLI.Zone_B_Every_Add_500_gms_upto_3_kgs__c = objProduct.Zone_B_Every_Add_500_gms_upto_3_kgs__c;
            objectOLI.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c = objProduct.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c;
            objectOLI.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c = objProduct.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c;
            objectOLI.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c = objProduct.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c;
            objectOLI.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c = objProduct.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c;            
            objectOLI.Zone_A_Every_Additional_Slab_1_Kg__c = objProduct.Zone_A_Every_Additional_Slab_1_Kg__c;
            objectOLI.Zone_B_Every_Additional_Slab_1_Kg__c = objProduct.Zone_B_Every_Additional_Slab_1_Kg__c;
            objectOLI.Zone_C_N1_Every_Additional_Slab_1_Kg__c = objProduct.Zone_C_N1_Every_Additional_Slab_1_Kg__c;
            objectOLI.Zone_C_N2_Every_Additional_Slab_1_Kg__c = objProduct.Zone_C_N2_Every_Additional_Slab_1_Kg__c;
            objectOLI.Zone_D_N1_Every_Additional_Slab_1_Kg__c = objProduct.Zone_D_N1_Every_Additional_Slab_1_Kg__c;
            objectOLI.Zone_D_N2_Every_Additional_Slab_1_Kg__c = objProduct.Zone_D_N2_Every_Additional_Slab_1_Kg__c;
            objectOLI.Zone_E_Every_Additional_Slab_1_Kg__c = objProduct.Zone_E_Every_Additional_Slab_1_Kg__c;            
            objectOLI.Zone_A_RTO_every_1_kg__c = objProduct.Zone_A_RTO_every_1_kg__c;
            objectOLI.Zone_B_RTO_every_1_kg__c = objProduct.Zone_B_RTO_every_1_kg__c;
            objectOLI.Zone_C_N1_RTO_every_1_kg__c = objProduct.Zone_C_N1_RTO_every_1_kg__c;
            objectOLI.Zone_C_N2_RTO_every_1_kg__c = objProduct.Zone_C_N2_RTO_every_1_kg__c;
            objectOLI.Zone_D_N1_RTO_every_1_kg__c = objProduct.Zone_D_N1_RTO_every_1_kg__c;
            objectOLI.Zone_D_N2_RTO_every_1_kg__c = objProduct.Zone_D_N2_RTO_every_1_kg__c;
            objectOLI.Zone_E_RTO_every_1_kg__c = objProduct.Zone_E_RTO_every_1_kg__c;            
            objectOLI.Zone_C_N1_DTO_Upto_500gms__c = objProduct.Zone_C_N1_DTO_Upto_500gms__c;
            objectOLI.Zone_C_N2_DTO_Upto_500gms__c = objProduct.Zone_C_N2_DTO_Upto_500gms__c;
            objectOLI.Zone_D_N1_DTO_Upto_500gms__c = objProduct.Zone_D_N1_DTO_Upto_500gms__c;
            objectOLI.Zone_D_N2_DTO_Upto_500gms__c = objProduct.Zone_D_N2_DTO_Upto_500gms__c;            
            objectOLI.Zone_C_N1_DTO_every_add_500gm__c = objProduct.Zone_C_N1_DTO_every_add_500gm__c;
            objectOLI.Zone_C_N2_DTO_every_add_500gm__c = objProduct.Zone_C_N2_DTO_every_add_500gm__c;
            objectOLI.Zone_D_N1_DTO_every_add_500gm__c = objProduct.Zone_D_N1_DTO_every_add_500gm__c;
            objectOLI.Zone_D_N2_DTO_every_add_500gm__c = objProduct.Zone_D_N2_DTO_every_add_500gm__c;
       
       
       
       
       
       objectOLI1.Zone_A_0_250gm__c = ObjProduct1.Zone_A_0_250gm__c;
       ObjectOLI1.Zone_B_0_250gm__c = ObjProduct1.Zone_B_0_250gm__c;
       objectOLI1.Zone_C_0_250gm__c = objProduct1.Zone_C_0_250gm__c;
       ObjectOLI1.Zone_D_0_250gm__c = objProduct1.Zone_D_0_250gm__c;
       ObjectOLI1.Zone_E_0_250gm__c = objProduct1.Zone_E_0_250gm__c;
       ObjectOLI1.Zone_A_Additional_250_gms_till_500_gms__c = objProduct1.Zone_A_Additional_250_gms_till_500_gms__c;
       ObjectOLI1.Zone_B_Additional_250_gms_till_500_gms__c = ObjProduct1.Zone_B_Additional_250_gms_till_500_gms__c;
       ObjectOLI1.Zone_C_Additional_250_gms_till_500_gms__c = ObjProduct1.Zone_C_Additional_250_gms_till_500_gms__c;
       ObjectOLI1.Zone_D_Additional_250_gms_till_500_gms__c = ObjProduct1.Zone_D_Additional_250_gms_till_500_gms__c;
       ObjectOLI1.Zone_E_Additional_250_gms_till_500_gms__c = ObjProduct1.Zone_E_Additional_250_gms_till_500_gms__c;
       ObjectOLI1.Zone_A_Additional_500_gm_till_5kg__c = objProduct1.Zone_A_Additional_500_gm_till_5kg__c;
       ObjectOLI1.Zone_B_Additional_500_gm_till_5kg__c = objProduct1.Zone_B_Additional_500_gm_till_5kg__c;
       ObjectOLI1.Zone_C_Additional_500_gm_till_5kg__c = ObjProduct1.Zone_C_Additional_500_gm_till_5kg__c;
       ObjectOLI1.Zone_D_Additional_500_gm_till_5kg__c = objProduct1.Zone_D_Additional_500_gm_till_5kg__c;
       ObjectOLI1.Zone_E_Additional_500_gm_till_5kg__c =  ObjProduct1.Zone_E_Additional_500_gm_till_5kg__c;
       ObjectOLI1.Zone_A_Additional_1kg_Above_5kg__c = objProduct1.Zone_A_Additional_1kg_Above_5kg__c;
       ObjectOLI1.Zone_B_Additional_1kg_Above_5kg__c = ObjProduct1.Zone_B_Additional_1kg_Above_5kg__c;
       ObjectOLI1.Zone_C_Additional_1kg_Above_5kg__c = ObjPRoduct1.Zone_C_Additional_1kg_Above_5kg__c;
       ObjectOLI1.Zone_D_Additional_1kg_Above_5kg__c = ObjProduct1.Zone_D_Additional_1Kg_Above_5kg__c;   
       ObjectOLI1.Zone_E_Additional_1kg_Above_5kg__c = ObjProduct1.Zone_E_Additional_1kg_Above_5kg__c;
        objectOLI1.Zone_A_Upto_500_gms__c = objProduct1.Zone_A_Upto_500_gms__c;
        objectOLI1.Zone_B_Upto_500_gms__c = objProduct1.Zone_B_Upto_500_gms__c;
        objectOLI1.Zone_E_Upto_500_gms__c = objProduct1.Zone_E_Upto_500_gms__c;
        objectOLI1.Zone_E_Every_additional_500_gms__c = objProduct1.Zone_E_Every_additional_500_gms__c;
        objectOLI1.Zone_A_DTO_Upto_500gm__c = objProduct1.Zone_A_DTO_Upto_500gm__c;
        objectOLI1.Zone_B_DTO_Upto_500gm__c = objProduct1.Zone_B_DTO_Upto_500gm__c;
        objectOLI1.Zone_E_DTO_Upto_500gm__c = objProduct1.Zone_E_DTO_Upto_500gm__c;
        objectOLI1.Zone_A_DTO_every_add_500gm__c = objProduct1.Zone_A_DTO_every_add_500gm__c;
        objectOLI1.Zone_B_DTO_every_add_500gm__c = objProduct1.Zone_B_DTO_every_add_500gm__c;
        objectOLI1.Zone_E_DTO_every_add_500gm__c = objProduct1.Zone_E_DTO_every_add_500gm__c;
        objectOLI1.COD_Charges__c = objProduct1.COD_Charges__c;
        objectOLI1.COD_Value__c = objProduct1.COD_Value__c;
      objectOLI1.Wallet_Transaction_Charge__c = objProduct1.Wallet_Transaction_Charge__c;
        objectOLI1.Wallet_Transaction_Rate__c = objProduct1.Wallet_Transaction_Rate__c;
        objectOLI1.Transaction_Charge__c =  objProduct1.Transaction_Charge__c;
        objectOLI1.Credit_Card_Transaction_Charge__c =  objProduct1.Credit_Card_Transaction_Charge__c;
        objectOLI1.Credit_Card_Rates__c = objProduct1.Credit_Card_Rates__c;
        objectOLI1.Threshold_Charge__c =   objProduct1.Threshold_Charge__c; 
        objectOLI1.Debit_Before_Rates__c = objProduct1.Debit_Before_Rates__c;
        objectOLI1.Debit_After_Rates__c =  objProduct1.Debit_After_Rates__c;
        objectOLI1.Volumetric_Formulae__c = objProduct1.Volumetric_Formulae__c;
        objectOLI1.Service_Charges__c = objProduct1.Service_Charges__c;
        objectOLI1.Fuel_Surcharge__c = objProduct1.Fuel_Surcharge__c;
        objectOLI1.Rural_Pin_Code_Pricing__c = objProduct1.Rural_Pin_Code_Pricing__c;
        objectOLI1.Maximum_liability_per_consignment__c = objProduct1.Maximum_liability_per_consignment__c;
        objectOLI1.Maximum_Liability_for_Reverse_Percent__c=objProduct1.Maximum_Liability_for_Reverse_Percent__c;
        objectOLI1.Maximum_Liability_for_Forward_Percent__c = objProduct1.Maximum_Liability_for_Forward_Percent__c;
        objectOLI1.Maximum_Liability_for_Reverse__c=objProduct1.Maximum_Liability_for_Reverse__c;
        objectOLI1.COD_Remittance__c = objProduct1.COD_Remittance__c;
        objectOLI1.Quantity = 1;
        objectOLI1.TotalPrice = 1;
        objectOLI1.OpportunityId = oppId;
        objectOLI1.Status__c = 'Draft';
        objectOLI1.IsActive__c = true;        
            objectOLI1.Zone_A_Every_additional_500_gms__c = objProduct1.Zone_A_Every_additional_500_gms__c;
            objectOLI1.Zone_B_Every_additional_500_gms__c = objProduct1.Zone_B_Every_additional_500_gms__c;
            objectOLI1.Zone_C_Every_additional_500_gms__c = objProduct1.Zone_C_Every_additional_500_gms__c;
            objectOLI1.Zone_D_Every_additional_500_gms__c = objProduct1.Zone_D_Every_additional_500_gms__c;
            objectOLI1.Zone_E_Every_additional_500_gms__c = objProduct1.Zone_E_Every_additional_500_gms__c;            
            objectOLI1.Zone_A_RTO_every_500_gms__c = objProduct1.Zone_A_RTO_every_500_gms__c;
            objectOLI1.Zone_B_RTO_every_500_gms__c = objProduct1.Zone_B_RTO_every_500_gms__c;
            objectOLI1.Zone_C_RTO_every_500_gms__c = objProduct1.Zone_C_RTO_every_500_gms__c;
            objectOLI1.Zone_D_RTO_every_500_gms__c = objProduct1.Zone_D_RTO_every_500_gms__c;
            objectOLI1.Zone_E_RTO_every_500_gms__c = objProduct1.Zone_E_RTO_every_500_gms__c;            
            objectOLI1.Zone_C_Upto_500_gms__c = objProduct1.Zone_C_Upto_500_gms__c;
            objectOLI1.Zone_D_Upto_500_gms__c = objProduct1.Zone_D_Upto_500_gms__c;            
            objectOLI1.Zone_C_DTO_Upto_500gm__c = objProduct1.Zone_C_DTO_Upto_500gm__c;
            objectOLI1.Zone_D_DTO_Upto_500gm__c = objProduct1.Zone_D_DTO_Upto_500gm__c;            
            objectOLI1.Zone_C_DTO_every_add_500gm__c = objProduct1.Zone_C_DTO_every_add_500gm__c;
            objectOLI1.Zone_D_DTO_every_add_500gm__c = objProduct1.Zone_D_DTO_every_add_500gm__c;        
    }
    
   
   
     public pageReference saveOLI() {    
                 System.debug('Inside the SaveOLI Method');
         System.debug('Value of Opportunity PricebookID is '+opp.Pricebook2Id);
        opp = [select id,Approval__c,RecordType.DeveloperName, Status__c, Counter__c, Maximum_Discount__c,Pricebook2Id, (Select Id,Name, Description__c, Maximum_liability_per_consignment__c,Maximum_Liability_for_Reverse_Percent__c,Maximum_Liability_for_Reverse__c, Status__c From OpportunityLineItems Where IsActive__c=TRUE) from Opportunity where id =: oppId];
         if (opp.RecordType.DeveloperName == 'C2C')
             {
                  List<Pricebook2> lstPricebook = [Select id from Pricebook2 where Name like '%C2C Pricing Model%' limit 1];
                 opp.Pricebook2Id=lstPricebook[0].id;
             }
         update opp;
         System.debug('Opportunity --> '+opp.OpportunityLineItems);
        if (opp.OpportunityLineItems.size() == 0 ) {
            System.debug('If the Size of Opportunity Line Item of a particular Opportunity is zero');
            descString = '<ul class="express-shipping-orderlist">';
            System.debug('Value of descString is ' +descString);
            descString1 ='<ul class="express-shipping-orederlist">';
            System.debug('Value of descString1 is '+descString1);
            if (opp.RecordType.DeveloperName == 'C2C') {
                System.debug('Value in ProductExp is '+productExp);
                if(productExp.Maximum_liability_per_consignment__c!=null)
                {
                System.debug('If the Record Type Name of a Particular Opportunity is C2C');
                descString = '<li>Standard product damage/lost in transit liability of ' + productExp.Maximum_liability_per_consignment__c + ' or product value, whichever is lower.</li>';
                }
                if(productSur.Maximum_liability_per_consignment__c !=null) {
                descString1 = '<li>Standard product damage/lost in transit liability of ' + productSur.Maximum_liability_per_consignment__c + ' or product value, whichever is lower.</li>';
            }
                
                } 
        } else {
            System.debug('If the size of Opportunity Line ITem of a Particular Opportunity is greater than Zero');
            if(objectOLI.Maximum_liability_per_consignment__c !=null){
                descString = '<li>Standard product damage/lost in transit liability of ' + objectOLI.Maximum_liability_per_consignment__c + ' or product value, whichever is lower.</li>';
            }else{
                descString = '';
            }
            if(objectOLI1.Maximum_liability_per_consignment__c != null)
            {
                descString1 = '<li>Standard product damage/lost in transit liablity of ' + objectOLI1.Maximum_Liability_per_consignment__c + ' or product value, whichever is lower.</li>';
            }
            else{
                descString1 = '';
            }
            System.debug('Value of descString if OLI is zero '+descString);
            System.debug('Value of descString1 if OLI is Zero '+descString1);
        }
        descString += '<li>Weights to be determined based on volumetric or actual, whichever is higher.</li>';
        descString += '<li>For volumetric weight calculation, all sides are measured in cm.</li>';       
        descString += '<li>Payment terms &#45; invoice to be cleared within 15 days.</li></ul>';
        descString1 += '<li>Weights to be determinated based on volumnentric or actual, whichever is higher.</li>';
        descString1 += '<li>For Volumnetric Weight Calculation, all sides are mesured in cm.</li>';
        descString1 += '<li>Payement terms &#45; invoice to be cleared within 15 days.</li><ul>';
         if(opp.RecordType.DeveloperName == 'C2C') {
         try {
             System.debug('Inside the Try Method of Save OLI');
                if ((oliList1.size() > 0 && oliList1[0].Status__c == 'Submitted') || (oliList.size() > 0 && oliList[0].Status__c == 'Submitted') ) {  
                    showContent = true;
                    successError = 'error';
                    msg = 'Cannot modify this pricing since it is submitted for Approval';
                    return null;
                }
                
                if (oliList1.size() > 0 && oliList1[0].Status__c == 'Draft' && objectOLI1.id!=null) {
                    system.debug('oliList>>'+oliList1);                   
                   
                    
                    objectOLI1.Description__c = descString1;
                    objectOLI1.IsCustom__c = false;   
                      System.debug('objectOLI.Transaction_Charge__c-->>'+objectOLI1.Transaction_Charge__c+'---objectOLI.COD_Charges__c-->>'+objectOLI1.COD_Charges__c+'=-----objectOLI.Credit_Card_Transaction_Charge__c-->>'+objectOLI1.Credit_Card_Transaction_Charge__c);
                    if(
                       ( (objectOLI1.Transaction_Charge__c < objectOLI1.COD_Charges__c || objectOLI1.Credit_Card_Transaction_Charge__c < objectOLI1.COD_Charges__c)
                        &&
                        (objectOLI1.Transaction_Charge__c > 25 || objectOLI1.Credit_Card_Transaction_Charge__c > 25) ) || 
                        ( (objectOLI.Transaction_Charge__c < objectOLI.COD_Charges__c || objectOLI.Credit_Card_Transaction_Charge__c < objectOLI.COD_Charges__c)
                        &&
                        (objectOLI.Transaction_Charge__c > 25 || objectOLI.Credit_Card_Transaction_Charge__c > 25) )
                    ){
                        opp.COD_Director_Approval_Required__c = true;
                    }else{
                        opp.COD_Director_Approval_Required__c =false;
                    }
                    
                    if((objectOLI.Transaction_Charge__c < 25 || objectOLI.Credit_Card_Transaction_Charge__c < 25) || 
                      ( objectOLI.Transaction_Charge__c < 25 || objectOLI.Credit_Card_Transaction_Charge__c < 25 ) ){
                        opp.COD_BU_Head_Approval_Required__c = true;
                    }else{
                        opp.COD_BU_Head_Approval_Required__c =false;
                    }
                     Update objectOLI1;
                    
                    if (objectOLI1.MaxDiscount__c == null) {
                        objectOLI1.MaxDiscount__c = 0.0;
                    }
                    
                    DiscountUtility objDiscountUtil = new DiscountUtility();
                    objectOLI1.MaxDiscount__c = objDiscountUtil.findMaxDiscount(objectOLI1.Id);
                    opp.Maximum_Discount__c = objectOLI1.MaxDiscount__c;                    
                    update objectOLI1;
                    update opp;
                }
             else if(oliList1.size() > 0 && oliList1[0].Status__c != 'Draft' && oliList1[0].Status__c != 'Submitted'){
                    OpportunityLineItem objNewOLI1 = new OpportunityLineItem();        
                    ObjNewOLI1.Zone_A_0_250gm__c = ObjectOLI1.Zone_A_0_250gm__c;
                    ObjNewOLI1.Zone_B_0_250gm__c = ObjectOLI1.Zone_B_0_250gm__c;
                    ObjNewOLI1.Zone_C_0_250gm__c = ObjectOLI1.Zone_C_0_250gm__c;
                    ObjNewOLI1.Zone_D_0_250gm__c = ObjectOLI1.Zone_D_0_250gm__c;
                    ObjNewOLI1.Zone_E_0_250gm__c = ObjectOLI1.Zone_E_0_250gm__c;
                    ObjNewOLI1.Zone_A_Additional_250_gms_till_500_gms__c = objectOLI1.Zone_A_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI1.Zone_B_Additional_250_gms_till_500_gms__c = objectOLI1.Zone_B_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI1.Zone_C_Additional_250_gms_till_500_gms__c = objectOLI1.Zone_C_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI1.Zone_D_Additional_250_gms_till_500_gms__c = objectOLI1.Zone_D_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI1.Zone_E_Additional_250_gms_till_500_gms__c = objectOLI1.Zone_E_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI1.Zone_A_Additional_500_gm_till_5kg__c = ObjectOLI1.Zone_A_Additional_500_gm_till_5kg__c;
                    ObjNewOLI1.Zone_B_Additional_500_gm_till_5kg__c = ObjectOLI1.Zone_B_Additional_500_gm_till_5kg__c;
                    ObjNewOLI1.Zone_C_Additional_500_gm_till_5kg__c = ObjectOLI1.Zone_C_Additional_500_gm_till_5kg__c;
                    ObjNewOLI1.Zone_D_Additional_500_gm_till_5kg__c = ObjectOLI1.Zone_D_Additional_500_gm_till_5kg__c;
                    ObjNewOLI1.Zone_E_Additional_500_gm_till_5kg__c = ObjectOLI1.Zone_E_Additional_500_gm_till_5kg__c;
                    ObjNewOLI1.Zone_A_Additional_1kg_Above_5kg__c = ObjectOLI1.Zone_A_Additional_1kg_Above_5kg__c;
                    ObjNewOLI1.Zone_B_Additional_1kg_Above_5kg__c = ObjectOLI1.Zone_B_Additional_1kg_Above_5kg__c;
                    ObjNewOLI1.Zone_C_Additional_1kg_Above_5kg__c = ObjectOLI1.Zone_C_Additional_1kg_Above_5kg__c;
                    ObjNewOLI1.Zone_D_Additional_1kg_Above_5kg__c = ObjectOLI1.Zone_D_Additional_1kg_Above_5kg__c;
                    ObjNewOLI1.Zone_E_Additional_1kg_Above_5kg__c = ObjectOLI1.Zone_E_Additional_1kg_Above_5kg__c;
                    objNewOLI1.Zone_A_Upto_500_gms__c = objectOLI1.Zone_A_Upto_500_gms__c;
                    objNewOLI1.Zone_B_Upto_500_gms__c = objectOLI1.Zone_B_Upto_500_gms__c;
                    objNewOLI1.Zone_E_Upto_500_gms__c = objectOLI1.Zone_E_Upto_500_gms__c;
                    objNewOLI1.Zone_E_Every_additional_500_gms__c = objectOLI1.Zone_E_Every_additional_500_gms__c;
                    objNewOLI1.Zone_A_DTO_Upto_500gm__c = objectOLI1.Zone_A_DTO_Upto_500gm__c;
                    objNewOLI1.Zone_B_DTO_Upto_500gm__c = objectOLI1.Zone_B_DTO_Upto_500gm__c;
                    objNewOLI1.Zone_E_DTO_Upto_500gm__c = objectOLI1.Zone_E_DTO_Upto_500gm__c;
                    objNewOLI1.Zone_A_DTO_every_add_500gm__c = objectOLI1.Zone_A_DTO_every_add_500gm__c;
                    objNewOLI1.Zone_B_DTO_every_add_500gm__c = objectOLI1.Zone_B_DTO_every_add_500gm__c;
                    objNewOLI1.Zone_E_DTO_every_add_500gm__c = objectOLI1.Zone_E_DTO_every_add_500gm__c;
                    objNewOLI1.COD_Charges__c = objectOLI1.COD_Charges__c;
                    objNewOLI1.COD_Value__c = objectOLI1.COD_Value__c;
                    objNewOLI1.Wallet_Transaction_Charge__c = objectOLI1.Wallet_Transaction_Charge__c;
                    objNewOLI1.Wallet_Transaction_Rate__c = objectOLI1.Wallet_Transaction_Rate__c;
                    objNewOLI1.Transaction_Charge__c =  objectOLI1.Transaction_Charge__c;
                    objNewOLI1.Credit_Card_Transaction_Charge__c =  objectOLI1.Credit_Card_Transaction_Charge__c;
                    objNewOLI1.Credit_Card_Rates__c = objectOLI1.Credit_Card_Rates__c;
                    objNewOLI1.Threshold_Charge__c =   objectOLI1.Threshold_Charge__c; 
                    objNewOLI1.Debit_Before_Rates__c = objectOLI1.Debit_Before_Rates__c;
                    objNewOLI1.Debit_After_Rates__c =  objectOLI1.Debit_After_Rates__c;
                    objNewOLI1.Volumetric_Formulae__c = objectOLI1.Volumetric_Formulae__c;
                    objNewOLI1.Service_Charges__c = objectOLI1.Service_Charges__c;
                    objNewOLI1.Fuel_Surcharge__c = objectOLI1.Fuel_Surcharge__c;
                    objNewOLI1.Rural_Pin_Code_Pricing__c = objectOLI1.Rural_Pin_Code_Pricing__c;
                    objNewOLI1.Maximum_liability_per_consignment__c = objectOLI1.Maximum_liability_per_consignment__c;                   
                    objNewOLI1.Maximum_Liability_for_Reverse_Percent__c=objectOLI1.Maximum_Liability_for_Reverse_Percent__c;
                    objNewOLI1.Maximum_Liability_for_Forward_Percent__c = objectOLI1.Maximum_Liability_for_Forward_Percent__c;
                    objNewOLI1.Maximum_Liability_for_Reverse__c=objectOLI1.Maximum_Liability_for_Reverse__c;
                    
                    objNewOLI1.COD_Remittance__c = objectOLI1.COD_Remittance__c;
                    
                    objNewOLI1.Quantity = 1;
                    objNewOLI1.TotalPrice = 1;
                    objNewOLI1.OpportunityId = oppId;
                    objNewOLI1.Status__c = 'Draft';
                    objNewOLI1.IsActive__c = true; 
                    objNewOLI1.PricebookEntryId = objectOLI1.PricebookEntryId;
                    System.debug('Current Counter is '+opp.counter__c);
                    if(opp.Counter__c == null){
                        opp.Counter__c = 1;
                    }else{
                        System.debug('Inside the else conditino of Opp Counter');
                        opp.Counter__c += 1;
                    }
                    System.debug('Updated Counter Value is '+opp.counter__c);
                    System.debug('objNewOLI.Transaction_Charge__c-->>'+objNewOLI1.Transaction_Charge__c+'---objNewOLI.COD_Charges__c-->>'+objNewOLI1.COD_Charges__c+'=-----objNewOLI.Credit_Card_Transaction_Charge__c-->>'+objNewOLI1.Credit_Card_Transaction_Charge__c);
                    if(
                        (objNewOLI1.Transaction_Charge__c < objNewOLI1.COD_Charges__c || objNewOLI1.Credit_Card_Transaction_Charge__c < objNewOLI1.COD_Charges__c)
                        &&
                        (objNewOLI1.Transaction_Charge__c > 25 || objNewOLI1.Credit_Card_Transaction_Charge__c > 25)
                    ){
                        opp.COD_Director_Approval_Required__c = true;
                        System.debug('opp.COD_Director_Approval_Required__c'+opp.COD_Director_Approval_Required__c);
                    }else{
                        opp.COD_Director_Approval_Required__c =false;
                        System.debug('opp.COD_Director_Approval_Required__c'+opp.COD_Director_Approval_Required__c);
                    }
                    
                    if(objNewOLI1.Transaction_Charge__c < 25 || objNewOLI1.Credit_Card_Transaction_Charge__c < 25){
                        
                        opp.COD_BU_Head_Approval_Required__c = true;
                        System.debug('opp.COD_Director_Approval_Required__c'+opp.COD_Director_Approval_Required__c);
                    }else{
                        opp.COD_BU_Head_Approval_Required__c =false;
                        System.debug('opp.COD_Director_Approval_Required__c'+opp.COD_Director_Approval_Required__c);
                    }
                  objNewOLI1.Counter__c = opp.Counter__c;
                    objNewOLI1.Description__c = descString1;
                    System.debug('OpportunityLineITem for objNewOLI1 '+objNewOLI1);
                    Insert objNewOLI1;
                    lstCmprOLI.add(objNewOLI1);
                    System.debug('Line number 681 Value of object Line Item is '+objNewOLI1.id);
                    if (objNewOLI1.MaxDiscount__c == null) {
                        objNewOLI1.MaxDiscount__c = 0.0;
                    }                    
                    DiscountUtility objDiscountUtil = new DiscountUtility();
                    objNewOLI1.MaxDiscount__c = objDiscountUtil.findMaxDiscount(objNewOLI1.Id);
                    opp.Maximum_Discount__c = objNewOLI1.MaxDiscount__c;
                    update objNewOLI1;
                 update opp;
                  //  inactiveOtherOLI(opp.Id, objNewOLI1.Id);   
                    
                }
             else {
                 System.debug('Orignal Value of Opp Counter '+opp.Counter__c);
                    if(opp.Counter__c == null){
                        opp.Counter__c = 1;
                    }else{
                        System.debug('Inside the Else Condition of Opp Counter');
                        opp.Counter__c += 1;
                    }
                 System.debug('Value of Opp Counter '+opp.Counter__c);
                    objectOLI1.Counter__c = opp.Counter__c;
                    objectOLI1.Description__c = descString1;   
                    System.debug('objectOLI.Transaction_Charge__c-->>'+objectOLI1.Transaction_Charge__c+'---objectOLI.COD_Charges__c-->>'+objectOLI1.COD_Charges__c+'=-----objectOLI.Credit_Card_Transaction_Charge__c-->>'+objectOLI1.Credit_Card_Transaction_Charge__c);
                   if(
                        (objectOLI1.Transaction_Charge__c < objectOLI1.COD_Charges__c || objectOLI1.Credit_Card_Transaction_Charge__c < objectOLI1.COD_Charges__c)
                        &&
                        (objectOLI1.Transaction_Charge__c > 25 || objectOLI1.Credit_Card_Transaction_Charge__c > 25)
                    ){
                        opp.COD_Director_Approval_Required__c = true;
                   }else{
                        opp.COD_Director_Approval_Required__c =false;
                    }
                    
                    if(objectOLI1.Transaction_Charge__c < 25 || objectOLI1.Credit_Card_Transaction_Charge__c < 25){
                        opp.COD_BU_Head_Approval_Required__c = true;
                    }else{
                        opp.COD_BU_Head_Approval_Required__c =false;
                    }
                    System.debug('Opportunity Line ITem for Express Shipping are '+objectOLI1);
            Insert objectOLI1;          
                    System.debug('Line Number 714 Value of Object Line Item is '+objectOLI1);

                    if (objectOLI1.MaxDiscount__c == null) {
                        objectOLI1.MaxDiscount__c = 0.0;
                    }
                    
                    DiscountUtility objDiscountUtil = new DiscountUtility();
                    objectOLI1.MaxDiscount__c = objDiscountUtil.findMaxDiscount(objectOLI1.Id);
                    opp.Maximum_Discount__c = objectOLI1.MaxDiscount__c;
                    update objectOLI1; 
                 update opp;
                   // inactiveOtherOLI(opp.Id, objectOLI1.Id);          
                }               
            /*  if (oliList.size() > 0 && oliList[0].Status__c == 'Submitted') {  
                    showContent = true;
                    successError = 'error';
                    msg = 'Cannot modify this pricing since it is submitted for Approval';
                    //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, 'Cannot modify this pricing since it is submitted for Approval'));
                    return null;
                } */
                if (oliList.size() > 0 && oliList[0].Status__c == 'Draft' && objectOLI.id!=null) {
                    objectOLI.Description__c = descString;
                    objectOLI.IsCustom__c = false;
                    system.debug('objectOLI--------->'+objectOLI);
                      System.debug('objectOLI.Transaction_Charge__c-->>'+objectOLI.Transaction_Charge__c+'---objectOLI.COD_Charges__c-->>'+objectOLI.COD_Charges__c+'=-----objectOLI.Credit_Card_Transaction_Charge__c-->>'+objectOLI.Credit_Card_Transaction_Charge__c);
                    /*SF - 244 For Approval Process */
                 /*   if(
                        (objectOLI.Transaction_Charge__c < objectOLI.COD_Charges__c || objectOLI.Credit_Card_Transaction_Charge__c < objectOLI.COD_Charges__c)
                        &&
                        (objectOLI.Transaction_Charge__c > 25 || objectOLI.Credit_Card_Transaction_Charge__c > 25)
                    ){
                        opp.COD_Director_Approval_Required__c = true;
                    }else{
                        opp.COD_Director_Approval_Required__c =false;
                    }
                    
                    if(objectOLI.Transaction_Charge__c < 25 || objectOLI.Credit_Card_Transaction_Charge__c < 25){
                        opp.COD_BU_Head_Approval_Required__c = true;
                    }else{
                        opp.COD_BU_Head_Approval_Required__c =false;
                    } */
                    /*SF - 244 */
                    
                    Update objectOLI;
                    DiscountUtility objDiscountUtil = new DiscountUtility();
                    objectOLI.MaxDiscount__c = objDiscountUtil.findMaxDiscount(objectOLI.Id);
                    System.debug('Value of ObjectOLI1 is '+objectOLI1.MaxDiscount__c);
                    System.debug('Value of ObjectOLI is '+objectOLI.MaxDiscount__c);
                    if(objectOLI.MaxDiscount__c > objectOLI1.MaxDiscount__c)
                    opp.Maximum_Discount__c = objectOLI.MaxDiscount__c;
                    update objectOLI;  
                    update opp;
                }
                //else if(oliList.size() > 0 && oliList[0].Status__c == 'Corporate Approved'){
                else if(oliList.size() > 0 && oliList[0].Status__c != 'Draft'  && oliList[0].Status__c != 'Submitted'){
                    OpportunityLineItem objNewOLI = new OpportunityLineItem();
                    ObjNewOLI.Zone_A_0_250gm__c = ObjectOLI.Zone_A_0_250gm__c;
                    ObjNewOLI.Zone_B_0_250gm__c = ObjectOLI.Zone_B_0_250gm__c;
                    ObjNewOLI.Zone_C_0_250gm__c = ObjectOLI.Zone_C_0_250gm__c;
                    ObjNewOLI.Zone_D_0_250gm__c = ObjectOLI.Zone_D_0_250gm__c;
                    ObjNewOLI.Zone_E_0_250gm__c = ObjectOLI.Zone_E_0_250gm__c;
                    ObjNewOLI.Zone_A_Additional_250_gms_till_500_gms__c = ObjectOLI.Zone_A_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI.Zone_B_Additional_250_gms_till_500_gms__c = ObjectOLI.Zone_B_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI.Zone_C_Additional_250_gms_till_500_gms__c = ObjectOLI.Zone_C_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI.Zone_D_Additional_250_gms_till_500_gms__c = ObjectOLI.Zone_D_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI.Zone_E_Additional_250_gms_till_500_gms__c = ObjectOLI.Zone_E_Additional_250_gms_till_500_gms__c;
                    ObjNewOLI.Zone_A_Additional_500_gm_till_5kg__c = ObjectOLI.Zone_A_Additional_500_gm_till_5kg__c;
                    ObjNewOLI.Zone_B_Additional_500_gm_till_5kg__c = ObjectOLI.Zone_B_Additional_500_gm_till_5kg__c;
                    ObjNewOLI.Zone_C_Additional_500_gm_till_5kg__c = ObjectOLI.Zone_C_Additional_500_gm_till_5kg__c;
                    ObjNewOLI.Zone_D_Additional_500_gm_till_5kg__c = ObjectOLI.Zone_D_Additional_500_gm_till_5kg__c;
                    ObjNewOLI.Zone_E_Additional_500_gm_till_5kg__c = ObjectOLI.Zone_E_Additional_500_gm_till_5kg__c;
                    ObjNewOLI.Zone_A_Additional_1kg_Above_5kg__c = ObjectOLI.Zone_A_Additional_1kg_Above_5kg__c;
                    ObjNewOLI.Zone_B_Additional_1kg_Above_5kg__c = ObjectOLI.Zone_B_Additional_1kg_Above_5kg__c;
                    ObjNewOLI.Zone_C_Additional_1kg_Above_5kg__c = ObjectOLI.Zone_C_Additional_1kg_Above_5kg__c;
                    ObjNewOLI.Zone_D_Additional_1kg_Above_5kg__c = ObjectOLI.Zone_D_Additional_1kg_Above_5kg__c;
                    ObjNewOLI.Zone_E_Additional_1kg_Above_5kg__c = ObjectOLI.Zone_E_Additional_1kg_Above_5kg__c;
                    objNewOLI.Zone_A_Upto_500_gms__c = objectOLI.Zone_A_Upto_500_gms__c;
                    objNewOLI.Zone_B_Upto_500_gms__c = objectOLI.Zone_B_Upto_500_gms__c;
                    objNewOLI.Zone_E_Upto_500_gms__c = objectOLI.Zone_E_Upto_500_gms__c;
                    objNewOLI.Zone_E_Every_additional_500_gms__c = objectOLI.Zone_E_Every_additional_500_gms__c;
                    objNewOLI.Zone_A_DTO_Upto_500gm__c = objectOLI.Zone_A_DTO_Upto_500gm__c;
                    objNewOLI.Zone_B_DTO_Upto_500gm__c = objectOLI.Zone_B_DTO_Upto_500gm__c;
                    objNewOLI.Zone_E_DTO_Upto_500gm__c = objectOLI.Zone_E_DTO_Upto_500gm__c;
                    objNewOLI.Zone_A_DTO_every_add_500gm__c = objectOLI.Zone_A_DTO_every_add_500gm__c;
                    objNewOLI.Zone_B_DTO_every_add_500gm__c = objectOLI.Zone_B_DTO_every_add_500gm__c;
                    objNewOLI.Zone_E_DTO_every_add_500gm__c = objectOLI.Zone_E_DTO_every_add_500gm__c;
                    objNewOLI.COD_Charges__c = objectOLI.COD_Charges__c;
                    objNewOLI.COD_Value__c = objectOLI.COD_Value__c;
                    
                    /*SF - 244 */
                    objNewOLI.Wallet_Transaction_Charge__c = objectOLI.Wallet_Transaction_Charge__c;
                    objNewOLI.Wallet_Transaction_Rate__c = objectOLI.Wallet_Transaction_Rate__c;
                    objNewOLI.Transaction_Charge__c =  objectOLI.Transaction_Charge__c; // Debit Card
                    objNewOLI.Credit_Card_Transaction_Charge__c =  objectOLI.Credit_Card_Transaction_Charge__c;
                    objNewOLI.Credit_Card_Rates__c = objectOLI.Credit_Card_Rates__c;
                    objNewOLI.Threshold_Charge__c =   objectOLI.Threshold_Charge__c; 
                    objNewOLI.Debit_Before_Rates__c = objectOLI.Debit_Before_Rates__c;
                    objNewOLI.Debit_After_Rates__c =  objectOLI.Debit_After_Rates__c;
                    /* End Of SF - 244 */
                    
                    objNewOLI.Volumetric_Formulae__c = objectOLI.Volumetric_Formulae__c;
                    objNewOLI.Service_Charges__c = objectOLI.Service_Charges__c;
                    objNewOLI.Fuel_Surcharge__c = objectOLI.Fuel_Surcharge__c;
                    objNewOLI.Rural_Pin_Code_Pricing__c = objectOLI.Rural_Pin_Code_Pricing__c;
                    objNewOLI.Maximum_liability_per_consignment__c = objectOLI.Maximum_liability_per_consignment__c;
                    objNewOLI.Maximum_Liability_for_Reverse__c=objectOLI.Maximum_Liability_for_Reverse__c;
                    objNewOLI.Maximum_Liability_for_Reverse_Percent__c=objectOLI.Maximum_Liability_for_Reverse_Percent__c;
                    objNewOLI.Maximum_Liability_for_Forward_Percent__c = objectOLI.Maximum_Liability_for_Forward_Percent__c;
                    objNewOLI.COD_Remittance__c = objectOLI.COD_Remittance__c;
                    
                   
                    objNewOLI.Quantity = 1;
                    objNewOLI.TotalPrice = 1;
                    objNewOLI.OpportunityId = oppId;
                    objNewOLI.Status__c = 'Draft';
                    objNewOLI.IsActive__c = true;  
                    objNewOLI.PricebookEntryId = objectOLI.PricebookEntryId;                               
                    
                  /*  if(opp.Counter__c == null){
                        opp.Counter__c = 1;
                    }else{
                        opp.Counter__c += 1;
                    } */
                    
                    
                    /*SF - 244 For Approval Process */
                    System.debug('objNewOLI.Transaction_Charge__c-->>'+objNewOLI.Transaction_Charge__c+'---objNewOLI.COD_Charges__c-->>'+objNewOLI.COD_Charges__c+'=-----objNewOLI.Credit_Card_Transaction_Charge__c-->>'+objNewOLI.Credit_Card_Transaction_Charge__c);
                    if(
                        (objNewOLI.Transaction_Charge__c < objNewOLI.COD_Charges__c || objNewOLI.Credit_Card_Transaction_Charge__c < objNewOLI.COD_Charges__c)
                        &&
                        (objNewOLI.Transaction_Charge__c > 25 || objNewOLI.Credit_Card_Transaction_Charge__c > 25)
                    ){
                        opp.COD_Director_Approval_Required__c = true;
                    }else{
                        opp.COD_Director_Approval_Required__c =false;
                    }
                    
                    if(objNewOLI.Transaction_Charge__c < 25 || objNewOLI.Credit_Card_Transaction_Charge__c < 25){
                        opp.COD_BU_Head_Approval_Required__c = true;
                    }else{
                        opp.COD_BU_Head_Approval_Required__c =false;
                    }
                    /*SF - 244 */
                    
                    objNewOLI.Counter__c = opp.Counter__c;
                    objNewOLI.Description__c = descString;
                    Insert objNewOLI;   
                    lstCmprOLI.add(objNewOLI);
                    if (objNewOLI.MaxDiscount__c == null) {
                        objNewOLI.MaxDiscount__c = 0.0;
                    }                    
                    DiscountUtility objDiscountUtil = new DiscountUtility();
                    objNewOLI.MaxDiscount__c = objDiscountUtil.findMaxDiscount(objNewOLI.Id);
                    System.debug('Value of ObjectOLI1 is '+objectOLI1.MaxDiscount__c);
                    System.debug('Value of ObjectOLI is '+objectOLI.MaxDiscount__c);
                    if(objectOLI.MaxDiscount__c > objectOLI1.MaxDiscount__c)
                    opp.Maximum_Discount__c = objNewOLI.MaxDiscount__c;
                    update objNewOLI;
                    update opp;
                   // inactiveOtherOLI(opp.Id, objNewOLI.Id);
                } 
             else {
                /*    if(opp.Counter__c == null){
                        opp.Counter__c = 1;
                    }else{
                        opp.Counter__c += 1;
                    }*/
                    objectOLI.Counter__c = opp.Counter__c;
                    objectOLI.Description__c = descString;
                    System.debug('objectOLI 1->'+objectOLI);  
                    
                    System.debug('objectOLI.Transaction_Charge__c-->>'+objectOLI.Transaction_Charge__c+'---objectOLI.COD_Charges__c-->>'+objectOLI.COD_Charges__c+'=-----objectOLI.Credit_Card_Transaction_Charge__c-->>'+objectOLI.Credit_Card_Transaction_Charge__c);
                    /*SF - 244 For Approval Process */
                    if(
                        (objectOLI.Transaction_Charge__c < objectOLI.COD_Charges__c || objectOLI.Credit_Card_Transaction_Charge__c < objectOLI.COD_Charges__c)
                        &&
                        (objectOLI.Transaction_Charge__c > 25 || objectOLI.Credit_Card_Transaction_Charge__c > 25)
                    ){
                        opp.COD_Director_Approval_Required__c = true;
                    }else{
                        opp.COD_Director_Approval_Required__c =false;
                    }
                    
                    if(objectOLI.Transaction_Charge__c < 25 || objectOLI.Credit_Card_Transaction_Charge__c < 25){
                        opp.COD_BU_Head_Approval_Required__c = true;
                    }else{
                        opp.COD_BU_Head_Approval_Required__c =false;
                    }
                    /*SF - 244 */
                    
                    try
                    {
                        System.debug('Inside the try method to save oli');
                    Insert objectOLI;
                    }
                    Catch(Exception e)
                    {
                        System.debug('Tried to insert the Standard Surface OLI '+e.getMessage());
                    }
                    if(ObjectOLI.id != null && ObjectOLI1.Id != null)
                    {
                      
                    }
                    System.debug('objectOLI 2->'+objectOLI);  
                    if (objectOLI.MaxDiscount__c == null) {
                        objectOLI.MaxDiscount__c = 0.0;
                    }
                    DiscountUtility objDiscountUtil = new DiscountUtility();
                    objectOLI.MaxDiscount__c = objDiscountUtil.findMaxDiscount(objectOLI.Id);
                 System.debug('Value of ObjectOLI1 is '+objectOLI1.MaxDiscount__c);
                    System.debug('Value of ObjectOLI is '+objectOLI.MaxDiscount__c);
                 if(objectOLI.MaxDiscount__c > objectOLI1.MaxDiscount__c)
                    opp.Maximum_Discount__c = objectOLI.MaxDiscount__c;
                    update objectOLI;  
                 update opp;
                   // inactiveOtherOLI(opp.Id, objectOLI.Id);                  
                }
             System.debug('Size of lstCmprOLi is '+lstCmprOLI.size());
             if(lstCmprOLI.size()!=null && lstCmprOLI.size()>0 && lstCmprOLI.size()==2)
                 {
                     System.debug('Value in lstCmprOLI is '+lstCmprOLI);
                     for(OpportunityLineItem oli:lstCmprOLI)
                {
                    lstStrInactive.add(oli.id);
                }
                 System.debug('Value in List of StrInactive is '+lstStrInactive);
                 inactiveOtherOLI(oppId,lstStrInactive);
               }
                if(lstCmprOLI.Size()!=null && lstCmprOLI.size()>0 && (lstCmprOLI.size()<2 || lstCmprOLI.size()>2))
                {
                    System.debug('Inside the listCompare OpportunityLine Item');
                    delete lstCmprOLI;
                }
             else{  
				
                opp.Status__c = 'Draft';
                /*     if(opp.Maximum_Discount__c<=15 || (opp.Maximum_Discount__c<=35 && roleName.Name=='Manager') || (opp.Maximum_Discount__c<=50 && roleName.Name=='Director') || roleName.Name=='VP'){
system.debug('opp.Maximum_Discount__c--->'+opp.Maximum_Discount__c);
opp.Status__c = 'Corporate Approved';
}*/
                opp.Pricing__c = 'Standard Pricing';
                //sf-62
                opp.Approval_for_Upload_Contract__c = false;
            
                update opp;          
             }
                return new pageReference('/' + oppId);
            }
            Catch(Exception e) {
                String msg = e.getMessage();
                if (msg.contains('Email') || msg.contains('Phone')) {
                    showContent = true;
                    successError = 'error';
                    msg = 'Validation Error: Enter Email or Phone on Converted Opportunity';
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Validation Error: Enter Email or Phone on Converted Opportunity'));
                }
                return null;
            }
         }
          
 else {
            return null;
        }
    }      
     
    
    
    public void incrementCounter(){
        if(opp.Counter__c == 0 || opp.Counter__c == null){
            counter = 1;
        }else{
            counter = Integer.valueOf(opp.Counter__c);
        }
        opp.Counter__c = counter+1;        
        update opp;
    }  
    
    // Delete OLI and B2B Price Where selected Pricing is different from Product Name
    public void deleteOLI(){
        if(oppId != ''){            
            Opportunity objOpp = [select id, (Select Id From OpportunityLineItems WHERE Status__c = 'Draft') from Opportunity where id=:oppId]; 
            if(objOpp.OpportunityLineItems.size()>0){
                String oliId = objOpp.OpportunityLineItems[0].Id;
                delete [SELECT Id FROM B2B_Price__c WHERE Opportunity_Line_Item_Id__c =: oliId];
                delete objOpp.OpportunityLineItems[0];
            }       
        }
        if(opp.Counter__c != null){
            opp.Counter__c -=1;
            //update objOpportunity;
        }
    }
    
    //Make OLI Inactive and update OLI List
    public void inactiveOtherOLI(String oppId, List<String> OpplineItemId){
        System.debug('Value of OpplineItemId is '+OpplineItemId);
        System.debug('In inactiveOtherOLI');
        List<OpportunityLineItem> oliListToUpdate = new List<OpportunityLineItem>();
        for(OpportunityLineItem objOppLI : [SELECT Id, IsActive__c FROM OpportunityLineItem WHERE OpportunityId =: oppId AND ID NOT IN : OpplineItemId]){
                System.debug('Value of ObjOppli id is '+objOppLI.id);
            	objOppLI.IsActive__c = false;
                oliListToUpdate.add(objOppLI);            
        }
        System.debug(oliListToUpdate);
        update oliListToUpdate;
    }    
    
    //Revert back to Opportunity detail page when user click on Cancel button
    public pageReference cancelOLI() {
        return new pageReference('/' + oppId);
    }
    
    //Direct custom(slab) pricing when custom button is clicked
    public pageReference redirectToCustomPricing() {
        return new pageReference('/apex/ProductCustomPricingEditableVF?id=' + oppId);
    }
    
    public PageReference isOpportunitySubmitted(){
        if(opp.Status__c =='Submitted'){
            isStatusSubmitted = true;
            successError = 'error';
            msg = 'Cannot modify this pricing since it is submitted for Approval';
        }else{
            if(opp.Email__c == null || opp.Phone__c == null){
                isStatusSubmitted = true;
                successError = 'error';
                msg = 'Please Enter Email and Phone on Opportunity.';
            }else{
                return null;
            }
        }
        return null;
    } 
}