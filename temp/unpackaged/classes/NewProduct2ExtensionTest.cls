/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: NewProduct2ExtensionTest
* Created Date: 29-June-2017
* Description: Primary test class for NewProduct2Extension
*******************************************************************/


@isTest
public class NewProduct2ExtensionTest {
    public static testMethod void insertHyperlocal(){
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'Hyperlocal' ];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Product2 objProduct2 = TestDataUtility.objProduct;
        objProduct2.RecordTypeId=rt.Id;
        objProduct2.Min_Billable_Weight__c=1;
        objProduct2.Way_Bill_Charge__c=10;
        objProduct2.Insurance__c=1.2;
        objProduct2.Entry_Tax_Service_Charge__c=1.5;
        objProduct2.Fuel_Surcharge__c=1.5;
        objProduct2.RoV_Surcharge__c=2.5;
        objProduct2.Max_Dead_weight_package__c =2.2;
        update objProduct2;
                
        List<Hyperlocal_Price__c> HyperlocalList= new List<Hyperlocal_Price__c>();
        Hyperlocal_Price__c objHyperlocal = new Hyperlocal_Price__c();
        objHyperlocal.Number_of_Order_per_trip__c=2;
        objHyperlocal.Base_Range_in_Km__c=2;
        objHyperlocal.Base_Charge_per_Order_INR__c='55';
        objHyperlocal.COD_Charges__c=20;
        objHyperlocal.Additional_Charge_INR_per_Km__c = 10;
        objHyperlocal.Additional_Range__c=2.5;
        objHyperlocal.COD_Charges_in__c=5;
        objHyperlocal.Product__c=objProduct2.Id;
        HyperlocalList.add(objHyperlocal);
        insert HyperlocalList;
        ApexPages.currentPage().getParameters().put('index','0');
      //  NewProduct2Extension NPE=new NewProduct2Extension();
      
    }
    public static testMethod void insertHyperlocal1(){
        
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'Hyperlocal' ];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Product2 objProduct2 = TestDataUtility.objProduct;
        objProduct2.RecordTypeId=rt.Id;
        /*objProduct2.Min_Billable_Weight__c=1;
        objProduct2.Way_Bill_Charge__c=10;
        objProduct2.Insurance__c=1.2;
        objProduct2.Entry_Tax_Service_Charge__c=1.5;
        objProduct2.Fuel_Surcharge__c=1.5;
        objProduct2.RoV_Surcharge__c=2.5;
        objProduct2.Max_Dead_weight_package__c =2.2;*/
        update objProduct2;
        Product2 objProductTwo = new Product2();
		ApexPages.currentPage().getParameters().put('RecordType',objProduct2.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProductTwo));
        objExtension.saveSurfaceShipping();
        objExtension.save5By5Pricing();
        objExtension.save6By6Pricing();
        objExtension.save14By14Pricing();
    }
    public static testMethod void insertHyperlocal2(){
        
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'Hyperlocal' ];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Product2 objProduct2 = TestDataUtility.objProduct;
        objProduct2.RecordTypeId=rt.Id;
        /*objProduct2.Min_Billable_Weight__c=1;
        objProduct2.Way_Bill_Charge__c=10;
        objProduct2.Insurance__c=1.2;
        objProduct2.Entry_Tax_Service_Charge__c=1.5;
        objProduct2.Fuel_Surcharge__c=1.5;
        objProduct2.RoV_Surcharge__c=2.5;
        objProduct2.Max_Dead_weight_package__c =2.2;*/
        update objProduct2;
        Product2 objProductThree = new Product2();
		ApexPages.currentPage().getParameters().put('RecordType',objProduct2.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProductThree));
     //   objExtension.saveSurfaceShipping();
        objExtension.save5By5Pricing();
     //   objExtension.save6By6Pricing();
     //   objExtension.save14By14Pricing();
    }
    public static testMethod void insertHyperlocal3(){
        
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'Hyperlocal' ];
        TestDataUtility.crtProductwithPBE('Hyperlocal');
        
        Product2 objProduct2 = TestDataUtility.objProduct;
        objProduct2.RecordTypeId=rt.Id;
        /*objProduct2.Min_Billable_Weight__c=1;
        objProduct2.Way_Bill_Charge__c=10;
        objProduct2.Insurance__c=1.2;
        objProduct2.Entry_Tax_Service_Charge__c=1.5;
        objProduct2.Fuel_Surcharge__c=1.5;
        objProduct2.RoV_Surcharge__c=2.5;
        objProduct2.Max_Dead_weight_package__c =2.2;*/
        update objProduct2;
        Product2 objProductfour = new Product2();
		ApexPages.currentPage().getParameters().put('RecordType',objProduct2.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProductfour));
     //   objExtension.saveSurfaceShipping();
     //   objExtension.save5By5Pricing();
        objExtension.save6By6Pricing();
     //   objExtension.save14By14Pricing();
    }
    public static testMethod void testSurface()
    {
        insertHyperlocal();
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'Standard_shipping' ];
        TestDataUtility.crtProductwithPBE('Standard Shipping');
        
        Product2 objProduct = TestDataUtility.objProduct;
        objProduct.RecordTypeId=rt.Id;
        update objProduct;       
               
        ApexPages.currentPage().getParameters().put('id',objProduct.id);
        ApexPages.currentPage().getParameters().put('RecordType',objProduct.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProduct));
        System.assertEquals(objProduct.Id, objExtension.objProduct.Id);
        objExtension.savePricing();
        objExtension.goBack();
          objExtension.toAdd();
            objExtension.toDelete();
            objExtension.saveHyperlocal();
         
    }

    public static testMethod void testExpress(){
        insertHyperlocal();
        
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'Express_shipping' ];
        TestDataUtility.crtProductwithPBE('Express Shipping');
        
        Product2 objProduct = TestDataUtility.objProduct;
        objProduct.RecordTypeId=rt.Id;
        update objProduct;
        
        ApexPages.currentPage().getParameters().put('id',objProduct.id);
        ApexPages.currentPage().getParameters().put('RecordType',objProduct.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProduct));
        System.assertEquals(objProduct.Id,objExtension.objProduct.Id);
        objExtension.savePricing();
        objExtension.goBack();
        
    }
    public static testMethod void testB2B5by5(){
       insertHyperlocal();
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName='B2B_5x5' ];
        TestDataUtility.crtProductwithPBE('B2B 5*5');
        
        Product2 objProduct = TestDataUtility.objProduct;
        objProduct.Min_Billable_Weight__c=10;
        objProduct.Way_Bill_Charge__c=10;
        objProduct.Insurance__c=1.2;
        objProduct.Entry_Tax_Service_Charge__c=1.5;
        objProduct.Fuel_Surcharge__c=1.5;
        objProduct.RoV_Surcharge__c=2.5;
        objProduct.Max_Dead_weight_package__c =2.2;
        objProduct.RoV_Surcharge_RS_10_000__c=4;
        objProduct.CFT__c=5.0;
        objProduct.RecordTypeId=rt.Id;
        update objProduct;
        
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
                    B2BpriceList.add(objB2Bprice);
                }
                
        }
        insert B2BpriceList;
        System.debug('B2BpriceList ->'+ B2BpriceList);
        
        ApexPages.currentPage().getParameters().put('id',objProduct.Id);
        ApexPages.currentPage().getParameters().put('RecordType',objProduct.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProduct));
        System.assertEquals(objProduct.Id, objExtension.objProduct.Id);
        objExtension.savePricing();
        
        
    }
    public static testMethod void testB2B15by15(){
        insertHyperlocal();
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'B2b_15x15' ];
        TestDataUtility.crtProductwithPBE('B2B 15*15');
        
        Product2 objProduct = TestDataUtility.objProduct;
        objProduct.Min_Billable_Weight__c=10;
        objProduct.Way_Bill_Charge__c=10;
        objProduct.Insurance__c=1.2;
        objProduct.Entry_Tax_Service_Charge__c=1.5;
        objProduct.Fuel_Surcharge__c=1.5;
        objProduct.RoV_Surcharge__c=2.5;
        objProduct.Max_Dead_weight_package__c =2.2;
        objProduct.RoV_Surcharge_RS_10_000__c=4;
        objProduct.CFT__c=5.0;
        objProduct.RecordTypeId=rt.Id;
        update objProduct;
        
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        
        List<String> sourceList = new List<String>();
        sourceList.add('NCR');
        sourceList.add('LUH');
        sourceList.add('JAI');
        sourceList.add('JAM');
        sourceList.add('LKO');
        sourceList.add('BOM');
        sourceList.add('AMD');
        sourceList.add('GOA');
        sourceList.add('IXR');
        sourceList.add('IDR');
        sourceList.add('BLR');
        sourceList.add('HYD');
        sourceList.add('CJB');
        sourceList.add('CCU');
        sourceList.add('GUA'); 
        
        for(Integer i=0;i<sourceList.size();i++){
            for(Integer j=0;j<sourceList.size();j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList[i];    
                    objB2Bprice.Destination__c=sourceList[j];   
                    B2BpriceList.add(objB2Bprice);
            }
        }
        
        insert B2BpriceList;
        
        ApexPages.currentPage().getParameters().put('id',objProduct.id);
        ApexPages.currentPage().getParameters().put('RecordType',objProduct.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProduct));
        System.assertEquals(objProduct.Id, objExtension.objProduct.Id);
        objExtension.savePricing();
        
        
    }
    public static testMethod void testB2B14by14(){
        insertHyperlocal();
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'B2b_14x14' ];
        TestDataUtility.crtProductwithPBE('B2B 14*14');
        
        Product2 objProduct = TestDataUtility.objProduct;
        objProduct.Min_Billable_Weight__c=10;
        objProduct.Way_Bill_Charge__c=10;
        objProduct.Insurance__c=1.2;
        objProduct.Entry_Tax_Service_Charge__c=1.5;
        objProduct.Fuel_Surcharge__c=1.5;
        objProduct.RoV_Surcharge__c=2.5;
        objProduct.Max_Dead_weight_package__c =2.2;
        objProduct.RoV_Surcharge_RS_10_000__c=4;
        objProduct.CFT__c=5.0;
        objProduct.RecordTypeId=rt.Id;
        update objProduct;
        
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        
        List<String> sourceList = new List<String>();
        sourceList.add('N1');
        sourceList.add('N2');
        sourceList.add('N3');
        sourceList.add('C1');
        sourceList.add('C2');
        sourceList.add('W1');
        sourceList.add('W2');
        sourceList.add('S1');
        sourceList.add('S2');
        sourceList.add('S3');
        sourceList.add('E1');
        sourceList.add('E2');
        sourceList.add('NE1');
        sourceList.add('NE2');
        
        for(Integer i=0;i<sourceList.size();i++){
            for(Integer j=0;j<sourceList.size();j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList[i];    
                    objB2Bprice.Destination__c=sourceList[j];   
                    B2BpriceList.add(objB2Bprice);
            }
        }
        
        insert B2BpriceList;
        
        ApexPages.currentPage().getParameters().put('id',objProduct.id);
        ApexPages.currentPage().getParameters().put('RecordType',objProduct.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProduct));
        System.assertEquals(objProduct.Id, objExtension.objProduct.Id);
        objExtension.savePricing();
        
        
    }
    public static testMethod void testB2B6by6(){
        insertHyperlocal();
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'B2b_6x6' ];
        TestDataUtility.crtProductwithPBE('B2B 6*6');
        
        Product2 objProduct = TestDataUtility.objProduct;
        objProduct.Min_Billable_Weight__c=10;
        objProduct.Way_Bill_Charge__c=10;
        objProduct.Insurance__c=1.2;
        objProduct.Entry_Tax_Service_Charge__c=1.5;
        objProduct.Fuel_Surcharge__c=1.5;
        objProduct.RoV_Surcharge__c=2.5;
        objProduct.Max_Dead_weight_package__c =2.2;
        objProduct.RoV_Surcharge_RS_10_000__c=4;
        objProduct.CFT__c=5.0;
        objProduct.RecordTypeId=rt.Id;
        update objProduct;
        
        List<B2B_Price__c>  B2BpriceList= new List<B2B_Price__c> ();
        
        List<String> sourceList = new List<String>();
        sourceList.add('North');
        sourceList.add('West');
        sourceList.add('South');
        sourceList.add('Kerala');
        sourceList.add('East');
        sourceList.add('North East');        
        for(Integer i=0;i<sourceList.size();i++){
            for(Integer j=0;j<sourceList.size();j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList[i];    
                    objB2Bprice.Destination__c=sourceList[j];   
                    B2BpriceList.add(objB2Bprice);
            }
        }
        
        insert B2BpriceList;
        
        ApexPages.currentPage().getParameters().put('id',objProduct.id);
        ApexPages.currentPage().getParameters().put('RecordType',objProduct.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProduct));
        System.assertEquals(objProduct.Id, objExtension.objProduct.Id);
        objExtension.savePricing();
        
        
    }
 
    public static testMethod void testB2BLanewise(){
        insertHyperlocal();
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Product2' and isActive=true AND DeveloperName = 'B2b_LanexLane' ];
        TestDataUtility.crtProductwithPBE('B2B Lanewise');
        
        Product2 objProduct = TestDataUtility.objProduct;
        objProduct.RecordTypeId=rt.Id;
        update objProduct;
        
        B2B_Price__c objB2Bprice = new B2B_Price__c();
        objB2Bprice.Source__c='North';
        objB2Bprice.Destination__c='North';
        objB2Bprice.Amount__c=15;
        objB2Bprice.Product__c=objProduct.Id;
        insert objB2Bprice;
        
        ApexPages.currentPage().getParameters().put('id',objProduct.id);
        ApexPages.currentPage().getParameters().put('RecordType',objProduct.RecordTypeId);
        NewProduct2Extension objExtension = new NewProduct2Extension(new ApexPages.StandardController(objProduct));
        System.assertEquals(objProduct.Id, objExtension.objProduct.Id);
        objExtension.savePricing();      
    }

}