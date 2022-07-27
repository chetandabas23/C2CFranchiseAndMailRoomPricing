/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: B2BPricingInlineExtension
* Created Date: 7-June-2017
* Description: Extension for B2BPricingInlineVF that is used to show B2B Pricing in output mode on Opportunity
*******************************************************************/

public class B2BPricingInlineExtension{

    public Opportunity opp{get;set;}
    /*public String oliId{get;set;}
    public List<B2B_Price__c> B2blist{get;set;}
    public PriceBook2 objPB{get;set;}
    public PriceBook2 objPB1{get;set;}
    public PriceBook2 objPB2{get;set;}*/
    public OpportunityLineItem olt{get;set;}
    public OpportunityLineItem objOLI{get;set;}
    public String oppId{get;set;}
    public List<B2B5By5PriceWrapper> B2B5By5PriceWrapperList{get;set;}
    public List<B2B15By15PriceWrapper> B2B15By15PriceWrapperList{get;set;}
    public List<B2B14By14PriceWrapper> B2B14By14PriceWrapperList{get;set;} 
    public List<B2B6By6PriceWrapper> B2B6By6PriceWrapperList{get;set;}
    public List<B2B_Price__c> laneWiseList{get;set;} 
    public Contract__c con{get;set;}   
    public String conid{get;set;} 
    public Contact contact{get;set;}
    public string contactId{get;set;}
    public String AccountRegisteredName{get; set;}
    
    public String msg{get;set;}
    public String successError{get;set;}
    public Boolean hasOLI{get;set;}

    public B2BPricingInlineExtension(ApexPages.StandardController stdController){
        msg = '';
        hasOLI = false;
        successError = '';
        
        // Initialize getter setter variables and retrieve OLI and contract 
        oppId = ApexPages.currentPage().getParameters().get('id');
        opp = new Opportunity();
        conid = ApexPages.currentPage().getParameters().get('ContractId');
        contactId = ApexPages.currentPage().getParameters().get('ContactId');
        List<Opportunity> opportunityList = new List<Opportunity>();
        if(contactId!=null){
            contact = [select id,Name from Contact where id=:contactId];
         }
        if(conid!=null){
            con = [select Status__c,Agreement_Signed_by_User_IP_Address__c,Accepted_Time__c,Contact__r.Email,Type__c,Effective_Date__c from Contract__c where id=:conid];
        }
        if(oppId!=null){
          opportunityList = [select id,Name,Co_Loader__c,HasOpportunityLineItem,Insurance_Required__c, RecordType.Name,RecordType.DeveloperName,Account.Name,Account.Registered_Name__c,(Select Id,Description__c From OpportunityLineItems limit 1) from Opportunity where id=:oppId];
            if(opportunityList.size()>0){
                opp=opportunityList[0];
                AccountRegisteredName =opp.Account.Registered_Name__c;
            }
            if(opp.OpportunityLineItems.size()>0){
                olt = [select id,Maximum_liability_per_consignment__c,Insurance__c,CFT__c,Divisor__c from OpportunityLineItem where OpportunityId=:oppId AND IsActive__c=true limit 1];
            }
                
        }

        objOLI = new OpportunityLineItem();
        B2B5By5PriceWrapperList = new List<B2B5By5PriceWrapper>();
        B2B15By15PriceWrapperList = new List<B2B15By15PriceWrapper>();
        B2B14By14PriceWrapperList = new List<B2B14By14PriceWrapper>();
        B2B6By6PriceWrapperList = new List<B2B6By6PriceWrapper>();
        List<B2B_Price__c> b2bPriceList;
        laneWiseList = new List<B2B_Price__c>();

        if(ApexPages.currentPage().getParameters().get('id') != null){
            oppId = ApexPages.currentPage().getParameters().get('id');
        }

        if(oppId != ''){
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            oliList = [SELECT ID, Name,CFT__c,Divisor__c, FM_Charge__c,LM_Charge__c, Updated_Product_Name__c, Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c, Fuel_Surcharge__c,RoV_Surcharge__c,RoV_Surcharge_RS_10_000__c,Max_Dead_weight_package__c,Discount__c,Status__c,AWB_Charges__c,Minimum_Chargeable_Amount__c,Minimum_Chargeable_Weight__c,Free_Storage_Period__c,DemurrageCharges_Per_awb_per_consignment__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_Rs__c,ODA_Per_MAwb__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Per_Kg__c,Mall_Deliveries_Per_Mawb__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Liability_per_consignment__c,Description__c, Intra_City__c, Average_Diesel_Price__c, Diesel_Tolerance_Value__c FROM OpportunityLineItem WHERE OpportunityId =: oppId AND IsActive__c = true];
            if(oliList.size()>0){
                objOLI = oliList[0];
                b2bPriceList = [SELECT ID, Name, Source__c , Destination__c, Amount__c FROM B2B_Price__c WHERE Opportunity_Line_Item_Id__c =: oliList[0].Id];
            }
        }
        
        //Display Matrix based on Product Name 
        if(objOLI != null){
            if(objOLI.Updated_Product_Name__c == 'B2B 5*5'){
                Set<String> sourceSet = new Set<String>();                
                sourceSet.add('North');
                sourceSet.add('West');
                sourceSet.add('South');
                sourceSet.add('East');
                sourceSet.add('North East');
                List<B2B_Price__c> B2BPriceTempList;
                for(String sourceString : sourceSet){
                    B2BPriceTempList = new List<B2B_Price__c>();
                    for(B2B_Price__c objB2BPrice : b2bPriceList){
                        if(objB2BPrice.Source__c == sourceString){
                            B2BPriceTempList.add(objB2BPrice);                            
                        }
                    }
                    B2B5By5PriceWrapperList.add(new B2B5By5PriceWrapper(sourceString, B2BPriceTempList));
                }                
            }else if(objOLI.Updated_Product_Name__c == 'B2B 6*6'){
                Set<String> sourceSet = new Set<String>();                
                sourceSet.add('North');
                sourceSet.add('West');
                sourceSet.add('South');
                sourceSet.add('Kerala');
                sourceSet.add('East');
                sourceSet.add('North East');
                List<B2B_Price__c> B2BPriceTempList;
                for(String sourceString : sourceSet){
                    B2BPriceTempList = new List<B2B_Price__c>();
                    for(B2B_Price__c objB2BPrice : b2bPriceList){
                        if(objB2BPrice.Source__c == sourceString){
                            B2BPriceTempList.add(objB2BPrice);                            
                        }
                    }
                    B2B6By6PriceWrapperList.add(new B2B6By6PriceWrapper(sourceString, B2BPriceTempList));
                }                
            }
            else if(objOLI.Updated_Product_Name__c == 'B2B 15*15'){
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

                List<B2B_Price__c> B2BPriceTempList;
                for(String sourceString : sourceSet){
                    B2BPriceTempList = new List<B2B_Price__c>();
                    for(B2B_Price__c objB2BPrice : b2bPriceList){
                        if(objB2BPrice.Source__c == sourceString){
                            B2BPriceTempList.add(objB2BPrice);
                        }
                    }
                    B2B15By15PriceWrapperList.add(new B2B15By15PriceWrapper(sourceString, B2BPriceTempList));
                }
            }
            else if(objOLI.Updated_Product_Name__c == 'B2B 14*14'){
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

                List<B2B_Price__c> B2BPriceTempList;
                for(String sourceString : sourceSet){
                    B2BPriceTempList = new List<B2B_Price__c>();
                    for(B2B_Price__c objB2BPrice : b2bPriceList){
                        if(objB2BPrice.Source__c == sourceString){
                            B2BPriceTempList.add(objB2BPrice);
                        }
                    }
                    B2B14By14PriceWrapperList.add(new B2B14By14PriceWrapper(sourceString, B2BPriceTempList));
                }
            }
            else if(objOLI.Updated_Product_Name__c == 'B2B Lanewise'){
                laneWiseList = b2bPriceList;
            }
        }
   
    }
    
