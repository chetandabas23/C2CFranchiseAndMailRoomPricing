/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: ProductDetailPageExtension
* Created Date: 8-June-2017
* Description:  Extension for pricing in output mode.    
*******************************************************************/
public class ProductDetailPageExtension
{
    public List<Hyperlocal_Price__c> hpList{get;set;}
    public List<B2B_Price__c>B2blist{get;set;}
    public String productId{get;set;}
    Public String strProductName{get;set;}
    Public String strProductName1{get;set;}
    public String description{get;set;}
    public Product2 objProduct{get; set;}
    Public product2 objProduct1{get; set;}
    public Product2 objProduct2= new Product2();
    public List<OpportunityLineItem> oliList= new List<OpportunityLineItem>();
    public List<B2B5By5PriceWrapper> B2B5By5PriceWrapperList{get;set;}
    public Map<String, Map<String, B2B_Price__c>> b2bPriceMap{get;set;}
    public List<B2B15By15PriceWrapper> B2B15By15PriceWrapperList{get;set;}  
    public List<B2B6By6PriceWrapper> B2B6By6PriceWrapperList{get;set;}
    public List<B2B14By14PriceWrapper> B2B14By14PriceWrapperList{get;set;}
    
    // Initialize getter setter, class variables and check recordType of Product
    public ProductDetailPageExtension(ApexPages.StandardController controller)
    {
        hpList = new List<Hyperlocal_Price__c>();
        B2blist = new List<B2B_Price__c>();
        objProduct= new Product2();
        productId = ApexPages.currentPage().getParameters().get('id');
        objProduct2 = [select Id,RecordType.DeveloperName from Product2 where id=:productId LIMIT 1];
        b2bPriceMap = new Map<String, Map<String, B2B_Price__c>>();
        B2B5By5PriceWrapperList = new List<B2B5By5PriceWrapper>();
        B2B15By15PriceWrapperList = new List<B2B15By15PriceWrapper>();           
        B2B6By6PriceWrapperList = new List<B2B6By6PriceWrapper>();
        B2B14By14PriceWrapperList = new List<B2B14By14PriceWrapper>();
        //Hyperlocal pricing
        if(objProduct2.RecordType.DeveloperName == 'Hyperlocal' ){
            Product2 objProduct2 = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,
                                    Fuel_Surcharge__c,RoV_Surcharge__c,Max_Dead_weight_package__c from Product2 where Name=:'Hyperlocal' ];
            hpList = [select id,Number_of_Order_per_trip__c,Base_Range_in_Km__c,Base_Charge_per_Order_INR__c,COD_Charges__c,
                      Additional_Charge_INR_per_Km__c,Additional_Range__c,COD_Charges_in__c from Hyperlocal_Price__c where Product__c=:objProduct2.id ORDER BY Number_of_Order_per_trip__c];
        }
        if(objProduct2.RecordType.DeveloperName == 'Franchise_Shipping'){
            DisplayMatrix('%'+System.Label.Franchise_Express+'%','%'+System.Label.Franchise_Standard+'%');
           // DisplayMatrix('%Delhivery Commercial Express - C2C%','%Delhivery Commercial Standard - C2C%');
        }
        if(objProduct2.RecordType.DeveloperName == 'Mail_Room') {
            DisplayMatrix('%'+System.Label.MailRoom_Express+'%','%'+System.Label.MailRoom_Standard+'%');
          //  DisplayMatrix('%Delhivery Commercial Express - C2C MailRoom%','%Delhivery Commercial Standard - C2C MailRoom%');
        }
        if(objProduct2.RecordType.DeveloperName == 'Express_Shipping' ){
            DisplayMatrix('%Express%','');
        }
        if(objProduct2.RecordType.DeveloperName == 'Standard_shipping' ){
            DisplayMatrix('%Standard Shipping%','');
        }   
        if(objProduct2.RecordType.DeveloperName == 'B2B_5x5' ){
            B2B5By5Matrix();
            DisplayMatrix('%B2B 5*5%','');
        }    
        if(objProduct2.RecordType.DeveloperName == 'B2b_15x15'){
            B2B15By15Matrix();
            DisplayMatrix('%B2B 15*15%','');
        }
        if(objProduct2.RecordType.DeveloperName == 'B2B_6x6'){
            B2B6By6Matrix();
            DisplayMatrix('%B2B 6*6%','');
        }
        if(objProduct2.RecordType.DeveloperName == 'B2B_14x14'){
            B2B14By14Matrix();
            DisplayMatrix('%B2B 14*14%','');
        }
        
    }
    // Query existing express and surface product 
    public void DisplayMatrix(String ProductName,String ProductName1){
        Schema.DescribesObjectResult r= Product2.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = new Map<String, Schema.SObjectField>();
        mapFields=r.fields.getMap();
        String productQuery='SELECT ';
        String fieldNames='';
        for(String apiName: mapFields.KeySet()){
            fieldNames+=apiName+',';
        }
        fieldNames =fieldNames.subString(0,fieldNames.length() - 1 );
        if(objProduct2.RecordType.DeveloperName != 'Franchise_Shipping' && objProduct2.RecordType.DeveloperName != 'Mail_Room')
        productQuery= productQuery+ fieldNames+' FROM Product2 WHERE Id=:productId AND Name LIKE :ProductName LIMIT 1';  
        if(objProduct2.RecordType.DeveloperName == 'Franchise_Shipping' || objProduct2.RecordType.DeveloperName == 'Mail_Room')
            productQuery = productQuery+ fieldNames+ ' FROM Product2 WHERE ISACTIVE=TRUE AND (NAME LIKE :ProductName OR NAME LIKE :ProductName1) LIMIT 2';
        List<Product2> productList= Database.Query(productQuery);
        if(productList.size() != 0) {
            objProduct=productList[0];
            strProductName = objProduct.Name;
        }
        if((objProduct2.RecordType.DeveloperName == 'Franchise_Shipping' || objProduct2.RecordType.DeveloperName == 'Mail_Room') && productList.size() != 0)
        {
            objProduct1 = productList[1];
            strProductName1 = objProduct1.Name;
        }
        System.debug('objProduct ->'+objProduct);
    }
    
    // Get Product B2B 5*5 and assign to getter setter instance of Product
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
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,
                       Fuel_Surcharge__c,RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c from Product2 where Name=:'B2B 5*5'];
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }        
    }
    // Get Product B2B 15*15 and assign to getter setter instance of Product
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
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,
                       Fuel_Surcharge__c,RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c from Product2 where Name=:'B2B 15*15'];
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }       
    }
    // Get Product B2B 6*6 and assign to getter setter instance of Product--Apurva 3-01-2017
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
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,
                       Fuel_Surcharge__c,RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c from Product2 where Name=:'B2B 6*6'];
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }       
    }
    // Get Product B2B 14*14 and assign to getter setter instance of Product--Apurva 4-01-2017
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
        ProductList = [select id,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c,
                       Fuel_Surcharge__c,RoV_Surcharge__c,Max_Dead_weight_package__c,RoV_Surcharge_RS_10_000__c from Product2 where Name=:'B2B 14*14'];
        if(ProductList.size()>0){
            objProduct= ProductList[0];
        }       
    }
    public PageReference goBack(){
        return new pageReference('/01t/o');
    }
    Public pagereference EditFranchise1()
    {
        return new pagereference('/lightning/r/Product2/'+objProduct1.Id+'/edit');
    }
    Public pagereference EditFranchise()
    {
        return new pagereference('/lightning/r/Product2/'+objProduct.id+'/edit');
    }
}