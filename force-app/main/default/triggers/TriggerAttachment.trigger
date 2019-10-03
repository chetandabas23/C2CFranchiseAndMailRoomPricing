trigger TriggerAttachment on Attachment__c (After insert, After update ) {

    list<Customer_Onboarding__c> listobjcustom=new list<Customer_Onboarding__c>();
    //Set of onboarding Id
    Set<Id> SetId=new Set<Id>();
    Boolean IsProductMarketplace = false;
    Boolean ISProductMapping = false;
    trigger_stopper__c TriggerStoper = trigger_stopper__c.getInstance('TriggerAttUpdateDocumentsVerified');
    if(TriggerStoper != null && TriggerStoper.Trigger_After__c == true)
    {
        list<Customer_Onboarding__c> Updatelistobjcustom=new list<Customer_Onboarding__c>();
        
        for(Attachment__c att : Trigger.New) 
        {
            
            SetId.add(att.Customer_Onboarding__c);
            
            system.debug('Attachment__c---->'+att);
        }
        system.debug(SetId);
        if(SetId != null)
        {
            system.debug('At Line 23');
            Id CODRecordTypeId = Schema.SObjectType.Customer_Onboarding__c.getRecordTypeInfosByName().get('Fulfillment').getRecordTypeId();
            listobjcustom = [Select Id,IsDocuments_Verified__c,Opportunity__r.Client_Other_Service__c,(Select Id,Fulfillment_Document_Type__c,Document_Status__c,Verified__c from Attachments__r where (Fulfillment_Document_Type__c='Product Feed' OR Fulfillment_Document_Type__c='Marketplace Mapping') AND Document_Status__c=:'Verified') from Customer_Onboarding__c where id IN :SetId AND RecordType.Name=:'Fulfillment'];
        }
        System.debug('listobjcustom.Attachment---'+listobjcustom);
        
        if(listobjcustom != null && listobjcustom.size()>0)
        {
            for(Customer_Onboarding__c cob :listobjcustom)
            {
                System.debug('Attachment'+cob.Attachments__r);
                if(listobjcustom != null && listobjcustom.size()>0)
                {
                    for(Attachment__c att : cob.Attachments__r)
                    {
                        if(att.Fulfillment_Document_Type__c == 'Marketplace Mapping' && att.Document_Status__c=='Verified')
                        {
                            IsProductMarketplace = true;
                        }
                        if(att.Fulfillment_Document_Type__c == 'Product Feed' && att.Document_Status__c=='Verified')
                        {
                            ISProductMapping = true;
                        }
                        System.debug(IsProductMarketplace +'---------'+ ISProductMapping);
                    }
                }
                
                if((IsProductMarketplace == true && ISProductMapping== true) || ((IsProductMarketplace == false && cob.Opportunity__r.Client_Other_Service__c =='Owner Website') && ISProductMapping== true))
                {
                    System.debug('IN True');
                    cob.IsDocuments_Verified__c=true;
                    Updatelistobjcustom.add(cob);
                } 
                else
                {
                    System.debug('IN False');
                    cob.IsDocuments_Verified__c=false;
                    Updatelistobjcustom.add(cob);
                } 
            }
            update Updatelistobjcustom;
        }
    }
}