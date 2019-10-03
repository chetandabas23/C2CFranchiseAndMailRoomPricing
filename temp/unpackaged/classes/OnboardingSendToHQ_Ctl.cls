public class OnboardingSendToHQ_Ctl {
    public Customer_Onboarding__c objOnboarding{get;set;}
    public List<String> strList {get;set;}
    public List<Account> accountList;
    public List<Account> operatingAccountList;
    public String DesiredHqName;
    public Error_Log__c errorRecord;
    public static boolean isHQUpdate = false;
    String invoicingMode ='';
    public OnboardingSendToHQ_Ctl(ApexPages.StandardController controller) {
        objOnboarding = (Customer_Onboarding__c) controller.getRecord();
        accountList = new List<Account>();
        operatingAccountList = new List<Account>();
        strList = new List<String>();
        DesiredHqName='';
        errorRecord = new Error_Log__c();
        //List<Customer_Onboarding__c> listOnBoarding = [select id,Email__c,Contact__r.Name from Customer_Onboarding__c where Id=:objOnboarding.Id];
        
        List<Customer_Onboarding__c> listOnBoarding =  getOnBoardingRecord(objOnboarding.Id);
        
        if(listOnBoarding!=null && listOnBoarding.size()>0){
            objOnboarding = listOnBoarding[0];
        }
        //sendToHQ();
    }
    
    public List<Customer_Onboarding__c> getOnBoardingRecord(Id recId){
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        DescribeSObjectResult describeResult = Customer_Onboarding__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        system.debug('fieldNames****** '+fieldNames);
        String query = 'SELECT ' + String.join( fieldNames, ',' );
        query += ',Opportunity__r.Client_Category__c,  Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Email__c,Account__r.Phone__c,Account__r.Name, Opportunity__r.Operating_Account__c, Opportunity__r.StageName, Opportunity__r.Sub_Category__c ';
        query += ' FROM '+ describeResult.getName() + ' WHERE id = '+ '\''+ recId + '\''; 
        System.debug('Query ->'+query);
        try{
            listOnboarding = Database.query(query);
            
        }catch(Exception e){
            system.debug('Error caught >>'+e);
        }
        return listOnboarding;
    }
    
    public pagereference sendToHQ(){
        system.debug('objOnboarding in sendToHQ >>'+objOnboarding);
        system.debug('objOnboarding in sendToHQ objOnboarding.Account__c >>'+objOnboarding.Account__c);
        map<String, String> mapRequestBody = new map<String, String>();
         if(objOnboarding.FRS_Code__c ==null || objOnboarding.FRS_Code__c ==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please generate the FRS code and try again.'));
            return null;
        }
        if(objOnboarding.Status__c == 'Draft'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The Customer Onboarding form is in Draft state. To send it to HQ, please submit the form and try again.'));
            return null;
        }
        if((objOnboarding.Is_Prepaid__c == true || objOnboarding.Invoicing_Mode__c=='COD Net-off' || objOnboarding.Invoicing_Mode__c=='Delhivery Miles')&& objOnboarding.Wallet_Notification_Email__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter wallet notification email and try again.'));
            return null;
        }
        if((objOnboarding.Is_Prepaid__c == true || objOnboarding.Invoicing_Mode__c=='COD Net-off' || objOnboarding.Invoicing_Mode__c=='Delhivery Miles') && objOnboarding.Wallet_Notification_Mobile__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter wallet notification Mobile and try again.'));
            return null;
        }
        if(objOnboarding.Email__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter email and try again.'));
            return null;
        }
        
        if(objOnboarding.Contact__c==null || objOnboarding.Report_Recipients__c==null ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select Contact/Report Recipients Email and try again.'));
            return null;
        }
        if(objOnboarding.Invoicing_Mode__c==null || objOnboarding.Invoicing_Mode__c==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select Invoicing mode and try again.'));
            return null;
        }
        if(objOnboarding.Billing_Mode__c == null){
            String err = 'Please select correct billing mode.';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err));
            return null;
        }
        
        if(objOnboarding.X_Ray_Limit__c == null){ 
            String err = 'Please enter X-Ray Limit';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err));
            return null;
        }
        
        if(objOnboarding.Account__c == null){
            String err = 'Please add a Service Account to this Customer Onboarding record';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err));
            return null;
        }
        
        if(objOnboarding.Account__r.Email__c == null && objOnboarding.Account__r.Phone__c == null){
            String err = 'Please enter the email or phone for related Account before you sync it to HQ - <a href="/'+objOnboarding.Account__c+'">'+objOnboarding.Account__r.Name+'</a>';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err));
            return null;
        }
        
        if(objOnboarding.Desired_HQ_Name__c == null){
            String err = 'Please enter Desired HQ Name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err));
            return null;
        }
        
         if(objOnboarding.IsDocuments_Verified__c == false){
            String err = 'Cob\'s documents are not verfied yet. ';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err));
            return null;
        } 
        
        
        HQ_API__c hqAPI = HQ_API__c.getValues('Create');
        HttpResponse reseponseBody ;
        DesiredHqName = (objOnboarding.Desired_HQ_Name__c).replaceAll(' \\s+', ' '); 
        System.debug('DesiredHqName ->'+DesiredHqName);
        if(DesiredHqName.length()>= 30 ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter a short Desired HQ Name'));
            return null;    
        }
        if(objOnboarding.Client_Id__c == null || objOnboarding.Client_Id__c == '' ){
            String requestBody;
            //if(objOnboarding.X_Ray_Limit__c != null)
            //requestBody = '{"report_recipients":"'+objOnboarding.Email__c+'","client_name":"'+DesiredHqName +'","client_first_name":"'+objOnboarding.Contact__r.FirstName +'","client_last_name":"'+objOnboarding.Contact__r.LastName +'","billing_mode":"'+objOnboarding.Billing_Mode__c+'","xray_amount_limit":"'+objOnboarding.X_Ray_Limit__c+'"}';
            
            //SF-211: Updated Request body to HQ
            if(objOnboarding.Invoicing_Mode__c=='COD Net-off'){
                invoicingMode = 'cod_netoff';
            }else if(objOnboarding.Invoicing_Mode__c=='Delhivery Miles'){
                invoicingMode = 'prepaid';
            }else if(objOnboarding.Invoicing_Mode__c=='Monthly Invoiced'){
                invoicingMode = 'postpaid';
            }else{
                invoicingMode = objOnboarding.Invoicing_Mode__c;
            }
            if((objOnboarding.Opportunity_Record_Type__c=='Standard Shipping' || objOnboarding.Opportunity_Record_Type__c=='Express Shipping') && objOnboarding.Opportunity_Owner__c !='XB Onboarding' ){
                List<OpportunityLineItem> oliItem=[SELECT Id, OpportunityId, IsActive__c,Qr_Code__c,Payment_Link__c FROM OpportunityLineItem where IsActive__c=true and OpportunityId=:objOnboarding.Opportunity__c limit 1];
                If(oliItem.size()>0){
                    requestBody = '{"report_recipients":"'+objOnboarding.Email__c+'","client_name":"'+DesiredHqName +'","client_first_name":"'+objOnboarding.Contact__r.FirstName +'","client_last_name":"'+objOnboarding.Contact__r.LastName +'","billing_mode":"'+objOnboarding.Billing_Mode__c+'","xray_amount_limit":'+objOnboarding.X_Ray_Limit__c+',"client_type":"'+objOnboarding.Opportunity__r.Client_Category__c+'","billing_method":"'+invoicingMode+'","salesforce_id":"'+objOnboarding.Account__c+'","wallet_provider":"'+'DEL-MILES'+'","phone":"'+String.valueOf(objOnboarding.Contact_number__c)+'","wallet_notification_mobile":"'+String.valueOf(objOnboarding.Wallet_Notification_Mobile__c)+'","wallet_notification_email":"'+String.valueOf(objOnboarding.Wallet_Notification_Email__c)+'","qrod":'+oliItem[0].Qr_Code__c+',"plod":'+oliItem[0].Payment_Link__c+',"bank_detail":{"ifsc_code": "'+objOnboarding.RTGS_IFSC_code__c+'","bank_name":"'+objOnboarding.Bank_name__c+'","beneficiary_name":"'+objOnboarding.Beneficiary_name__c+'","account_number":"'+objOnboarding.Bank_A_c_Number__c+'"}'+'}';
                }else{
                    requestBody = '{"report_recipients":"'+objOnboarding.Email__c+'","client_name":"'+DesiredHqName +'","client_first_name":"'+objOnboarding.Contact__r.FirstName +'","client_last_name":"'+objOnboarding.Contact__r.LastName +'","billing_mode":"'+objOnboarding.Billing_Mode__c+'","xray_amount_limit":'+objOnboarding.X_Ray_Limit__c+',"client_type":"'+objOnboarding.Opportunity__r.Client_Category__c+'","billing_method":"'+invoicingMode+'","salesforce_id":"'+objOnboarding.Account__c+'","wallet_provider":"'+'DEL-MILES'+'","phone":"'+String.valueOf(objOnboarding.Contact_number__c)+'","wallet_notification_mobile":"'+String.valueOf(objOnboarding.Wallet_Notification_Mobile__c)+'","wallet_notification_email":"'+String.valueOf(objOnboarding.Wallet_Notification_Email__c)+'","qrod":'+'false'+',"plod":'+'false'+',"bank_detail":{"ifsc_code": "'+objOnboarding.RTGS_IFSC_code__c+'","bank_name":"'+objOnboarding.Bank_name__c+'","beneficiary_name":"'+objOnboarding.Beneficiary_name__c+'","account_number":"'+objOnboarding.Bank_A_c_Number__c+'"}'+'}';
                }
            }else{
                requestBody = '{"report_recipients":"'+objOnboarding.Email__c+'","client_name":"'+DesiredHqName +'","client_first_name":"'+objOnboarding.Contact__r.FirstName +'","client_last_name":"'+objOnboarding.Contact__r.LastName +'","billing_mode":"'+objOnboarding.Billing_Mode__c+'","xray_amount_limit":'+objOnboarding.X_Ray_Limit__c+',"client_type":"'+objOnboarding.Opportunity__r.Client_Category__c+'","billing_method":"'+invoicingMode+'","salesforce_id":"'+objOnboarding.Account__c+'","wallet_provider":"'+'DEL-MILES'+'","phone":"'+String.valueOf(objOnboarding.Contact_number__c)+'","wallet_notification_mobile":"'+String.valueOf(objOnboarding.Wallet_Notification_Mobile__c)+'","wallet_notification_email":"'+String.valueOf(objOnboarding.Wallet_Notification_Email__c)+'"}';
            }
                      
            //else
            //    requestBody = '{"report_recipients":"'+objOnboarding.Email__c+'","client_name":"'+DesiredHqName +'","client_first_name":"'+objOnboarding.Contact__r.FirstName +'","client_last_name":"'+objOnboarding.Contact__r.LastName +'","billing_mode":"'+objOnboarding.Billing_Mode__c+'","xray_amount_limit":"'+Integer.valueOf("0")+'"}';
            System.debug('requestBody--->'+requestBody);
            String errorMsg = '';
            JSONParser parser;
            if(!Test.isRunningTest()){
                system.debug('--hqAPI.URL__c--'+hqAPI.URL__c);
                reseponseBody = CallOutUtil.calloutMethod(hqAPI.URL__c,requestBody);
                System.debug('reseponseBody ->'+reseponseBody);
                parser = JSON.createParser(reseponseBody.getBody());
                system.debug('---responsebody-1-'+reseponseBody.getBody());
                if(reseponseBody.getStatus()== 'BAD REQUEST'){
                    
                    // Get the value.
                    system.debug('---responsebody-BADREQ-'+reseponseBody.getBody());
                    parser.nextToken();
                    errorMsg = parser.getText();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Something went wrong. Please check Error logs for more information.'));
                    errorRecord = new Error_Log__c();
                    errorRecord.Type__c = 'HQ';
                    errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ reseponseBody.getBody() + '. Please check following data for null values: Onboarding Email, Onboarding Desired HQ Name, Onboarding Contact First/Last Name, Billing Mode, XRay Amount Limit and Email on Onboarding. Or else, update the HQ name and try again ';
                    //errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ errorMsg + '. Please check following data for null values: Onboarding Email, Onboarding Desired HQ Name, Onboarding Contact First/Last Name, Billing Mode, XRay Amount Limit and Email on Onboarding. Or else, update the HQ name and try again ';
                    insert errorRecord;
                    return null;
                    
                }
            
            }else{
                reseponseBody = new HttpResponse();
                String body = '{"updated_data":{"reg_name":"we","postal_cat":"CatB","rem_email":"r@gmail.com","allow_no_data":true,"vat_number":2322,"cst_number":234,"dto_email_recipients":"b@h.com","send_sms_cod":true,"push_url":"ew","report_recipients":"n@gmail.com, new@gmail.com","eco_code":3243,"mps_service":true,"rto_email_recipients":"a@gmail.com","send_sms_prepaid":true,"send_sms_reverse":true,"send_mail_pickup":true,"address":"weq","frs_code":3234,"return_add":"weq","upload_recipients":"wer@gmail.com","product_type":"B2B","ndr_report_recipients":"net@gmail.com","auto_pickup":true,"send_sms_cash":true,"send_sms_ndr":true},"name":"client2221 new test","success":true,"error":""}';
                reseponseBody.setBody(body);
            }  
            
            String clientUMS;
            String clientCMS;
            String UserName;
            // Parse the JSON response
            System.debug('objOnboarding.Client_Id__c !!!!!! out if '+objOnboarding.Client_Id__c);
            System.debug('objOnboarding.Client_Id__c !!!!!! In if '+objOnboarding.Client_Id__c);
            
            system.debug('---responsebody--'+reseponseBody.getBody());
            parser = JSON.createParser(reseponseBody.getBody());
            System.debug('parser>>'+parser);
            while (parser.nextToken() != null) {
                //System.debug('parser.getCurrentToken()  '+parser.getCurrentToken());
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'error')) {
                    parser.nextToken();
                    If(parser.getText()=='client already exist in ums'){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Client already exists'));
                            errorRecord = new Error_Log__c();
                            errorRecord.Type__c = 'HQ';
                            errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ parser.getText();
                            insert errorRecord;
                            return null;
                    }
                    
                    
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'username')) {
                    system.debug('parser.getText()@@'+parser.getText());
                    // Get the value.
                    parser.nextToken();
                    objOnboarding.CL_PANEL_User_Name__c = parser.getText();
                    UserName = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'user_uuid')) {
                    system.debug('parser.getText()@@'+parser.getText());
                    // Get the value.
                    parser.nextToken();
                    objOnboarding.HQ_UUID__c = parser.getText();
                    clientUMS = parser.getText();
                }
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'uuid')) {
                    system.debug('parser.getText()@@'+parser.getText());
                    // Get the value.
                    parser.nextToken();
                    objOnboarding.Client_Id__c = parser.getText();
                    clientCMS = parser.getText();
                }
                
            }
            
            //for client user id
            // Parse the JSON response
            
            /*JSONParser parser = JSON.createParser(reseponseBody.getBody());
while (parser.nextToken() != null) {
System.debug('parser.getCurrentToken()  '+parser.getCurrentToken());
if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
(parser.getText() == 'non_field_errors')) {
parser.nextToken();

if(parser.getText()=='['){
parser.nextToken();
System.debug('parser.getText() ******** '+parser.getText() );
System.debug('parser.getCurrentToken()  '+parser.getCurrentToken()); 
if(parser.getText()=='Client user id already exists'){
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Client user id already exists'));
return null;
}
} 
}
if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
(parser.getText() == 'client_user_name')) {
system.debug('parser.getText()@@'+parser.getText());
// Get the value.
parser.nextToken();
objOnboarding.Client_User_Id__c = parser.getText();
clientUser = parser.getText();

}
}           
*/
            //if((objOnboarding.Client_User_Id__c == null || objOnboarding.Client_User_Id__c == '') && (objOnboarding.Client_User_Id__c == null || objOnboarding.Client_User_Id__c == '')){
            //update objOnboarding;
            if(clientCMS!='' || clientCMS!=null){
                objOnboarding.Status__c = 'Synced to HQ';
                UpdatingHQ(clientCMS,UserName,clientUMS);
            }
        }else
        {
            System.debug('objOnboarding.Client_Id__c>>>>>>'+objOnboarding.Client_Id__c);
            System.debug('objOnboarding.Client_User_Id__c>>>>>>'+objOnboarding.Client_User_Id__c);
            UpdatingHQ(objOnboarding.Client_Id__c,objOnboarding.Client_User_Id__c,objOnboarding.HQ_UUID__c); 
        }
        return null;
    }
    
    
    public pagereference UpdatingHQ(string client,string clientUser,string clientums){
        HQ_API__c hqAPI = HQ_API__c.getValues('Update');
        
        system.debug('---inside updatinghq()----');
        system.debug('---inside updatinghq()client----'+client);
        system.debug('---inside updatinghq()clientUser----'+clientUser);
        //map<String, String> mapRequestBodyone = new map<String, String>();    
        //if(objOnboarding.Client_Id__c!=null){
        
        OnBoardingWrapper objOnBoardingWrapper = new OnBoardingWrapper();
        
        objOnBoardingWrapper.ndr_report_recipients = objOnboarding.NDR_report_recipients__c;
        objOnBoardingWrapper.report_recipients = objOnboarding.Report_Recipients__c;    //n@gmail.com, new@gmail.com
        objOnBoardingWrapper.rto_email_recipients = objOnboarding.RTO_email_recipients__c;  //a@gmail.com
        objOnBoardingWrapper.dto_email_recipients = objOnboarding.DTO_email_recipients__c;  //b@h.com
        objOnBoardingWrapper.rem_email = objOnboarding.REM_email__c;    //r@gmail.com
        objOnBoardingWrapper.upload_recipients = objOnboarding.Upload_Recipients__c;    //wer@gmail.com
         if((objOnboarding.Opportunity_Record_Type__c=='Standard Shipping' || objOnboarding.Opportunity_Record_Type__c=='Express Shipping') && objOnboarding.Opportunity_Owner__c !='XB Onboarding' ){
            List<OpportunityLineItem> oliItem=[SELECT Id, OpportunityId, IsActive__c,Qr_Code__c,Payment_Link__c FROM OpportunityLineItem where IsActive__c=true and OpportunityId=:objOnboarding.Opportunity__c limit 1];
            OnBoardingWrapper.cls_bank_detail bank_detail=new OnBoardingWrapper.cls_bank_detail();
                bank_detail.ifsc_code=objOnboarding.RTGS_IFSC_code__c;
                bank_detail.bank_name=objOnboarding.Bank_name__c;
                bank_detail.beneficiary_name=objOnboarding.Beneficiary_name__c;
                bank_detail.account_number=objOnboarding.Bank_A_c_Number__c;
                objOnBoardingWrapper.bank_detail=bank_detail;
            If(oliItem.size()>0){
                objOnBoardingWrapper.plod=oliItem[0].Payment_Link__c;
                objOnBoardingWrapper.qrod=oliItem[0].Qr_Code__c;
            }else{
                objOnBoardingWrapper.plod=false;
                objOnBoardingWrapper.qrod=false;
            }
            
        }else{
            objOnBoardingWrapper.plod=false;
            objOnBoardingWrapper.qrod=false;
        }
        
        if(objOnboarding.VAT_Number__c != null && objOnboarding.VAT_Number__c != ''){
            objOnBoardingWrapper.vat_number = Integer.ValueOf(objOnboarding.VAT_Number__c.trim()); //2322
        }
        if(objOnboarding.CST_Number__c != null && objOnboarding.CST_Number__c != ''){
            objOnBoardingWrapper.cst_number = Integer.ValueOf(objOnboarding.CST_Number__c.trim()); //234
        }
        if(objOnboarding.Eco_Code__c != null && objOnboarding.Eco_Code__c != ''){
            objOnBoardingWrapper.eco_code = Integer.ValueOf(objOnboarding.Eco_Code__c.trim()); //3243
        }
        if(objOnboarding.FRS_Code__c != null && objOnboarding.FRS_Code__c != ''){
            objOnBoardingWrapper.frs_code = Integer.ValueOf(objOnboarding.FRS_Code__c.trim()); //3234
        }
        objOnBoardingWrapper.return_add = objOnboarding.Return_Address__c;  //weq
        String address='';
        if(objOnboarding.Registered_Address_Line_1__c != null  && objOnboarding.Registered_Address_Line_1__c !=''){
            
            address = objOnboarding.Registered_Address_Line_1__c;
        }
        if(objOnboarding.Registered_Address_Line_2__c != null  && objOnboarding.Registered_Address_Line_2__c !=''){
            address = address +', '+objOnboarding.Registered_Address_Line_2__c;
        }
        if(objOnboarding.Registered_Address_City__c != null  && objOnboarding.Registered_Address_City__c !=''){
            address = address +', '+objOnboarding.Registered_Address_City__c;
        }
        if(objOnboarding.Registered_Address_State__c != null  && objOnboarding.Registered_Address_State__c !=''){
            address = address +', '+objOnboarding.Registered_Address_State__c;
        }
        if(objOnboarding.Registered_Address_Postal_Code__c != null  && objOnboarding.Registered_Address_Postal_Code__c !=''){
            address = address +', '+objOnboarding.Registered_Address_Postal_Code__c;
        }
        if(objOnboarding.Registered_Address_Country__c != null  && objOnboarding.Registered_Address_Country__c !=''){
            address = address +', '+objOnboarding.Registered_Address_Country__c;
        }
        address = address.replace('null','');
        address = address.removeStart(',');
        address = address+'.';
        if(address.containsOnly('.')){
            address = address.remove('.');
        }
        objOnBoardingWrapper.address = address;
        
        objOnBoardingWrapper.reg_name = objOnboarding.Company_Registered_Name__c;   //we
        objOnBoardingWrapper.push_url = objOnboarding.push_url__c;  //ew
        objOnBoardingWrapper.product_type = objOnboarding.Product_Type__c;  //B2B
        //objOnBoardingWrapper.is_prepaid = Boolean.valueOf(objOnboarding.Is_Prepaid__c);
        objOnBoardingWrapper.wallet_provider = 'DEL-MILES'; //DEL-MILES
        objOnBoardingWrapper.wallet_notification_mobile = String.valueOf(objOnboarding.Wallet_Notification_Mobile__c);  //
        objOnBoardingWrapper.wallet_notification_email = String.valueOf(objOnboarding.Wallet_Notification_Email__c);    //
        objOnBoardingWrapper.mps_service = Boolean.valueOf(objOnboarding.MPS_Service__c);
        objOnBoardingWrapper.send_mail_pickup = Boolean.valueOf(objOnboarding.Send_mail_Pickup__c);
        objOnBoardingWrapper.send_sms_prepaid = Boolean.valueOf(objOnboarding.Send_SMS_Prepaid__c);
        objOnBoardingWrapper.send_sms_cash = Boolean.valueOf(objOnboarding.send_sms_cash__c);
        objOnBoardingWrapper.send_sms_cod = Boolean.valueOf(objOnboarding.Send_SMS_COD__c);
        objOnBoardingWrapper.send_sms_reverse = Boolean.valueOf(objOnboarding.Send_SMS_Reverse__c);
        objOnBoardingWrapper.send_sms_ndr = Boolean.valueOf(objOnboarding.Send_SMS_NDR__c);
        objOnBoardingWrapper.auto_pickup = Boolean.valueOf(objOnboarding.auto_pickup__c);
        objOnBoardingWrapper.allow_no_data = Boolean.valueOf(objOnboarding.allow_no_data__c);
        objOnBoardingWrapper.billing_mode = objOnboarding.Billing_Mode__c;  //Surface
        //objOnBoardingWrapper.billing_mode = 'E';  //Surface
        objOnBoardingWrapper.postal_cat = objOnboarding.Postal_Cat1__c; //CatBcls_services 
        //Client user id to send
        objOnBoardingWrapper.client_user_name = objOnboarding.Client_User_Id__c;
        //objOnBoardingWrapper.client_xray_amount = String.valueOf(objOnboarding.X_Ray_Limit__c);
        objOnBoardingWrapper.xray_amount_limit = String.valueOf(objOnboarding.X_Ray_Limit__c);
        objOnBoardingWrapper.client_billing_mode = objOnboarding.Billing_Mode__c;
        
        System.debug('objOnboarding.Contact_number__c>>>'+objOnboarding.Contact_number__c);
        
        objOnBoardingWrapper.phone = String.valueOf(objOnboarding.Contact_number__c);  //7832142123
        objOnBoardingWrapper.billing_client_config = objOnboarding.Billing_Client_Config__c;    //
        objOnBoardingWrapper.movement_config = objOnboarding.Movement_Config__c;    //
        
        //SF-211: Updated Request body to HQ
        if(objOnboarding.Invoicing_Mode__c=='COD Net-off'){
            invoicingMode = 'cod_netoff';
        }else if(objOnboarding.Invoicing_Mode__c=='Delhivery Miles'){
            invoicingMode = 'prepaid';
        }else if(objOnboarding.Invoicing_Mode__c=='Monthly Invoiced'){
            invoicingMode = 'postpaid';
        }else{
            invoicingMode = objOnboarding.Invoicing_Mode__c;
        }
        
        objOnBoardingWrapper.billing_method = invoicingMode;  
        objOnBoardingWrapper.salesforce_id = objOnboarding.Account__c;
        objOnBoardingWrapper.client_type = objOnboarding.Opportunity__r.Client_Category__c;
        
        List<State__c> stateList = new List<State__c>([SELECT Id,GST_Number__c,HQ_State__c,State__c,Customer_Onboarding__c FROM State__c WHERE Customer_Onboarding__c =:objOnboarding.id]);
        
        
        
        
        OnBoardingWrapper.cls_gst_states gstState = new OnBoardingWrapper.cls_gst_states();
        List<OnBoardingWrapper.cls_gst_states> listGSTStates = new List<OnBoardingWrapper.cls_gst_states>();
        for(State__c objState : stateList){
            if(objState.HQ_State__c){
                objOnBoardingWrapper.ho_state = objState.State__c;
            }
            
            if(objState.State__c =='Andaman and Nicobar Islands'){
                gstState.AndamanandNicobarIslands = objState.GST_Number__c;
            }
            if(objState.State__c =='Arunachal Pradesh'){
                gstState.ArunachalPradesh = objState.GST_Number__c;
            }
            if(objState.State__c =='Andhra Pradesh'){
                gstState.AndhraPradesh = objState.GST_Number__c;
            }
            if(objState.State__c =='Assam'){
                gstState.Assam = objState.GST_Number__c;
            }
            if(objState.State__c =='Bihar'){
                gstState.Bihar = objState.GST_Number__c;
            }
            if(objState.State__c =='Chandigarh'){
                gstState.Chandigarh = objState.GST_Number__c;
            }
            if(objState.State__c =='Dadra and Nagar Haveli'){
                gstState.DadraandNagarHaveli = objState.GST_Number__c;
            }
            if(objState.State__c =='Daman and Diu'){
                gstState.DamanandDiu = objState.GST_Number__c;
            }
            if(objState.State__c =='Delhi'){
                gstState.Delhi = objState.GST_Number__c;
            }
            if(objState.State__c =='Goa'){
                gstState.Goa = objState.GST_Number__c;
            }
            if(objState.State__c =='Gujarat'){
                gstState.Gujarat = objState.GST_Number__c;
            }
            if(objState.State__c =='Haryana'){
                gstState.Haryana = objState.GST_Number__c;
            }
            if(objState.State__c =='Himachal Pradesh'){
                gstState.HimachalPradesh = objState.GST_Number__c;
            }
            if(objState.State__c =='Jammu and Kashmir'){
                gstState.JammuandKashmir = objState.GST_Number__c;
            }
            if(objState.State__c =='Jharkhand'){
                gstState.Jharkhand = objState.GST_Number__c;
            }
            if(objState.State__c =='Karnataka'){
                gstState.Karnataka = objState.GST_Number__c;
            }
            if(objState.State__c =='Kerala'){
                gstState.Kerala = objState.GST_Number__c;
            }
            if(objState.State__c =='Lakshadweep Islands'){
                gstState.LakshadweepIslands = objState.GST_Number__c;
            }
            if(objState.State__c =='Madhya Pradesh'){
                gstState.MadhyaPradesh = objState.GST_Number__c;
            }
            if(objState.State__c =='Maharashtra'){
                gstState.Maharashtra = objState.GST_Number__c;
            }
            if(objState.State__c =='Manipur'){
                gstState.Manipur = objState.GST_Number__c;
            }
            if(objState.State__c =='Meghalaya'){
                gstState.Meghalaya = objState.GST_Number__c;
            }
            if(objState.State__c =='Mizoram'){
                gstState.Mizoram = objState.GST_Number__c;
            }
            if(objState.State__c =='Nagaland'){
                gstState.Nagaland = objState.GST_Number__c;
            }
            if(objState.State__c =='Orissa'){
                gstState.Orissa = objState.GST_Number__c;
            }
            if(objState.State__c =='Pondicherry'){
                gstState.Pondicherry = objState.GST_Number__c;
            }
            if(objState.State__c =='Punjab'){
                gstState.Punjab = objState.GST_Number__c;
            }
            if(objState.State__c =='Rajasthan'){
                gstState.Rajasthan = objState.GST_Number__c;
            }
            if(objState.State__c =='Sikkim'){
                gstState.Sikkim = objState.GST_Number__c;
            }
            if(objState.State__c =='Tamil Nadu'){
                gstState.TamilNadu = objState.GST_Number__c;
            }
            if(objState.State__c =='Chhattisgarh'){
                gstState.Chhattisgarh = objState.GST_Number__c;
            }
            /*if(objState.State__c =='Telangana'){
gstState.Telangana = objState.GST_Number__c;
}*/
            if(objState.State__c =='Tripura'){
                gstState.Tripura = objState.GST_Number__c;
            }
            if(objState.State__c =='Uttar Pradesh'){
                gstState.UttarPradesh = objState.GST_Number__c;
            }
            if(objState.State__c =='Uttarakhand'){
                gstState.Uttarakhand = objState.GST_Number__c;
            }
            if(objState.State__c =='West Bengal'){
                gstState.WestBengal = objState.GST_Number__c;
            }
            objOnBoardingWrapper.gst_states = gstState;
            
        }
        
        OnBoardingWrapper.cls_services services = new OnBoardingWrapper.cls_services();
        
        if(objOnboarding.Services__c != null){
            strList.addAll(objOnboarding.Services__c.split(';'));
            System.debug('strList>>>>'+strList);
            for(String str : strList){
                if(str == 'DTO'){
                    services.Pickup = true;
                }
                if(str == 'COD'){
                    services.COD = true;
                }
                if(str == 'Pre-paid'){
                    services.Prepaid = true;
                }
                if(str == 'REPL'){
                    services.REPL = true;
                }
            }
        }
        objOnBoardingWrapper.services = services;
        
        string jsonstring = JSON.serialize(objOnBoardingWrapper);
        
        jsonstring = jsonstring.replace('"Prepaid":true','"Pre-paid":true');
        jsonstring = jsonstring.replace('"Prepaid":false','"Pre-paid":false');
        
        jsonstring = jsonstring.replace('"Prepaid":null,','"Pre-paid":false,');
        jsonstring = jsonstring.replace('"REPL":null,','"REPL":false,');
        jsonstring = jsonstring.replace('"Pickup":null,','"Pickup":false,');
        jsonstring = jsonstring.replace('"COD":null,','"COD":false,');
        
        
        jsonstring = jsonstring.replace('"ho_state":"Andaman and Nicobar Islands"','"ho_state":"Andaman & Nicobar"');
        jsonstring = jsonstring.replace('"ho_state":"Daman and Diu"','"ho_state":"Daman & Diu"');
        jsonstring = jsonstring.replace('"ho_state":"Jammu and Kashmir"','"ho_state":"Jammu & Kashmir"');
        
        jsonstring = jsonstring.replace('AndamanandNicobarIslands','Andaman & Nicobar');
        jsonstring = jsonstring.replace('AndhraPradesh','Andhra Pradesh');
        jsonstring = jsonstring.replace('ArunachalPradesh','Arunachal Pradesh');
        jsonstring = jsonstring.replace('DadraandNagarHaveli','Dadra and Nagar Haveli');
        jsonstring = jsonstring.replace('DamanandDiu','Daman & Diu');
        jsonstring = jsonstring.replace('HimachalPradesh','Himachal Pradesh');
        jsonstring = jsonstring.replace('JammuandKashmir','Jammu & Kashmir');
        jsonstring = jsonstring.replace('LakshadweepIslands','Lakshadweep');
        jsonstring = jsonstring.replace('MadhyaPradesh','Madhya Pradesh');
        jsonstring = jsonstring.replace('TamilNadu','Tamil Nadu');
        jsonstring = jsonstring.replace('UttarPradesh','Uttar Pradesh');
        jsonstring = jsonstring.replace('WestBengal','West Bengal');
        
        jsonstring = jsonstring.replace('"billing_client_config":"--None--"','"billing_client_config":""');
        jsonstring = jsonstring.replace('"billing_client_config":"Pickup State"','"billing_client_config":"pickup_state"');
        jsonstring = jsonstring.replace('"billing_client_config":"Drop State"','"billing_client_config":"drop_state"');
        jsonstring = jsonstring.replace('"billing_client_config":"Client HO"','"billing_client_config":"client_ho"');
        
        
        jsonstring = jsonstring.replace('"movement_config":"--None--"','"movement_config":""');
        jsonstring = jsonstring.replace('"movement_config":"Client HO state GST IN"','"movement_config":"client_ho_state_gstin"');
        jsonstring = jsonstring.replace('"movement_config":"Warehouse state GST IN"','"movement_config":"warehouse_state_gstin"');
        
        
        System.debug('jsonstring>>>>'+jsonstring);
        
        jsonstring = jsonstring.replace('"West Bengal":null,','');
        jsonstring = jsonstring.replace('"Uttar Pradesh":null,','');
        jsonstring = jsonstring.replace('"Tripura":null,','');
        jsonstring = jsonstring.replace('"Tamil Nadu":null,','');
        jsonstring = jsonstring.replace('"Sikkim":null,','');
        jsonstring = jsonstring.replace('"Rajasthan":null,','');
        jsonstring = jsonstring.replace('"Punjab":null,','');
        jsonstring = jsonstring.replace('"Pondicherry":null,','');
        jsonstring = jsonstring.replace('"Orissa":null,','');
        jsonstring = jsonstring.replace('"Nagaland":null,','');
        jsonstring = jsonstring.replace('"Mizoram":null,','');
        jsonstring = jsonstring.replace('"Meghalaya":null,','');
        jsonstring = jsonstring.replace('"Manipur":null,','');
        jsonstring = jsonstring.replace('"Maharashtra":null,','');
        jsonstring = jsonstring.replace('"Madhya Pradesh":null,','');
        jsonstring = jsonstring.replace('"Lakshadweep":null,','');
        jsonstring = jsonstring.replace('"Kerala":null,','');
        jsonstring = jsonstring.replace('"Karnataka":null,','');
        jsonstring = jsonstring.replace('"Jharkhand":null,','');
        jsonstring = jsonstring.replace('"Jammu & Kashmir":null,','');
        jsonstring = jsonstring.replace('"Himachal Pradesh":null,','');
        jsonstring = jsonstring.replace('"Haryana":null,','');
        jsonstring = jsonstring.replace('"Gujarat":null,','');
        jsonstring = jsonstring.replace('"Goa":null,','');
        jsonstring = jsonstring.replace('"Delhi":null,','');
        jsonstring = jsonstring.replace('"Daman & Diu":null,','');
        jsonstring = jsonstring.replace('"Dadra and Nagar Haveli":null,','');
        jsonstring = jsonstring.replace('"Chhattisgarh":null,','');
        jsonstring = jsonstring.replace('"Chandigarh":null,','');
        jsonstring = jsonstring.replace('"Bihar":null,','');
        jsonstring = jsonstring.replace('"Assam":null,','');
        jsonstring = jsonstring.replace('"Arunachal Pradesh":null,','');
        jsonstring = jsonstring.replace('"Andhra Pradesh":null,','');
        jsonstring = jsonstring.replace('"Andaman & Nicobar":null','');
        jsonstring = jsonstring.replace('"Uttarakhand":null,','');
        jsonstring = jsonstring.replace(',}','}');
        jsonstring = jsonstring.replace('"bank_detail":null,', '');
        
        
        //jsonstring = jsonstring.replace('"billing_delhivery_config":""','West Bengal');
        
        
        
        System.debug('jsonstring>>>>'+jsonstring);
        
        
        String endPoint = hqAPI.URL__c+ client+'/';
        system.debug('endPoint!!!'+endPoint);
        HttpResponse response = new HttpResponse();
        try{
            if(!Test.isRunningTest()){
                response = CallOutUtil.calloutPutMethod(endPoint,jsonstring); 
            }else{
                response.setStatusCode(200); //='{"updated_data":{"reg_name":"we","postal_cat":"CatB","rem_email":"r@gmail.com","allow_no_data":true,"vat_number":2322,"cst_number":234,"dto_email_recipients":"b@h.com","send_sms_cod":true,"push_url":"ew","report_recipients":"n@gmail.com, new@gmail.com","eco_code":3243,"mps_service":true,"rto_email_recipients":"a@gmail.com","send_sms_prepaid":true,"send_sms_reverse":true,"send_mail_pickup":true,"address":"weq","frs_code":3234,"return_add":"weq","upload_recipients":"wer@gmail.com","product_type":"B2B","ndr_report_recipients":"net@gmail.com","auto_pickup":true,"send_sms_cash":true,"send_sms_ndr":true},"name":"client2221 new test","success":true,"error":""}';
            }
            
            objOnboarding.Status__c = 'Synced To HQ';
            update objOnboarding;
            system.debug('response@@@'+response.getBody());
            String responseone = '['+response+']';
            //Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(response);
            //system.debug('m@@@'+m);
            //system.debug('get(success) @@@'+m.get('success'));
            //if(m.get('success') == true)
            String errorMsg=''; 
            if(response.getStatusCode() == 200){
                System.debug('In Success IF');
                //system.debug('get(success) @@@ In If'+m.get('success'));
                //objOnboarding.Client_Id__c = client;
                //objOnboarding.Client_User_Id__c = clientUser;
                //objOnboarding.Success__c =  String.valueOf(m.get('success'));
                //if(m.get('error') == null)   {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Sync Successful'));
                objOnboarding.Status__c = 'Synced To HQ';
                // }
                system.debug('objOnboarding---.'+objOnboarding);
                //sf-95:To make opportunity Live(Outbound) ----samruddhi
                Opportunity objOpp = [Select id,StageName from Opportunity where id=:objOnboarding.Opportunity__c];
                objOpp.StageName = 'Live (Outbound)';       
                update objOpp;      
                //-----sf-95: ends here----
                
                //return null;
            }
            else{
                System.debug('In Success Else'+response.getBody());
                
                
                //objOnboarding.Error__c = String.valueOf(m.get('error'));
                /*
                JSONParser parser = JSON.createParser(response.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'error')) {
                            // Get the value.
                            parser.nextToken();
                            errorMsg = parser.getText();
                        }
                }
                */
                //System.debug('errorMsg ->'+errorMsg);
                
                if( response.getBody().contains('phone') ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Invalid phone number.'));  
                    //return null;
                }
                if( response.getBody().contains('gst_states') || response.getBody().contains('ho_state')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Invalid Gst state or ho_state.'));  
                    //return null;
                }
                /* else if(errorMsg.contains('wallet_notification_email') )
                {
                    errorMsg='Invalid Wallet Notification Email';    
                }
                else if(errorMsg.contains('wallet_provider')){
                    errorMsg='Invalid Wallet Provider';    
                }
                else if(DesiredHqName == null || DesiredHqName==''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please fill out Desired HQ Name' ));//String.valueOf(m.get('error'))         
                } */
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please fill out Mandatory fields Wallet Notification Email, Wallet Notification Mobile, And Wallet Provider' ));//String.valueOf(m.get('error'))
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Error: Please check Error logs for more information.'));  
                errorRecord = new Error_Log__c();
                errorRecord.Type__c = 'HQ';
                errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ response.getBody();
                insert errorRecord;
                //return null;
            }
        
            if(errorMsg=='' && response.getStatusCode() == 200){
                
                if(objOnboarding.Account__c!=null || objOnboarding.Account__c !=''){
                    accountList=[SELECT Id, External_ID__c, Active__c, Client_Status__c, Bank_A_c_Number__c, Bank_name__c, Beneficiary_name__c, PAN_card__c, RTGS_IFSC_code__c, Registered_Address_City__c, Registered_Address_Country__c, Registered_Address_Line_1__c, Registered_Address_Line_2__c, Registered_Address_Postal_Code__c, Registered_Address_State__c, BillingAddress, BillingCity, BillingState, BillingStreet, BillingCountry FROM Account WHERE Id=:objOnboarding.Account__c];
                    
                    operatingAccountList = [SELECT Id, External_ID__c, Active__c, Client_Status__c, Bank_A_c_Number__c, Bank_name__c, Beneficiary_name__c, PAN_card__c, RTGS_IFSC_code__c, FRS_Code__c, Registered_Address_City__c, Registered_Address_Country__c, Registered_Address_Line_1__c, Registered_Address_Line_2__c, Registered_Address_Postal_Code__c, Registered_Address_State__c, BillingAddress, BillingCity, BillingState, BillingStreet, BillingCountry FROM Account WHERE Id=:objOnboarding.Opportunity__r.Operating_Account__c];
                    System.debug('Service Account->'+objOnboarding.Account__c);
                }
                System.debug('accountList before update>>'+accountList);
                System.debug('operatingAccountList before update>>'+operatingAccountList);
                
                if(accountList.size()>0 && (DesiredHqName != null || DesiredHqName!='') ){            
                    accountList[0].External_ID__c=objOnboarding.Desired_HQ_Name__c;
                    accountList[0].Activation_Date__c=date.today();
                    accountList[0].Active__c = true;
                    accountList[0].Client_Status__c='Active';
                    accountList[0].Bank_A_c_Number__c= objOnboarding.Bank_A_c_Number__c;
                    accountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    accountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    accountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    accountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    
                    accountList[0].NDR_report_recipients__c = objOnboarding.NDR_report_recipients__c;
                    accountList[0].Report_Recipients__c = objOnboarding.Report_Recipients__c;
                    accountList[0].RTO_email_recipients__c = objOnboarding.RTO_email_recipients__c;
                    accountList[0].DTO_email_recipients__c = objOnboarding.DTO_email_recipients__c;
                    accountList[0].REM_email__c = objOnboarding.REM_email__c;
                    accountList[0].Upload_Recipients__c = objOnboarding.Upload_Recipients__c;
                    accountList[0].VAT_Number__c = objOnboarding.VAT_Number__c;
                    accountList[0].CST_Number__c = objOnboarding.CST_Number__c;
                    accountList[0].Eco_Code__c = objOnboarding.Eco_Code__c;
                    accountList[0].FRS_Code__c = objOnboarding.FRS_Code__c;
                    accountList[0].Return_Address__c = objOnboarding.Return_Address__c;
                    accountList[0].Registered_Address_Line_1__c = objOnboarding.Registered_Address_Line_1__c;
                    accountList[0].Registered_Address_Line_2__c = objOnboarding.Registered_Address_Line_2__c;
                    accountList[0].Registered_Address_City__c = objOnboarding.Registered_Address_City__c;
                    accountList[0].Registered_Address_State__c = objOnboarding.Registered_Address_State__c;
                    accountList[0].Registered_Address_Postal_Code__c = objOnboarding.Registered_Address_Postal_Code__c;
                    accountList[0].Registered_Address_Country__c = objOnboarding.Registered_Address_Country__c;
                    accountList[0].Push_url__c = objOnboarding.Push_url__c;
                    accountList[0].Product_Type__c = objOnboarding.Product_Type__c;
                    accountList[0].Is_Prepaid__c = objOnboarding.Is_Prepaid__c;
                    accountList[0].Wallet_Notification_Mobile__c = objOnboarding.Wallet_Notification_Mobile__c;
                    accountList[0].Wallet_Notification_Email__c = objOnboarding.Wallet_Notification_Email__c;
                    accountList[0].MPS_Service__c = objOnboarding.MPS_Service__c;
                    accountList[0].Send_mail_Pickup__c = objOnboarding.Send_mail_Pickup__c;
                    accountList[0].Send_SMS_Prepaid__c = objOnboarding.Send_SMS_Prepaid__c;
                    accountList[0].send_sms_cash__c = objOnboarding.send_sms_cash__c;
                    accountList[0].Send_SMS_COD__c = objOnboarding.Send_SMS_COD__c;
                    accountList[0].Send_SMS_Reverse__c = objOnboarding.Send_SMS_Reverse__c;
                    accountList[0].Send_SMS_NDR__c = objOnboarding.Send_SMS_NDR__c;
                    accountList[0].auto_pickup__c = objOnboarding.auto_pickup__c;
                    accountList[0].allow_no_data__c = objOnboarding.allow_no_data__c;
                    accountList[0].Billing_Mode__c = objOnboarding.Billing_Mode__c;
                    accountList[0].Postal_Cat__c = objOnboarding.Postal_Cat1__c;
                    accountList[0].X_Ray_Limit__c = objOnboarding.X_Ray_Limit__c;
                    accountList[0].Contact_number__c = objOnboarding.Contact_number__c;
                    accountList[0].Billing_Client_Config__c = objOnboarding.Billing_Client_Config__c;
                    accountList[0].Movement_Config__c = objOnboarding.Movement_Config__c;
                    accountList[0].Client_User_Id__c = objOnboarding.Client_User_Id__c;
                    accountList[0].Client_Id__c = objOnboarding.Client_Id__c;
                    accountList[0].Company_Registered_Name__c= objOnboarding.Company_Registered_Name__c;
                    accountList[0].Bank_A_c_Number__c = objOnboarding.Bank_A_c_Number__c;
                    accountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    accountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    accountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    accountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    accountList[0].BillingStreet = objOnboarding.Invoice_Address_Line_1__c + ' ' +objOnboarding.Invoice_Address_Line_2__c;
                    accountList[0].BillingCity = objOnboarding.Invoice_Address_City__c;
                    accountList[0].BillingState = objOnboarding.Invoice_Address_State__c;
                    accountList[0].BillingCountry = objOnboarding.Invoice_Address_Country__c;
                    accountList[0].BillingPostalCode = objOnboarding.Invoice_Address_Postal_Code__c;
                    accountList[0].Wallet_Provider__c = objOnboarding.Wallet_Provider__c;
                    accountList[0].Contract_Start_Date__c = objOnboarding.Contract_Start_Date__c;
                    accountList[0].Contract_End_Date__c = objOnboarding.Contract_End_Date__c;
                    accountList[0].Product_category__c = objOnboarding.Product_category__c;
                    accountList[0].GST_not_registered__c = objOnboarding.GST_not_registered__c;
                    accountList[0].Services__c = objOnboarding.Services__c;
                    accountList[0].Invoicing_Mode__c = objOnboarding.Invoicing_Mode__c;
                    
                    //
                    
                    
                    accountList[0].Registered_Address_City__c= objOnboarding.Registered_Address_City__c;
                    accountList[0].Registered_Address_Line_1__c= objOnboarding.Registered_Address_Line_1__c;
                    accountList[0].Registered_Address_Line_2__c= objOnboarding.Registered_Address_Line_2__c;
                    accountList[0].Registered_Address_Country__c= objOnboarding.Registered_Address_Country__c;
                    accountList[0].Registered_Address_Postal_Code__c= objOnboarding.Registered_Address_Postal_Code__c;
                    accountList[0].Registered_Address_State__c= objOnboarding.Registered_Address_State__c;
                    
                    accountList[0].BillingCity = objOnboarding.Invoice_Address_City__c;
                    accountList[0].BillingCountry = objOnboarding.Invoice_Address_Country__c;
                    accountList[0].BillingStreet = objOnboarding.Invoice_Address_Line_1__c +' '+ objOnboarding.Invoice_Address_Line_2__c;
                    accountList[0].BillingPostalCode = objOnboarding.Invoice_Address_Postal_Code__c;
                    accountList[0].BillingState = objOnboarding.Invoice_Address_State__c;
                    
                    for(State__c stateListToUpdate : [SELECT Id,GST_Number__c,HQ_State__c,State__c,Customer_Onboarding__c FROM State__c WHERE Customer_Onboarding__c =:objOnboarding.id ]){
                        accountList[0].State__c = stateListToUpdate.Id;
                        accountList[0].GST_Number__c = stateListToUpdate.GST_Number__c;
                        accountList[0].HQ_State__c = stateListToUpdate.HQ_State__c;
                        accountList[0].State_Name__c = stateListToUpdate.State__c;
                        
                    }
                    
                    isHQUpdate = true;
                    System.debug('accountList>>'+accountList);
                    update accountList;
                }
                
               if(operatingAccountList.size()>0 && (DesiredHqName != null || DesiredHqName!='') && ((operatingAccountList[0].Bank_A_c_Number__c!=null && objOnboarding.Send_to_Operating_Account__c == true) || (operatingAccountList[0].Bank_A_c_Number__c==null))){
                    System.debug('operatingAccountList>>'+operatingAccountList);
                    //operatingAccountList[0].External_ID__c = objOnboarding.Desired_HQ_Name__c;
                    //operatingAccountList[0].Activation_Date__c = date.today();
                    operatingAccountList[0].Active__c = true;
                    operatingAccountList[0].Client_Status__c='Active';
                    operatingAccountList[0].Bank_A_c_Number__c= objOnboarding.Bank_A_c_Number__c;
                    operatingAccountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    operatingAccountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    operatingAccountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    operatingAccountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    operatingAccountList[0].FRS_Code__c= objOnboarding.FRS_Code__c;
                    
                    operatingAccountList[0].Registered_Address_City__c= objOnboarding.Registered_Address_City__c;
                    operatingAccountList[0].Registered_Address_Line_1__c= objOnboarding.Registered_Address_Line_1__c;
                    operatingAccountList[0].Registered_Address_Line_2__c= objOnboarding.Registered_Address_Line_2__c;
                    operatingAccountList[0].Registered_Address_Country__c= objOnboarding.Registered_Address_Country__c;
                    operatingAccountList[0].Registered_Address_Postal_Code__c= objOnboarding.Registered_Address_Postal_Code__c;
                    operatingAccountList[0].Registered_Address_State__c= objOnboarding.Registered_Address_State__c;
                    
                    operatingAccountList[0].BillingCity = objOnboarding.Invoice_Address_City__c;
                    operatingAccountList[0].BillingCountry = objOnboarding.Invoice_Address_Country__c;
                    operatingAccountList[0].BillingStreet = objOnboarding.Invoice_Address_Line_1__c +' '+ objOnboarding.Invoice_Address_Line_2__c;
                    operatingAccountList[0].BillingPostalCode = objOnboarding.Invoice_Address_Postal_Code__c;
                    operatingAccountList[0].BillingState = objOnboarding.Invoice_Address_State__c;
                    
                    //
                    
                    operatingAccountList[0].NDR_report_recipients__c = objOnboarding.NDR_report_recipients__c;
                    operatingAccountList[0].Report_Recipients__c = objOnboarding.Report_Recipients__c;
                    operatingAccountList[0].RTO_email_recipients__c = objOnboarding.RTO_email_recipients__c;
                    operatingAccountList[0].DTO_email_recipients__c = objOnboarding.DTO_email_recipients__c;
                    operatingAccountList[0].REM_email__c = objOnboarding.REM_email__c;
                    operatingAccountList[0].Upload_Recipients__c = objOnboarding.Upload_Recipients__c;
                    operatingAccountList[0].VAT_Number__c = objOnboarding.VAT_Number__c;
                    operatingAccountList[0].CST_Number__c = objOnboarding.CST_Number__c;
                    operatingAccountList[0].Eco_Code__c = objOnboarding.Eco_Code__c;
                    operatingAccountList[0].FRS_Code__c = objOnboarding.FRS_Code__c;
                    operatingAccountList[0].Return_Address__c = objOnboarding.Return_Address__c;
                    operatingAccountList[0].Registered_Address_Line_1__c = objOnboarding.Registered_Address_Line_1__c;
                    operatingAccountList[0].Registered_Address_Line_2__c = objOnboarding.Registered_Address_Line_2__c;
                    operatingAccountList[0].Registered_Address_City__c = objOnboarding.Registered_Address_City__c;
                    operatingAccountList[0].Registered_Address_State__c = objOnboarding.Registered_Address_State__c;
                    operatingAccountList[0].Registered_Address_Postal_Code__c = objOnboarding.Registered_Address_Postal_Code__c;
                    operatingAccountList[0].Registered_Address_Country__c = objOnboarding.Registered_Address_Country__c;
                    operatingAccountList[0].Push_url__c = objOnboarding.Push_url__c;
                    operatingAccountList[0].Product_Type__c = objOnboarding.Product_Type__c;
                    operatingAccountList[0].Is_Prepaid__c = objOnboarding.Is_Prepaid__c;
                    operatingAccountList[0].Wallet_Notification_Mobile__c = objOnboarding.Wallet_Notification_Mobile__c;
                    operatingAccountList[0].Wallet_Notification_Email__c = objOnboarding.Wallet_Notification_Email__c;
                    operatingAccountList[0].MPS_Service__c = objOnboarding.MPS_Service__c;
                    operatingAccountList[0].Send_mail_Pickup__c = objOnboarding.Send_mail_Pickup__c;
                    operatingAccountList[0].Send_SMS_Prepaid__c = objOnboarding.Send_SMS_Prepaid__c;
                    operatingAccountList[0].send_sms_cash__c = objOnboarding.send_sms_cash__c;
                    operatingAccountList[0].Send_SMS_COD__c = objOnboarding.Send_SMS_COD__c;
                    operatingAccountList[0].Send_SMS_Reverse__c = objOnboarding.Send_SMS_Reverse__c;
                    operatingAccountList[0].Send_SMS_NDR__c = objOnboarding.Send_SMS_NDR__c;
                    operatingAccountList[0].auto_pickup__c = objOnboarding.auto_pickup__c;
                    operatingAccountList[0].allow_no_data__c = objOnboarding.allow_no_data__c;
                    operatingAccountList[0].Billing_Mode__c = objOnboarding.Billing_Mode__c;
                    operatingAccountList[0].Postal_Cat__c = objOnboarding.Postal_Cat1__c;
                    operatingAccountList[0].X_Ray_Limit__c = objOnboarding.X_Ray_Limit__c;
                    operatingAccountList[0].Contact_number__c = objOnboarding.Contact_number__c;
                    operatingAccountList[0].Billing_Client_Config__c = objOnboarding.Billing_Client_Config__c;
                    operatingAccountList[0].Movement_Config__c = objOnboarding.Movement_Config__c;
                    operatingAccountList[0].Client_User_Id__c = objOnboarding.Client_User_Id__c;
                    operatingAccountList[0].Client_Id__c = objOnboarding.Client_Id__c;
                    operatingAccountList[0].Company_Registered_Name__c= objOnboarding.Company_Registered_Name__c;
                    operatingAccountList[0].Bank_A_c_Number__c = objOnboarding.Bank_A_c_Number__c;
                    operatingAccountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    operatingAccountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    operatingAccountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    operatingAccountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    operatingAccountList[0].BillingStreet = objOnboarding.Invoice_Address_Line_1__c + ' ' +objOnboarding.Invoice_Address_Line_2__c;
                    operatingAccountList[0].BillingCity = objOnboarding.Invoice_Address_City__c;
                    operatingAccountList[0].BillingState = objOnboarding.Invoice_Address_State__c;
                    operatingAccountList[0].BillingCountry = objOnboarding.Invoice_Address_Country__c;
                    operatingAccountList[0].BillingPostalCode = objOnboarding.Invoice_Address_Postal_Code__c;
                    operatingAccountList[0].Wallet_Provider__c = objOnboarding.Wallet_Provider__c;
                    operatingAccountList[0].Contract_Start_Date__c = objOnboarding.Contract_Start_Date__c;
                    operatingAccountList[0].Contract_End_Date__c = objOnboarding.Contract_End_Date__c;
                    operatingAccountList[0].Product_category__c = objOnboarding.Product_category__c;
                    operatingAccountList[0].GST_not_registered__c = objOnboarding.GST_not_registered__c;
                    operatingAccountList[0].Services__c = objOnboarding.Services__c;
                    operatingAccountList[0].Invoicing_Mode__c = objOnboarding.Invoicing_Mode__c;
                    
                    //
                    
                    
                    
                    isHQUpdate = true;
                    update operatingAccountList;
                }
            }
            
            
        }
        catch(Exception e){
            update objOnboarding;
            // if(m.get('error') == null)   {
            System.debug('Message>>>>'+e.getMessage());
            System.debug('Message>>>>'+e.getStackTraceString());           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Something is wrong. Check Error logs for more details'));
            errorRecord = new Error_Log__c();
            errorRecord.Type__c = 'HQ';
            errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ e.getMessage();
            errorRecord.Stack_Trace__c = e.getStackTraceString();
            insert errorRecord;
            //}
        }
        
        
        return null;
    }
    
    public pagereference updateToHQ(){
        system.debug('objOnboarding.Client_Id__c--->'+objOnboarding.Client_Id__c);
        if(objOnboarding.Status__c == 'Draft'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The Customer Onboarding form is in Draft state. To send it to HQ, please submit the form and try again.'));
            return null;
        }
        
        if(objOnboarding.Desired_HQ_Name__c == null){
            String err = 'Please enter Desired HQ Name';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, err));
            return null;
        }
        
        DesiredHqName = (objOnboarding.Desired_HQ_Name__c).replaceAll(' \\s+', ' '); 
        System.debug('DesiredHqName ->'+DesiredHqName);
        if(DesiredHqName.length()>=30){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter a short Desired HQ Name'));
            return null;    
        }
        if(objOnboarding.Client_Id__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Data not sent to HQ. Hence, cannot be updated.' ));
        }else{
            HQ_API__c hqAPI = HQ_API__c.getValues('Update');
            
            
            //map<String, String> mapRequestBodyone = new map<String, String>();    
            //if(objOnboarding.Client_Id__c!=null){
            
            OnBoardingWrapper objOnBoardingWrapper = new OnBoardingWrapper();
            
            objOnBoardingWrapper.ndr_report_recipients = objOnboarding.NDR_report_recipients__c;
            objOnBoardingWrapper.report_recipients = objOnboarding.Report_Recipients__c;    //n@gmail.com, new@gmail.com
            objOnBoardingWrapper.rto_email_recipients = objOnboarding.RTO_email_recipients__c;  //a@gmail.com
            objOnBoardingWrapper.dto_email_recipients = objOnboarding.DTO_email_recipients__c;  //b@h.com
            objOnBoardingWrapper.rem_email = objOnboarding.REM_email__c;    //r@gmail.com
            objOnBoardingWrapper.upload_recipients = objOnboarding.Upload_Recipients__c;    //wer@gmail.com
               if((objOnboarding.Opportunity_Record_Type__c=='Standard Shipping' || objOnboarding.Opportunity_Record_Type__c=='Express Shipping') && objOnboarding.Opportunity_Owner__c !='XB Onboarding' ){
                List<OpportunityLineItem> oliItem=[SELECT Id, OpportunityId, IsActive__c,Qr_Code__c,Payment_Link__c FROM OpportunityLineItem where IsActive__c=true and OpportunityId=:objOnboarding.Opportunity__c limit 1];
                OnBoardingWrapper.cls_bank_detail bank_detail=new OnBoardingWrapper.cls_bank_detail();
                    bank_detail.ifsc_code=objOnboarding.RTGS_IFSC_code__c;
                    bank_detail.bank_name=objOnboarding.Bank_name__c;
                    bank_detail.beneficiary_name=objOnboarding.Beneficiary_name__c;
                    bank_detail.account_number=objOnboarding.Bank_A_c_Number__c;
                    objOnBoardingWrapper.bank_detail=bank_detail;
                If(oliItem.size()>0){
                    objOnBoardingWrapper.plod=oliItem[0].Payment_Link__c;
                    objOnBoardingWrapper.qrod=oliItem[0].Qr_Code__c;
                    
                }else{
                    objOnBoardingWrapper.plod=false;
                    objOnBoardingWrapper.qrod=false;
                }
                
            }else{
                objOnBoardingWrapper.plod=false;
                objOnBoardingWrapper.qrod=false;
            }

            if(objOnboarding.VAT_Number__c != null && objOnboarding.VAT_Number__c != ''){
                objOnBoardingWrapper.vat_number = Integer.ValueOf(objOnboarding.VAT_Number__c.trim()); //2322
            }
            if(objOnboarding.CST_Number__c != null && objOnboarding.CST_Number__c != ''){
                objOnBoardingWrapper.cst_number = Integer.ValueOf(objOnboarding.CST_Number__c.trim()); //234
            }
            if(objOnboarding.Eco_Code__c != null && objOnboarding.Eco_Code__c != ''){
                objOnBoardingWrapper.eco_code = Integer.ValueOf(objOnboarding.Eco_Code__c.trim()); //3243
            }
            if(objOnboarding.FRS_Code__c != null && objOnboarding.FRS_Code__c != ''){
                objOnBoardingWrapper.frs_code = Integer.ValueOf(objOnboarding.FRS_Code__c.trim()); //3234
            }
            objOnBoardingWrapper.return_add = objOnboarding.Return_Address__c;  //weq
            String address='';
            if(objOnboarding.Registered_Address_Line_1__c != null  && objOnboarding.Registered_Address_Line_1__c !=''){
                
                address = objOnboarding.Registered_Address_Line_1__c;
            }
            if(objOnboarding.Registered_Address_Line_2__c != null  && objOnboarding.Registered_Address_Line_2__c !=''){
                address = address +', '+objOnboarding.Registered_Address_Line_2__c;
            }
            if(objOnboarding.Registered_Address_City__c != null  && objOnboarding.Registered_Address_City__c !=''){
                address = address +', '+objOnboarding.Registered_Address_City__c;
            }
            if(objOnboarding.Registered_Address_State__c != null  && objOnboarding.Registered_Address_State__c !=''){
                address = address +', '+objOnboarding.Registered_Address_State__c;
            }
            if(objOnboarding.Registered_Address_Postal_Code__c != null  && objOnboarding.Registered_Address_Postal_Code__c !=''){
                address = address +', '+objOnboarding.Registered_Address_Postal_Code__c;
            }
            if(objOnboarding.Registered_Address_Country__c != null  && objOnboarding.Registered_Address_Country__c !=''){
                address = address +', '+objOnboarding.Registered_Address_Country__c;
            }
            address = address.replace('null','');
            address = address.removeStart(',');
            address = address+'.';
            if(address.containsOnly('.')){
                address = address.remove('.');
            }
            objOnBoardingWrapper.address = address;
            
            objOnBoardingWrapper.reg_name = objOnboarding.Company_Registered_Name__c;   //we
            objOnBoardingWrapper.push_url = objOnboarding.push_url__c;  //ew
            objOnBoardingWrapper.product_type = objOnboarding.Product_Type__c;  //B2B
            //objOnBoardingWrapper.is_prepaid = Boolean.valueOf(objOnboarding.Is_Prepaid__c);
            objOnBoardingWrapper.wallet_provider = 'DEL-MILES'; //DEL-MILES
            objOnBoardingWrapper.wallet_notification_mobile = String.valueOf(objOnboarding.Wallet_Notification_Mobile__c);  //
            objOnBoardingWrapper.wallet_notification_email = String.valueOf(objOnboarding.Wallet_Notification_Email__c);    //
            objOnBoardingWrapper.mps_service = Boolean.valueOf(objOnboarding.MPS_Service__c);
            objOnBoardingWrapper.send_mail_pickup = Boolean.valueOf(objOnboarding.Send_mail_Pickup__c);
            objOnBoardingWrapper.send_sms_prepaid = Boolean.valueOf(objOnboarding.Send_SMS_Prepaid__c);
            objOnBoardingWrapper.send_sms_cash = Boolean.valueOf(objOnboarding.send_sms_cash__c);
            objOnBoardingWrapper.send_sms_cod = Boolean.valueOf(objOnboarding.Send_SMS_COD__c);
            objOnBoardingWrapper.send_sms_reverse = Boolean.valueOf(objOnboarding.Send_SMS_Reverse__c);
            objOnBoardingWrapper.send_sms_ndr = Boolean.valueOf(objOnboarding.Send_SMS_NDR__c);
            objOnBoardingWrapper.auto_pickup = Boolean.valueOf(objOnboarding.auto_pickup__c);
            objOnBoardingWrapper.allow_no_data = Boolean.valueOf(objOnboarding.allow_no_data__c);
            objOnBoardingWrapper.billing_mode = objOnboarding.Billing_Mode__c;  //Surface
            //objOnBoardingWrapper.billing_mode = 'E';  //Surface
            objOnBoardingWrapper.postal_cat = objOnboarding.Postal_Cat1__c; //CatBcls_services 
            //Client user id to send
            objOnBoardingWrapper.client_user_name = objOnboarding.Client_User_Id__c;
            //objOnBoardingWrapper.client_xray_amount = String.valueOf(objOnboarding.X_Ray_Limit__c);
            objOnBoardingWrapper.xray_amount_limit = String.valueOf(objOnboarding.X_Ray_Limit__c);
            objOnBoardingWrapper.client_billing_mode = objOnboarding.Billing_Mode__c;
            
            System.debug('objOnboarding.Contact_number__c>>>'+objOnboarding.Contact_number__c);
            
            objOnBoardingWrapper.phone = String.valueOf(objOnboarding.Contact_number__c);  //7832142123
            objOnBoardingWrapper.billing_client_config = objOnboarding.Billing_Client_Config__c;    //
            objOnBoardingWrapper.movement_config = objOnboarding.Movement_Config__c;    //
            
            
            //SF-211: Updated Request body to HQ
            if(objOnboarding.Invoicing_Mode__c=='COD Net-off'){
                invoicingMode = 'cod_netoff';
            }else if(objOnboarding.Invoicing_Mode__c=='Delhivery Miles'){
                invoicingMode = 'prepaid';
            }else if(objOnboarding.Invoicing_Mode__c=='Monthly Invoiced'){
                invoicingMode = 'postpaid';
            }else{
                invoicingMode = objOnboarding.Invoicing_Mode__c;
            }
            
            objOnBoardingWrapper.billing_method = invoicingMode;
            List<State__c> stateList = new List<State__c>([SELECT Id,GST_Number__c,HQ_State__c,State__c,Customer_Onboarding__c FROM State__c WHERE Customer_Onboarding__c =:objOnboarding.id]);
            
            
            
            
            OnBoardingWrapper.cls_gst_states gstState = new OnBoardingWrapper.cls_gst_states();
            List<OnBoardingWrapper.cls_gst_states> listGSTStates = new List<OnBoardingWrapper.cls_gst_states>();
            for(State__c objState : stateList){
                if(objState.HQ_State__c){
                    objOnBoardingWrapper.ho_state = objState.State__c;
                }
                
                if(objState.State__c =='Andaman and Nicobar Islands'){
                    gstState.AndamanandNicobarIslands = objState.GST_Number__c;
                }
                if(objState.State__c =='Arunachal Pradesh'){
                    gstState.ArunachalPradesh = objState.GST_Number__c;
                }
                if(objState.State__c =='Andhra Pradesh'){
                    gstState.AndhraPradesh = objState.GST_Number__c;
                }
                if(objState.State__c =='Assam'){
                    gstState.Assam = objState.GST_Number__c;
                }
                if(objState.State__c =='Bihar'){
                    gstState.Bihar = objState.GST_Number__c;
                }
                if(objState.State__c =='Chandigarh'){
                    gstState.Chandigarh = objState.GST_Number__c;
                }
                if(objState.State__c =='Dadra and Nagar Haveli'){
                    gstState.DadraandNagarHaveli = objState.GST_Number__c;
                }
                if(objState.State__c =='Daman and Diu'){
                    gstState.DamanandDiu = objState.GST_Number__c;
                }
                if(objState.State__c =='Delhi'){
                    gstState.Delhi = objState.GST_Number__c;
                }
                if(objState.State__c =='Goa'){
                    gstState.Goa = objState.GST_Number__c;
                }
                if(objState.State__c =='Gujarat'){
                    gstState.Gujarat = objState.GST_Number__c;
                }
                if(objState.State__c =='Haryana'){
                    gstState.Haryana = objState.GST_Number__c;
                }
                if(objState.State__c =='Himachal Pradesh'){
                    gstState.HimachalPradesh = objState.GST_Number__c;
                }
                if(objState.State__c =='Jammu and Kashmir'){
                    gstState.JammuandKashmir = objState.GST_Number__c;
                }
                if(objState.State__c =='Jharkhand'){
                    gstState.Jharkhand = objState.GST_Number__c;
                }
                if(objState.State__c =='Karnataka'){
                    gstState.Karnataka = objState.GST_Number__c;
                }
                if(objState.State__c =='Kerala'){
                    gstState.Kerala = objState.GST_Number__c;
                }
                if(objState.State__c =='Lakshadweep Islands'){
                    gstState.LakshadweepIslands = objState.GST_Number__c;
                }
                if(objState.State__c =='Madhya Pradesh'){
                    gstState.MadhyaPradesh = objState.GST_Number__c;
                }
                if(objState.State__c =='Maharashtra'){
                    gstState.Maharashtra = objState.GST_Number__c;
                }
                if(objState.State__c =='Manipur'){
                    gstState.Manipur = objState.GST_Number__c;
                }
                if(objState.State__c =='Meghalaya'){
                    gstState.Meghalaya = objState.GST_Number__c;
                }
                if(objState.State__c =='Mizoram'){
                    gstState.Mizoram = objState.GST_Number__c;
                }
                if(objState.State__c =='Nagaland'){
                    gstState.Nagaland = objState.GST_Number__c;
                }
                if(objState.State__c =='Orissa'){
                    gstState.Orissa = objState.GST_Number__c;
                }
                if(objState.State__c =='Pondicherry'){
                    gstState.Pondicherry = objState.GST_Number__c;
                }
                if(objState.State__c =='Punjab'){
                    gstState.Punjab = objState.GST_Number__c;
                }
                if(objState.State__c =='Rajasthan'){
                    gstState.Rajasthan = objState.GST_Number__c;
                }
                if(objState.State__c =='Sikkim'){
                    gstState.Sikkim = objState.GST_Number__c;
                }
                if(objState.State__c =='Tamil Nadu'){
                    gstState.TamilNadu = objState.GST_Number__c;
                }
                if(objState.State__c =='Chhattisgarh'){
                    gstState.Chhattisgarh = objState.GST_Number__c;
                }
                
                if(objState.State__c =='Tripura'){
                    gstState.Tripura = objState.GST_Number__c;
                }
                if(objState.State__c =='Uttar Pradesh'){
                    gstState.UttarPradesh = objState.GST_Number__c;
                }
                if(objState.State__c =='Uttarakhand'){
                    gstState.Uttarakhand = objState.GST_Number__c;
                }
                if(objState.State__c =='West Bengal'){
                    gstState.WestBengal = objState.GST_Number__c;
                }
                objOnBoardingWrapper.gst_states = gstState;
                
            }
            
            OnBoardingWrapper.cls_services services = new OnBoardingWrapper.cls_services();
            
            if(objOnboarding.Services__c != null){
                strList.addAll(objOnboarding.Services__c.split(';'));
                System.debug('strList>>>>'+strList);
                for(String str : strList){
                    if(str == 'DTO'){
                        services.Pickup = true;
                    }
                    if(str == 'COD'){
                        services.COD = true;
                    }
                    if(str == 'Pre-paid'){
                        services.Prepaid = true;
                    }
                    if(str == 'REPL'){
                        services.REPL = true;
                    }
                }
            }
            objOnBoardingWrapper.services = services;
            
            string jsonstring = JSON.serialize(objOnBoardingWrapper);
            
            jsonstring = jsonstring.replace('"Prepaid":true','"Pre-paid":true');
            jsonstring = jsonstring.replace('"Prepaid":false','"Pre-paid":false');
            
            jsonstring = jsonstring.replace('"Prepaid":null,','"Pre-paid":false,');
            jsonstring = jsonstring.replace('"REPL":null,','"REPL":false,');
            jsonstring = jsonstring.replace('"Pickup":null,','"Pickup":false,');
            jsonstring = jsonstring.replace('"COD":null,','"COD":false,');
            
            
            jsonstring = jsonstring.replace('"ho_state":"Andaman and Nicobar Islands"','"ho_state":"Andaman & Nicobar"');
            jsonstring = jsonstring.replace('"ho_state":"Daman and Diu"','"ho_state":"Daman & Diu"');
            jsonstring = jsonstring.replace('"ho_state":"Jammu and Kashmir"','"ho_state":"Jammu & Kashmir"');
            
            jsonstring = jsonstring.replace('AndamanandNicobarIslands','Andaman & Nicobar');
            jsonstring = jsonstring.replace('AndhraPradesh','Andhra Pradesh');
            jsonstring = jsonstring.replace('ArunachalPradesh','Arunachal Pradesh');
            jsonstring = jsonstring.replace('DadraandNagarHaveli','Dadra and Nagar Haveli');
            jsonstring = jsonstring.replace('DamanandDiu','Daman & Diu');
            jsonstring = jsonstring.replace('HimachalPradesh','Himachal Pradesh');
            jsonstring = jsonstring.replace('JammuandKashmir','Jammu & Kashmir');
            jsonstring = jsonstring.replace('LakshadweepIslands','Lakshadweep');
            jsonstring = jsonstring.replace('MadhyaPradesh','Madhya Pradesh');
            jsonstring = jsonstring.replace('TamilNadu','Tamil Nadu');
            jsonstring = jsonstring.replace('UttarPradesh','Uttar Pradesh');
            jsonstring = jsonstring.replace('WestBengal','West Bengal');
            
            jsonstring = jsonstring.replace('"billing_client_config":"--None--"','"billing_client_config":""');
            jsonstring = jsonstring.replace('"billing_client_config":"Pickup State"','"billing_client_config":"pickup_state"');
            jsonstring = jsonstring.replace('"billing_client_config":"Drop State"','"billing_client_config":"drop_state"');
            jsonstring = jsonstring.replace('"billing_client_config":"Client HO"','"billing_client_config":"client_ho"');
            
            
            jsonstring = jsonstring.replace('"movement_config":"--None--"','"movement_config":""');
            jsonstring = jsonstring.replace('"movement_config":"Client HO state GST IN"','"movement_config":"client_ho_state_gstin"');
            jsonstring = jsonstring.replace('"movement_config":"Warehouse state GST IN"','"movement_config":"warehouse_state_gstin"');
            
            
            System.debug('jsonstring>>>>'+jsonstring);
            
            jsonstring = jsonstring.replace('"West Bengal":null,','');
            jsonstring = jsonstring.replace('"Uttar Pradesh":null,','');
            jsonstring = jsonstring.replace('"Tripura":null,','');
            jsonstring = jsonstring.replace('"Tamil Nadu":null,','');
            jsonstring = jsonstring.replace('"Sikkim":null,','');
            jsonstring = jsonstring.replace('"Rajasthan":null,','');
            jsonstring = jsonstring.replace('"Punjab":null,','');
            jsonstring = jsonstring.replace('"Pondicherry":null,','');
            jsonstring = jsonstring.replace('"Orissa":null,','');
            jsonstring = jsonstring.replace('"Nagaland":null,','');
            jsonstring = jsonstring.replace('"Mizoram":null,','');
            jsonstring = jsonstring.replace('"Meghalaya":null,','');
            jsonstring = jsonstring.replace('"Manipur":null,','');
            jsonstring = jsonstring.replace('"Maharashtra":null,','');
            jsonstring = jsonstring.replace('"Madhya Pradesh":null,','');
            jsonstring = jsonstring.replace('"Lakshadweep":null,','');
            jsonstring = jsonstring.replace('"Kerala":null,','');
            jsonstring = jsonstring.replace('"Karnataka":null,','');
            jsonstring = jsonstring.replace('"Jharkhand":null,','');
            jsonstring = jsonstring.replace('"Jammu & Kashmir":null,','');
            jsonstring = jsonstring.replace('"Himachal Pradesh":null,','');
            jsonstring = jsonstring.replace('"Haryana":null,','');
            jsonstring = jsonstring.replace('"Gujarat":null,','');
            jsonstring = jsonstring.replace('"Goa":null,','');
            jsonstring = jsonstring.replace('"Delhi":null,','');
            jsonstring = jsonstring.replace('"Daman & Diu":null,','');
            jsonstring = jsonstring.replace('"Dadra and Nagar Haveli":null,','');
            jsonstring = jsonstring.replace('"Chhattisgarh":null,','');
            jsonstring = jsonstring.replace('"Chandigarh":null,','');
            jsonstring = jsonstring.replace('"Bihar":null,','');
            jsonstring = jsonstring.replace('"Assam":null,','');
            jsonstring = jsonstring.replace('"Arunachal Pradesh":null,','');
            jsonstring = jsonstring.replace('"Andhra Pradesh":null,','');
            jsonstring = jsonstring.replace('"Andaman & Nicobar":null','');
            jsonstring = jsonstring.replace('"Uttarakhand":null,','');
            jsonstring = jsonstring.replace(',}','}');
            jsonstring = jsonstring.replace('"bank_detail":null,', '');
            System.debug('jsonstring 1>>>>'+jsonstring);
            
            
            String endPoint = hqAPI.URL__c+ objOnboarding.Client_Id__c+'/';
            system.debug('endPoint!!!'+endPoint);
            HttpResponse response = new HttpResponse();
            if(!Test.isRunningTest()){
                response = CallOutUtil.calloutPutMethod(endPoint,jsonstring); 
            }else{
                response.setStatusCode(200); //='{"updated_data":{"reg_name":"we","postal_cat":"CatB","rem_email":"r@gmail.com","allow_no_data":true,"vat_number":2322,"cst_number":234,"dto_email_recipients":"b@h.com","send_sms_cod":true,"push_url":"ew","report_recipients":"n@gmail.com, new@gmail.com","eco_code":3243,"mps_service":true,"rto_email_recipients":"a@gmail.com","send_sms_prepaid":true,"send_sms_reverse":true,"send_mail_pickup":true,"address":"weq","frs_code":3234,"return_add":"weq","upload_recipients":"wer@gmail.com","product_type":"B2B","ndr_report_recipients":"net@gmail.com","auto_pickup":true,"send_sms_cash":true,"send_sms_ndr":true},"name":"client2221 new test","success":true,"error":""}';
            }
            update objOnboarding;
            system.debug('response@@@'+response.getBody());
            String responseone = '['+response+']';
            system.debug('responseone-->'+responseone);
            //Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(response);
            //system.debug('m@@@'+m);
            //system.debug('get(success) @@@'+m.get('success'));
            //if(m.get('success') == true)
            if(response.getStatusCode() == 200){
                System.debug('In Success IF');
                //system.debug('get(success) @@@ In If'+m.get('success'));
                objOnboarding.Client_Id__c = objOnboarding.Client_Id__c;
                objOnboarding.Client_User_Id__c = objOnboarding.Client_User_Id__c;
                //objOnboarding.Success__c =  String.valueOf(m.get('success'));
                //if(m.get('error') == null)   {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Sync Successful'));
                objOnboarding.Status__c = 'Synced To HQ';
                // }
                system.debug('objOnboarding---.'+objOnboarding);
                //sf-95:To make opportunity Live(Outbound) ----samruddhi
                Opportunity objOpp = [Select id,StageName from Opportunity where id=:objOnboarding.Opportunity__c];
                objOpp.StageName = 'Live (Outbound)';       
                update objOpp;      
                //-----sf-95: ends here----
                
                //return null;
            }
            else{
                System.debug('In Success Else'+response.getBody());
                String errorMsg='';
                //objOnboarding.Error__c = String.valueOf(m.get('error'));
                /*
                JSONParser parser = JSON.createParser(response.getBody());
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
                        (parser.getText() == 'error')) {
                            // Get the value.
                            parser.nextToken();
                            errorMsg = parser.getText();
                        }
                }
                System.debug('errorMsg ->'+errorMsg);
                if( errorMsg.contains('wallet_notification_mobile') ){
                    errorMsg='Invalid Wallet Notification Mobile. Please enter 10 digit valid mobile number ';
                }
                else if(errorMsg.contains('wallet_notification_email') )
                {
                    errorMsg='Invalid Wallet Notification Email';    
                }
                else if(errorMsg.contains('wallet_provider')){
                    errorMsg='Invalid Wallet Provider';    
                }
                else if(DesiredHqName == null || DesiredHqName==''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please fill out Desired HQ Name' ));//String.valueOf(m.get('error'))         
                }
                // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please fill out Mandatory fields Wallet Notification Email, Wallet Notification Mobile, And Wallet Provider' ));//String.valueOf(m.get('error'))
                */
                 if( response.getBody().contains('phone') ){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Invalid phone number.'));  
                    //return null;
                }
                if( response.getBody().contains('gst_states') || response.getBody().contains('ho_state')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Invalid Gst state or ho_state.'));  
                    //return null;
                }
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Error:Please check Error logs for more information.'));  
                errorRecord = new Error_Log__c();
                errorRecord.Type__c = 'HQ';
                errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ response.getBody();
                insert errorRecord;
                //return null;
            }
            try{
                if(objOnboarding.Account__c!=null || objOnboarding.Account__c !=''){
                    //accountList=[SELECT Id, External_ID__c FROM Account WHERE Id=:objOnboarding.Account__c];
                    accountList=[SELECT Id, External_ID__c, Active__c, Client_Status__c, Bank_A_c_Number__c, Bank_name__c, Beneficiary_name__c, PAN_card__c, RTGS_IFSC_code__c, Registered_Address_City__c, Registered_Address_Country__c, Registered_Address_Line_1__c, Registered_Address_Line_2__c, Registered_Address_Postal_Code__c, Registered_Address_State__c, BillingAddress, BillingCity, BillingState, BillingStreet, BillingCountry FROM Account WHERE Id=:objOnboarding.Account__c];
                    
                    operatingAccountList = [SELECT Id, External_ID__c, Active__c, Client_Status__c, Bank_A_c_Number__c, Bank_name__c, Beneficiary_name__c, PAN_card__c, RTGS_IFSC_code__c, Registered_Address_City__c, Registered_Address_Country__c, Registered_Address_Line_1__c, Registered_Address_Line_2__c, Registered_Address_Postal_Code__c, Registered_Address_State__c, BillingAddress, BillingCity, BillingState, BillingStreet, BillingCountry FROM Account WHERE Id=:objOnboarding.Opportunity__r.Operating_Account__c];
                    System.debug('Service Account->'+objOnboarding.Account__c);
                }
                if(accountList.size()>0 && (DesiredHqName != null || DesiredHqName!='') ){            
                    accountList[0].External_ID__c=objOnboarding.Desired_HQ_Name__c;
                    accountList[0].Activation_Date__c=date.today();
                    accountList[0].Active__c = true;
                    accountList[0].Client_Status__c='Active';
                    accountList[0].Bank_A_c_Number__c= objOnboarding.Bank_A_c_Number__c;
                    accountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    accountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    accountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    accountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    
                    accountList[0].NDR_report_recipients__c = objOnboarding.NDR_report_recipients__c;
                    accountList[0].Report_Recipients__c = objOnboarding.Report_Recipients__c;
                    accountList[0].RTO_email_recipients__c = objOnboarding.RTO_email_recipients__c;
                    accountList[0].DTO_email_recipients__c = objOnboarding.DTO_email_recipients__c;
                    accountList[0].REM_email__c = objOnboarding.REM_email__c;
                    accountList[0].Upload_Recipients__c = objOnboarding.Upload_Recipients__c;
                    accountList[0].VAT_Number__c = objOnboarding.VAT_Number__c;
                    accountList[0].CST_Number__c = objOnboarding.CST_Number__c;
                    accountList[0].Eco_Code__c = objOnboarding.Eco_Code__c;
                    accountList[0].FRS_Code__c = objOnboarding.FRS_Code__c;
                    accountList[0].Return_Address__c = objOnboarding.Return_Address__c;
                    accountList[0].Registered_Address_Line_1__c = objOnboarding.Registered_Address_Line_1__c;
                    accountList[0].Registered_Address_Line_2__c = objOnboarding.Registered_Address_Line_2__c;
                    accountList[0].Registered_Address_City__c = objOnboarding.Registered_Address_City__c;
                    accountList[0].Registered_Address_State__c = objOnboarding.Registered_Address_State__c;
                    accountList[0].Registered_Address_Postal_Code__c = objOnboarding.Registered_Address_Postal_Code__c;
                    accountList[0].Registered_Address_Country__c = objOnboarding.Registered_Address_Country__c;
                    accountList[0].Push_url__c = objOnboarding.Push_url__c;
                    accountList[0].Product_Type__c = objOnboarding.Product_Type__c;
                    accountList[0].Is_Prepaid__c = objOnboarding.Is_Prepaid__c;
                    accountList[0].Wallet_Notification_Mobile__c = objOnboarding.Wallet_Notification_Mobile__c;
                    accountList[0].Wallet_Notification_Email__c = objOnboarding.Wallet_Notification_Email__c;
                    accountList[0].MPS_Service__c = objOnboarding.MPS_Service__c;
                    accountList[0].Send_mail_Pickup__c = objOnboarding.Send_mail_Pickup__c;
                    accountList[0].Send_SMS_Prepaid__c = objOnboarding.Send_SMS_Prepaid__c;
                    accountList[0].send_sms_cash__c = objOnboarding.send_sms_cash__c;
                    accountList[0].Send_SMS_COD__c = objOnboarding.Send_SMS_COD__c;
                    accountList[0].Send_SMS_Reverse__c = objOnboarding.Send_SMS_Reverse__c;
                    accountList[0].Send_SMS_NDR__c = objOnboarding.Send_SMS_NDR__c;
                    accountList[0].auto_pickup__c = objOnboarding.auto_pickup__c;
                    accountList[0].allow_no_data__c = objOnboarding.allow_no_data__c;
                    accountList[0].Billing_Mode__c = objOnboarding.Billing_Mode__c;
                    accountList[0].Postal_Cat__c = objOnboarding.Postal_Cat1__c;
                    accountList[0].X_Ray_Limit__c = objOnboarding.X_Ray_Limit__c;
                    accountList[0].Contact_number__c = objOnboarding.Contact_number__c;
                    accountList[0].Billing_Client_Config__c = objOnboarding.Billing_Client_Config__c;
                    accountList[0].Movement_Config__c = objOnboarding.Movement_Config__c;
                    accountList[0].Client_User_Id__c = objOnboarding.Client_User_Id__c;
                    accountList[0].Client_Id__c = objOnboarding.Client_Id__c;
                    accountList[0].Company_Registered_Name__c= objOnboarding.Company_Registered_Name__c;
                    accountList[0].Bank_A_c_Number__c = objOnboarding.Bank_A_c_Number__c;
                    accountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    accountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    accountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    accountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    accountList[0].BillingStreet = objOnboarding.Invoice_Address_Line_1__c + ' ' +objOnboarding.Invoice_Address_Line_2__c;
                    accountList[0].BillingCity = objOnboarding.Invoice_Address_City__c;
                    accountList[0].BillingState = objOnboarding.Invoice_Address_State__c;
                    accountList[0].BillingCountry = objOnboarding.Invoice_Address_Country__c;
                    accountList[0].BillingPostalCode = objOnboarding.Invoice_Address_Postal_Code__c;
                    accountList[0].Wallet_Provider__c = objOnboarding.Wallet_Provider__c;
                    accountList[0].Contract_Start_Date__c = objOnboarding.Contract_Start_Date__c;
                    accountList[0].Contract_End_Date__c = objOnboarding.Contract_End_Date__c;
                    accountList[0].Product_category__c = objOnboarding.Product_category__c;
                    accountList[0].GST_not_registered__c = objOnboarding.GST_not_registered__c;
                    accountList[0].Services__c = objOnboarding.Services__c;
                    accountList[0].Invoicing_Mode__c = objOnboarding.Invoicing_Mode__c;
                    
                    
                    for(State__c stateListToUpdate : [SELECT Id,GST_Number__c,HQ_State__c,State__c,Customer_Onboarding__c FROM State__c WHERE Customer_Onboarding__c =:objOnboarding.id ]){
                        accountList[0].State__c = stateListToUpdate.Id;
                        accountList[0].GST_Number__c = stateListToUpdate.GST_Number__c;
                        accountList[0].HQ_State__c = stateListToUpdate.HQ_State__c;
                        accountList[0].State_Name__c = stateListToUpdate.State__c;
                        
                    }
                    isHQUpdate = true;
                    update accountList;
                }
                
                if(operatingAccountList.size()>0 && (DesiredHqName != null || DesiredHqName!='') && ((operatingAccountList[0].Bank_A_c_Number__c!=null && objOnboarding.Send_to_Operating_Account__c == true) || (operatingAccountList[0].Bank_A_c_Number__c==null))){
                    //operatingAccountList[0].External_ID__c = objOnboarding.Desired_HQ_Name__c;
                    operatingAccountList[0].Activation_Date__c = date.today();
                    operatingAccountList[0].Active__c = true;
                    operatingAccountList[0].Client_Status__c='Active';
                    operatingAccountList[0].Bank_A_c_Number__c= objOnboarding.Bank_A_c_Number__c;
                    operatingAccountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    operatingAccountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    operatingAccountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    operatingAccountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    operatingAccountList[0].FRS_Code__c= objOnboarding.FRS_Code__c;
                    
                    operatingAccountList[0].NDR_report_recipients__c = objOnboarding.NDR_report_recipients__c;
                    operatingAccountList[0].Report_Recipients__c = objOnboarding.Report_Recipients__c;
                    operatingAccountList[0].RTO_email_recipients__c = objOnboarding.RTO_email_recipients__c;
                    operatingAccountList[0].DTO_email_recipients__c = objOnboarding.DTO_email_recipients__c;
                    operatingAccountList[0].REM_email__c = objOnboarding.REM_email__c;
                    operatingAccountList[0].Upload_Recipients__c = objOnboarding.Upload_Recipients__c;
                    operatingAccountList[0].VAT_Number__c = objOnboarding.VAT_Number__c;
                    operatingAccountList[0].CST_Number__c = objOnboarding.CST_Number__c;
                    operatingAccountList[0].Eco_Code__c = objOnboarding.Eco_Code__c;
                    operatingAccountList[0].FRS_Code__c = objOnboarding.FRS_Code__c;
                    operatingAccountList[0].Return_Address__c = objOnboarding.Return_Address__c;
                    operatingAccountList[0].Registered_Address_Line_1__c = objOnboarding.Registered_Address_Line_1__c;
                    operatingAccountList[0].Registered_Address_Line_2__c = objOnboarding.Registered_Address_Line_2__c;
                    operatingAccountList[0].Registered_Address_City__c = objOnboarding.Registered_Address_City__c;
                    operatingAccountList[0].Registered_Address_State__c = objOnboarding.Registered_Address_State__c;
                    operatingAccountList[0].Registered_Address_Postal_Code__c = objOnboarding.Registered_Address_Postal_Code__c;
                    operatingAccountList[0].Registered_Address_Country__c = objOnboarding.Registered_Address_Country__c;
                    operatingAccountList[0].Push_url__c = objOnboarding.Push_url__c;
                    operatingAccountList[0].Product_Type__c = objOnboarding.Product_Type__c;
                    operatingAccountList[0].Is_Prepaid__c = objOnboarding.Is_Prepaid__c;
                    operatingAccountList[0].Wallet_Notification_Mobile__c = objOnboarding.Wallet_Notification_Mobile__c;
                    operatingAccountList[0].Wallet_Notification_Email__c = objOnboarding.Wallet_Notification_Email__c;
                    operatingAccountList[0].MPS_Service__c = objOnboarding.MPS_Service__c;
                    operatingAccountList[0].Send_mail_Pickup__c = objOnboarding.Send_mail_Pickup__c;
                    operatingAccountList[0].Send_SMS_Prepaid__c = objOnboarding.Send_SMS_Prepaid__c;
                    operatingAccountList[0].send_sms_cash__c = objOnboarding.send_sms_cash__c;
                    operatingAccountList[0].Send_SMS_COD__c = objOnboarding.Send_SMS_COD__c;
                    operatingAccountList[0].Send_SMS_Reverse__c = objOnboarding.Send_SMS_Reverse__c;
                    operatingAccountList[0].Send_SMS_NDR__c = objOnboarding.Send_SMS_NDR__c;
                    operatingAccountList[0].auto_pickup__c = objOnboarding.auto_pickup__c;
                    operatingAccountList[0].allow_no_data__c = objOnboarding.allow_no_data__c;
                    operatingAccountList[0].Billing_Mode__c = objOnboarding.Billing_Mode__c;
                    operatingAccountList[0].Postal_Cat__c = objOnboarding.Postal_Cat1__c;
                    operatingAccountList[0].X_Ray_Limit__c = objOnboarding.X_Ray_Limit__c;
                    operatingAccountList[0].Contact_number__c = objOnboarding.Contact_number__c;
                    operatingAccountList[0].Billing_Client_Config__c = objOnboarding.Billing_Client_Config__c;
                    operatingAccountList[0].Movement_Config__c = objOnboarding.Movement_Config__c;
                    operatingAccountList[0].Client_User_Id__c = objOnboarding.Client_User_Id__c;
                    operatingAccountList[0].Client_Id__c = objOnboarding.Client_Id__c;
                    operatingAccountList[0].Company_Registered_Name__c= objOnboarding.Company_Registered_Name__c;
                    operatingAccountList[0].Bank_A_c_Number__c = objOnboarding.Bank_A_c_Number__c;
                    operatingAccountList[0].Bank_name__c= objOnboarding.Bank_name__c;
                    operatingAccountList[0].Beneficiary_name__c= objOnboarding.Beneficiary_name__c;
                    operatingAccountList[0].PAN_card__c= objOnboarding.PAN_card__c;
                    operatingAccountList[0].RTGS_IFSC_code__c= objOnboarding.RTGS_IFSC_code__c;
                    operatingAccountList[0].BillingStreet = objOnboarding.Invoice_Address_Line_1__c + ' ' +objOnboarding.Invoice_Address_Line_2__c;
                    operatingAccountList[0].BillingCity = objOnboarding.Invoice_Address_City__c;
                    operatingAccountList[0].BillingState = objOnboarding.Invoice_Address_State__c;
                    operatingAccountList[0].BillingCountry = objOnboarding.Invoice_Address_Country__c;
                    operatingAccountList[0].BillingPostalCode = objOnboarding.Invoice_Address_Postal_Code__c;
                    operatingAccountList[0].Wallet_Provider__c = objOnboarding.Wallet_Provider__c;
                    operatingAccountList[0].Contract_Start_Date__c = objOnboarding.Contract_Start_Date__c;
                    operatingAccountList[0].Contract_End_Date__c = objOnboarding.Contract_End_Date__c;
                    operatingAccountList[0].Product_category__c = objOnboarding.Product_category__c;
                    operatingAccountList[0].GST_not_registered__c = objOnboarding.GST_not_registered__c;
                    operatingAccountList[0].Services__c = objOnboarding.Services__c;
                    operatingAccountList[0].Invoicing_Mode__c = objOnboarding.Invoicing_Mode__c;
                    
                    system.debug('operatingAccountList>>'+operatingAccountList);
                    isHQUpdate = true;
                    update operatingAccountList;
                }
                
                
                
            }
            catch(Exception e){
                // if(m.get('error') == null)   {
                System.debug('Message>>>>'+e.getMessage());
                System.debug('Message>>>>'+e.getStackTraceString());           
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Something is wrong. Please check the error logs for more details'));
                errorRecord = new Error_Log__c();
                errorRecord.Type__c = 'HQ';
                errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ e.getMessage();
                errorRecord.Stack_Trace__c = e.getStackTraceString();
                insert errorRecord;
                //}
            }
        }
        return null;
    }
}