@isTest
public class DiscountUtilityTest 
{
    public static testMethod void testExpress(){
        
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Opportunity' and isActive=true AND DeveloperName = 'Express_Shipping' ];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('Express Shipping');
        insert objproduct;
        
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;  
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();
    }
    public static testMethod void testSurface(){
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Opportunity' and isActive=true AND DeveloperName = 'Standard_Shipping' ];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('Standard Shipping');
        insert objproduct;
        
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;
        
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();     
    }
    public static testMethod void testSurface1(){
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Opportunity' and isActive=true AND DeveloperName = 'C2C' ];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('Delhivery Commercial Express - C2C');
        insert objproduct;
        
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;
        
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();     
    }
     public static testMethod void testSurface2(){
        RecordType rt = [Select Name, Id From RecordType where sObjectType='Opportunity' and isActive=true AND DeveloperName = 'C2C' ];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('Delhivery Commercial Express - C2C MailRoom');
        insert objproduct;
        
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;
        
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();     
    }
    public static testMethod void testB2B5by5(){
        RecordType rt = [Select DeveloperName, Id From RecordType where sObjectType='Opportunity' AND DeveloperName = 'B2B'];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('B2B 5*5');
        insert objproduct;
        
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;
        
         List<String> sourceList = new List<String>();                
            sourceList.add('North');
            sourceList.add('West');
            sourceList.add('South');
            sourceList.add('East');
            sourceList.add('North East');
            
        List<B2B_Price__c> B2BPriceList = new List<B2B_Price__c>();
        for (Integer i = 0; i<sourceList.size(); i++ ){
                for (Integer j=0; j<sourceList.size(); j++ ){
                    B2B_Price__c objB2BPrice = new  B2B_Price__c();
                    objB2BPrice.Source__c = sourceList[i];
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2BPrice.Destination__c = sourceList[j];
                    objB2BPrice.Amount__c = 10;
                    objB2BPrice.Opportunity_Line_Item_Id__c=OLI.Id;
                    B2BPriceList.add(objB2BPrice);
                }
        }
        insert B2BPriceList;
        
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();
       
    }
    public static testMethod void testB2B15by15(){
        RecordType rt = [Select DeveloperName, Id From RecordType where sObjectType='Opportunity' AND DeveloperName = 'B2B'];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('B2B 15*15');
        insert objproduct;
      
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;
        
        List<B2B_Price__c>  B2BpriceList2= new List<B2B_Price__c> ();
        List<String> sourceList2 = new List<String>();
        sourceList2.add('NCR');
        sourceList2.add('LUH');
        sourceList2.add('JAI');
        sourceList2.add('JAM');
        sourceList2.add('LKO');
        sourceList2.add('BOM');
        sourceList2.add('AMD');
        sourceList2.add('GOA');
        sourceList2.add('IXR');
        sourceList2.add('IDR');
        sourceList2.add('BLR');
        sourceList2.add('HYD');
        sourceList2.add('CJB');
        sourceList2.add('CCU');
        sourceList2.add('GUA'); 
        
        for(Integer i=0;i<sourceList2.size();i++){
            for(Integer j=0;j<sourceList2.size();j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList2[i];    
                    objB2Bprice.Destination__c=sourceList2[j];   
                    objB2BPrice.Opportunity_Line_Item_Id__c=OLI.Id;
                    B2BpriceList2.add(objB2Bprice);
            }
        }
        insert B2BpriceList2;
        
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();
       
    }
    public static testMethod void testB2B15by4(){
        RecordType rt = [Select DeveloperName, Id From RecordType where sObjectType='Opportunity' AND DeveloperName = 'B2B'];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('B2B 14*14');
        insert objproduct;
      
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;
        
        List<B2B_Price__c>  B2BpriceList2= new List<B2B_Price__c> ();
        List<String> sourceList2 = new List<String>();
         sourceList2.add('N1');
            sourceList2.add('N2');
            sourceList2.add('N3');
            sourceList2.add('C1');
            sourceList2.add('C2');
            sourceList2.add('W1');
            sourceList2.add('W2');
            sourceList2.add('S1');
            sourceList2.add('S2');
            sourceList2.add('S3');
            sourceList2.add('E1');
            sourceList2.add('E2');
            sourceList2.add('NE1');
            sourceList2.add('NE2');
       
        
        for(Integer i=0;i<sourceList2.size();i++){
            for(Integer j=0;j<sourceList2.size();j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList2[i];    
                    objB2Bprice.Destination__c=sourceList2[j];   
                    objB2BPrice.Opportunity_Line_Item_Id__c=OLI.Id;
                    B2BpriceList2.add(objB2Bprice);
            }
        }
        insert B2BpriceList2;
        
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();
       
    }
     public static testMethod void testB2B15by6(){
        RecordType rt = [Select DeveloperName, Id From RecordType where sObjectType='Opportunity' AND DeveloperName = 'B2B'];
        Opportunity objOpportunity = TestDataUtility.crtActOppCont(rt.Id);
        
        Product2 objProduct = crtProduct('B2B 6*6');
        insert objproduct;
      
        PricebookEntry objPBE = new PricebookEntry(
             Pricebook2Id = Test.getStandardPricebookId(),
             Product2Id = objproduct.Id,
             UnitPrice = 10000,
             IsActive = true,
             UseStandardPrice = false
        );
        insert objPBE;
        
        OpportunityLineItem OLI= crtOLI(objOpportunity.Id,objPBE.Id);
        insert OLI;
        
        List<B2B_Price__c>  B2BpriceList2= new List<B2B_Price__c> ();
        List<String> sourceList2 = new List<String>();
         sourceList2.add('North');
            sourceList2.add('West');
            sourceList2.add('South');
            sourceList2.add('Kerala');
            sourceList2.add('East');
            sourceList2.add('North East');
        
        
        for(Integer i=0;i<sourceList2.size();i++){
            for(Integer j=0;j<sourceList2.size();j++){
                    B2B_Price__c objB2Bprice= new B2B_Price__c();
                    objB2Bprice.Amount__c=15;
                    objB2Bprice.Product__c=objProduct.Id;
                    objB2Bprice.Source__c=sourceList2[i];    
                    objB2Bprice.Destination__c=sourceList2[j];   
                    objB2BPrice.Opportunity_Line_Item_Id__c=OLI.Id;
                    B2BpriceList2.add(objB2Bprice);
            }
        }
        insert B2BpriceList2;
        
        DiscountUtility objdiscountutility = new DiscountUtility();
        objdiscountutility.findMaxDiscount(OLI.Id);
        objdiscountutility.checkOtherFieldDiscount();
       
    }
    
    
    public static Product2 crtProduct(String ProductName){
        Product2 objproduct = new Product2();
        objproduct.Name = ProductName;
        objproduct.IsActive = true;
        objProduct.Min_Billable_Weight__c = 10;
        objProduct.Way_Bill_Charge__c = 10;
        objProduct.Zone_D_Upto_500_gms__c=10;
        objProduct.Zone_A_Every_additional_500_gms__c=10;
        objProduct.Zone_B_Every_additional_500_gms__c=10;
        objProduct.Zone_C_Every_additional_500_gms__c=10;
        objProduct.Zone_D_Every_additional_500_gms__c=10;
        objProduct.Zone_C_RTO_every_500_gms__c=10;
        objProduct.Zone_D_RTO_every_500_gms__c=10;
        objProduct.Zone_B_RTO_every_500_gms__c=10;
        objProduct.Zone_A_RTO_every_500_gms__c=10;
        objProduct.Zone_E_RTO_every_500_gms__c=10;
        objProduct.Zone_C_DTO_Upto_500gm__c=10;
        objProduct.Zone_D_DTO_Upto_500gm__c=10;
        objProduct.Zone_C_DTO_every_add_500gm__c=10;
        objProduct.Zone_D_DTO_every_add_500gm__c=10;
        objProduct.Zone_A_0_250gm__c=10;
        objProduct.Zone_B_0_250gm__c=12;
        objProduct.Zone_C_0_250gm__c=15;
        objProduct.Zone_D_0_250gm__c=17;
        objProduct.Zone_E_0_250gm__c=19;
        ObjProduct.Zone_A_Additional_250_gms_till_500_gms__c=12;
        objProduct.Zone_B_Additional_250_gms_till_500_gms__c=13;
        objProduct.Zone_C_Additional_250_gms_till_500_gms__c=14;
        ObjProduct.Zone_D_Additional_250_gms_till_500_gms__c=15;
        ObjProduct.Zone_E_Additional_250_gms_till_500_gms__c=17;
        ObjProduct.Zone_A_Additional_500_gm_till_5kg__c=11;
        objProduct.Zone_B_Additional_500_gm_till_5kg__c=12;
        ObjProduct.Zone_C_Additional_500_gm_till_5Kg__c=13;
        ObjProduct.Zone_D_Additional_500_gm_till_5kg__c=14;
        ObjProduct.Zone_E_Additional_500_gm_till_5kg__c=15;
        ObjProduct.Zone_A_Additional_1kg_Above_5kg__c=18;
        ObjProduct.Zone_B_Additional_1kg_Above_5kg__c=22;
        ObjProduct.Zone_C_Additional_1kg_Above_5kg__c=23;
        ObjProduct.Zone_D_Additional_1kg_Above_5kg__c=24;
        ObjProduct.Zone_E_Additional_1kg_Above_5kg__c=25;        
        objProduct.Insurance__c = 10;
        objProduct.Entry_Tax_Service_Charge__c = 10;
        objProduct.Fuel_Surcharge__c = 10;
        objProduct.RoV_Surcharge__c = 10;
        objProduct.RoV_Surcharge_RS_10_000__c = 10;
        objProduct.Max_Dead_weight_package__c = 10;
        objProduct.Zone_A_Upto_500_gms__c = 10;
        objProduct.Zone_B_Upto_500_gms__c = 10;
        objProduct.Zone_C_Upto_500_gms__c=10;
        objProduct.Zone_C_N1_Upto_500_gms__c = 10;
        objProduct.Zone_C_N2_Upto_500_gms__c = 10;
        objProduct.Zone_D_N1_Upto_500_gms__c = 10;
        objProduct.Zone_B_Upto_500_gms__c = 10;
        objProduct.Zone_C_N1_Upto_500_gms__c = 10;
        objProduct.Zone_C_N2_Upto_500_gms__c = 10;
        objProduct.Zone_D_N1_Upto_500_gms__c = 10;
        objProduct.Zone_D_N2_Upto_500_gms__c = 10;
        objProduct.Zone_E_Upto_500_gms__c = 10;
        objProduct.Zone_A_Every_Add_500_gms_upto_3_kgs__c = 10;
        objProduct.Zone_B_Every_Add_500_gms_upto_3_kgs__c = 10;
        objProduct.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c = 10;
        objProduct.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c = 10;
        objProduct.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c = 10;
        objProduct.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c = 10;
        objProduct.Zone_E_Every_additional_500_gms__c = 10;
        objProduct.Zone_A_Every_Additional_Slab_1_Kg__c = 10;
        objProduct.Zone_B_Every_Additional_Slab_1_Kg__c = 10;
        objProduct.Zone_C_N1_Every_Additional_Slab_1_Kg__c = 10;
        objProduct.Zone_C_N2_Every_Additional_Slab_1_Kg__c = 10;
        objProduct.Zone_D_N1_Every_Additional_Slab_1_Kg__c = 10;
        objProduct.Zone_D_N2_Every_Additional_Slab_1_Kg__c = 10;
        objProduct.Zone_E_Every_Additional_Slab_1_Kg__c = 10;
        objProduct.Zone_A_RTO_every_1_kg__c = 10;
        objProduct.Zone_B_RTO_every_1_kg__c = 10;
        objProduct.Zone_C_N1_RTO_every_1_kg__c = 10;
        objProduct.Zone_C_N2_RTO_every_1_kg__c = 10;
        objProduct.Zone_D_N1_RTO_every_1_kg__c = 10;
        objProduct.Zone_D_N2_RTO_every_1_kg__c = 10;
        objProduct.Zone_E_RTO_every_1_kg__c = 10;
        objProduct.Zone_A_DTO_Upto_500gm__c = 10;
        objProduct.Zone_B_DTO_Upto_500gm__c = 10;
        objProduct.Zone_C_N1_DTO_Upto_500gms__c = 10;
        objProduct.Zone_C_N2_DTO_Upto_500gms__c = 10;
        objProduct.Zone_D_N1_DTO_Upto_500gms__c = 10;
        objProduct.Zone_D_N2_DTO_Upto_500gms__c = 10;
        objProduct.Zone_E_DTO_Upto_500gm__c = 10;
        objProduct.Zone_A_DTO_every_add_500gm__c = 10;
        objProduct.Zone_B_DTO_every_add_500gm__c = 10;
        objProduct.Zone_C_N1_DTO_every_add_500gm__c = 10;
        objProduct.Zone_C_N2_DTO_every_add_500gm__c = 10;
        objProduct.Zone_D_N1_DTO_every_add_500gm__c = 10;
        objProduct.Zone_D_N2_DTO_every_add_500gm__c = 10;
        objProduct.Zone_E_DTO_every_add_500gm__c = 10;
        
        return objProduct;
    }
    public static OpportunityLineItem crtOLI(String OpportunityId, String PBEntryId){
        OpportunityLineItem Objoli = new OpportunityLineItem();
        Objoli.OpportunityId = OpportunityId;
        Objoli.Quantity = 5;
        Objoli.PricebookEntryId = PBEntryId;
        Objoli.TotalPrice =50;
        Objoli.MaxDiscount__c = 7;
        objoli.Min_Billable_Weight__c = 5;
        objOLI.Way_Bill_Charge__c = 5;
        objOLI.Insurance__c = 5;
        objOLI.Entry_Tax_Service_Charge__c = 5;
        objOLI.Fuel_Surcharge__c = 5;
        objOLI.RoV_Surcharge__c = 5;
        objOLI.RoV_Surcharge_RS_10_000__c = 5;
        objOLI.Max_Dead_weight_package__c = 5;
        objOLI.Zone_A_Upto_500_gms__c = 5;
        objOLI.Zone_B_Upto_500_gms__c = 5;
        objOLI.Zone_C_Upto_500_gms__c=5;
        objOLI.Zone_C_N1_Upto_500_gms__c = 5;
        objOLI.Zone_C_N2_Upto_500_gms__c = 5;
        objOLI.Zone_D_N1_Upto_500_gms__c = 5;
        objOLI.Zone_B_Upto_500_gms__c = 5;
        objOLI.Zone_C_N1_Upto_500_gms__c = 5;
        objOLI.Zone_C_N2_Upto_500_gms__c = 5;
        objOLI.Zone_D_N1_Upto_500_gms__c = 5;
        objOLI.Zone_D_N2_Upto_500_gms__c = 5;
        objOLI.Zone_E_Upto_500_gms__c = 5;
        objOLI.Zone_A_Every_Add_500_gms_upto_3_kgs__c = 5;
        objOLI.Zone_B_Every_Add_500_gms_upto_3_kgs__c = 5;
        objOLI.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c = 5;
        objOLI.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c = 5;
        objOLI.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c = 5;
        objOLI.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c = 5;
        objOLI.Zone_E_Every_additional_500_gms__c = 5;
        objOLI.Zone_A_Every_Additional_Slab_1_Kg__c = 5;
        objOLI.Zone_B_Every_Additional_Slab_1_Kg__c = 5;
        objOLI.Zone_C_N1_Every_Additional_Slab_1_Kg__c = 5;
        objOLI.Zone_C_N2_Every_Additional_Slab_1_Kg__c = 5;
        objOLI.Zone_D_N1_Every_Additional_Slab_1_Kg__c = 5;
        objOLI.Zone_D_N2_Every_Additional_Slab_1_Kg__c = 5;
        objOLI.Zone_E_Every_Additional_Slab_1_Kg__c = 5;
        objOLI.Zone_A_RTO_every_1_kg__c = 5;
        objOLI.Zone_B_RTO_every_1_kg__c = 5;
        objOLI.Zone_C_N1_RTO_every_1_kg__c = 5;
        objOLI.Zone_C_N2_RTO_every_1_kg__c = 5;
        objOLI.Zone_D_N1_RTO_every_1_kg__c = 5;
        objOLI.Zone_D_N2_RTO_every_1_kg__c = 5;
        objOLI.Zone_E_RTO_every_1_kg__c = 5;
        objOLI.Zone_A_DTO_Upto_500gm__c = 5;
        objOLI.Zone_B_DTO_Upto_500gm__c = 5;
        objOLI.Zone_C_N1_DTO_Upto_500gms__c = 5;
        objOLI.Zone_C_N2_DTO_Upto_500gms__c = 5;
        objOLI.Zone_D_N1_DTO_Upto_500gms__c = 5;
        objOLI.Zone_D_N2_DTO_Upto_500gms__c = 5;
        objOLI.Zone_E_DTO_Upto_500gm__c = 5;
        objOLI.Zone_A_DTO_every_add_500gm__c = 5;
        objOLI.Zone_B_DTO_every_add_500gm__c = 5;
        objOLI.Zone_C_N1_DTO_every_add_500gm__c = 5;
        objOLI.Zone_C_N2_DTO_every_add_500gm__c = 5;
        objOLI.Zone_D_N1_DTO_every_add_500gm__c = 5;
        objOLI.Zone_D_N2_DTO_every_add_500gm__c = 5;
        objOLI.Zone_E_DTO_every_add_500gm__c = 5;
        objOLI.Zone_A_0_250gm__c=10;
        objOLI.Zone_B_0_250gm__c=10;
        objOLI.Zone_C_0_250gm__c=10;
        objOLI.Zone_D_0_250gm__c=10;
        objOLI.Zone_E_0_250gm__c=10;
        objOLI.Zone_A_Additional_250_gms_till_500_gms__c=11;
        objOLI.Zone_B_Additional_250_gms_till_500_gms__c=11;
        objOLI.Zone_C_Additional_250_gms_till_500_gms__c=10;
        objOLI.Zone_D_Additional_250_gms_till_500_gms__c=10;
        objOLI.Zone_E_Additional_250_gms_till_500_gms__c=10;
        objOLI.Zone_A_Additional_500_gm_till_5kg__c=10;
        objOLI.Zone_B_Additional_500_gm_till_5kg__c=10;
        objOLI.Zone_C_Additional_500_gm_till_5Kg__c=10;
        objOLI.Zone_D_Additional_500_gm_till_5kg__c=10;
        objOLI.Zone_E_Additional_500_gm_till_5kg__c=10;
        objOLI.Zone_A_Additional_1kg_Above_5kg__c=10;
        objOLI.Zone_B_Additional_1kg_Above_5kg__c=20;
        objOLI.Zone_C_Additional_1kg_Above_5kg__c=20;
        objOLI.Zone_D_Additional_1kg_Above_5kg__c=20;
        objOLI.Zone_E_Additional_1kg_Above_5kg__c=20; 
        objOLI.Zone_D_Upto_500_gms__c=5;
        objOLI.Zone_A_Every_additional_500_gms__c=5;
        objOLI.Zone_B_Every_additional_500_gms__c=5;
        objOLI.Zone_C_Every_additional_500_gms__c=5;
        objOLI.Zone_D_Every_additional_500_gms__c=5;
        objOLI.Zone_C_RTO_every_500_gms__c=5;
        objOLI.Zone_D_RTO_every_500_gms__c=5;
        objOLI.Zone_B_RTO_every_500_gms__c=5;
        objOLI.Zone_A_RTO_every_500_gms__c=5;
        objOLI.Zone_E_RTO_every_500_gms__c=5;
        objOLI.Zone_C_DTO_Upto_500gm__c=5;
        objOLI.Zone_D_DTO_Upto_500gm__c=5;
        objOLI.Zone_C_DTO_every_add_500gm__c=5;
        objOLI.Zone_D_DTO_every_add_500gm__c=5;
        return Objoli;
    }
        
    
}