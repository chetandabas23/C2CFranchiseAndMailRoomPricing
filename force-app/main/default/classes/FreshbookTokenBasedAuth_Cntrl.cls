/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Atul Dobhal)
* Class Name: FreshbookTokenBasedAuth_Cntrl
* Created Date: 19-Mar-2017
* Description: Controller to create client on button click for freshbooks
*************************************************************************/
public class FreshbookTokenBasedAuth_Cntrl {
    private string authToken;
    private string url;
    public string client_Id;
    public String Xml;
    public string basicAuthToken;
    public static boolean isFRSGeneration = false;
    public FreshbookTokenBasedAuth_Cntrl(Apexpages.StandardController Controller){
        
    }
    
    public void pushDataFreshbooks(){
        Blob basiAuth;
        HttpResponse responseFile;
        String successResponseXML;
        String Frs_Code;
        Set<Id> cobAccountSet = New Set<Id>();
        client_Id = ApexPages.currentPage().getParameters().get('Id');
        authToken = getFreshBookToken() + ':X';
        
        url = getFreshBookURL();
        List<Account> serviceAccountList = New  List<Account>();
        List<Account> updateRestServiceAcc = New  List<Account>();
        List<Customer_Onboarding__c> updateRestCOBList = New  List<Customer_Onboarding__c>();
        List<Customer_Onboarding__c> coBList = New List<Customer_Onboarding__c>();
        
        Customer_Onboarding__c objCustomer = [SELECT Id,Account__r.Name,Account__r.parent.Name,FRS_Code__c, Account__r.Id, Email__c,Contact_number__c,Registered_Address_Country__c,Registered_Address_City__c, Registered_Address_Line_1__c, Registered_Address_Line_2__c, Registered_Address_Postal_Code__c, Registered_Address_State__c, VAT_Number__c, Account__r.FRS_Code__c, Account__r.ParentId, Account__r.Parent.FRS_Code__c, Company_Registered_Name__c FROM Customer_Onboarding__c WHERE Id =: Client_Id];
        
        /* Account objAccount = [SELECT Id, ParentId, FRS_Code__c FROM Account WHERE Id =: objCustomer.Account__r.Id];
        Account objOperatingAccount = [SELECT Id, FRS_Code__c FROM Account WHERE Id =: objAccount.ParentId]; */
        
        if(objCustomer!=null){
            if(objCustomer.Account__c!= null && objCustomer.Account__r.ParentId!=null){
                serviceAccountList = [SELECT Id, FRS_Code__c FROM Account WHERE ParentId =: objCustomer.Account__r.ParentId];
            }
            if(!serviceAccountList.isEmpty()){
                for(Account objAcc : serviceAccountList){
                    cobAccountSet.add(objAcc.Id);    
                }
            }
            
            if(cobAccountSet.size()>0){
                coBList = [SELECT Id, FRS_Code__c FROM Customer_Onboarding__c WHERE Account__c IN: cobAccountSet AND Id!=:Client_Id];
                system.debug('FRS'+objCustomer.FRS_Code__c);
            }
        }
        
        
        
        
        if(objCustomer.FRS_Code__c != null && objCustomer.FRS_Code__c !=''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Already synced to freshbooks')); 
        }else{
            system.debug('client_Id--->'+client_Id);
            Xml = XmlgeneratorUtility.generateXML(objCustomer);
            system.debug('Xml--->'+Xml);
            
            basiAuth = blob.valueof(authToken);
            basicAuthToken = EncodingUtil.base64Encode(basiAuth);
            
            try{
                HttpRequest request = new HttpRequest();
                request.setEndpoint(url);
                request.setMethod('POST');
                request.setHeader('Content-Type','text/xml');
                request.setHeader('Authorization','Basic ' + basicAuthToken );
                request.setBody(Xml);
                system.debug('request'+request);
                if(!test.isRunningTest()){
                    responseFile = new Http().send(request);
                    successResponseXML = responseFile.getBody();
                    Frs_Code = XMLParser.parse(successResponseXML);
                    system.debug('Frs_Code-->'+Frs_Code);
                    Frs_Code = Frs_Code.substringAfter( 'Element: client_id');
                    system.debug('Frs_Code-->'+Frs_Code);
                }else{
                    Frs_Code = '1234';
                }
                
                /* objAccount.FRS_Code__c = Frs_Code;
                update objAccount;
                
                objOperatingAccount.FRS_Code__c = Frs_Code;
                update objOperatingAccount; */
                
                objCustomer.FRS_Code__c = Frs_Code;
                objCustomer.Account__r.FRS_Code__c = Frs_Code;
                objCustomer.Account__r.Parent.FRS_Code__c = Frs_Code;
                isFRSGeneration = true;
                update objCustomer;
                update objCustomer.Account__r;
                update objCustomer.Account__r.Parent;
                
                system.debug('objCustomer >>'+objCustomer);
                system.debug('objCustomer.Account__r.FRS_Code__c >>'+objCustomer.Account__r.FRS_Code__c);
                system.debug('objCustomer.Account__r.Parent.FRS_Code__c >>'+objCustomer.Account__r.Parent.FRS_Code__c);
                system.debug('serviceAccountList >>'+ serviceAccountList);
                system.debug('coBList >>'+ coBList);
                system.debug('updateRestCOBList >>'+ updateRestCOBList);
                
                for(Account objServiceAccount : serviceAccountList){
                    //if(objServiceAccount.FRS_Code__c == Null || objServiceAccount.FRS_Code__c ==''){
                        objServiceAccount.FRS_Code__c = Frs_Code; 
                        updateRestServiceAcc.add(objServiceAccount);    
                    //}
                    
                }
                
                system.debug('updateRestServiceAcc >>'+updateRestServiceAcc);
                if(!updateRestServiceAcc.isEmpty()){
                    update updateRestServiceAcc;
                }
                
                if(!coBList.isEmpty()){
                    for(Customer_Onboarding__c objNewCOB : coBList){
                        //if(objNewCOB.FRS_Code__c == Null || objNewCOB.FRS_Code__c ==''){
                            objNewCOB.FRS_Code__c = Frs_Code;
                            updateRestCOBList.add(objNewCOB);
                        //}
                    }
                }
                
            
                system.debug('updateRestCOBList >>'+updateRestCOBList);
                if(!updateRestCOBList.isEmpty()){
                    update updateRestCOBList;
                }
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Sync to freshbooks'));
            }catch(Exception e){
                system.debug('Error-->'+e.getStackTraceString());
                system.debug('Error-->'+e.getMessage());
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Something went wrong, please connect with your System Administrator'));    
            }
        }
    }
    
    public static string getFreshBookToken(){
        //if(!test.isRunningTest()){
            return [select Authentication_Token__c from Freshbooks__c where Name__c = 'FreshBooks'].Authentication_Token__c;
        /*}else{
            return null;
        }*/
    }
    
    public static string getFreshBookURL(){
        //if(!test.isRunningTest()){
            return [select Enpoint_URL__c from Freshbooks__c where Name__c = 'FreshBooks'].Enpoint_URL__c;
        /*}else{
            return null;
        }*/
    }
}