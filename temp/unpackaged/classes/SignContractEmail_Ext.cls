/************************************************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: SignContractEmail_Ext
* Created Date: 17-May-2017
* Description: To send the contract agreement to Opportunity according to Account's Invoice Mode.    
*************************************************************************************************/
public class SignContractEmail_Ext
{
    public Opportunity opp{get;set;}
    public String billing{get;set;}
    public String oppid{get;set;}
    public List<OpportunityContactRole> contactRoleList{get;set;}
    public List<Contact> ListToSendEmail{get;set;}
    public Contract__c objContract{get;set;}
    public Contract__c objContract1{get;set;}
    public string selectedContactId {get;set;}
    public Contact contact {get;set;}
    public Boolean renderSendEmailMessage{get;set;}
    public Boolean setBack{get;set;}
    public Boolean isContractPresent{get;set;}
    public List<Contact> contactList{get;set;}
    public List<Contract__c> contractObjAddendum{get;set;}
    public List<Contract__c> contractObj{get;set;}
    public String msg{get;set;}
    public String successError{get;set;}
    public Boolean hasOLI{get;set;}
    public boolean showContent{get;set;}
    public String startDate{get;set;}
    public date effectiveDate{get;set;}
    public date endDate{get;set;}
    /*Contract - Soft Approval & Signed Contract*/
    public Boolean isValidated {get;set;}
    public Boolean isSoftApproval {get;set;}
    public String selectedValue {get;set;}
    public String selectedConID {get;set;}
    
    public SignContractEmail_Ext(ApexPages.standardController controller)
    {
        System.debug('Controller Refreshed');
        //Rendering the back link
        setBack = false;
        msg = '';
        hasOLI = false;
        showContent= false;
        successError = '';
        isContractPresent = true;
        startDate = null;
        //Rendering the select email block
        renderSendEmailMessage = false;
        contactRoleList = new List<OpportunityContactRole>();
        contactList = new List<Contact>();
        ListToSendEmail = new List<Contact>();
        //Current opportunity id
        oppid = ApexPages.currentPage().getParameters().get('id');
        //To fetch Invoice Mode picklist value from related account
        opp = [select id,Status__c,StageName,Account.Invoicing_Mode__c,State_Province__c,City__c,Street__c,Zip_Postal_Code__c,Country__c,Account.Name,HasOpportunityLineItem,Insurance_Required__c from Opportunity where id=:oppid];
        billing = opp.Account.Invoicing_Mode__c;
        //List of Contacts in Contact Role
        contactRoleList = [select id,ContactId from OpportunityContactRole where OpportunityId=:oppid];
        /*List<Contract__c> contractObj = [select id from Contract__c where Opportunity__c=:oppid];
if(contractObj.size()>0){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no Contract available for sending the Addendum.'));        
//return null;
}*/
        //Object to set Start and End time of Contract Agreement 
        objContract1 = new Contract__c();
        for(OpportunityContactRole ocr : contactRoleList){
            Contact c = [select id,Email,Name from Contact where id=:ocr.ContactId];  
            contactList.add(c);
        }
        system.debug('selectedValue  >>'+selectedValue );
        if(contactRoleList.size()==1) {
            renderSendEmailMessage = true;
            for(OpportunityContactRole ocr : contactRoleList){
                contact = [select id,Email,Name from Contact where id=:ocr.ContactId]; 
                system.debug('>>>>>>>>'+ contact);
            }
        }
        //Checking whether the contract has been send to the opportunity before or not
        contractObj = [select id from Contract__c where Opportunity__c=:oppid and (Type__c='Services Agreement' or Type__c='B2B')];
        contractObjAddendum = [select id,Type__c from Contract__c where Opportunity__c=:oppid and Type__c='Addendum'];
        /*  if(contractObj.size()>0){
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Contract Agreement already sent!'));
renderSendEmailMessage = true;
setBack = true;
}*/
        
        //Check if Addendum already sent
        /* if(contractObjAddendum.size()>0 && contractObj.size()>0)
{
renderSendEmailMessage = true;
setBack = true;
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Addendum for the Agreement is already sent!'));
}*/
        
    }
    
