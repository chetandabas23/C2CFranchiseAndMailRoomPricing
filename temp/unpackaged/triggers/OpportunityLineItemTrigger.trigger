/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: OpportunityLineItemTrigger
* Created Date: 01-June-2017
* Description: Trigger on Opportunity line item for deleting related B2B Prices and to update the Status of Parent Opportunity
*******************************************************************/

trigger OpportunityLineItemTrigger on OpportunityLineItem(before delete, after insert, after update,after delete){
	if(Trigger.isBefore){
		if(Trigger.isDelete){
			OpportunityLineItemTriggerUtility.deleteRelatedPrices(Trigger.old);
		}
	}
   if(Trigger.isAfter)
   {
       System.debug('Inside the After Opportunity Line Item');
       if(Trigger.isDelete){
           System.debug('Inside the is Delete Condition '+trigger.old);
           OpportunityLineItemTriggerUtility.deleteFranchisePricing(Trigger.old);
       }
   }/*else{
		if(Trigger.isInsert){
			OpportunityLineItemTriggerUtility.changeStatusOfOpportunity(Trigger.new);
		}else if(Trigger.isUpdate){
			OpportunityLineItemTriggerUtility.changeStatusOfOpportunity(Trigger.new);
		}
	}*/
}