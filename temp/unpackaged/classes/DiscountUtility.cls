/*****************************************************************
    * Author: Techila Global Services Pvt Ltd.
    * Class Name: DiscountUtility
    * Created Date: 15-June-2017
    * Description:  Utility class for Discount
    *******************************************************************/
    global class DiscountUtility{
    
    public Product2 objProduct;
    public OpportunityLineItem objOLI;
    public Decimal maxDiscount;

    // Method to get maximum discount from several field discount in each recordtype
    global Decimal findMaxDiscount(String oliId){
        
        objOLI = new OpportunityLineItem();        
        List<B2B_Price__c> oliB2BPriceList ;
        Map<String, Map<String, Decimal>> productB2BPriceMap;        
        maxDiscount = 0.0;
        DescribeSObjectResult describeResult = OpportunityLineItem.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        String query = ' SELECT ' + String.join( fieldNames, ',' ) + ' FROM ' + describeResult.getName() + '  WHERE Id = '+'\''+oliId+'\'';    
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList = Database.query(query);
        if(oliList.size()>0){
            objOLI = oliList[0];
        }
        if(objOLI.Updated_Product_Name__c != null){
            List<Product2> productList = new List<Product2>();
            DescribeSObjectResult describeResult1 = Product2.getSObjectType().getDescribe();
            List<String> fieldNames1 = new List<String>(describeResult1.fields.getMap().keySet());
            String q = ' SELECT ' + String.join( fieldNames1, ',' ) + ' FROM ' + describeResult1.getName() + ' WHERE Name =  '+'\''+objOLI.Updated_Product_Name__c+'\'';
            objProduct = new Product2();    
            productList = Database.query(q);    
            if(productList.size()>0){
                objProduct = productList[0];
            }
        }
        String oliString = oliId;
        if(oliString.length()<=15){
            oliString += '%';
        }            
        oliB2BPriceList = [SELECT ID, Name, Opportunity_Line_Item_Id__c, Source__c , Destination__c, Amount__c FROM B2B_Price__c WHERE Opportunity_Line_Item_Id__c  like: oliString];               
        
        if(objOLI.Updated_Product_Name__c == 'B2B 5*5'){    
            productB2BPriceMap = new Map<String, Map<String, Decimal>>();
            Set<String> sourceSet = new Set<String>();                
            sourceSet.add('North');
            sourceSet.add('West');
            sourceSet.add('South');
            sourceSet.add('East');
            sourceSet.add('North East');
            String productId;
            if(objProduct != null){
                productId = objProduct.Id;
            }
            List<B2B_Price__c> prodcutB2BPriceList = new List<B2B_Price__c>();
            prodcutB2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];            
            Map<String, Decimal> b2bPriceTempMap;
            
            for(String sourceString : sourceSet){
                b2bPriceTempMap = new Map<String, Decimal>();
                for(B2B_Price__c objB2BPrice : prodcutB2BPriceList){
                    if(objB2BPrice.Source__c == sourceString){
                        b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice.Amount__c);
                    }
                }
                productB2BPriceMap.put(sourceString, b2bPriceTempMap);
            }
            for(B2B_Price__c objB2BPrice : oliB2BPriceList){
                Decimal amount = productB2BPriceMap.get(objB2BPrice.Source__c).get(objB2BPrice.Destination__c);
                if(amount > objB2BPrice.Amount__c){
                    Decimal discountPercentage = ((amount - objB2BPrice.Amount__c)/amount)*100;
                    if(discountPercentage > maxDiscount){
                        maxDiscount = discountPercentage;
                    }
                }
            }
            //checkOtherFieldDiscount();                                                                                          
        }
        else if(objOLI.Updated_Product_Name__c == 'B2B 6*6'){    
            productB2BPriceMap = new Map<String, Map<String, Decimal>>();
            Set<String> sourceSet = new Set<String>();                
            sourceSet.add('North');
            sourceSet.add('West');
            sourceSet.add('South');
            sourceSet.add('Kerala');
            sourceSet.add('East');
            sourceSet.add('North East');
            String productId;
            if(objProduct != null){
                productId = objProduct.Id;
            }
            List<B2B_Price__c> prodcutB2BPriceList = new List<B2B_Price__c>();
            prodcutB2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];            
            Map<String, Decimal> b2bPriceTempMap;
            
            for(String sourceString : sourceSet){
                b2bPriceTempMap = new Map<String, Decimal>();
                for(B2B_Price__c objB2BPrice : prodcutB2BPriceList){
                    if(objB2BPrice.Source__c == sourceString){
                        b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice.Amount__c);
                    }
                }
                productB2BPriceMap.put(sourceString, b2bPriceTempMap);
            }
            for(B2B_Price__c objB2BPrice : oliB2BPriceList){
                Decimal amount = productB2BPriceMap.get(objB2BPrice.Source__c).get(objB2BPrice.Destination__c);
                if(amount > objB2BPrice.Amount__c){
                    Decimal discountPercentage = ((amount - objB2BPrice.Amount__c)/amount)*100;
                    if(discountPercentage > maxDiscount){
                        maxDiscount = discountPercentage;
                    }
                }
            }
            //checkOtherFieldDiscount();                                                                                          
        }
        else if(objOLI.Updated_Product_Name__c == 'B2B 14*14'){
            productB2BPriceMap = new Map<String, Map<String, Decimal>>();
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
            
            String productId;
            if(objProduct != null){
                productId = objProduct.Id;
            }
            List<B2B_Price__c> prodcutB2BPriceList = new List<B2B_Price__c>();
            prodcutB2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];            
            Map<String, Decimal> b2bPriceTempMap;
            
            for(String sourceString : sourceSet){
                b2bPriceTempMap = new Map<String, Decimal>();
                for(B2B_Price__c objB2BPrice : prodcutB2BPriceList){
                    if(objB2BPrice.Source__c == sourceString){
                        b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice.Amount__c);
                    }
                }
                productB2BPriceMap.put(sourceString, b2bPriceTempMap);
            }
            for(B2B_Price__c objB2BPrice : oliB2BPriceList){
                Decimal amount = productB2BPriceMap.get(objB2BPrice.Source__c).get(objB2BPrice.Destination__c);
                if(amount > objB2BPrice.Amount__c){
                    Decimal discountPercentage = ((amount - objB2BPrice.Amount__c)/amount)*100;
                    if(discountPercentage > maxDiscount){
                        maxDiscount = discountPercentage;
                    }
                }
            }   
            //checkOtherFieldDiscount();          
        }
        else if(objOLI.Updated_Product_Name__c == 'B2B 15*15'){
            productB2BPriceMap = new Map<String, Map<String, Decimal>>();
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
            
            String productId;
            if(objProduct != null){
                productId = objProduct.Id;
            }
            List<B2B_Price__c> prodcutB2BPriceList = new List<B2B_Price__c>();
            prodcutB2BPriceList = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c WHERE Product__c =: productId];            
            Map<String, Decimal> b2bPriceTempMap;
            
            for(String sourceString : sourceSet){
                b2bPriceTempMap = new Map<String, Decimal>();
                for(B2B_Price__c objB2BPrice : prodcutB2BPriceList){
                    if(objB2BPrice.Source__c == sourceString){
                        b2bPriceTempMap.put(objB2BPrice.Destination__c, objB2BPrice.Amount__c);
                    }
                }
                productB2BPriceMap.put(sourceString, b2bPriceTempMap);
            }
            for(B2B_Price__c objB2BPrice : oliB2BPriceList){
                Decimal amount = productB2BPriceMap.get(objB2BPrice.Source__c).get(objB2BPrice.Destination__c);
                if(amount > objB2BPrice.Amount__c){
                    Decimal discountPercentage = ((amount - objB2BPrice.Amount__c)/amount)*100;
                    if(discountPercentage > maxDiscount){
                        maxDiscount = discountPercentage;
                    }
                }
            }   
            //checkOtherFieldDiscount();          
        }
        else if(objOLI.Updated_Product_Name__c == 'Express Shipping'){
            Decimal per;
            if(objProduct.Zone_A_Upto_500_gms__c > objOLI.Zone_A_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_A_Upto_500_gms__c, objOLI.Zone_A_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Upto_500_gms__c > objOLI.Zone_B_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_B_Upto_500_gms__c, objOLI.Zone_B_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Upto_500_gms__c > objOLI.Zone_C_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_C_Upto_500_gms__c, objOLI.Zone_C_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Upto_500_gms__c > objOLI.Zone_D_Upto_500_gms__c    ){
                per = calculatePercentage(objProduct.Zone_D_Upto_500_gms__c , objOLI.Zone_D_Upto_500_gms__c );
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Upto_500_gms__c > objOLI.Zone_E_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_E_Upto_500_gms__c, objOLI.Zone_E_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_Every_additional_500_gms__c > objOLI.Zone_A_Every_additional_500_gms__c){
                per = calculatePercentage(objProduct.Zone_A_Every_additional_500_gms__c, objOLI.Zone_A_Every_additional_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Every_additional_500_gms__c > objOLI.Zone_B_Every_additional_500_gms__c){
                per = calculatePercentage(objProduct.Zone_B_Every_additional_500_gms__c, objOLI.Zone_B_Every_additional_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Every_additional_500_gms__c > objOLI.Zone_C_Every_additional_500_gms__c){
                per = calculatePercentage(objProduct.Zone_C_Every_additional_500_gms__c, objOLI.Zone_C_Every_additional_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Every_additional_500_gms__c > objOLI.Zone_D_Every_additional_500_gms__c){
                per = calculatePercentage(objProduct.Zone_D_Every_additional_500_gms__c, objOLI.Zone_D_Every_additional_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Every_additional_500_gms__c > objOLI.Zone_E_Every_additional_500_gms__c){
                per = calculatePercentage(objProduct.Zone_E_Every_additional_500_gms__c, objOLI.Zone_E_Every_additional_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_RTO_every_500_gms__c > objOLI.Zone_A_RTO_every_500_gms__c){
                per = calculatePercentage(objProduct.Zone_A_RTO_every_500_gms__c, objOLI.Zone_A_RTO_every_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_RTO_every_500_gms__c > objOLI.Zone_B_RTO_every_500_gms__c){
                per = calculatePercentage(objProduct.Zone_B_RTO_every_500_gms__c, objOLI.Zone_B_RTO_every_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_RTO_every_500_gms__c > objOLI.Zone_C_RTO_every_500_gms__c){
                per = calculatePercentage(objProduct.Zone_C_RTO_every_500_gms__c, objOLI.Zone_C_RTO_every_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_RTO_every_500_gms__c > objOLI.Zone_D_RTO_every_500_gms__c){
                per = calculatePercentage(objProduct.Zone_D_RTO_every_500_gms__c, objOLI.Zone_D_RTO_every_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_RTO_every_500_gms__c > objOLI.Zone_E_RTO_every_500_gms__c){
                per = calculatePercentage(objProduct.Zone_E_RTO_every_500_gms__c, objOLI.Zone_E_RTO_every_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_DTO_Upto_500gm__c > objOLI.Zone_A_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_A_DTO_Upto_500gm__c, objOLI.Zone_A_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_DTO_Upto_500gm__c > objOLI.Zone_B_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_B_DTO_Upto_500gm__c, objOLI.Zone_B_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_DTO_Upto_500gm__c > objOLI.Zone_C_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_C_DTO_Upto_500gm__c, objOLI.Zone_C_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_DTO_Upto_500gm__c > objOLI.Zone_D_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_D_DTO_Upto_500gm__c, objOLI.Zone_D_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_DTO_Upto_500gm__c > objOLI.Zone_E_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_E_DTO_Upto_500gm__c, objOLI.Zone_E_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_DTO_every_add_500gm__c > objOLI.Zone_A_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_A_DTO_every_add_500gm__c, objOLI.Zone_A_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_DTO_every_add_500gm__c > objOLI.Zone_B_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_B_DTO_every_add_500gm__c, objOLI.Zone_B_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_DTO_every_add_500gm__c > objOLI.Zone_C_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_C_DTO_every_add_500gm__c, objOLI.Zone_C_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_DTO_every_add_500gm__c > objOLI.Zone_D_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_D_DTO_every_add_500gm__c, objOLI.Zone_D_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_DTO_every_add_500gm__c > objOLI.Zone_E_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_E_DTO_every_add_500gm__c, objOLI.Zone_E_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            System.debug('maxDiscount----------->'+maxDiscount);
        }
        else if(objOLI.Updated_Product_Name__c == 'Standard Shipping'){
            Decimal per;
            if(objProduct.Zone_A_Upto_500_gms__c > objOLI.Zone_A_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_A_Upto_500_gms__c, objOLI.Zone_A_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Upto_500_gms__c > objOLI.Zone_B_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_B_Upto_500_gms__c, objOLI.Zone_B_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N1_Upto_500_gms__c > objOLI.Zone_C_N1_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_C_N1_Upto_500_gms__c, objOLI.Zone_C_N1_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N2_Upto_500_gms__c > objOLI.Zone_C_N2_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_C_N2_Upto_500_gms__c, objOLI.Zone_C_N2_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_D_N1_Upto_500_gms__c > objOLI.Zone_D_N1_Upto_500_gms__c  ){
                per = calculatePercentage(objProduct.Zone_D_N1_Upto_500_gms__c, objOLI.Zone_D_N1_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_N2_Upto_500_gms__c > objOLI.Zone_D_N2_Upto_500_gms__c  ){
                per = calculatePercentage(objProduct.Zone_D_N2_Upto_500_gms__c, objOLI.Zone_D_N2_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_E_Upto_500_gms__c > objOLI.Zone_E_Upto_500_gms__c){
                per = calculatePercentage(objProduct.Zone_E_Upto_500_gms__c, objOLI.Zone_E_Upto_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            } 

            if(objProduct.Zone_A_Every_Add_500_gms_upto_3_kgs__c > objOLI.Zone_A_Every_Add_500_gms_upto_3_kgs__c){
                per = calculatePercentage(objProduct.Zone_A_Every_Add_500_gms_upto_3_kgs__c, objOLI.Zone_A_Every_Add_500_gms_upto_3_kgs__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Every_Add_500_gms_upto_3_kgs__c > objOLI.Zone_B_Every_Add_500_gms_upto_3_kgs__c){
                per = calculatePercentage(objProduct.Zone_B_Every_Add_500_gms_upto_3_kgs__c, objOLI.Zone_B_Every_Add_500_gms_upto_3_kgs__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c > objOLI.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c){
                per = calculatePercentage(objProduct.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c, objOLI.Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c > objOLI.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c){
                per = calculatePercentage(objProduct.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c, objOLI.Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c > objOLI.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c){
                per = calculatePercentage(objProduct.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c, objOLI.Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c > objOLI.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c){
                per = calculatePercentage(objProduct.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c, objOLI.Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_E_Every_additional_500_gms__c > objOLI.Zone_E_Every_additional_500_gms__c){
                per = calculatePercentage(objProduct.Zone_E_Every_additional_500_gms__c, objOLI.Zone_E_Every_additional_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_Every_Additional_Slab_1_Kg__c > objOLI.Zone_A_Every_Additional_Slab_1_Kg__c){
                per = calculatePercentage(objProduct.Zone_A_Every_Additional_Slab_1_Kg__c, objOLI.Zone_A_Every_Additional_Slab_1_Kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Every_Additional_Slab_1_Kg__c > objOLI.Zone_B_Every_Additional_Slab_1_Kg__c){
                per = calculatePercentage(objProduct.Zone_B_Every_Additional_Slab_1_Kg__c, objOLI.Zone_B_Every_Additional_Slab_1_Kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N1_Every_Additional_Slab_1_Kg__c > objOLI.Zone_C_N1_Every_Additional_Slab_1_Kg__c){
                per = calculatePercentage(objProduct.Zone_C_N1_Every_Additional_Slab_1_Kg__c, objOLI.Zone_C_N1_Every_Additional_Slab_1_Kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N2_Every_Additional_Slab_1_Kg__c > objOLI.Zone_C_N2_Every_Additional_Slab_1_Kg__c){
                per = calculatePercentage(objProduct.Zone_C_N2_Every_Additional_Slab_1_Kg__c, objOLI.Zone_C_N2_Every_Additional_Slab_1_Kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_D_N1_Every_Additional_Slab_1_Kg__c > objOLI.Zone_D_N1_Every_Additional_Slab_1_Kg__c){
                per = calculatePercentage(objProduct.Zone_D_N1_Every_Additional_Slab_1_Kg__c, objOLI.Zone_D_N1_Every_Additional_Slab_1_Kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_N2_Every_Additional_Slab_1_Kg__c > objOLI.Zone_D_N2_Every_Additional_Slab_1_Kg__c){
                per = calculatePercentage(objProduct.Zone_D_N2_Every_Additional_Slab_1_Kg__c, objOLI.Zone_D_N2_Every_Additional_Slab_1_Kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_E_Every_Additional_Slab_1_Kg__c > objOLI.Zone_E_Every_Additional_Slab_1_Kg__c){
                per = calculatePercentage(objProduct.Zone_E_Every_Additional_Slab_1_Kg__c, objOLI.Zone_E_Every_Additional_Slab_1_Kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }  
            
            if(objProduct.Zone_A_RTO_every_1_kg__c > objOLI.Zone_A_RTO_every_1_kg__c){
                per = calculatePercentage(objProduct.Zone_A_RTO_every_1_kg__c, objOLI.Zone_A_RTO_every_1_kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_RTO_every_1_kg__c > objOLI.Zone_B_RTO_every_1_kg__c){
                per = calculatePercentage(objProduct.Zone_B_RTO_every_1_kg__c, objOLI.Zone_B_RTO_every_1_kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N1_RTO_every_1_kg__c > objOLI.Zone_C_N1_RTO_every_1_kg__c){
                per = calculatePercentage(objProduct.Zone_C_N1_RTO_every_1_kg__c, objOLI.Zone_C_N1_RTO_every_1_kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N2_RTO_every_1_kg__c > objOLI.Zone_C_N2_RTO_every_1_kg__c){
                per = calculatePercentage(objProduct.Zone_C_N2_RTO_every_1_kg__c, objOLI.Zone_C_N2_RTO_every_1_kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_D_N1_RTO_every_1_kg__c > objOLI.Zone_D_N1_RTO_every_1_kg__c){
                per = calculatePercentage(objProduct.Zone_D_N1_RTO_every_1_kg__c, objOLI.Zone_D_N1_RTO_every_1_kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_N2_RTO_every_1_kg__c > objOLI.Zone_D_N2_RTO_every_1_kg__c){
                per = calculatePercentage(objProduct.Zone_D_N2_RTO_every_1_kg__c, objOLI.Zone_D_N2_RTO_every_1_kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_E_RTO_every_1_kg__c > objOLI.Zone_E_RTO_every_1_kg__c){
                per = calculatePercentage(objProduct.Zone_E_RTO_every_1_kg__c, objOLI.Zone_E_RTO_every_1_kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            } 

            if(objProduct.Zone_A_DTO_Upto_500gm__c > objOLI.Zone_A_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_A_DTO_Upto_500gm__c, objOLI.Zone_A_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_DTO_Upto_500gm__c > objOLI.Zone_B_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_B_DTO_Upto_500gm__c, objOLI.Zone_B_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N1_DTO_Upto_500gms__c > objOLI.Zone_C_N1_DTO_Upto_500gms__c){
                per = calculatePercentage(objProduct.Zone_C_N1_DTO_Upto_500gms__c, objOLI.Zone_C_N1_DTO_Upto_500gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N2_DTO_Upto_500gms__c > objOLI.Zone_C_N2_DTO_Upto_500gms__c){
                per = calculatePercentage(objProduct.Zone_C_N2_DTO_Upto_500gms__c, objOLI.Zone_C_N2_DTO_Upto_500gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_D_N1_DTO_Upto_500gms__c > objOLI.Zone_D_N1_DTO_Upto_500gms__c){
                per = calculatePercentage(objProduct.Zone_D_N1_DTO_Upto_500gms__c, objOLI.Zone_D_N1_DTO_Upto_500gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_N2_DTO_Upto_500gms__c > objOLI.Zone_D_N2_DTO_Upto_500gms__c){
                per = calculatePercentage(objProduct.Zone_D_N2_DTO_Upto_500gms__c, objOLI.Zone_D_N2_DTO_Upto_500gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_E_DTO_Upto_500gm__c > objOLI.Zone_E_DTO_Upto_500gm__c){
                per = calculatePercentage(objProduct.Zone_E_DTO_Upto_500gm__c, objOLI.Zone_E_DTO_Upto_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            } 

            if(objProduct.Zone_A_DTO_every_add_500gm__c > objOLI.Zone_A_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_A_DTO_every_add_500gm__c, objOLI.Zone_A_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_DTO_every_add_500gm__c > objOLI.Zone_B_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_B_DTO_every_add_500gm__c, objOLI.Zone_B_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N1_DTO_every_add_500gm__c > objOLI.Zone_C_N1_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_C_N1_DTO_every_add_500gm__c, objOLI.Zone_C_N1_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_N2_DTO_every_add_500gm__c > objOLI.Zone_C_N2_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_C_N2_DTO_every_add_500gm__c, objOLI.Zone_C_N2_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_D_N1_DTO_every_add_500gm__c > objOLI.Zone_D_N1_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_D_N1_DTO_every_add_500gm__c, objOLI.Zone_D_N1_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_N2_DTO_every_add_500gm__c > objOLI.Zone_D_N2_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_D_N2_DTO_every_add_500gm__c, objOLI.Zone_D_N2_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }            
            if(objProduct.Zone_E_DTO_every_add_500gm__c > objOLI.Zone_E_DTO_every_add_500gm__c){
                per = calculatePercentage(objProduct.Zone_E_DTO_every_add_500gm__c, objOLI.Zone_E_DTO_every_add_500gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            } 
        }
         else if(objOLI.Updated_Product_Name__c == 'Delhivery Commercial Express - C2C' || objOLI.Updated_Product_Name__c == 'Delhivery Commercial Standard - C2C'){
            Decimal per;
            if(objProduct.Zone_A_0_250gm__c > objOLI.Zone_A_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_A_0_250gm__c, objOLI.Zone_A_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_0_250gm__c > objOLI.Zone_B_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_B_0_250gm__c, objOLI.Zone_B_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_0_250gm__c > objOLI.Zone_C_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_C_0_250gm__c, objOLI.Zone_C_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_0_250gm__c > objOLI.Zone_D_0_250gm__c    ){
                per = calculatePercentage(objProduct.Zone_D_0_250gm__c , objOLI.Zone_D_0_250gm__c );
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_0_250gm__c > objOLI.Zone_E_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_E_0_250gm__c, objOLI.Zone_E_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_Additional_250_gms_till_500_gms__c > objOLI.Zone_A_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_A_Additional_250_gms_till_500_gms__c, objOLI.Zone_A_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Additional_250_gms_till_500_gms__c > objOLI.Zone_B_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_B_Additional_250_gms_till_500_gms__c, objOLI.Zone_B_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Additional_250_gms_till_500_gms__c > objOLI.Zone_C_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_C_Additional_250_gms_till_500_gms__c, objOLI.Zone_C_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Additional_250_gms_till_500_gms__c > objOLI.Zone_D_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_D_Additional_250_gms_till_500_gms__c, objOLI.Zone_D_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Additional_250_gms_till_500_gms__c > objOLI.Zone_E_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_E_Additional_250_gms_till_500_gms__c, objOLI.Zone_E_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_Additional_500_gm_till_5kg__c > objOLI.Zone_A_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_A_Additional_500_gm_till_5kg__c, objOLI.Zone_A_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Additional_500_gm_till_5kg__c > objOLI.Zone_B_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_B_Additional_500_gm_till_5kg__c, objOLI.Zone_B_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Additional_500_gm_till_5kg__c > objOLI.Zone_C_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_C_Additional_500_gm_till_5kg__c, objOLI.Zone_C_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Additional_500_gm_till_5kg__c > objOLI.Zone_D_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_D_Additional_500_gm_till_5kg__c, objOLI.Zone_D_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Additional_500_gm_till_5kg__c > objOLI.Zone_E_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_E_Additional_500_gm_till_5kg__c, objOLI.Zone_E_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
             
            if(objProduct.Zone_A_Additional_1kg_Above_5kg__c > objOLI.Zone_A_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_A_Additional_1kg_Above_5kg__c, objOLI.Zone_A_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Additional_1kg_Above_5kg__c > objOLI.Zone_B_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_B_Additional_1kg_Above_5kg__c, objOLI.Zone_B_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Additional_1kg_Above_5kg__c > objOLI.Zone_C_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_C_Additional_1kg_Above_5kg__c, objOLI.Zone_C_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Additional_1kg_Above_5kg__c > objOLI.Zone_D_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_D_Additional_1kg_Above_5kg__c, objOLI.Zone_D_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Additional_1kg_Above_5kg__c > objOLI.Zone_E_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_E_Additional_1kg_Above_5kg__c, objOLI.Zone_E_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

             System.debug('maxDiscount----------->'+maxDiscount);
        }
      	 else if(objOLI.Updated_Product_Name__c == 'Delhivery Commercial Express - C2C MailRoom' || objOLI.Updated_Product_Name__c == 'Delhivery Commercial Standard - C2C MailRoom'){
            Decimal per;
            if(objProduct.Zone_A_0_250gm__c > objOLI.Zone_A_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_A_0_250gm__c, objOLI.Zone_A_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_0_250gm__c > objOLI.Zone_B_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_B_0_250gm__c, objOLI.Zone_B_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_0_250gm__c > objOLI.Zone_C_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_C_0_250gm__c, objOLI.Zone_C_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_0_250gm__c > objOLI.Zone_D_0_250gm__c    ){
                per = calculatePercentage(objProduct.Zone_D_0_250gm__c , objOLI.Zone_D_0_250gm__c );
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_0_250gm__c > objOLI.Zone_E_0_250gm__c){
                per = calculatePercentage(objProduct.Zone_E_0_250gm__c, objOLI.Zone_E_0_250gm__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_Additional_250_gms_till_500_gms__c > objOLI.Zone_A_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_A_Additional_250_gms_till_500_gms__c, objOLI.Zone_A_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Additional_250_gms_till_500_gms__c > objOLI.Zone_B_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_B_Additional_250_gms_till_500_gms__c, objOLI.Zone_B_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Additional_250_gms_till_500_gms__c > objOLI.Zone_C_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_C_Additional_250_gms_till_500_gms__c, objOLI.Zone_C_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Additional_250_gms_till_500_gms__c > objOLI.Zone_D_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_D_Additional_250_gms_till_500_gms__c, objOLI.Zone_D_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Additional_250_gms_till_500_gms__c > objOLI.Zone_E_Additional_250_gms_till_500_gms__c){
                per = calculatePercentage(objProduct.Zone_E_Additional_250_gms_till_500_gms__c, objOLI.Zone_E_Additional_250_gms_till_500_gms__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

            if(objProduct.Zone_A_Additional_500_gm_till_5kg__c > objOLI.Zone_A_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_A_Additional_500_gm_till_5kg__c, objOLI.Zone_A_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Additional_500_gm_till_5kg__c > objOLI.Zone_B_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_B_Additional_500_gm_till_5kg__c, objOLI.Zone_B_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Additional_500_gm_till_5kg__c > objOLI.Zone_C_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_C_Additional_500_gm_till_5kg__c, objOLI.Zone_C_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Additional_500_gm_till_5kg__c > objOLI.Zone_D_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_D_Additional_500_gm_till_5kg__c, objOLI.Zone_D_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Additional_500_gm_till_5kg__c > objOLI.Zone_E_Additional_500_gm_till_5kg__c){
                per = calculatePercentage(objProduct.Zone_E_Additional_500_gm_till_5kg__c, objOLI.Zone_E_Additional_500_gm_till_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
                          
            if(objProduct.Zone_A_Additional_1kg_Above_5kg__c > objOLI.Zone_A_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_A_Additional_1kg_Above_5kg__c, objOLI.Zone_A_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_B_Additional_1kg_Above_5kg__c > objOLI.Zone_B_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_B_Additional_1kg_Above_5kg__c, objOLI.Zone_B_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_C_Additional_1kg_Above_5kg__c > objOLI.Zone_C_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_C_Additional_1kg_Above_5kg__c, objOLI.Zone_C_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_D_Additional_1kg_Above_5kg__c > objOLI.Zone_D_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_D_Additional_1kg_Above_5kg__c, objOLI.Zone_D_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }
            if(objProduct.Zone_E_Additional_1kg_Above_5kg__c > objOLI.Zone_E_Additional_1kg_Above_5kg__c){
                per = calculatePercentage(objProduct.Zone_E_Additional_1kg_Above_5kg__c, objOLI.Zone_E_Additional_1kg_Above_5kg__c);
                if(per > maxDiscount){
                    maxDiscount = per;
                }
            }

             System.debug('maxDiscount----------->'+maxDiscount);
        }
       
        return maxDiscount.setScale(3);                     
    }
    
    //  Return Discount in percentage
    public Decimal calculatePercentage(Decimal a1, Decimal a2){
        return ((a1 - a2)/a1)*100;
    }

    public void checkOtherFieldDiscount(){
        Decimal per;
        if(objProduct.Min_Billable_Weight__c > objOLI.Min_Billable_Weight__c){
            per = calculatePercentage(objProduct.Min_Billable_Weight__c, objOLI.Min_Billable_Weight__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }   

        if(objProduct.Way_Bill_Charge__c > objOLI.Way_Bill_Charge__c){
            per = calculatePercentage(objProduct.Way_Bill_Charge__c, objOLI.Way_Bill_Charge__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }   

        if(objProduct.Insurance__c > objOLI.Insurance__c){
            per = calculatePercentage(objProduct.Insurance__c, objOLI.Insurance__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }   

        if(objProduct.Entry_Tax_Service_Charge__c > objOLI.Entry_Tax_Service_Charge__c){
            per = calculatePercentage(objProduct.Entry_Tax_Service_Charge__c, objOLI.Entry_Tax_Service_Charge__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }   

        if(objProduct.Fuel_Surcharge__c > objOLI.Fuel_Surcharge__c){
            per = calculatePercentage(objProduct.Fuel_Surcharge__c, objOLI.Fuel_Surcharge__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }   

        if(objProduct.RoV_Surcharge__c > objOLI.RoV_Surcharge__c){
            per = calculatePercentage(objProduct.RoV_Surcharge__c, objOLI.RoV_Surcharge__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }   

        if(objProduct.RoV_Surcharge_RS_10_000__c > objOLI.RoV_Surcharge_RS_10_000__c){
            per = calculatePercentage(objProduct.RoV_Surcharge_RS_10_000__c, objOLI.RoV_Surcharge_RS_10_000__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }   

        if(objProduct.Max_Dead_weight_package__c > objOLI.Max_Dead_weight_package__c){
            per = calculatePercentage(objProduct.Max_Dead_weight_package__c, objOLI.Max_Dead_weight_package__c);
            if(per > maxDiscount){
                maxDiscount = per;
            }
        }           
    }
}