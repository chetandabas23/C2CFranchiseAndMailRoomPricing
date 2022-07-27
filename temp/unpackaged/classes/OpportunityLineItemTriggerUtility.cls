/*****************************************************************
* Author: Chetan Dabas.
* Class Name: OpportunityLineItemTriggerUtility
* Created Date: 15-Sept-2019
* Description: Utility class for OpportunityLineItem Trigger
*******************************************************************/
global class OpportunityLineItemTriggerUtility{ 

    //Utility class to delete all related B2B Prices when OLI gets deleted
    global static void deleteRelatedPrices(List<OpportunityLineItem> oliList){		
        for(OpportunityLineItem objOLI : oliList){
            String oliString = String.valueOf(objOLI.Id);
            if(oliString.length()<=15){
                oliString += '%';
            }
            if(objOLI.Updated_Product_Name__c=='Hyperlocal'){
                delete [SELECT id FROM Hyperlocal_Price__c WHERE Opportunity_Line_Item_Id__c like: oliString];                
            }else if(objOLI.Updated_Product_Name__c=='B2B 5*5' || objOLI.Updated_Product_Name__c=='B2B 15*15' || objOLI.Updated_Product_Name__c=='B2B Lanewise'){
                delete [SELECT id FROM B2B_Price__c WHERE Opportunity_Line_Item_Id__c like: oliString];
            }else if(objOLI.Updated_Product_Name__c=='Express Shipping' || objOLI.Updated_Product_Name__c=='Standard Shipping'){
                delete [SELECT id FROM Slab_Price__c WHERE Opportunity_Line_Item_Id__c like: oliString];
            }            
        }
          }
    global static void deleteFranchisePricing(List<OpportunityLineItem> oliList){
        System.debug('Inside the delete Franchise PRicing Method and the value of oli list is '+olilist);
        Set<Id> SetOppId = new Set<Id>();
        List<String> lstStr = new List<String>();
        for(OpportunityLineITem lstOLI:oliList){
            SetOppId.add(lstOLI.OpportunityId);
            lstStr.add(lstOLI.version__c);
        }
        List<OpportunityLineITem> lstOPPLI = [Select id,Name from OpportunityLineItem where Version__c IN :lstStr AND OpportunityID IN:SetOppId];
        if(lstOppLI !=null && lstOPPLI.size()>0)
        {
            delete lstOPPLI;
        }
    }
}