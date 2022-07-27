public class clsNotification {
    
    public Id CobRecordId{get;set;}
    public Customer_Onboarding__c objCust{get;set;}
   	String strCCAddress;
    public clsNotification(ApexPages.StandardController controller) {
        CobRecordId=ApexPages.currentPage().getParameters().get('id');
        objCust=(Customer_Onboarding__c )controller.getRecord();
        
    }
    public PageReference sentEmailNotification(){
        System.debug('objCus'+objCust);
        system.debug('---Enter sentEmailNotification method---');
        
        if(objCust.POC_Welcome_Mail__c==false && (objCust.Status__c=='Synced To HQ' ||objCust.Status__c=='Synced To Oracle' ||objCust.Status__c== 'Synced to Bird' ))
        {
            
            if(objCust.CL_PANEL_User_Name__c!=null && objCust.CL_PANEL_User_Name__c!='')
            {   system.debug('objCust---'+objCust);
             system.debug('objCust.Opportunity__r---'+objCust.Opportunity__r);
             system.debug('objCust.EMAIL_POC1__c---'+objCust.EMAIL_POC1__c);
             system.debug('objCust.EMAIL_POC2__c---'+objCust.EMAIL_POC2__c);
             if(objCust.EMAIL_POC1__c!=null && objCust.EMAIL_POC1__c!='' && objCust.EMAIL_POC2__c!=null && objCust.EMAIL_POC2__c!='' &&  objCust.Desired_HQ_Name__c!=null && objCust.Desired_HQ_Name__c!='')
             {
                 
                 if((objCust.Email__c !=null && objCust.Email__c !='' && objCust.Opportunity__r.owner.Email!=null && objCust.Opportunity__r.owner.Email!='')|| Test.isRunningTest())
                 { 
                     
                     if(objCust.Contact__c!=null && (String)objCust.Contact__c!='')
                     {
                         try
                         {
                             strCCAddress= System.label.C2C_CCAddress;
                             System.debug('OppOwner'+objCust.Opportunity__r.owner.Email);
                             String[] ccAddresses = new String[] {objCust.EMAIL_POC1__c,objCust.EMAIL_POC2__c,objCust.Opportunity__r.owner.Email};
                              System.debug('StrCCAddress are '+strCCAddress);
                             System.debug('StrCCAddress after comma seperated are '+strCCAddress);
                             List<String> lstCCAddress = strCCAddress.split(',');
                                 if(objCust.Opportunity_Record_Type__c=='C2C')
                             {
                                 	ccAddresses.addAll(lstCCAddress);
                             }
                                 String[] toAddresses = new String[] {objCust.Email__c};
                                     // String[] ccAddresses = new String[] {'rishabh.sharma1@delhivery.com'};
                                     // String[] toAddresses = new String[] {'saurabh.rastogi@delhivery.com'};
                                     
                                     OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress where DisplayName=:'Welcome Poc'  limit 1];
                             EmailTemplate templateId = [Select id from EmailTemplate where name = 'POC Welcome Mail'];
                             EmailTemplate templateIdB2B = [Select id from EmailTemplate where name = 'POC Welcome Mail_B2B'];
                             EmailTemplate templateIdC2C = [Select id from EmailTemplate where name = 'C2C Welcome Mail'];
                             ID FinaltemplateId = objCust.Opportunity_Record_Type__c == 'B2B'?templateIdB2B.id:objCust.Opportunity_Record_Type__c =='C2C'?templateIdC2C.id:templateId.id;
                             ID FinaltemplateIdPrepaid =[Select id from EmailTemplate where name = 'POC Welcome Mail Prepaid'].id;  
                             
                             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            // Changes for POC Email Prepaid and Postpaid
                             if(objCust.Opportunity_Record_Type__c == 'Standard Shipping' || objCust.Opportunity_Record_Type__c == 'Express Shipping')
                             {
                                 if(objCust.Is_Postpaid__c)
                                 {
                                     mail.setTemplateID(FinaltemplateId); 
                                 }
                                 else
                                 {
                                     mail.setTemplateID(FinaltemplateIdPrepaid); 
                                 }
                             }
                             else
                             {
                                 mail.setTemplateID(FinaltemplateId); 
                                 
                             }
                             mail.setTargetObjectId(objCust.contact__C);
                             mail.setSaveAsActivity(false);
                             mail.setOrgWideEmailAddressId(owa.id);
                             mail.setToAddresses(toAddresses  );
                             // mail.subject = 'Delhivery Startup Operation Mail -'+ objCust.Desired_HQ_Name__c;
                             mail.setCCAddresses( ccAddresses );
                             mail.setWhatId(objCust.id);
                             
                             Messaging.SendEmailResult [] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail});
                             
                             objCust.POC_Welcome_Mail__c=true;
                             objCust.Status__c = 'Completed';                            
                             
                             if (results[0].success) 
                             {
                                 update objCust;
                                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'POC Email sent successfully!'));
                                 cls_PocSendtoHq objPOCclass = new cls_PocSendtoHq(objCust.Id);
                                 cls_PocSendtoHq.sendPOCtoHq(objCust.Id);
                                 
                             }else {
                                 System.debug('The email failed to send: ' + results[0].errors[0].message);
                             }
                         }catch(Exception ex)
                         {
                             system.debug('error'+ex);
                             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Something getting wrong please contact to SFDC Team!'));
                             
                         }
                     }
                     else{
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'NO Contact selected on COB!'));
                         
                         
                     }
                 }else{
                     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Opportunity or Email for this COB is not filled!'));
                     
                 }
             }
             else
             {
                 
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Fill POC Deatils and Desired HQ Name !'));
                 
             }
             
            }else{
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please provide CL PANEL credential!'));
            }
        }else{
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'POC Welcome mail already sent to Customer or Status is not Synced To HQ or Synced To Oracle or Synced to Bird!'));
            
        }
        return null;
    }
}