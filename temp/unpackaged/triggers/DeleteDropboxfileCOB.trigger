trigger DeleteDropboxfileCOB on Customer_Onboarding__c (before delete) {
	
    Set<Id> costumerOnBaordSet = new Set<Id>();
    Set<Id> attachSet = new Set<Id>();
    if(Trigger.isBefore && Trigger.isDelete){
        for(Customer_Onboarding__c objCOB : Trigger.old){
            costumerOnBaordSet.add(objCOB.Id);
        }
        for(Attachment__c objAttachment : [SELECT Id FROM Attachment__c WHERE Customer_Onboarding__c IN:costumerOnBaordSet AND Contract__c = Null]){
        	attachSet.add(objAttachment.Id);	    
        }
	DeleteAttachmentHandler.deleteCaseDropboxAttachment(attachSet);
	}
}