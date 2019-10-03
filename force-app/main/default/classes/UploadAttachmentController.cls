/*****************************************************************
* Author: Techila
* Class Name: UploadAttachmentController
* Updated Date: 11th Jan 2018
* Description: Extension class for UploadAttachment VF
*****************************************************************/
public class UploadAttachmentController{
    
    public Boolean isContract {get;set;}
    Public Boolean showFulfillment {get;set;} //used to show when cob record type is fulfillment picklist
    Public Boolean showNotFulfillment {get;set;} //used to show when cob record type is not fulfillment picklist
    public Boolean isCOB {get;set;}
    public Boolean isCase {get;set;}
    public Id recordId {get;set;}
    public Contract__c contractRecord {get;set;}
    public Customer_Onboarding__c cobRecord {get;set;}
    public Case caseRecord{get;set;}
    public Attachment attachmentUpload {get;set;}   
    public Attachment attachmentUpload_Con {get;set;}
    public Attachment attachmentUpload_Case {get;set;}
    public String attachmentType{get;set;}
    public Attachment__c attachmentRecord{get;set;}
    public List <Contract__c> latestContractList ;
    
    public UploadAttachmentController(ApexPages.StandardSetController controller){
        this.attachmentRecord = (Attachment__c)controller.getRecord();
        system.debug('<><><><><><>'+ attachmentRecord);
        attachmentUpload = new Attachment();
        attachmentUpload_Con = new Attachment();
        attachmentUpload_Case = new Attachment();
        recordId = ApexPages.currentPage().getParameters().get('id');
        system.debug('-Ua--recordId-'+recordId);
        showFulfillment=false;
        showNotFulfillment=false;
        
        Schema.SObjectType sobjectType = recordId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        
        if(sobjectName == 'Contract__c'){
            isContract = true;
            contractRecord = [SELECT ID, Name, Status__c, is_Latest_Contract__c, Opportunity__c FROM Contract__c WHERE Id=:recordId];
        }else if(sobjectName == 'Customer_Onboarding__c'){
            isCOB = true;
            cobRecord = [SELECT ID, Name, Opportunity__c, recordType.Name FROM Customer_Onboarding__c WHERE Id=:recordId];
            if(cobRecord.recordType.Name == 'Fulfillment'){
                showFulfillment=true;
                showNotFulfillment=false;
            }else{
                showFulfillment=false;
                showNotFulfillment=true;
            }
        }else if (sobjectName == 'Case'){
            isCase = true;
            caseRecord = [SELECT Id, CaseNumber FROM Case WHERE Id =: recordId];
        }
        
        
    }
    
    public PageReference saveCOBAttachment(){
        system.debug('attachmentRecord >>'+attachmentRecord);
        String attachmentType = attachmentRecord.Type__c;
        String attachmentFulfillType = attachmentRecord.Fulfillment_Document_Type__c;
        try{
            if((attachmentType!=null || attachmentFulfillType!=null) && attachmentUpload!=null){
                if(attachmentUpload!= new Attachment()){
                    Attachment__c objAttachment = new Attachment__c();
                    objAttachment.Customer_Onboarding__c = cobRecord.id;
                    
                    /**SF-50 Starts: If Contract attachments are already present for the current Opportunity, make them visible for COB related list**/
                    List <Attachment__c> attachmentRecordList = new List <Attachment__c>();
                    List <Attachment__c> updateExtAttachments = new List <Attachment__c>();
                    
                    attachmentRecordList = [SELECT Id, Contract__c, Customer_Onboarding__c, Contract__r.Opportunity__c, Contract__r.is_Latest_Contract__c FROM Attachment__c WHERE Contract__r.Opportunity__c=:cobRecord.Opportunity__c AND Contract__r.is_Latest_Contract__c=true LIMIT 1];
                    system.debug('attachmentRecordList'+attachmentRecordList);
                    if(!attachmentRecordList.isEmpty()){
                        for(Attachment__c attContractRecord: attachmentRecordList){
                            attContractRecord.Customer_Onboarding__c = cobRecord.Id;
                            updateExtAttachments.add(attContractRecord);
                        }
                    }
                    system.debug('updateExtAttachments >>'+updateExtAttachments);
                    if(!updateExtAttachments.isEmpty()){
                        update updateExtAttachments;
                    }
                    /**SF-50 Ends: If Contract attachments are already present for the current Opportunity, make them visible for COB related list**/
                    
                    objAttachment.Type__c = attachmentType;
                    objAttachment.Fulfillment_Document_Type__c = attachmentFulfillType;
                    //String Extension = attachmentUpload_Con.Name.substringAfter('.');
                    //String objName = system.now() +attachmentUpload.Name ;
                    if(attachmentUpload.Name.length()>60){
                        objAttachment.Name = system.now() + attachmentUpload.Name.right(60);// +'.'+ Extension;
                    }else{
                        objAttachment.Name = system.now() + attachmentUpload.Name  ;
                    }
                    insert objAttachment;
                    
                    attachmentUpload.ParentId = objAttachment.Id;
                    attachmentUpload.Name = objAttachment.Name;
                    system.debug('attachmentUpload >>'+attachmentUpload);
                    insert attachmentUpload;
                    
                    PageReference attachPage = new PageReference('/'+objAttachment.Id);
                    return attachPage;
                    
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload an Attachment to Customer Onboarding.'));
                    return null;
                }
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please add an attachment Type.'));
                attachmentUpload = new Attachment();
                return null;
            }   
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload an Attachment to Customer Onboarding.'));
            return null;
        }
        
    }
    
