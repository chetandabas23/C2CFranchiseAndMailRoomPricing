/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: B2B5By5PriceWrapper
* Created Date: 13-June-2017
* Description: Wrapper class for B2B 15*15 Pricing
*******************************************************************/

public class B2B15By15PriceWrapper{
    public String source{get;set;}
    public Decimal ncrAmount{get;set;}
    public Decimal luhAmount{get;set;}
    public Decimal jaiAmount{get;set;}
    public Decimal jamAmount{get;set;}
    public Decimal lkoAmount{get;set;}
    public Decimal bomAmount{get;set;}
    public Decimal amdAmount{get;set;}
    public Decimal goaAmount{get;set;}
    public Decimal ixrAmount{get;set;}
    public Decimal idrAmount{get;set;}
    public Decimal blrAmount{get;set;}
    public Decimal hydAmount{get;set;}
    public Decimal cjbAmount{get;set;}
    public Decimal ccuAmount{get;set;}
    public Decimal guaAmount{get;set;}

      // Assign amount based on destination    
    public B2B15By15PriceWrapper(String sString, List<B2B_Price__c> B2BList){
        this.source = sString;
        for(B2B_Price__c objB2BPrice : B2BList){
            if(objB2BPrice.Destination__c == 'NCR'){
                ncrAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'LUH'){
                luhAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'JAI'){
                jaiAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'JAM'){
                jamAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'LKO'){
                lkoAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'BOM'){
                bomAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'AMD'){
                amdAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'GOA'){
                goaAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'IXR'){
                ixrAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'IDR'){
                idrAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'BLR'){
                blrAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'HYD'){
                hydAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'CJB'){
                cjbAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'CCU'){
                ccuAmount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'GUA'){
                guaAmount = objB2BPrice.Amount__c;
            }
        }            
    }        
}