public class DropBoxUrlCreateHandler {
    public static void createDropBoxUrl(Set<String> DropboxURL){
    	List<String> dropboxLinkList = New List<String>();
        dropboxLinkList.addAll(DropboxURL);
        system.debug('dropboxLinkList-->'+dropboxLinkList);
        for(integer i=0;i<dropboxLinkList.size();i++){
            Error_Log__c objErrorLog = New Error_Log__c();
            objErrorLog.DropBox_Url__c = dropboxLinkList[i];
            objErrorLog.IsSuccess__c = true;
            objErrorLog.Type__c = 'Delete Dropbox Files';
            insert objErrorLog;
            System.debug('objErrorLog-->'+objErrorLog);
        }
    }
}