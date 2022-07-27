/*****************************************************************
* Author: Apurva Prasade
* Class Name: B2B14By14PriceWrapper
* Created Date: 4th-Jan-2017
* Description: Wrapper class for B2B 14*14 Pricing
*******************************************************************/

public class B2B14By14PriceWrapper{
    public String source{get;set;}
    public Decimal n1Amount{get;set;}
    public Decimal n2Amount{get;set;}
    public Decimal n3Amount{get;set;}
    public Decimal c1Amount{get;set;}
    public Decimal c2Amount{get;set;}
    public Decimal w1Amount{get;set;}
    public Decimal w2Amount{get;set;}
    public Decimal s1Amount{get;set;}
    public Decimal s2Amount{get;set;}
    public Decimal s3Amount{get;set;}
    public Decimal e1Amount{get;set;}
    public Decimal e2Amount{get;set;}
    public Decimal ne1Amount{get;set;}
    public Decimal ne2Amount{get;set;}

      // Assign amount based on destination    
    public B2B14By14PriceWrapper(String sString, List<B2B_Price__c> B2BList){
        this.source = sString;
        for(B2B_Price__c objB2BPrice : B2BList){
            if(objB2BPrice.Destination__c == 'N1'){
                n1Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'N2'){
                n2Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'N3'){
                n3Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'C1'){
                c1Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'C2'){
                c2Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'W1'){
                w1Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'W2'){
                w2Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'S1'){
                s1Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'S2'){
                s2Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'S3'){
                s3Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'E1'){
                e1Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'E2'){
                e2Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'NE1'){
                ne1Amount = objB2BPrice.Amount__c;
            }else if(objB2BPrice.Destination__c == 'NE2'){
                ne2Amount = objB2BPrice.Amount__c;
            }
        }            
    }        
}