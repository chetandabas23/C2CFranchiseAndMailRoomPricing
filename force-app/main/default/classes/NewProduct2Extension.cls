/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: NewProduct2Extension
* Created Date: 31-May-2017
* Description: To override the New button of Product.  
*******************************************************************/
public with sharing class NewProduct2Extension {
    
    public String recTypeId;
    public String recTypeName{get;set;}
    public List<B2B5By5PriceWrapper> B2B5By5PriceWrapperList{get;set;}
    public List<B2B15By15PriceWrapper> B2B15By15PriceWrapperList{get;set;}
    public List<B2B6By6PriceWrapper> B2B6By6PriceWrapperList{get;set;}
    public List<B2B14By14PriceWrapper> B2B14By14PriceWrapperList{get;set;}    
    public String productId;
    public Map<String, Map<String, B2B_Price__c>> b2bPriceMap{get;set;}
    public Product2 objProduct{get; set;}
    Public product2 objProduct1{get; set;}
    public List<Hyperlocal_Price__c> hpList{get;set;}
    public Hyperlocal_Price__c objHyperLocal {get;set;}
    public List<Hyperlocal_Price__c> deleteHpList = new List<Hyperlocal_Price__c>();
    public List<Hyperlocal_Price__c> ListToAddHP{get;set;}
    public Opportunity opp{get;set;}
    public Product2 product{get;set;}
    public string productId1{get;set;}
    public Product2 currentRecord{get; set;}
    public String ErrorStr{get;set;}
    
    // Initialize getter setter variables of class and call method based on recordType
    public NewProduct2Extension(ApexPages.StandardController controller) {
        
        B2B5By5PriceWrapperList = new List<B2B5By5PriceWrapper>();
        B2B15By15PriceWrapperList = new List<B2B15By15PriceWrapper>();
        B2B6By6PriceWrapperList = new List<B2B6By6PriceWrapper>();
        B2B14By14PriceWrapperList = new List<B2B14By14PriceWrapper>();         
        recTypeId = '';                
        recTypeName = '';
        productId = '';
        b2bPriceMap = new Map<String, Map<String, B2B_Price__c>>();
        objProduct= new Product2();
        objProduct1 = new Product2();
        hpList = new List<Hyperlocal_Price__c>();
        objHyperLocal = new Hyperlocal_Price__c();
        deleteHpList = new List<Hyperlocal_Price__c>();
        ListToAddHP = new List<Hyperlocal_Price__c>();        
        product = new Product2();
        productId1 = '';
        currentRecord = new Product2();
        ErrorStr = '';
        
        recTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        if(ApexPages.currentPage().getParameters().get('id')!=null){
            currentRecord = [SELECT Id,RecordTypeId FROM Product2 WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
        }
        
        
        objProduct.Insurance__c = 0.5;
        
        if(recTypeId != null && recTypeId != ''){
            recTypeName = [SELECT DeveloperName FROM RecordType WHERE Id =: recTypeId].DeveloperName;
        }
        else{
            recTypeName = [SELECT DeveloperName FROM RecordType WHERE Id =: currentRecord.RecordTypeId].DeveloperName;
        }
        system.debug('recTypeName------>'+recTypeName);
        Map<String, String> b2bProductMap = new Map<String, String>();
        b2bProductMap.put('B2B_5x5','B2B 5*5');
        b2bProductMap.put('B2b_15x15','B2B 15*15');
        b2bProductMap.put('B2B_6x6','B2B 6*6');
        b2bProductMap.put('B2B_14x14','B2B 14*14');
        b2bProductMap.put('B2b_LanexLane','B2B LanexLane');
        
        
        List<Product2> product2List = new List<Product2>();
        product2List = [SELECT Id FROM Product2 WHERE Name =: b2bProductMap.get(recTypeName)];
        if(product2List.size()>0){
            productId = product2List[0].Id;
        }
        
        if(recTypeName == 'B2B_5x5'){
            B2B5By5Matrix();
        }
        if(recTypeName == 'B2b_15x15'){
            B2B15By15Matrix();
        }
        if(recTypeName == 'B2B_14x14'){
            B2B14By14Matrix();
        }
        if(recTypeName == 'B2B_6x6'){
            B2B6By6Matrix();
        }
        if(recTypeName == 'B2b_LanexLane'){
            B2BLanexLaneMatrix();
        }
        if(recTypeName == 'Express_shipping'){
            ExpressShippingMatrix(); 
        }
        
        if(recTypeName == 'Standard_Shipping'){
            SurfaceShippingMatrix();
        }
        if(recTypeName == 'Franchise_Shipping'){
            FranchiseShippingMatrix();
        }
        if(recTypeName == 'Mail_Room'){
            MailRoomShippingMatrix();
        }
        
        //hyperlocal pricing
        product = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,
                   Fuel_Surcharge__c,RoV_Surcharge__c,Max_Dead_weight_package__c from Product2 where Name=:'Hyperlocal'];
        productId1 = product.id;
        /*hpList = [select id,Number_of_Order_per_trip__c,Base_Range_in_Km__c,Base_Charge_per_Order_INR__c,COD_Charges__c,
Additional_Charge_INR_per_Km__c,Additional_Range__c,COD_Charges_in__c from Hyperlocal_Price__c where Product__c=:product.id ORDER BY Number_of_Order_per_trip__c];
*/
        
        List<Hyperlocal_Price__c> hyperlocalList=new List<Hyperlocal_Price__c>();
        hyperlocalList=[select id,Number_of_Order_per_trip__c,Base_Range_in_Km__c,Base_Charge_per_Order_INR__c,COD_Charges__c,
                        Additional_Charge_INR_per_Km__c,Additional_Range__c,COD_Charges_in__c from Hyperlocal_Price__c where Product__c=:product.id ORDER BY Number_of_Order_per_trip__c];
        
        if(hyperlocalList.size() >0){
            hpList =hyperlocalList;
        }           
    }
    public void ExpressShippingMatrix(){
        
        // Retrieve Existing Express Shipping Product Values    
        String Name='Express%';
        String productQuery = 'SELECT ';
        Schema.DescribeSObjectResult r = Product2.sObjectType.getDescribe();
        Map<String,Schema.SObjectField> mapFields = new Map<String,Schema.SObjectField>();
        mapFields=r.fields.getMap();
        String fieldNames='';
        for(string apiName : mapFields.keySet()){
            fieldNames+= apiName+',';
        }
        fieldNames = fieldNames.substring(0, fieldNames.length() - 1);
        productQuery=productQuery+fieldNames+' FROM Product2 WHERE Name LIKE :Name LIMIT 1';
        //productQuery=productQuery+fieldNames+' FROM Product2 WHERE Name=Express Shipping LIMIT 1';
        List<Product2> ProductList=Database.query(productQuery);
        //objProduct=Database.query(productQuery);
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }
        
        
    }
    public void SurfaceShippingMatrix(){
        
        // Retrieve Existing Standard Shipping Product Values    
        String Name='Standard Shipping';
        String productQuery = 'SELECT ';
        Schema.DescribeSObjectResult r = Product2.sObjectType.getDescribe();
        Map<String,Schema.SObjectField> mapFields = new Map<String,Schema.SObjectField>();
        mapFields=r.fields.getMap();
        String fieldNames='';
        for(string apiName : mapFields.keySet()){
            fieldNames+= apiName+',';
        }
        fieldNames = fieldNames.substring(0, fieldNames.length() - 1);
        productQuery=productQuery+fieldNames+' FROM Product2 WHERE Name LIKE : Name LIMIT 1';
        List<Product2> ProductList=Database.query(productQuery);
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }
    }
    Public void MailRoomShippingMatrix() {
         String Name='Delhivery Commercial Standard - C2C MailRoom';
        String Name1 = 'Delhivery Commercial Express - C2C MailRoom';
        String productQuery ='SELECT ';
        Schema.DescribeSObjectResult r = Product2.SObjectType.getDescribe();
        Map<String,Schema.SObjectField> mapFields = new Map<String,Schema.SObjectField>();
        mapFields = r.fields.getMap();
        String fieldNames='';
        for(string apiName : mapFields.keySet()){
            fieldNames+=apiName+',';
        }
        fieldNames= fieldNames.substring(0, fieldNames.length() - 1);
        productQuery = productQuery+fieldNames+' FROM Product2 WHERE NAME LIKE : NAME OR Name LIKE : Name1 Order By Name';
        List<Product2> ProductList = Database.query(productQuery);
        if(ProductList.size()>0)
        {
            objProduct = ProductList[0];
            objProduct1 = ProductList[1];
        }
    }
    Public Void FranchiseShippingMatrix(){
        String Name='Delhivery Commercial Standard - C2C';
        String Name1 = 'Delhivery Commercial Express - C2C';
        String productQuery ='SELECT ';
        Schema.DescribeSObjectResult r = Product2.SObjectType.getDescribe();
        Map<String,Schema.SObjectField> mapFields = new Map<String,Schema.SObjectField>();
        mapFields = r.fields.getMap();
        String fieldNames='';
        for(string apiName : mapFields.keySet()){
            fieldNames+=apiName+',';
        }
        fieldNames= fieldNames.substring(0, fieldNames.length() - 1);
        productQuery = productQuery+fieldNames+' FROM Product2 WHERE (NAME LIKE : NAME OR Name LIKE : Name1) Order By Name';
        List<Product2> ProductList = Database.query(productQuery);
        System.debug('Value in ProductList is '+ProductList);
        if(ProductList.size()>0)
        {
            objProduct = ProductList[0];
            objProduct1 = ProductList[1];
        }
        System.debug('ObjProduct is '+objProduct);
        System.debug('ObjProduct1 is '+objProduct1);
    }
    Public void SaveMailRoomShipping(){
          List<Product2> lstPRod = new List<Product2>();
        if(objProduct.id==null){
          /*  objProduct.Name='Delhivery Commercial Standard - C2C MailRoom';
            objProduct.RecordTypeId=recTypeId;
            objProduct.IsActive=true;
            lstProd.add(ObjProduct);*/
        }
        if(objProduct1.id==null)
        {
           /* objProduct.Name='Delhivery Commercial Express - C2C MailRoom';
            objProduct1.RecordTypeId = recTypeId;
            ObjProduct1.IsActive=true;
            lstProd.add(objProduct1);   */             
        }
        else if(objProduct.id!=null){
            lstProd.add(objProduct);           
        }
        else if(objProduct1.id!=null)
        {
            lstProd.add(objProduct1);
        }
        if(lstProd!=null && lstProd.size()>0)
        {
            upsert lstProd;
        }     
    }
    Public void SaveFranchiseShipping(){
        System.debug('Inside the SaveFranchise Shipping method');
        System.debug('Value of ObjProduct Id is '+objProduct.id);
        System.debug('Value of ObjProduct1 Id is '+objProduct1.id);
        List<Product2> lstPRod = new List<Product2>();
        if(objProduct.id==null){
          /*  objProduct.Name='Delhivery Commercial Standard - C2C';
            objProduct.RecordTypeId=recTypeId;
            objProduct.IsActive=true;
            lstProd.add(ObjProduct);*/
        }
        if(objProduct1.id==null)
        {
           /* objProduct.Name='Delhivery Commercial Express - C2C';
            objProduct1.RecordTypeId = recTypeId;
            ObjProduct1.IsActive=true;
            lstProd.add(objProduct1);   */             
        }
         if(objProduct.id!=null){
            System.debug('Value in ObjProduct is '+ObjProduct);
            lstProd.add(objProduct);           
        }
         if(objProduct1.id!=null)
        {
            System.debug('Value in ObjProduct1 is '+ObjProduct1);
            lstProd.add(objProduct1);
        }
        if(lstProd!=null && lstProd.size()>0)
        {
            System.debug('Value in lstProd is '+lstProd[0]);
            System.debug('Value in lstProd1 is '+lstProd[1]);
            upsert lstProd;
        }     
    }
    // Insert Standard Shipping Product or update existing Surface product
    public void saveSurfaceShipping(){
        
        if(objProduct.Id==null ){
            objProduct.Name='Standard Shipping';
            objProduct.RecordTypeId=recTypeId;
            objProduct.IsActive=true;
            insert objProduct;
        }
        else{
            Update objProduct;      
        }
    }
    
    // Insert Surface Express Product or update existing Express product
    public void saveExpressShipping(){
        if(objProduct.Id==null ){
            objProduct.Name='Express Shipping';
            objProduct.RecordTypeId=recTypeId;
            objProduct.IsActive=true;
            insert objProduct;
        }
        else{
            Update objProduct;      
        }
        
    }
    
    //If product is B2B 5*5 ,display B2B 5*5 matrix using an getter setter instance of Product
    public void B2B5By5Matrix(){        
        Set<String> sourceSet = new Set<String>();
        sourceSet.add('North');
        sourceSet.add('West');
        sourceSet.add('South');
        sourceSet.add('East');
        sourceSet.add('North East');
        List<B2B_Price__c> B2BPriceList = new List<B2B_Price__c>();
        
        B2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];
        List<B2B_Price__c> B2BPriceTempList;
        Map<String, B2B_Price__c> b2bPriceTempMap;
        
        for(String sourceString : sourceSet){
            B2BPriceTempList = new List<B2B_Price__c>();
            b2bPriceTempMap = new Map<String, B2B_Price__c>();
            
            for(B2B_Price__c objB2BPrice : B2BPriceList){
                if(objB2BPrice.Source__c == sourceString){
                    B2BPriceTempList.add(objB2BPrice);
                    b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice);
                }
            }
            B2B5By5PriceWrapperList.add(new B2B5By5PriceWrapper(sourceString, B2BPriceTempList));
            b2bPriceMap.put(sourceString, b2bPriceTempMap);
        } 
        List<Product2> ProductList = new List<Product2>();
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,CFT__c,Intra_City__c,
                       RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c,AWB_Charges__c,Minimum_Chargeable_Amount_Rs__c,Minimum_Chargeable_Weight_Kg__c,Free_Storage_Period_days__c,Demurrage_Charges_Per_awb_Rs_per_consig__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_A__c,Fuel_Surcharge__c,ODA_Per_MAwb_Rs__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Additional_Per_Kg_Rs__c,Average_Diesel_Price__c,Diesel_Tolerance_Value__c,Mall_Deliveries_Additional_Per_Mawb_Rs__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Liability_per_consignment__c from Product2 where Name=:'B2B 5*5'];
        if(ProductList.size()>0){
            
            objProduct= ProductList[0];
        }        
    }
    //If product is B2B 6*6 ,display B2B 6*6 matrix using an getter setter instance of Product -- Apurva 3-01-2017
    public void B2B6By6Matrix(){        
        Set<String> sourceSet = new Set<String>();
        sourceSet.add('North');
        sourceSet.add('West');
        sourceSet.add('South');
        sourceSet.add('Kerala');
        sourceSet.add('East');
        sourceSet.add('North East');
        List<B2B_Price__c> B2BPriceList = new List<B2B_Price__c>();
        
        B2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];
        List<B2B_Price__c> B2BPriceTempList;
        Map<String, B2B_Price__c> b2bPriceTempMap;
        
        for(String sourceString : sourceSet){
            B2BPriceTempList = new List<B2B_Price__c>();
            b2bPriceTempMap = new Map<String, B2B_Price__c>();
            
            for(B2B_Price__c objB2BPrice : B2BPriceList){
                if(objB2BPrice.Source__c == sourceString){
                    B2BPriceTempList.add(objB2BPrice);
                    b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice);
                }
            }
            B2B6By6PriceWrapperList.add(new B2B6By6PriceWrapper(sourceString, B2BPriceTempList));
            b2bPriceMap.put(sourceString, b2bPriceTempMap);
        } 
        List<Product2> ProductList = new List<Product2>();
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,CFT__c, Intra_City__c,
                       RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c,AWB_Charges__c,Minimum_Chargeable_Amount_Rs__c,Minimum_Chargeable_Weight_Kg__c,Free_Storage_Period_days__c,Demurrage_Charges_Per_awb_Rs_per_consig__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_A__c,Fuel_Surcharge__c,ODA_Per_MAwb_Rs__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Additional_Per_Kg_Rs__c,Mall_Deliveries_Additional_Per_Mawb_Rs__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Liability_per_consignment__c, Average_Diesel_Price__c, Diesel_Tolerance_Value__c from Product2 where Name=:'B2B 6*6'];
        if(ProductList.size()>0){
            
            objProduct= ProductList[0];
        }        
    }
    //If product is B2B 14*14 ,display B2B 14*14 matrix using an getter setter instance of Product -- Apurva 4-01-2017
    public void B2B14By14Matrix(){        
        Set<String> sourceSet = new Set<String>();
        sourceSet.add('N1');
        sourceSet.add('N2');
        sourceSet.add('N3');
        sourceSet.add('C1');
        sourceSet.add('C2');
        sourceSet.add('W1');
        sourceSet.add('W2');
        sourceSet.add('S1');
        sourceSet.add('S2');
        sourceSet.add('S3');
        sourceSet.add('E1');
        sourceSet.add('E2');
        sourceSet.add('NE1');
        sourceSet.add('NE2');
        List<B2B_Price__c> B2BPriceList = new List<B2B_Price__c>();
        
        B2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];
        List<B2B_Price__c> B2BPriceTempList;
        Map<String, B2B_Price__c> b2bPriceTempMap;
        
        for(String sourceString : sourceSet){
            B2BPriceTempList = new List<B2B_Price__c>();
            b2bPriceTempMap = new Map<String, B2B_Price__c>();
            
            for(B2B_Price__c objB2BPrice : B2BPriceList){
                if(objB2BPrice.Source__c == sourceString){
                    B2BPriceTempList.add(objB2BPrice);
                    b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice);
                }
            }
            B2B14By14PriceWrapperList.add(new B2B14By14PriceWrapper(sourceString, B2BPriceTempList));
            b2bPriceMap.put(sourceString, b2bPriceTempMap);
        } 
        List<Product2> ProductList = new List<Product2>();
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,CFT__c,
                       RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c,AWB_Charges__c,Minimum_Chargeable_Amount_Rs__c,Minimum_Chargeable_Weight_Kg__c,Free_Storage_Period_days__c,Demurrage_Charges_Per_awb_Rs_per_consig__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_A__c,Fuel_Surcharge__c,ODA_Per_MAwb_Rs__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Additional_Per_Kg_Rs__c,Mall_Deliveries_Additional_Per_Mawb_Rs__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Liability_per_consignment__c, Average_Diesel_Price__c, Diesel_Tolerance_Value__c from Product2 where Name=:'B2B 14*14'];
        if(ProductList.size()>0){
            
            objProduct= ProductList[0];
        }        
    }
    //If product is B2B 15*15 ,display B2B 15*15 matrix using an getter setter instance of Product
    public void B2B15By15Matrix(){
        Set<String> sourceSet = new Set<String>();
        sourceSet.add('NCR');
        sourceSet.add('LUH');
        sourceSet.add('JAI');
        sourceSet.add('JAM');
        sourceSet.add('LKO');
        sourceSet.add('BOM');
        sourceSet.add('AMD');
        sourceSet.add('GOA');
        sourceSet.add('IXR');
        sourceSet.add('IDR');
        sourceSet.add('BLR');
        sourceSet.add('HYD');
        sourceSet.add('CJB');
        sourceSet.add('CCU');
        sourceSet.add('GUA'); 
        List<B2B_Price__c> B2BPriceList = new List<B2B_Price__c>();
        B2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];
        List<B2B_Price__c> B2BPriceTempList;
        Map<String, B2B_Price__c> b2bPriceTempMap;
        for(String sourceString : sourceSet){
            B2BPriceTempList = new List<B2B_Price__c>();
            b2bPriceTempMap = new Map<String, B2B_Price__c>();
            for(B2B_Price__c objB2BPrice : B2BPriceList){
                if(objB2BPrice.Source__c == sourceString){
                    B2BPriceTempList.add(objB2BPrice);
                    b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice);
                }
            }
            B2B15By15PriceWrapperList.add(new B2B15By15PriceWrapper(sourceString, B2BPriceTempList));
            b2bPriceMap.put(sourceString, b2bPriceTempMap);
        }
        List<Product2> ProductList = new List<Product2>();
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,CFT__c,
                       RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c,AWB_Charges__c,Minimum_Chargeable_Amount_Rs__c,Minimum_Chargeable_Weight_Kg__c,Free_Storage_Period_days__c,Demurrage_Charges_Per_awb_Rs_per_consig__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_A__c,Fuel_Surcharge__c,ODA_Per_MAwb_Rs__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Additional_Per_Kg_Rs__c,Mall_Deliveries_Additional_Per_Mawb_Rs__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Average_Diesel_Price__c,Diesel_Tolerance_Value__c,Liability_per_consignment__c from Product2 where Name=:'B2B 15*15'];
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }       
    }
    
    //If product is B2B Lanewise ,display B2B Lanewise using an getter setter instance of Product
    public void B2BLanexLaneMatrix()
    {
        List<Product2> ProductList = new List<Product2>();
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,CFT__c,
                       RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c,AWB_Charges__c,Minimum_Chargeable_Amount_Rs__c,Minimum_Chargeable_Weight_Kg__c,Free_Storage_Period_days__c,Demurrage_Charges_Per_awb_Rs_per_consig__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_A__c,Fuel_Surcharge__c,ODA_Per_MAwb_Rs__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Additional_Per_Kg_Rs__c,Mall_Deliveries_Additional_Per_Mawb_Rs__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Liability_per_consignment__c, Average_Diesel_Price__c, Diesel_Tolerance_Value__c from Product2 where Name=:'B2B Lanewise'];
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }      
    }
    // Method to direct current page back to Opportunity Page
    public PageReference goBack(){
        PageReference pg = new PageReference('/01t/o');
        return pg;
    }
    
    //Save Pricing by calling respective method based on recordType
    public PageReference savePricing(){
        if(recTypeName == 'B2B_5x5'){
            save5By5Pricing();
            //display validation errors on page
            if(ErrorStr!=null && ErrorStr!=''){
                objProduct.CFT__c.addError(ErrorStr);
                ErrorStr = null;
                return null;
            }
        }else if(recTypeName == 'B2b_15x15'){
            save15By15Pricing();
            if(ErrorStr!=null && ErrorStr!=''){
                objProduct.CFT__c.addError(ErrorStr);
                ErrorStr = null;
                return null;
            }
        }
        else if(recTypeName == 'B2B_14x14'){
            save14By14Pricing();
            if(ErrorStr!=null && ErrorStr!=''){
                objProduct.CFT__c.addError(ErrorStr);
                ErrorStr = null;
                return null;
            }
        }
        else if(recTypeName == 'B2B_6x6'){
            save6By6Pricing();
            if(ErrorStr!=null && ErrorStr!=''){
                objProduct.CFT__c.addError(ErrorStr);
                ErrorStr = null;
                return null;
            }
        }
        else if(recTypeName == 'B2b_LanexLane'){
            saveB2BLanexLanePricing();
            if(ErrorStr!=null && ErrorStr!=''){
                objProduct.CFT__c.addError(ErrorStr);
                ErrorStr = null;
                return null;
            }
            PageReference pg = new PageReference('/'+objProduct.Id);
            return pg;                  
        }
        else if(recTypeName == 'Express_shipping'){
            saveExpressShipping();
            PageReference pg = new PageReference('/'+objProduct.Id);
            return pg; 
        }
        else if(recTypeName == 'Hyperlocal'){
            saveHyperlocal();
            PageReference pg = new PageReference('/'+productId1);
            return pg;
        }
        if(recTypeName == 'Standard_shipping'){
            saveSurfaceShipping();
            PageReference pg = new PageReference('/'+objProduct.Id);
            return pg;                  
        }
        if(recTypeName == 'Franchise_shipping'){
            saveFranchiseShipping();
            PageReference pg = new PageReference('/'+objProduct.Id);
            return pg;
        }
        if(recTypeName == 'Mail_Room'){
            SaveMailRoomShipping();
            PageReference pg = new PageReference('/'+objProduct.id);
            return pg;
        }
        PageReference pg = new PageReference('/'+productId);
        return pg;      
    }
    
    public void save5By5Pricing(){
        
        List<B2B_Price__c> b2bPriceToUpdateList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice;
        system.debug('b2bPriceMap '+b2bPriceMap);
        for(B2B5By5PriceWrapper objWrap : B2B5By5PriceWrapperList){
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('North');
            objB2BPrice.Amount__c = objWrap.northAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('West');
            objB2BPrice.Amount__c = objWrap.westAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('South');
            objB2BPrice.Amount__c = objWrap.southAmount;
            b2bPriceToUpdateList.add(objB2BPrice);   
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('East');
            objB2BPrice.Amount__c = objWrap.eastAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('North East');
            objB2BPrice.Amount__c = objWrap.northEastAmount;
            b2bPriceToUpdateList.add(objB2BPrice);                 
        }              
        
        if(b2bPriceToUpdateList.size()>0){
            update b2bPriceToUpdateList;
        }
        if(objProduct.Id==null ){
            objProduct.Name='B2B 5*5';
            objProduct.RecordTypeId=recTypeId;
            objProduct.Max_Dead_weight_package__c = 35;
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.';                
            }else{
                insert objProduct;              
            }
        }
        else{
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.'; 
            }else{
                Update objProduct;                 
            }     
        }
    }
    public void save6By6Pricing(){
        
        List<B2B_Price__c> b2bPriceToUpdateList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice;
        system.debug('b2bPriceMap '+b2bPriceMap);
        for(B2B6By6PriceWrapper objWrap : B2B6By6PriceWrapperList){
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('North');
            objB2BPrice.Amount__c = objWrap.northAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('West');
            objB2BPrice.Amount__c = objWrap.westAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('South');
            objB2BPrice.Amount__c = objWrap.southAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('Kerala');
            objB2BPrice.Amount__c = objWrap.keralaAmount;
            b2bPriceToUpdateList.add(objB2BPrice);   
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('East');
            objB2BPrice.Amount__c = objWrap.eastAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('North East');
            objB2BPrice.Amount__c = objWrap.northEastAmount;
            b2bPriceToUpdateList.add(objB2BPrice);                 
        }              
        
        if(b2bPriceToUpdateList.size()>0){
            update b2bPriceToUpdateList;
        }
        if(objProduct.Id==null ){
            objProduct.Name='B2B 6*6';
            objProduct.RecordTypeId=recTypeId;
            objProduct.Max_Dead_weight_package__c = 35;         
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.';                
            }else{
                insert objProduct;              
            }
        }
        else{
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.'; 
            }else{
                Update objProduct;                 
            }     
        }
    }
    public void save14By14Pricing(){
        
        List<B2B_Price__c> b2bPriceToUpdateList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice;
        
        for(B2B14By14PriceWrapper objWrap  : B2B14By14PriceWrapperList){
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('N1');
            objB2BPrice.Amount__c = objWrap.n1Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('N2');
            objB2BPrice.Amount__c = objWrap.n2Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('N3');
            objB2BPrice.Amount__c = objWrap.n3Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('C1');
            objB2BPrice.Amount__c = objWrap.c1Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('C2');
            objB2BPrice.Amount__c = objWrap.c2Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('W1');
            objB2BPrice.Amount__c = objWrap.w1Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('W2');
            objB2BPrice.Amount__c = objWrap.w2Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('S1');
            objB2BPrice.Amount__c = objWrap.s1Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('S2');
            objB2BPrice.Amount__c = objWrap.s2Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('S3');
            objB2BPrice.Amount__c = objWrap.s3Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('E1');
            objB2BPrice.Amount__c = objWrap.e1Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('E2');
            objB2BPrice.Amount__c = objWrap.e2Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('NE1');
            objB2BPrice.Amount__c = objWrap.ne1Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('NE2');
            objB2BPrice.Amount__c = objWrap.ne2Amount;
            b2bPriceToUpdateList.add(objB2BPrice);
        }
        if(b2bPriceToUpdateList.size()>0){
            update b2bPriceToUpdateList;
        }
        if(objProduct.Id==null ){
            objProduct.Name='B2B 14*14';
            objProduct.RecordTypeId=recTypeId;
            objProduct.Max_Dead_weight_package__c = 35;
            
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.'; 
            }else{                
                insert objProduct;
            }
        }
        else{
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.';               
            }else{
                Update objProduct;              
            }     
        }
    }
    public void save15By15Pricing(){
        
        List<B2B_Price__c> b2bPriceToUpdateList = new List<B2B_Price__c>();
        B2B_Price__c objB2BPrice;
        
        for(B2B15By15PriceWrapper objWrap  : B2B15By15PriceWrapperList){
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('NCR');
            objB2BPrice.Amount__c = objWrap.ncrAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('LUH');
            objB2BPrice.Amount__c = objWrap.luhAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('JAI');
            objB2BPrice.Amount__c = objWrap.jaiAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('JAM');
            objB2BPrice.Amount__c = objWrap.jamAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('LKO');
            objB2BPrice.Amount__c = objWrap.lkoAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('BOM');
            objB2BPrice.Amount__c = objWrap.bomAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('AMD');
            objB2BPrice.Amount__c = objWrap.amdAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('GOA');
            objB2BPrice.Amount__c = objWrap.goaAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('IXR');
            objB2BPrice.Amount__c = objWrap.ixrAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('IDR');
            objB2BPrice.Amount__c = objWrap.idrAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('BLR');
            objB2BPrice.Amount__c = objWrap.blrAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('HYD');
            objB2BPrice.Amount__c = objWrap.hydAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('CJB');
            objB2BPrice.Amount__c = objWrap.cjbAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('CCU');
            objB2BPrice.Amount__c = objWrap.ccuAmount;
            b2bPriceToUpdateList.add(objB2BPrice);
            
            objB2BPrice = new B2B_Price__c();
            objB2BPrice = b2bPriceMap.get(objWrap.source).get('GUA');
            objB2BPrice.Amount__c = objWrap.guaAmount;
            b2bPriceToUpdateList.add(objB2BPrice);                                                                                                                                                                      
        }
        if(b2bPriceToUpdateList.size()>0){
            update b2bPriceToUpdateList;
        }
        if(objProduct.Id==null ){
            objProduct.Name='B2B 15*15';
            objProduct.RecordTypeId=recTypeId;
            objProduct.Max_Dead_weight_package__c = 35;
            
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.'; 
            }else{                
                insert objProduct;
            }
        }
        else{
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.';               
            }else{
                Update objProduct;              
            }     
        }
    }
    public void saveB2BLanexLanePricing()
    {
        if(objProduct.Id==null ){
            objProduct.Name='B2B Lanewise';
            objProduct.RecordTypeId=recTypeId;
            objProduct.Max_Dead_weight_package__c = 35;
            objProduct.Service_Charges__c = 18;
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.'; 
            }else{   
                insert objProduct;         
            }
        }
        else{
            if(objProduct.CFT__c<5 || objProduct.CFT__c>6){
                ErrorStr = 'CFT should accept only in range 5 to 6.'; 
            }else{ 
                Update objProduct;                  
            }    
        }
    }
    
    //Dynamically add textbox to insert new hyperlocal record 
    public void toAdd()
    {
        objHyperLocal = new Hyperlocal_Price__c();
        objHyperLocal.Product__c = productId1;
        hpList.add(objHyperLocal);
    }
    
    //Delete record when clicked on minus image
    public void toDelete()
    {
        Integer indexVal = Integer.valueof(system.currentpagereference().getparameters().get('index'));
        if(hpList[indexVal].Id != null){
            deleteHpList.add(hpList[indexVal]);}
        hpList.remove(indexVal);  
    }
    
    // Insert List of hyperlocal or add 
    public void saveHyperlocal()
    {
        ListToAddHP = new List<Hyperlocal_Price__c>();
        for(Hyperlocal_Price__c hpObj : hpList){
            if(hpObj.Number_of_Order_per_trip__c>0){
                ListToAddHP.add(hpObj);
            }
        }
        if(ListToAddHP.size()>0){
            upsert ListToAddHP;
            
            if(deleteHpList!=null && deleteHpList.size() > 0){
                delete deleteHpList;}   
        }
        
    }
    
}