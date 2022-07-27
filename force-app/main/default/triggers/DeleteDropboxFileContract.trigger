trigger DeleteDropboxFileContract on Contract__c (before delete) {
	
    Set<Id> contractSet = new Set<Id>();
    Set<Id> attachSet = new Set<Id>();
    if(Trigger.isBefore && Trigger.isDelete){
        for(Contract__c objContract : Trigger.old){
            contractSet.add(objContract.Id);
        }
        for(Attachment__c objAttachment : [SELECT Id FROM Attachment__c WHERE Contract__c IN:contractSet]){
        	attachSet.add(objAttachment.Id);	    
        }
	DeleteAttachmentHandler.deleteCaseDropboxAttachment(attachSet);
	}
}