    // To display Addendum and Contracts in Print Layout  
         public String getPrintView()
        {
            return
            '<!--[if gte mso 9]>' +
                '<xml>' +
                '<w:WordDocument>' +
                '<w:View>Print</w:View>' +
                '<w:Zoom>100</w:Zoom>' +
                '<w:DoNotOptimizeForBrowser/>' +
                '</w:WordDocument>' +
                '</xml>' +
                '<![endif]>';
        }
    
    public PageReference downloadContractAgreement(){
        PageReference pageRef;
        if(opp.HasOpportunityLineItem){ 
            if(opp.Insurance_Required__c){ 
                return null;
            } 
            else{
                pageRef = new PageReference('/apex/B2BNoInsurancePage?id='+opp.Id);
                return pageRef;
            }
        } 
        else{
            hasOLI = true; 
            successError = 'warning';
            msg ='No pricing is available to download a Agreement.';
            return null; 
        }
    }
    
    public PageReference downloadAddendum(){
        PageReference pageRef;
        System.debug('opp.HasOpportunityLineItem>>>>'+opp.HasOpportunityLineItem);
        if(opp.HasOpportunityLineItem){ 
            if(opp.Name.Contains('B2B')){ 
                System.debug('opp.HasOpportunityLineItem>>>>'+opp.Name);
                return null;
            } 
            else if(opp.RecordType.Name.Contains('C2C')){ 
                System.debug('opp.HasOpportunityLineItem>>>>'+opp.Name);
                pageRef = new PageReference('/apex/C2COpportunityAddendumPage?id='+opp.Id);
                return pageRef;
            }   
            else{ 
                System.debug('opp.HasOpportunityLineItem>>>>'+opp.Name);
                pageRef = new PageReference('/apex/OpportunityAddendumPage?id='+opp.Id);
                return pageRef;
            }           
        } 
        else{
            System.debug('opp.HasOpportunityLineItem>>>>'+opp.Name);
            hasOLI = true; 
            successError = 'warning';
            msg ='No pricing is available to send a Addendum.';
            return null;
        }
    }
    
    public PageReference generatePricingPDFB2B(){
        if(opp.HasOpportunityLineItem){ 
            //window.open('/apex/GeneratePricingPDFB2B?id={!Opportunity.Id}','_blank'); 
            return null;
        } 
        else{ 
            //alert('No pricing is available to generate a Pricing PDF.'); 
            hasOLI = true; 
            successError = 'warning';
            msg ='No pricing is available to generate a Pricing PDF.';
            return null;
        }   
    }
    
}