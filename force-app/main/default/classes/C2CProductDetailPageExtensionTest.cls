@isTest
public class C2CProductDetailPageExtensionTest {
    
      public static testMethod void testMethodForHyperlocal(){          
        Product2 objproduct = crtProduct('Hyperlocal','Hyperlocal');
        objproduct.Maximum_liability_per_consignment__c=5;
        insert  objproduct;        
        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct);
        ApexPages.currentPage().getParameters().put('Id',objproduct.Id);
        C2CProductDetailPageExtension objC2CProductDetailPageExtension = new C2CProductDetailPageExtension(sc);
        string Product = '';
        String product1 = '';
        objC2CProductDetailPageExtension.DisplayMatrix(Product,Product1);
        objC2CProductDetailPageExtension.B2B5By5Matrix();
        objC2CProductDetailPageExtension.B2B15By15Matrix();    
        objC2CProductDetailPageExtension.description='Test';
        System.assertEquals(5, objproduct.Maximum_liability_per_consignment__c);
        System.assertEquals('Test', objC2CProductDetailPageExtension.description);
    }
    public static Product2 crtProduct(String RecTypeDeveloperName, String ProductName){
        RecordType  rt2=[SELECT Id,DeveloperName FROM RecordType WHERE DeveloperName=:RecTypeDeveloperName AND SObjectType='Product2' ];        
        Product2 objProduct = new Product2();
        objProduct.Name=ProductName;
        objProduct.RecordTypeId=rt2.Id;
        objProduct.Maximum_liability_per_consignment__c=5;
        return objProduct;
    }
    
     public static testMethod void testMethodForExpressShipping(){          
        Product2 objproduct = crtProduct('Express_Shipping','Express_Shipping');
        objproduct.Maximum_liability_per_consignment__c=5;
        insert  objproduct;        
        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct);
        ApexPages.currentPage().getParameters().put('Id',objproduct.Id);
        C2CProductDetailPageExtension objC2CProductDetailPageExtension = new C2CProductDetailPageExtension(sc); 
        string Product = '%Express%';
         String Product1='';
        objC2CProductDetailPageExtension.DisplayMatrix(Product,Product1);
        objC2CProductDetailPageExtension.description='';
        
    }
    
     public static testMethod void testMethodForStandardShipping(){          
        Product2 objproduct = crtProduct('Standard_shipping','Standard_shipping');
        objproduct.Maximum_liability_per_consignment__c=5;
        insert  objproduct;        
        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct);
        ApexPages.currentPage().getParameters().put('Id',objproduct.Id);
        C2CProductDetailPageExtension objC2CProductDetailPageExtension = new C2CProductDetailPageExtension(sc); 
        string Product = '%Standard Shipping%';
         String Product1 = '';
        objC2CProductDetailPageExtension.DisplayMatrix(Product,Product1);
        objC2CProductDetailPageExtension.description='Test';
        System.assertEquals(5, objproduct.Maximum_liability_per_consignment__c);
        System.assertEquals('Test', objC2CProductDetailPageExtension.description);
    }
    
    public static testMethod void testMethodForB2B_5x5(){          
        Product2 objproduct = crtProduct('B2B_5x5','B2B_5x5');
        objproduct.Maximum_liability_per_consignment__c=5;
        objproduct.Min_Billable_Weight__c = 1000000;
        objproduct.Name = 'B2B 5*5';
        insert  objproduct; 
        System.debug('Name-->'+objproduct.Name);
		B2B_Price__c objB2BPrice = new B2B_Price__c();
        //objB2BPrice.Name = 'Test';       
        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct);
        ApexPages.currentPage().getParameters().put('Id',objproduct.Id);
        System.debug('objproduct.Id -->'+objproduct.Id);
        C2CProductDetailPageExtension objC2CProductDetailPageExtension = new C2CProductDetailPageExtension(sc); 
        string Product = '%B2B 5*5%';
        String product1= '';
        objB2BPrice.Source__c = 'North';
        objB2BPrice.Destination__c = 'Test';
        objB2BPrice.Amount__c=5;
        objB2BPrice.Product__c = objproduct.id;
        insert objB2BPrice;
        System.debug('objB2BPrice -->'+objB2BPrice);
        objC2CProductDetailPageExtension.B2B5By5Matrix();
        objC2CProductDetailPageExtension.DisplayMatrix(Product,Product1);
        objC2CProductDetailPageExtension.description='Test'; 
        System.assertEquals(5, objproduct.Maximum_liability_per_consignment__c);
        System.assertEquals('Test', objC2CProductDetailPageExtension.description);
      
    }
    public static testMethod void testMethodForB2B_15x15(){          
        Product2 objproduct = crtProduct('B2b_15x15','B2b_15x15');
        objproduct.Maximum_liability_per_consignment__c=5;
        objproduct.Min_Billable_Weight__c = 1000000;
        objproduct.Name = 'B2B 15*15';
        insert  objproduct;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct);
        ApexPages.currentPage().getParameters().put('Id',objproduct.Id);
        C2CProductDetailPageExtension objC2CProductDetailPageExtension = new C2CProductDetailPageExtension(sc); 
        string Product = '%B2B 15*15%';
        String product1 = '';
        B2B_Price__c objB2BPrice = new B2B_Price__c();
        objB2BPrice.Source__c = 'NCR';
        objB2BPrice.Destination__c = 'Test';
        objB2BPrice.Amount__c=5;
        objB2BPrice.Product__c = objproduct.id;
        insert objB2BPrice;
        objC2CProductDetailPageExtension.B2B15By15Matrix();
        objC2CProductDetailPageExtension.DisplayMatrix(Product,Product1);
        objC2CProductDetailPageExtension.description='Test';
        System.assertEquals(5, objproduct.Maximum_liability_per_consignment__c);
		System.assertEquals('Test', objC2CProductDetailPageExtension.description);        
    }
    public static testMethod void testMethodForB2B_6x6(){          
        Product2 objproduct = crtProduct('B2b_6x6','B2b_6x6');
        objproduct.Maximum_liability_per_consignment__c=5;
        objproduct.Min_Billable_Weight__c = 1000000;
        objproduct.Name = 'B2B 6*6';
        insert  objproduct;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct);
        ApexPages.currentPage().getParameters().put('Id',objproduct.Id);
        C2CProductDetailPageExtension objC2CProductDetailPageExtension = new C2CProductDetailPageExtension(sc); 
        string Product = '%B2B 6*6%';
        String product1 = '';
        B2B_Price__c objB2BPrice = new B2B_Price__c();
        objB2BPrice.Source__c = 'NCR';
        objB2BPrice.Destination__c = 'Test';
        objB2BPrice.Amount__c=5;
        objB2BPrice.Product__c = objproduct.id;
        insert objB2BPrice;
        objC2CProductDetailPageExtension.B2B6By6Matrix();
        objC2CProductDetailPageExtension.DisplayMatrix(Product,Product1);
        objC2CProductDetailPageExtension.description='Test';
        System.assertEquals(5, objproduct.Maximum_liability_per_consignment__c);
		System.assertEquals('Test', objC2CProductDetailPageExtension.description);        
    }
    public static testMethod void testMethodForB2B_14x14(){          
        Product2 objproduct = crtProduct('B2b_14x14','B2b_14x14');
        objproduct.Maximum_liability_per_consignment__c=5;
        objproduct.Min_Billable_Weight__c = 1000000;
        objproduct.Name = 'B2B 14x14';
        insert  objproduct;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(objproduct);
        ApexPages.currentPage().getParameters().put('Id',objproduct.Id);
        C2CProductDetailPageExtension objC2CProductDetailPageExtension = new C2CProductDetailPageExtension(sc); 
        string Product = '%B2B 14*14%';
        String product1 = '';
        B2B_Price__c objB2BPrice = new B2B_Price__c();
        objB2BPrice.Source__c = 'NCR';
        objB2BPrice.Destination__c = 'Test';
        objB2BPrice.Amount__c=5;
        objB2BPrice.Product__c = objproduct.id;
        insert objB2BPrice;
        objC2CProductDetailPageExtension.B2B14By14Matrix();
        objC2CProductDetailPageExtension.DisplayMatrix(Product,Product1);
        objC2CProductDetailPageExtension.description='Test';
        System.assertEquals(5, objproduct.Maximum_liability_per_consignment__c);
		System.assertEquals('Test', objC2CProductDetailPageExtension.description);        
    }

}