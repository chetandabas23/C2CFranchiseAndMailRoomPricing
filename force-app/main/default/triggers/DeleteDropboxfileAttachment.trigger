trigger DeleteDropboxfileAttachment on Attachment__c (before delete) {
	
    Set<Id> attachSet = New Set<Id>();
    Set<String> dropBoxUrl = New Set<String>();
    if(Trigger.isBefore && Trigger.isDelete){
        for(Attachment__c objAttachment : Trigger.old){
            attachSet.add(objAttachment.Id);
        }
        for(Attachment__c objAttachment : [SELECT Id,Dropbox_Link__c,DropBox_PathLower__c FROM Attachment__c WHERE Id IN: attachSet]){
            dropBoxUrl.add(objAttachment.Dropbox_Link__c);
        }
    system.debug('dropBoxUrl-->'+dropBoxUrl);
    DropBoxUrlCreateHandler.createDropBoxUrl(dropBoxUrl);    
    }
}