    public PageReference saveContractAttachment(){
        String attachmentType = attachmentRecord.Type__c;
        system.debug('attachmentType >>'+attachmentType);
        system.debug('attachmentUpload_Con >>'+attachmentUpload_Con);
        try{
            if(attachmentUpload_Con!= new Attachment() && attachmentUpload_Con!=null){
                Attachment__c objAttachment = new Attachment__c();
                objAttachment.Contract__c = contractRecord.id;
                
                /**SF-50 Starts: If Contract attachments are already present for the current Opportunity, make them visible for COB related list**/
                List <Customer_Onboarding__c> existingCOBList = new List <Customer_Onboarding__c>();
                Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
                
                existingCOBList = [SELECT Id, Opportunity__c FROM Customer_Onboarding__c WHERE Opportunity__c=:contractRecord.Opportunity__c LIMIT 1];
                system.debug('existingCOBList >>'+existingCOBList);
                
                if(!existingCOBList.isEmpty()){
                    objOnboarding = existingCOBList[0];
                    objAttachment.Customer_Onboarding__c = objOnboarding.Id;
                    //insert objAttachment;
                }
                /**SF-50 Ends: If Contract attachments are already present for the current Opportunity, make them visible for COB related list**/
                
                objAttachment.Type__c = 'Agreement';
                //String Extension = attachmentUpload_Con.Name.substringAfter('.');
                //String objName =  system.now() + attachmentUpload_Con.Name ;
                if(attachmentUpload_Con.Name.length()>60){
                    objAttachment.Name = system.now() + attachmentUpload_Con.Name.right(60);// + '.' + Extension;
                }else{
                    objAttachment.Name = system.now() + attachmentUpload_Con.Name ;
                }
                insert objAttachment;
                
                attachmentUpload_Con.ParentId = objAttachment.Id;
                attachmentUpload_Con.Name = objAttachment.Name;
                system.debug('attachmentUpload_Con >>'+attachmentUpload_Con);
                insert attachmentUpload_Con;
                
                PageReference attachPage = new PageReference('/'+objAttachment.Id);
                return attachPage;
                
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload an Attachment to Contract.'));
                return null;
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload an Attachment to Contract.'));
            return null;
        }
        
    }
    
    /***SF-55 --> Case: Manual attachment addition should be in 1 step Starts here***/
    public PageReference saveCaseAttachment(){
        String attachmentType = attachmentRecord.Type__c;
        system.debug('attachmentType >>'+attachmentType);
        system.debug('attachmentUpload_Case >>'+attachmentUpload_Case);
        try{
            if(attachmentUpload_Case!= new Attachment() && attachmentUpload_Case!=null){
                Attachment__c objAttachment = new Attachment__c();
                objAttachment.Case__c = caseRecord.id;
                
                if(attachmentUpload_Case.Name.length()>40){
                    objAttachment.Name = 'Case' +' '+ caseRecord.CaseNumber +' '+ system.now() + attachmentUpload_Case.Name.right(40);// + '.' + Extension;
                }else{
                    objAttachment.Name = 'Case' +' '+ caseRecord.CaseNumber +' '+system.now() + attachmentUpload_Case.Name ;
                }
                insert objAttachment;
                
                attachmentUpload_Case.ParentId = objAttachment.Id;
                attachmentUpload_Case.Name = objAttachment.Name;
                system.debug('attachmentUpload_Case >>'+attachmentUpload_Case);
                insert attachmentUpload_Case;
                
                PageReference attachPage = new PageReference('/'+objAttachment.Id);
                return attachPage;
                
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload an Attachment to Case.'));
                return null;
            }
        }catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload an Attachment to Case.'));
            return null;
        }    
    }
    /***SF-55 --> Case: Manual attachment addition should be in 1 step Ends here***/
    
    public PageReference backRecord(){
        if(isCOB!=null && isCOB==true){
            PageReference backtoCOB = new PageReference('/'+cobRecord.Id);
            return backtoCOB;
        }else if(isContract!=null && isContract==true){
            PageReference backtoContract = new PageReference('/'+contractRecord.Id);
            return backtoContract;
        }else if(isCase!=null && isCase==true){
            PageReference backtoCase = new PageReference('/'+caseRecord.Id);
            return backtoCase;
        }else{
            return null;
        }
    }
}