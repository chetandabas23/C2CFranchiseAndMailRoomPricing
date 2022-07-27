/*****************************************************************
* Author: Techila
* Class Name: ContractTriggerHandler
* Updated Date: 24th Jan 2018
* Description: Handler class for ContractTriggerHandler
*****************************************************************/

public class ContractTriggerHandler{
    public static void sendEmailForAcceptedContract (Set <Id> contractIdSet){
        system.debug('contractIdSet >>'+ contractIdSet);
        List <Contract__c> conRecList = new List <Contract__c>();
        String RecipientName='';
        conRecList = [SELECT Id, Name, Opportunity__c, Opportunity__r.Name, Opportunity__r.ownerId, Opportunity__r.Owner.Email, Opportunity__r.Owner.Name,Opportunity__r.RecordTypeId, Opportunity__r.AccountId, Opportunity__r.Account.OwnerId, Opportunity__r.Account.Owner.Name,Opportunity__r.Account.Owner.Email, Contact__c, Contact__r.Name, Opportunity__r.Operating_Account__c , Opportunity__r.Operating_Account__r.Owner.Name, Opportunity__r.Operating_Account__r.Owner.Email FROM Contract__c WHERE Id IN: contractIdSet];
        String BaseUrl=  URL.getSalesforceBaseUrl().getHost();
        Id FulfillmentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Fulfillment').getRecordTypeId();
        if(!conRecList.isEmpty()){  
            for(Contract__c contractRecord : conRecList){
                //Creating instance of email template for sending email
                Messaging.SingleEmailMessage mail_Contract = new Messaging.SingleEmailMessage();
                String linkURL ='https://'+BaseUrl+'/'+contractRecord.Id;
                List < String > toAddresses = new List < String >();
                if(contractRecord.Opportunity__r.Operating_Account__c!=null){
                    toAddresses.add(contractRecord.Opportunity__r.Operating_Account__r.Owner.Email);
                    RecipientName = contractRecord.Opportunity__r.Operating_Account__r.Owner.Name;
                    
                }else{
                    toAddresses.add(contractRecord.Opportunity__r.Owner.Email);
                    RecipientName = contractRecord.Opportunity__r.Owner.Name;
                    
                }      
                if(Test.isRunningTest()){
                    toAddresses=new List<String>{'test@gmail.com'};
                }
                mail_Contract.setToAddresses(toAddresses);
                mail_Contract.setSubject('Contract Accepted - '+contractRecord.Name);
                mail_Contract.saveAsActivity = false;
                if(contractRecord.Opportunity__r.RecordTypeId==FulfillmentRecordTypeId)
                    {
                        List<String> ccAddresses1=new List<String>();
                        ccAddresses1.add('amit.kumar11@delhivery.com');
                        mail_Contract.setCcAddresses(ccAddresses1);
                    }
                mail_Contract.setHTMLBody ( 'Hello '+RecipientName+', <br/>'+'<br/>'+contractRecord.Name+' has been Accepted by '+contractRecord.Opportunity__r.Name+ '<br/>' +'<br/>'+'<br/>'+'Thanks and regards,<br/>Delhivery');
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail_Contract});
            }
        }
    }
}