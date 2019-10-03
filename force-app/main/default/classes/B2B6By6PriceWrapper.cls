/*****************************************************************
* Author: Apurva Prasade
* Class Name: B2B6By6PriceWrapper
* Created Date: 3-Jan-2017
* Description: Wrapper class for B2B 6*6 Pricing
*******************************************************************/

public class B2B6By6PriceWrapper{
    public String source{get;set;}
    public Decimal northAmount{get;set;}
    public Decimal westAmount{get;set;}
    public Decimal southAmount{get;set;}
    public Decimal keralaAmount{get;set;}
    public Decimal eastAmount{get;set;}
    public Decimal northEastAmount{get;set;}       

    // Assign amount based on destination             
    public B2B6By6PriceWrapper(String sString, List<B2B_Price__c> B2BList){
        this.source = sString;
        for(B2B_Price__c objB2BPrice : B2BList)
        {
            if(objB2BPrice.Destination__c == 'North')
                northAmount = objB2BPrice.Amount__c;
            else if(objB2BPrice.Destination__c == 'West')
                westAmount = objB2BPrice.Amount__c;
            else if(objB2BPrice.Destination__c == 'South')
                southAmount = objB2BPrice.Amount__c;
            else if(objB2BPrice.Destination__c == 'Kerala')
                keralaAmount = objB2BPrice.Amount__c;
            else if(objB2BPrice.Destination__c == 'East')
                eastAmount = objB2BPrice.Amount__c;
            else if(objB2BPrice.Destination__c == 'North East')
                northEastAmount = objB2BPrice.Amount__c;
        }
    }
}