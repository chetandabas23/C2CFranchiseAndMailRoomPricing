public class DeleteAttachmentHandler {
	
    public static void deleteCaseDropboxAttachment(Set<Id> setAttachment){
        string trimId;
        List<Id> attachmnetId = New List<Id>();
        Set<String> attachmentIdSet = New Set<String>();
        List<Attachment__c> deleteAttachList = New List<Attachment__c>();
        List<Attachment__c> attachmentList = New List<Attachment__c>();
        
        attachmnetId.addAll(setAttachment);
        system.debug('setAttachment>>>'+setAttachment);
        for(integer i=0;i<attachmnetId.size();i++){
            trimId = String.valueOf(attachmnetId[i]).substring(0, 15);
            attachmentIdSet.add(trimId);
        }
        system.debug('attachmentIdSet>>>'+attachmentIdSet);
        
        attachmentList = [SELECT Id,Dropbox_Link__c FROM Attachment__C WHERE Id IN: attachmentIdSet];
   		 
        delete attachmentList; 
   }
}