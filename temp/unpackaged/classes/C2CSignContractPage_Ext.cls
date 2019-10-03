/************************************************************************************************
* Author: Chetan Dabas.
* Class Name: SignContractPage_Ext
* Created Date: 15-Sept-2019
* Description: To show the contract PDFs in iFrames and to implement the "I Agree" functionality. 
*************************************************************************************************/
public class C2CSignContractPage_Ext
{
    public Opportunity opp{get;set;}
    public String oppid{get;set;}
    public String conid{get;set;}
    public String isSoftApproval{get;set;}
    public Contract__c objContract{get;set;}
    public boolean bl{get;set;}
    public boolean bool{get;set;}
    public String ipAdress{get;set;}
    public String contactId{get;set;}
    public Boolean insurance{get;set;}
    public Contact contact{get;set;}
    public Boolean NullAgreement{get;set;}
    public Boolean isContractIdPresent{get; set;}
    public Boolean isContactIdPresent{get; set;}
    public Static Boolean contractExpiry{get;set;}
    public Boolean renderUploadButton{get; set;}    
    public Static Boolean contractVisibility{get; set;}
    public Boolean isLatest{get; set;}
    public Attachment attachmentUpload{get;set;}
    public Attachment__c objAttachment_Success{get;set;}
    public List<Attachment__c> objAttachment_SuccessList{get;set;}
    public List <Customer_OnBoarding__c> objCusOnBoard {get;set;}
    public Map <Boolean, Boolean> boolUploadMap = new Map <Boolean, Boolean>();
    public List <Contract__c> conRecordList {get;set;}
    public Contract__c contractRecordStatus {get;set;}
    public boolean subCatContractCheck{get;set;}
    public C2CSignContractPage_Ext(ApexPages.standardController controller){
        oppid = ApexPages.currentPage().getParameters().get('id');
        conid = ApexPages.currentPage().getParameters().get('ContractId');
        isSoftApproval = ApexPages.currentPage().getParameters().get('isSoftApproval');
        attachmentUpload = new Attachment();
        contractVisibility = false;
        contractExpiry = false;
        
        System.debug('ConId---->'+conid);
        
        contactId = ApexPages.currentPage().getParameters().get('ContactId');
        //to insert the ip address of system from which the contract is agreed
        ipAdress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');            
        //to show error if opportunity id is not present in url
        if(oppid=='' || !ApexPages.currentPage().getParameters().containsKey('id')){
            isContractIdPresent = true;
            NullAgreement = false;
        }
        opp = new Opportunity();
        objContract = new Contract__c();
        NullAgreement = false;
        isContractIdPresent=false;
        isContactIdPresent=false; 
        if(oppid != null){     
            List <Opportunity>  opportunityList = new List<Opportunity>();           
            opportunityList = [select Id, Name,Sub_Category__c,RecordType.Name, RecordType.DeveloperName, RecordTypeId, Account.Invoicing_Mode__c,Insurance__c,Insurance_Required__c,Agreement_Signed_Date__c from Opportunity where id=:oppid];
            if(opportunityList.size()>0){
                opp = opportunityList[0];
            }else{
                NullAgreement = true;
            }                    
        }        
        
        if(contactId!=null){
            contact = [select id from Contact where id=:contactId];
        }
        else{
            isContactIdPresent=true;
        }
        
        if(conid!=null){     
            List<Contract__c> contractList = new List<Contract__c>();
            
            contractList = [select Status__c,Submitted_Time__c,Agreement_Signed_by_User_IP_Address__c,Accepted_Time__c,Type__c, is_Latest_Contract__c,Start_date__c,End_date__c from Contract__c where id=:conid];
            if(contractList.size()>0){
                objContract = contractList[0];            
            }else{
                if(conid=='')
                    isContractIdPresent=true;
                else
                    NullAgreement = true; 
            }                    
        }
        else{
            isContractIdPresent=true;
        }
        system.debug('objContract --->'+objContract);
        
        
        if(objContract!=null){
            
            if(objContract.Status__c=='Accepted'){
                //boolean value to render the contract agreed message on page
                bool = true;
            }else{
                bool = false;            
            }
            if(opp.Insurance_Required__c)
            {
                insurance = true;
            }
            else{
                insurance = false;
            }
            //boolean value to render the iframe and Thank you message
            bl = false;            
        }
        
        
        /*Start : Show an error message when a Contract has already been Accepted*/
        if(objContract.Type__c != 'Addendum' && objContract.Type__c!='GST Agreement'){
            conRecordList = [Select id, Opportunity__c, Status__c, Type__c, is_Latest_Contract__c from  contract__c where Opportunity__c =:oppid  ORDER BY CreatedDate desc];
            if(!conRecordList.isEmpty()){
                for(Contract__c contractRecord : conRecordList){
                    contractRecordStatus = contractRecord;
                    system.debug('contractRecord >>'+contractRecord);
                    if(contractRecord.Status__c == 'Accepted' && opp.RecordType.Name=='B2B' && contractRecord.Type__c != 'Addendum' && contractRecord.Type__c != 'GST Agreement'){
                        bool = true;
                        renderUploadButton = false;
                        boolUploadMap.put(bool, renderUploadButton);
                    }else if(contractRecord.Status__c == 'Accepted' && opp.RecordType.Name!='B2B'  && contractRecord.Type__c != 'Addendum' && contractRecord.Type__c != 'GST Agreement'){
                        bool = true;
                        renderUploadButton = false;
                        boolUploadMap.put(bool, renderUploadButton);
                    }else if(contractRecord.Status__c != 'Accepted' && opp.RecordType.Name=='B2B' && isSoftApproval=='false'  && contractRecord.Type__c != 'Addendum' && contractRecord.Type__c != 'GST Agreement'){
                        bool = true;
                        renderUploadButton = true;
                    }else if(contractRecord.Status__c != 'Accepted' && opp.RecordType.Name=='B2B' && isSoftApproval=='true'  && contractRecord.Type__c != 'Addendum' && contractRecord.Type__c != 'GST Agreement'){
                        bool = false;
                        renderUploadButton = false;
                    }
                }
            }
            system.debug('--bool final--'+bool);
            system.debug('boolUploadMap >>'+boolUploadMap);
            for(Boolean statusCheck : boolUploadMap.keySet()){
                if(statusCheck == true && boolUploadMap.get(statusCheck) == false)
                {
                    bool = true;
                    renderUploadButton = false;
                    contractVisibility = true;
                    contractExpiry =  false;
                    PageReference pageRef = new PageReference('/apex/ContractVisibilityPage');
                    pageRef.setRedirect(true);       
                    //   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You have signed this Contract'));   
                }
            }
            
            objAttachment_SuccessList = new List <Attachment__c>();
            objAttachment_SuccessList = [SELECT Id, Dropbox_Link__c  FROM Attachment__c WHERE Contract__r.Opportunity__c =:oppid AND Contract__r.Status__c ='Accepted' LIMIT 1];
            if(!objAttachment_SuccessList.isEmpty()){
                objAttachment_Success = objAttachment_SuccessList[0];
            }
            /*Stop : Show an error message when a Contract has already been Accepted*/
        }
        system.debug('isContractIdPresent >>'+isContractIdPresent);
        system.debug('NullAgreement >>'+NullAgreement);
        system.debug('bool >>'+bool);
    }
    //Update the status of Contract from Submitted to Accepted
    public PageReference UpdateContract(){
        Set <String> conRecordStatus = new  Set <String>();
        system.debug('objContract >>'+objContract);
        if(objContract.Type__c != 'Addendum' && objContract.Type__c != 'GST Agreement' ){
            /*Start : Show an error message when a Contract has already been Accepted*/
            List <Contract__c> conRecordList = [Select id, Opportunity__c, Status__c, Type__c from  contract__c where Opportunity__c =:oppid order by CreatedDate desc];
            system.debug('conRecordList >>'+conRecordList);
            if(!conRecordList.isEmpty()){
                for(Contract__c contractRecord : conRecordList){
                    if(contractRecord.Status__c == 'Accepted' && contractRecord.Type__c =='Services Agreement' ){
                        bool = true;
                        conRecordStatus.add(contractRecord.Id);
                    }else{
                        bool = false;
                    }
                }
            }
            /*Stop : Show an error message when a Contract has already been Accepted*/
        }
        system.debug('conRecordStatus >>'+conRecordStatus);
        system.debug('isContractIdPresent >>'+isContractIdPresent);
        system.debug('NullAgreement >>'+NullAgreement);
        system.debug('bool >>'+bool);
        Savepoint sp = Database.setSavepoint();
        if(conRecordStatus.size() == 0){
            try{    
                system.debug('Inside try block');
                String attachmentName;
                // Date addStartDate;
                // Date addEndDate;
                bl = true;
                objContract.Agreement_Signed_by_User_IP_Address__c =  ipAdress;
                objContract.Status__c = 'Accepted';
                //accepting time of contract
                objContract.Accepted_Time__c = System.Now();  
                update objContract;
                
                system.debug('objContract-->'+objContract );
                opp.Agreement_Signed_Date__c = System.Now();
                opp.StageName = 'Contract Signed';
                opp.Offline_Agreement__c = false;
                if(objContract.Type__c == 'Addendum')
                {
                    opp.Addendum_Start_Date__c = objContract.Start_Date__c;
                    opp.Addendum_End_Date__c = objContract.End_Date__c;
                }
                update opp;                
                //attachment string not to exceed the field limit
                attachmentName = 'Agreement - '+opp.Name;
                if(attachmentName.length()>40){
                    //attachmentName.left(attachmentName.length()-10); 
                    attachmentName = attachmentName.substring(0, Math.min(attachmentName.length(), 55));
                    system.debug('in IF attachmentName-------->'+attachmentName);       
                }
                system.debug('attachmentName-------->'+attachmentName);
                system.debug('attachmentName.length()-------->'+attachmentName.length());
                attachmentName += ' '+objContract.Accepted_Time__c.format('dd-MM-yyyy HH:mm:ss','Asia/Kolkata'); 
                Attachment__c objAttachment = new Attachment__c();
                objAttachment.Contract__c = objContract.id;
                objAttachment.Type__c = 'Agreement';
                objAttachment.Name = attachmentName;
                System.debug('objAttachment.Name------->'+objAttachment.Name);
                insert objAttachment; 
                //To save pdf on attachments
                Blob body;
                if(opp.RecordType.DeveloperName !='C2C')
                {
                    if(objContract.Type__c=='Services Agreement' ){   
                        PageReference pdf = Page.ExpSurfacePDF;
                        pdf.getParameters().put('id',(String)opp.id);
                        pdf.getParameters().put('ContractId',(String)objContract.id);
                        pdf.getParameters().put('SignerIp',ipAdress);
                        pdf.getParameters().put('acceptedTime',String.valueof((objContract.Accepted_Time__c).format('dd-MM-yyyy HH:mm:ss','Asia/Kolkata')) );
                        pdf.setRedirect(true);                      
                        // Returns the output of the page as a PDF
                        if(!test.isRunningTest()){
                            body = pdf.getContentAsPDF();
                        }else{
                            body = blob.toPdf('TEST');
                        }                               
                    }
                    if(objContract.Type__c=='B2B'){
                        PageReference pdf;  
                        //if insurance is true for opportunity then save B2Bwithinsurance agreement otherwise save B2Bnoinsurance agreement
                        if(opp.Insurance__c){      
                            pdf = Page.B2BWithInsurancePDF;
                        }else{
                            pdf = Page.B2BNoInsurancePDF;
                        }
                        pdf.getParameters().put('id',(String)opp.id);
                        pdf.getParameters().put('ContractId',(String)objContract.id);
                        pdf.getParameters().put('SignerIp',ipAdress);
                        pdf.getParameters().put('acceptedTime',String.valueof((objContract.Accepted_Time__c).format('dd-MM-yyyy HH:mm:ss','Asia/Kolkata')) );
                        pdf.setRedirect(true);                
                        // Returns the output of the page as a PDF
                        System.debug('pdf ->'+pdf);
                        if(!test.isRunningTest()){ body = pdf.getContentAsPDF(); }
                        else{
                            body = blob.toPdf('TEST');
                        }                                   
                    }
                    if(objContract.Type__c=='Addendum'){  
                        system.debug('addendum');
                        PageReference pdf;
                        if(opp.RecordType.Name=='B2B'){
                            pdf = Page.OpportunityB2BAddendumAsPDF;
                        }else{
                            pdf = Page.OpportunityAddendumAsPDF;
                        }                
                        pdf.getParameters().put('id',(String)opp.id);
                        pdf.getParameters().put('ContractId',(String)objContract.id);
                        pdf.getParameters().put('ContactId',(String)contact.id);
                        pdf.getParameters().put('AddendumSignerIp',ipAdress);
                        pdf.getParameters().put('AddendumAcceptedTime',String.valueof((objContract.Accepted_Time__c).format('dd-MM-yyyy HH:mm:ss','Asia/Kolkata')) );
                        pdf.setRedirect(true);                
                        // Returns the output of the page as a PDF
                        if(!test.isRunningTest()){
                            body = pdf.getContentAsPDF();
                        }else{
                            body = blob.toPdf('TEST');
                        }                                
                    }
                }
                else if(opp.RecordType.DeveloperName == 'C2C')
                {
                     if(objContract.Type__c=='Addendum'){  
                        system.debug('addendum');
                        PageReference pdf;                       
                            pdf = Page.C2COpportunityAddendumAsPDF;                                 
                        pdf.getParameters().put('id',(String)opp.id);
                        pdf.getParameters().put('ContractId',(String)objContract.id);
                        pdf.getParameters().put('ContactId',(String)contact.id);
                        pdf.getParameters().put('AddendumSignerIp',ipAdress);
                        pdf.getParameters().put('AddendumAcceptedTime',String.valueof((objContract.Accepted_Time__c).format('dd-MM-yyyy HH:mm:ss','Asia/Kolkata')) );
                        pdf.setRedirect(true);                
                        // Returns the output of the page as a PDF
                        if(!test.isRunningTest()){
                            body = pdf.getContentAsPDF();
                        }else{
                            body = blob.toPdf('TEST');
                        }                                
                    }
                    else{
                    PageReference pdf;
                    if(objContract.Type__c=='Services Agreement')
                    pdf = Page.C2C_AgreementVFPage;  
                    else if(objContract.Type__c=='Addendum')
                    pdf = Page.C2COpportunityAddendumPage;
                    pdf.getParameters().put('id',(String)opp.id);
                    pdf.getParameters().put('ContractId',(String)objContract.id);
                    pdf.getParameters().put('SignerIp',ipAdress);
                    pdf.getParameters().put('acceptedTime',String.valueof((objContract.Accepted_Time__c).format('dd-MM-yyyy HH:mm:ss','Asia/Kolkata')) );
                    pdf.setRedirect(true);                      
                    // Returns the output of the page as a PDF
                    if(!test.isRunningTest()){
                        body = pdf.getContentAsPDF();
                    }else{
                        body = blob.toPdf('TEST');
                    } 
                    }
                }
                if(objAttachment!=null){
                    Attachment attach = new Attachment();
                    attach.Name = objAttachment.Name+'.pdf';
                    attach.ParentId = objAttachment.id;
                    attach.Body = body;    
                    insert attach;          
                } 
                /**SF-50 Starts: Add Contract attachments for the current Opportunity, under COB related list**/
                List <Attachment__c> attachmentRecordList = new List <Attachment__c>();
                List <Attachment__c> updateExtAttachments = new List <Attachment__c>();
                List <Customer_Onboarding__c> existingCOBList = new List <Customer_Onboarding__c>();
                Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c(); 
                existingCOBList = [SELECT Id, Opportunity__c FROM Customer_Onboarding__c WHERE Opportunity__c=:oppid LIMIT 1];
                system.debug('existingCOBList >>'+existingCOBList);
                if(!existingCOBList.isEmpty()){
                    objOnboarding = existingCOBList[0];
                    objAttachment.Customer_Onboarding__c = objOnboarding.Id;
                    update objAttachment;
                } 
                /**SF-50 Ends: Add Contract attachments for the current Opportunity, under COB related list**/    
                PageReference pageRef = new PageReference('/apex/ThankYouPage');
                pageRef.setRedirect(true);
                return pageRef;
            }
            catch(Exception e){
                //return null;
                system.debug('e.getLineNumber()-->'+e.getLineNumber());         
                Database.RollBack(sp);
                Error_Log__c objError = new Error_Log__c();
                objError.Type__c = 'Contract';
                objError.Stack_Trace__c = e.getStackTraceString();
                objError.Error_Message__c = e.getMessage();
                insert objError;
                return null;
            }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'A Contract for this Opportunity has already been accepted.'));
            bool = true;
            return null;
        }
    }
    //Submit signed Contract
    public PageReference submitSignedContract(){
       /* //isContactIdPresent = false;
        List <Contract__c> conRecordList = [Select id, Opportunity__c, Status__c from  contract__c where Opportunity__c =:oppid order by CreatedDate desc];
        system.debug('conRecordList B2B >>'+conRecordList);
        system.debug('opp.RecordType.Name >>'+opp.RecordType.Name);
        if(!conRecordList.isEmpty()){
            for(Contract__c contractRecord : conRecordList){
                if(contractRecord.Status__c == 'Accepted' && opp.RecordType.Name=='B2B' && isSoftApproval=='false'){
                    bool = true;
                    renderUploadButton = false;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload a signed contract.'));
                }else if(contractRecord.Status__c == 'Accepted' && opp.RecordType.Name!='B2B'){
                    bool = true;
                    renderUploadButton = false;
                }else if(contractRecord.Status__c != 'Accepted' && opp.RecordType.Name=='B2B' && isSoftApproval=='false'){
                    bool = true;
                    renderUploadButton = true;
                }
            }
        }
        system.debug('bool >>'+bool);
        system.debug('renderUploadButton >>'+renderUploadButton);
        
        system.debug('attachmentUpload >>'+attachmentUpload);
        //system.debug('attachmentUpload name >>'+attachmentUpload.name);
        if(attachmentUpload!=new Attachment() ){
            
            String attachmentName;
            String extension ='';
            String uploadedFileName ='';
            uploadedFileName = attachmentUpload.name;
            extension = uploadedFileName.substringafter('.');
            bl = true;
            objContract.Agreement_Signed_by_User_IP_Address__c =  ipAdress;
            objContract.Status__c = 'Accepted';
            //accepting time of contract
            objContract.Accepted_Time__c = System.Now();            
            update objContract;
            system.debug('objContract-->'+objContract );
            opp.Agreement_Signed_Date__c = System.Now();
            opp.StageName = 'Contract Signed';
            opp.Offline_Agreement__c = false;
            update opp; 
            //attachment string not to exceed the field limit
            attachmentName = 'Agreement - '+opp.Name;
            if(attachmentName.length()>40){
                //attachmentName.left(attachmentName.length()-10); 
                attachmentName = attachmentName.substring(0, Math.min(attachmentName.length(), 55));
                system.debug('in IF attachmentName-------->'+attachmentName);       
            }
            system.debug('attachmentName-------->'+attachmentName);
            system.debug('attachmentName.length()-------->'+attachmentName.length());
            attachmentName += ' '+objContract.Accepted_Time__c.format('dd-MM-yyyy HH:mm:ss','Asia/Kolkata');
            Attachment__c objAttachment = new Attachment__c();
            objAttachment.Contract__c = objContract.id;
            objAttachment.Type__c = 'Agreement';
            objAttachment.Name = attachmentName+'.'+extension;
            System.debug('objAttachment.Name------->'+objAttachment.Name);
            insert objAttachment;
            attachmentUpload.ParentId = objAttachment.Id;
            attachmentUpload.Name = objAttachment.Name;
            insert attachmentUpload;
            
            List <Attachment__c> attachmentRecordList = new List <Attachment__c>();
            List <Attachment__c> updateExtAttachments = new List <Attachment__c>();
            List <Customer_Onboarding__c> existingCOBList = new List <Customer_Onboarding__c>();
            Customer_Onboarding__c objOnboarding = new Customer_Onboarding__c();
            existingCOBList = [SELECT Id, Opportunity__c FROM Customer_Onboarding__c WHERE Opportunity__c=:oppid LIMIT 1];
            if(!existingCOBList.isEmpty()){
                objOnboarding = existingCOBList[0];
                if(!existingCOBList.isEmpty()){
                    objOnboarding = existingCOBList[0];
                    objAttachment.Customer_Onboarding__c = objOnboarding.Id;
                    update objAttachment;
                } 
            }
          
            objAttachment_SuccessList = new List <Attachment__c>();
            objAttachment_SuccessList = [SELECT Id, Dropbox_Link__c  FROM Attachment__c WHERE Contract__r.Opportunity__c =:oppid AND Contract__r.Status__c ='Accepted' LIMIT 1];
            if(!objAttachment_SuccessList.isEmpty()){
                objAttachment_Success = objAttachment_SuccessList[0];
            }
            renderUploadButton = false;
            PageReference pageRef = new PageReference('/apex/ThankYouPage');
            pageRef.setRedirect(true);
            return pageRef;
            
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please upload a signed contract.'));
            return null;
        } */
        return null;
    }
    //Method to track view of email Link
    public PageReference ViewTrack(){
        if(objContract.id!=null && opp.id!=null){
            // Added by Prakhar Goyal - Marking the contract link expired at the end of the month -SF-559
            system.debug('objContract-->'+objContract);
            if(objContract.Status__c =='Expired' && objContract.Type__c == 'Addendum'){
                system.debug('test');
                contractExpiry = true;
                bool = true;
                renderUploadButton = false;
                contractVisibility = false;
                PageReference pageRef = new PageReference('/SignContractPage/apex/ContractExpiryPage');
                pageRef.setRedirect(true);  
                return pageRef;
                
            }
            else if(objContract.Status__c =='Accepted' && objContract.Type__c == 'Addendum')
            {
                bool = true;
                renderUploadButton = false;
                contractVisibility = true;
                contractExpiry =  false;
                PageReference pageRef = new PageReference('/apex/ContractVisibilityPage');
                pageRef.setRedirect(true);   
                return pageRef;
                
            } 
            else if(objContract.Status__c!='Accepted' && objContract.Status__c!='Expired'){
                objContract.Status__c = 'Viewed';
            }else if(objContract.Status__c == 'Accepted'){
                bool = true;
            }
            objContract.LastViewed__c = System.Now(); 
            update objContract;
        }
        return null;
    }
}