    //Based on Contract Type, update the flow of sending Contract for Signatures
    public void changeRadio(){
        system.debug('selectedValue  >>'+selectedValue );
        if(selectedValue == ''){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a contract type'));
        }
        if(selectedValue=='Soft Approval'){
            isSoftApproval = true;
        }else if(selectedValue=='Signed Contract'){
            isSoftApproval = false;
        }
        system.debug('selectedValue >>'+selectedValue);
        system.debug('isSoftApproval >>'+isSoftApproval);
    }
    
    public List<SelectOption> getContacts() {
        List<SelectOption> options = new List<SelectOption>(); 
        for(Contact objCon : contactList){
            options.add(new SelectOption(objCon.ID,objCon.Name)); 
        }
        return options; 
    }
    
    
    //To get the radio selected value
    public PageReference getSelectedContact() {
        //selectedContactId = ApexPages.currentPage().getParameters().get('accid'); 
        System.debug('selectedContactId>>>'+selectedConID);
        if(selectedConID==null){
            showContent = true;
            successError = 'error';
            msg ='No contact is selected.';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No contact is selected.'));
            return null;
        }else{
            contact = [select id,Email,Name from Contact where id=:selectedConID];
            System.debug('contact>>>>'+contact);
            return null;
        }
    }
    
    //To get the radio selected value
    public PageReference getSelected() {
        selectedContactId = ApexPages.currentPage().getParameters().get('accid'); 
        System.debug('selectedContactId>>>'+selectedContactId);
        if(selectedContactId==null){
            showContent = true;
            successError = 'error';
            msg ='No contact is selected.';
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No contact is selected.'));
            return null;
        }else{
            contact = [select id,Email,Name from Contact where id=:selectedContactId];
            System.debug('contact>>>>'+contact);
            return null;
        }
    }
    //Contract Agreement send method according to billing value
    public pageReference toSendEmail()
    {
        System.debug('objContract1.Start_Date__c>>>>'+objContract1.Start_Date__c);
        System.debug('objContract1.Start_Date__c>>>>'+objContract1.End_Date__c);
        System.debug('objContract1.Start_Date__c>>>>'+objContract1.Effective_Date__c);
        try{
            
            List<Contract__c> existingContractList = [select id, is_Latest_Contract__c from Contract__c where Opportunity__c=:oppid and Type__c!='B2B' AND Status__c!='Accepted'];
            
            List<Contract__c> updateContractOld = new List<Contract__c> ();
            if(!existingContractList.isEmpty()){
                for(Contract__c existingContractRecord : existingContractList){
                    existingContractRecord.is_Latest_Contract__c = false;
                    updateContractOld.add(existingContractRecord);
                }
                update updateContractOld;
            }
            
            List<Contract__c> contractObj = [select id from Contract__c where Opportunity__c=:oppid and Type__c='Services Agreement'];
            System.debug('contractObj>>>>'+contractObj.size());
            //checking whether the contract has been send to the opportunity before or not
            /* if(contractObj.size()>0){
showContent = true;
successError = 'error';
isContractPresent = false;
msg = 'Contract Agreement already sent!';
//ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Contract Agreement already sent!'));
setBack = true;
return null;
} 

else{

System.debug('contact>>>>'+contact);
if(contact!=null)
ListToSendEmail.add(contact);
else{

showContent = true;
successError = 'error';
msg ='No contact is selected.' ;
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No contact is selected.'));
return null;
}*/
            ListToSendEmail = new List<Contact>();
            List<Contract__c> contractList = [select id from Contract__c where Opportunity__c=:oppid and Type__c='Services Agreement' AND Status__c='Accepted'];
            System.debug('contractList for Standard and Express ->'+ contractList);
            //Insert Contract on First Sent
            if(contractList.size() == 0  ){
                if(contact!=null)
                    ListToSendEmail.add(contact);
                else{
                    showContent = true;
                    successError = 'error';
                    msg ='No contact is selected.' ;
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No contact is selected.'));
                    return null;
                }   
                System.debug('ListToSendEmail>>>>'+ListToSendEmail.size());
                if(ListToSendEmail.size()>0) { 
                    renderSendEmailMessage = true;
                    objContract = new Contract__c();
                    objContract.Status__c = 'Submitted';
                    objContract.Opportunity__c = opp.id;
                    objContract.Type__c = 'Services Agreement';
                    //objContract.Start_Date__c = startDate;
                    objContract.Start_Date__c = objContract1.Start_Date__c;
                    /*if((Date.valueOf(endDate) > Date.valueOf(startDate) && Date.valueOf(endDate) > Date.valueOf(effectiveDate)) || Date.valueOf(endDate) == null)
objContract.End_Date__c = endDate;
else{
showContent = true;
successError = 'error';
msg ='End date should be greater than Start date and Effective date.' ;
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date should be greater than Start date and Effective date.'));
setBack = false;
//renderSendEmailMessage = false;
return null;
}                    
if(effectiveDate!=null){
if(Date.valueOf(effectiveDate)>=Date.valueOf(startDate)){
objContract.Effective_Date__c = effectiveDate;
}
else{
showContent = true;
successError = 'error';
msg ='No contact is selected.' ;
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Effective date should be greater than Start date.'));
setBack = false;
//renderSendEmailMessage = false;
return null;
}
}else{
showContent = true;
successError = 'error';
msg ='Please enter the Effective date.' ;
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the Effective date.'));
setBack = false;
//renderSendEmailMessage = false;
return null;
}
for(Contact con : ListToSendEmail){
if(con!=null){
objContract.Contact__c = con.id;
}                       
}      
if(objContract.Start_Date__c==null){
showContent = true;
successError = 'error';
msg ='Please set the Start Date and End Date of Agreement.' ;
//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please set the Start Date and End Date of Agreement.'));
return null;
}   
else{         
insert objContract;
string[] toaddress;
for(Contact con : ListToSendEmail){
toaddress = New String[] {con.Email};
String subject = 'Contract Agreement for '+ opp.Account.Name + ' from Delhivery';
string htmlBody;
htmlBody = 'Hi '+con.Name+',<br/><br/>'+'Click on the link below to find the Contract agreement.<br/>'+'<a href='+Label.SiteURL+'/SignContractPage?id='+oppid+'&ContractId='+objContract.id+'>click here</a>';
//Send the email
EmailUtilityClass.SendEmail(toaddress,htmlBody,subject);
opp.Agreement_Start_Date__c = objContract.Start_Date__c;
opp.Agreement_End_Date__c= objContract.End_Date__c;
opp.Agreement_Effective_Date__c = objContract.Effective_Date__c;
objContract.Effective_Date__c = effectiveDate;
update opp;

showContent = true;
successError = 'success';
msg ='Contract Agreement sent to '+con.Email ;
//ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Contract Agreement sent to '+con.Email));
}
renderSendEmailMessage = true;  
setBack = true;
return null;
}*/
                    
                    objContract.LastViewed__c=null;
                    objContract.is_Latest_Contract__c=true;
                    if((objContract1.End_Date__c>objContract1.Start_Date__c && objContract1.End_Date__c>objContract1.Effective_Date__c) || objContract1.End_Date__c==null)
                        objContract.End_Date__c = objContract1.End_Date__c;
                    else{
                        showContent = true;
                        successError = 'error';
                        msg ='End date should be greater than Start date and Effective date.' ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date should be greater than Start date and Effective date.'));
                        setBack = false;
                        if(contactList.size()>1)
                            renderSendEmailMessage = false;
                        return null;
                    }                    
                    if(objContract1.Effective_Date__c!=null){
                        if(objContract1.Effective_Date__c>=objContract1.Start_Date__c){
                            objContract.Effective_Date__c = objContract1.Effective_Date__c;
                        }
                        else{
                            showContent = true;
                            successError = 'error';
                            msg ='Effective date should be greater than or Equal to Start date.' ;
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Effective date should be greater than Start date.'));
                            setBack = false;
                            if(contactList.size()>1)
                                renderSendEmailMessage = false;
                            return null;
                        }
                    }else{
                        showContent = true;
                        successError = 'error';
                        msg ='Please enter the Effective date.' ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the Effective date.'));
                        setBack = false;
                        if(contactList.size()>1)
                            renderSendEmailMessage = false;
                        return null;
                    }
                    for(Contact con : ListToSendEmail){
                        if(con!=null){
                            objContract.Contact__c = con.id;
                        }                       
                    }      
                    if(objContract.Start_Date__c==null){
                        showContent = true;
                        successError = 'error';
                        msg ='Please set the Start Date and End Date of Agreement.' ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please set the Start Date and End Date of Agreement.'));
                        setBack = false;
                        
                        return null;
                    }   
                    else{         
                        insert objContract;
                        string[] toaddress;
                        for(Contact con : ListToSendEmail){
                            toaddress = New String[] {con.Email};
                                String subject = 'Contract Agreement for '+ opp.Account.Name + ' from Delhivery';
                            string htmlBody;
                            htmlBody = 'Hi '+con.Name+',<br/><br/>'+'Click on the link below to find the Contract agreement.<br/>'+'<a href='+Label.SiteURL+'/SignContractPage?id='+oppid+'&ContractId='+objContract.id+'>click here</a>';
                            //Send the email
                            EmailUtilityClass.SendEmail(toaddress,htmlBody,subject);
                            opp.Agreement_Start_Date__c = objContract.Start_Date__c;
                            opp.Agreement_End_Date__c= objContract.End_Date__c;
                            opp.Agreement_Effective_Date__c = objContract.Effective_Date__c;
                            objContract.Effective_Date__c = objContract1.Effective_Date__c;
                            update opp;
                            isContractPresent = false;
                            showContent = true;
                            setBack = true;
                            successError = 'success';
                            msg ='Contract Agreement sent to '+con.Email ;
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Contract Agreement sent to '+con.Email));
                        }
                        renderSendEmailMessage = true;  
                        setBack = true;
                        return null;
                    }
                }
                else{
                    showContent = true;
                    successError = 'info';
                    msg ='There is no Contact role present for which Agreement need to be send' ;
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'There is no Contact role present for which Agreement need to be send'));  
                    return null;
                }
                return null;
            }else{
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, ''));  
                setBack = true;
                showContent = true;
                successError = 'info';
                msg ='Contract Agreement already Signed ' ;
                return null;
            }
        }catch(Exception e){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'There is no related Contact to send an agreement.'));
            return null;
        }
    }
    
    //Addendum Agreement send method
    public pageReference toSendAddendum()
    {
        
        try{ 
            
            System.debug('In Method toSendAddendum');
            List<Contract__c> contractObj = [select id from Contract__c where Opportunity__c=:oppid];
            System.debug('contractObj'+contractObj);
            //Sending addendum only if the contract has been send to the opportunity before
            if(contractObj.size()>0){
                ListToSendEmail = new List<Contact>();
                System.debug('contact'+contact);
                if(contact!=null)
                    ListToSendEmail.add(contact);
                else{
                    showContent = true;
                    successError = 'error';
                    msg ='No contact is selected.' ;
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No contact is selected.'));
                    return null;
                }
                
                System.debug('ListToSendEmail>>>>'+ListToSendEmail.size());
                
                //Send email if and only if the contact is there in Contact Role of Opportunity
                if(ListToSendEmail.size()>0) {  
                    if(contactRoleList.size()>1)
                        //renderSendEmailMessage = true;      
                        renderSendEmailMessage = false;                 
                    //Insert contract if no contract is there in Opportunity                
                    objContract = new Contract__c();
                    objContract.Status__c = 'Submitted';
                    objContract.Opportunity__c = opp.id;
                    objContract.Type__c = 'Addendum';
                    objContract.Start_Date__c = objContract1.Start_Date__c;
                    if((objContract1.End_Date__c>objContract1.Start_Date__c && objContract1.End_Date__c>objContract1.Effective_Date__c) || objContract1.End_Date__c==null)
                        objContract.End_Date__c = objContract1.End_Date__c;
                    else{
                        showContent = true;
                        successError = 'error';
                        msg ='End date should be greater than Start date and Effective date.' ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date should be greater than Start date and Effective date.'));
                        setBack = false;
                        if(contactRoleList.size()>1)
                            //renderSendEmailMessage = true;
                            renderSendEmailMessage = false;
                        return null;
                    }                    
                    if(objContract1.Effective_Date__c!=null){
                        
                        if(objContract1.Effective_Date__c>=objContract1.Start_Date__c){
                            objContract.Effective_Date__c = objContract1.Effective_Date__c;
                        }
                        else{
                            showContent = true;
                            successError = 'error';
                            msg ='Effective date should be greater than Start date.' ;
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Effective date should be greater than Start date.'));
                            setBack = false;
                            if(contactRoleList.size()>1)
                                //renderSendEmailMessage = true;
                                renderSendEmailMessage = false;
                            return null;
                        }
                    }else{
                        showContent = true;
                        successError = 'error';
                        msg ='Please enter the Effective date.' ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the Effective date.'));
                        setBack = false;
                        if(contactRoleList.size()>1)
                            //renderSendEmailMessage = true;
                            renderSendEmailMessage = false;
                        return null;
                    }
                    for(Contact con : ListToSendEmail){
                        if(con!=null){
                            objContract.Contact__c = con.id;
                        }
                    }
                    if(objContract.Start_Date__c==null){
                        showContent = true;
                        successError = 'error';
                        msg ='Please set the Start Date and End Date of Agreement.' ;
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please set the Start Date and End Date of Agreement.'));
                        return null;
                    }
                    else{
                        insert objContract;
                        string[] toaddress;
                        for(Contact con : ListToSendEmail){
                            if(con!=null){
                                toaddress = New String[] {con.Email};
                                    }
                            String subject = 'Addendum from Delhivery for '+opp.Account.Name;
                            string htmlBody;
                            htmlBody = 'Hi '+con.Name+',<br/><br/>'+'Click on the link below to find the Addendum.<br/>'+'<a href='+Label.SiteURL+'/SignContractPage/apex/AddendumPDF?id='+oppid+'&ContractId='+objContract.id+'&ContactId='+con.id+'>click here</a>';
                            //Send the email
                            EmailUtilityClass.SendEmail(toaddress,htmlBody,subject);
                            isContractPresent = false;
                            showContent = true;
                            successError = 'success';
                            msg ='Addendum sent to '+con.Email ;
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'Addendum sent to '+con.Email));
                        }
                        System.debug('contactRoleList.size()>>>'+contactRoleList.size());
                        //if(contactRoleList.size()>1){
                        renderSendEmailMessage = true;
                        setBack = true; 
                        //}
                        
                        return null;
                    }  
                }
                return null;
            }
            return null;
        }
        catch(Exception e){
            
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'Please Select one Contact to Send Agreement.'));
            return null;
        }
    }
    //B2B Agreement send method
    public pageReference toSendB2B()
    {
        System.debug('toSendB2B');
        try{
            System.debug('selectedValue -- >'+selectedValue);
            if(isSoftApproval==null || selectedValue ==''){
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select a contract type'));
                showContent = true;
                successError = 'error';
                msg ='Please select a contract type';
                setBack = true;
                return null;
            }else if(objContract1.Effective_Date__c == null || objContract1.End_Date__c == null){
                showContent = true;
                successError = 'error';
                msg ='Input Effective Start Date and End Date';
                setBack = false;
                return null;
            }
            
            List<Contract__c> contractObj = [select id from Contract__c where Opportunity__c=:oppid and Type__c='B2B'];
            System.debug('contractObj>> '+contractObj.size());
            
            ListToSendEmail = new List<Contact>();
            List<Contract__c> contractList = [select id, is_Latest_Contract__c from Contract__c where Opportunity__c=:oppid and Type__c='B2B' AND Status__c='Accepted'];
            
            List<Contract__c> existingContractListB2B = [select id, is_Latest_Contract__c from Contract__c where Opportunity__c=:oppid and Type__c='B2B' AND Status__c!='Accepted'];
            
            List<Contract__c> updateContractOldB2B = new List<Contract__c> ();
            if(!existingContractListB2B.isEmpty()){
                for(Contract__c existingContractRecord : existingContractListB2B){
                    existingContractRecord.is_Latest_Contract__c = false;
                    updateContractOldB2B.add(existingContractRecord);
                }
                update updateContractOldB2B;
            }
            
            System.debug('contractList for B2B ->'+ contractList);
            //Checking whether the contract has been send to the opportunity before or not
            system.debug('***********'+ contact);
            if(contractList.size()== 0 ){   
                if(contact!=null)
                    ListToSendEmail.add(contact);
                else{
                    showContent = true;
                    successError = 'error';
                    msg ='No contact is selected.';
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No contact is selected.'));
                    return null;
                }
                
                if(ListToSendEmail.size()>0) { 
                    renderSendEmailMessage = true;                
                    objContract = new Contract__c();
                    objContract.Status__c = 'Submitted';
                    objContract.Opportunity__c = opp.id;
                    objContract.Type__c = 'B2B';
                    objContract.LastViewed__c=null;
                    objContract.Start_Date__c = objContract1.Start_Date__c;
                    objContract.is_Latest_Contract__c = true;
                    if((objContract1.End_Date__c>objContract1.Start_Date__c && objContract1.End_Date__c>objContract1.Effective_Date__c) || objContract1.End_Date__c==null)
                        objContract.End_Date__c = objContract1.End_Date__c;
                    else{
                        showContent = true;
                        successError = 'error';
                        msg ='End date should be greater than Start date and Effective date.';
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'End date should be greater than Start date and Effective date.'));
                        setBack = false;
                        if(contactRoleList.size()>1)
                            renderSendEmailMessage = false;
                        
                        return null;
                    }                    
                    if(objContract1.Effective_Date__c!=null){
                        if(objContract1.Effective_Date__c>=objContract1.Start_Date__c){
                            objContract.Effective_Date__c = objContract1.Effective_Date__c;
                        }
                        else{
                            showContent = true;
                            successError = 'error';
                            msg ='Effective date should be greater than Start date.';
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Effective date should be greater than Start date.'));
                            setBack = false;
                            if(contactRoleList.size()>1)
                                renderSendEmailMessage = false;
                            
                            return null;
                        }
                    }else{
                        showContent = true;
                        successError = 'error';
                        msg ='Please enter the Effective date.';
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the Effective date.'));
                        setBack = false;
                        if(contactRoleList.size()>1)
                            renderSendEmailMessage = false;
                        
                        return null;
                    }
                    for(Contact con : ListToSendEmail){
                        
                        objContract.Contact__c = con.id;
                        
                    }      
                    if(objContract.Start_Date__c==null){
                        showContent = true;
                        successError = 'error';
                        if(contactRoleList.size()>1)
                            renderSendEmailMessage = false;
                        msg ='Please set the Start Date of Agreement.';
                        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please set the Start Date of Agreement.'));
                        return null;
                    }   
                    else{         
                        insert objContract;
                        
                        string[] toaddress;
                        for(Contact con : ListToSendEmail){
                            toaddress = New String[] {con.Email};
                                String subject = 'B2B Agreement for '+opp.Account.Name+' from Delhivery';
                            string htmlBody;
                            htmlBody = 'Hi '+con.Name+',<br/><br/>'+'Click on the link below to find the Contract agreement.<br/>'+'<a href='+Label.SiteURL+'/SignContractPage/apex/B2BAgreementPDF?id='+oppid+'&ContractId='+objContract.id+'&isSoftApproval='+isSoftApproval+'>click here</a>';
                            //Send the email
                            EmailUtilityClass.SendEmail(toaddress,htmlBody,subject);
                            opp.Agreement_Start_Date__c = objContract.Start_Date__c;
                            opp.Agreement_End_Date__c= objContract.End_Date__c;
                            opp.Agreement_Effective_Date__c = objContract.Effective_Date__c;
                            update opp;
                            isContractPresent = false;
                            showContent = true;
                            setBack = true;
                            hasOLI = true;
                            successError = 'success';
                            msg ='B2B Agreement sent to '+con.Email;
                            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.CONFIRM, 'B2B Agreement sent to '+con.Email));
                        }
                        renderSendEmailMessage = true;  
                        setBack = true;
                        
                        System.debug('renderSendEmailMessage>>>'+renderSendEmailMessage);
                        System.debug('hasOLI>>>'+hasOLI);
                        System.debug('setBack>>>'+setBack);
                        return null;
                    }
                }
                else{
                    showContent = true;
                    successError = 'info';
                    msg ='There is no Contact role present for which OnBoarding form need to be send';
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'There is no Contact role present for which OnBoarding form need to be send'));  
                    return null;
                }
                return null;
            }else{
                showContent = true;
                successError = 'info';
                msg ='Contract Agreement already Signed';
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Contract Agreement already Signed '));  
                setBack = true;
                return null;
            }
        }catch(Exception e){
            showContent = true;
            successError = 'warning';
            msg ='There is no related Contact to send an agreement.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.WARNING, 'There is no related Contact to send an agreement.'));
            return null;
        }
        return null;
    }
    //Back button method to redirect the page to the current record of Opportunity
    public pageReference backLink()
    {
        PageReference nextPage = new PageReference('/'+oppid);
        return nextPage;
    }
    
    public pageReference validateContractSigned(){
        
        if(contactList.size()>0){
            List<Contract__c> contractObj = [select id from Contract__c where Opportunity__c=:oppid];
            System.debug('Contractobj size '+contractObj.size());
            System.debug('opp.HasOpportunityLineItem'+opp.HasOpportunityLineItem);
            if(contractObj.size()<=0 ){//&& opp.HasOpportunityLineItem == false
                System.debug('Contractobj '+contractObj);
                isContractPresent = false;
                setBack = true;
                hasOLI = true;
                successError = 'error';
                msg ='There is no Contract available for sending the Addendum.';
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There is no Contract available for sending the Addendum.'));        
                return null;
            }
            
            if(opp.Country__c==null&&opp.state_province__c==null&&opp.city__c==null&&opp.Zip_Postal_Code__c==null&&opp.Street__c==null)
            {
                hasOLI=true;
                successError='error';
                msg='Please enter address details fields(Country, State, City,Zipcode and Street) in Opportunity';
                return null;
            }else{
                if(opp.Country__c==null)
                {
                    hasOLI=true;
                    successError='error';
                    msg='Please enter Country in Opportunity';
                    return null;
                }
                if(opp.Zip_Postal_Code__c==null)
                {
                    hasOLI=true;
                    successError='error';
                    msg='Please enter Zipcode in Opportunity';
                    return null;
                }
                if(opp.City__c==null)
                {
                    hasOLI=true;
                    successError='error';
                    msg='Please enter City in Opportunity';
                    return null;
                }
                if(opp.state_province__c==null)
                {
                    hasOLI=true;
                    successError='error';
                    msg='Please enter State/Province in Opportunity';
                    return null;
                }
                if(opp.Street__c==null)
                {
                    hasOLI=true;
                    successError='error';
                    msg='Please enter Street in Opportunity';
                    return null;
                }
            }
            
            if(opp.HasOpportunityLineItem == false){
                hasOLI = true;
                successError = 'error';
                msg ='No pricing is available to send a Addendum';
                return null;
            }
            
        }else{
            System.debug('In Else>>');
            hasOLI = true;
            successError = 'info';
            msg ='There is no Contact associated to Opportunity for sending the Agreement.';
            return null;
        }
        
        if(opp.Status__c == 'Corporate Rejected'){ 
            //alert('Pricing is rejected. Please contact System Administrator'); 
            hasOLI = true; 
            successError = 'warning';
            msg ='Pricing is rejected. Please contact System Administrator.';
            return null;
        }else if(opp.Status__c != 'Corporate Approved'){ 
            //alert('There is no approved Pricing. Please contact System Administrator'); 
            hasOLI = true; 
            successError = 'warning';
            msg ='There is no approved Pricing. Please contact System Administrator.';
            return null;
        } 
        //sendContract();   
        return null;
    }
    
    public PageReference sendContract(){
        PageReference pageRef;
        if(opp.Status__c == 'Corporate Rejected'){ 
            //alert('Pricing is rejected. Please contact System Administrator'); 
            hasOLI = true; 
            successError = 'warning';
            msg ='Pricing is rejected. Please contact System Administrator.';
            return null;
        } 
        
        else if(opp.Status__c != 'Corporate Approved'){ 
            //alert('There is no approved Pricing. Please contact System Administrator'); 
            hasOLI = true; 
            successError = 'warning';
            msg ='There is no approved Pricing. Please contact System Administrator.';
            return null;
        } 
        
        else if(opp.HasOpportunityLineItem){ 
            
            if(opp.StageName == 'Commercials Agreed'){ 
                if(opp.Status__c == 'Corporate Rejected'){
                    //alert('Pricing is rejected. Please contact System Administrator');    
                    hasOLI = true; 
                    successError = 'warning';
                    msg ='Pricing is rejected. Please contact System Administrator.';
                    return null;
                }
                else{
                    //window.open('/apex/SignContractEmail?id={!Opportunity.Id}','_blank');
                    return null;
                }
            }else if(opp.StageName == 'Contract Signed'){ 
                //alert('You have already Signed the Contract'); 
                hasOLI = true; 
                successError = 'warning';
                msg ='You have already Signed the Contract.';
                return null;
            }
            else{ 
                //alert('Please get pricing approved'); 
                hasOLI = true; 
                successError = 'warning';
                msg ='Please get pricing approved.';
                return null;
            } 
        } 
        else{
            hasOLI = true; 
            successError = 'warning';
            msg ='No pricing is available to send a Agreement.';
            return null;
            //alert('No pricing is available to send a Agreement.'); 
        }
        
    }
    
}