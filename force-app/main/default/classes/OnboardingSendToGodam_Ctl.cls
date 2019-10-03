public class OnboardingSendToGodam_Ctl {
    public Customer_Onboarding__c objOnboarding{get;set;}
    
    public OnboardingSendToGodam_Ctl(ApexPages.StandardController controller) {
        objOnboarding = (Customer_Onboarding__c) controller.getRecord();
         List<Customer_Onboarding__c> listOnBoarding =  getOnBoardingRecord(objOnboarding.Id);//get all the fields from cob
        
        if(listOnBoarding!=null && listOnBoarding.size()>0){
            objOnboarding = listOnBoarding[0];
        }
    }
    public List<Customer_Onboarding__c> getOnBoardingRecord(Id recId){
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        DescribeSObjectResult describeResult = Customer_Onboarding__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        system.debug('fieldNames****** '+fieldNames);
        String query = 'SELECT ' + String.join( fieldNames, ',' );
        query += ',Opportunity__r.Client_Category__c,  Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Email__c,Account__r.Phone__c,Account__r.Name, Opportunity__r.Operating_Account__c, Opportunity__r.StageName';
        query += ' FROM '+ describeResult.getName() + ' WHERE id = '+ '\''+ recId + '\''; 
        System.debug('Query ->'+query);
        try{
            listOnboarding = Database.query(query);
            
        }catch(Exception e){
            system.debug('Error caught >>'+e);
        }
        return listOnboarding;
    }
    public pagereference sendToGodam(){
        system.debug('objOnboarding in sendToHQ >>'+objOnboarding);
        Godam_Client_Creation__c  GodamAPI=Godam_Client_Creation__c.getValues('Create');
        if(GodamAPI != null)
        {
            String URL=GodamAPI.URL__c;
            String Authorization_Token=GodamAPI.Authorization_Token__c;
            String requestBody;
            
            if(objOnboarding.Status__c == 'Draft'){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'For send it to Godam, please Accepted the form and try again.'));
                return null;
            }
            if(objOnboarding.IsDocuments_Verified__c == false){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Varify all the documents'));
                return null;
            }
            if(objOnboarding.Desired_HQ_Name__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Desired HQ Name'));
                return null;
            }
            If(objOnboarding.Registered_Address_Line_1__c==null || objOnboarding.Registered_Address_Country__c ==null || objOnboarding.Registered_Address_State__c == null|| objOnboarding.Registered_Address_City__c==null || objOnboarding.Registered_Address_Postal_Code__c== null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter complete Registered address'));
                return null;
            }
            if(objOnboarding.Contact_number__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Contact Number'));
                return null;
            }
            if(objOnboarding.Email__c == null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter Email Address'));
                return null;
            }
            If(objOnboarding.Return_Address_Line_1__c==null || objOnboarding.Return_Address_City__c ==null || objOnboarding.Return_Address_State__c == null|| objOnboarding.Return_Address_Country__c==null || objOnboarding.Return_Address_Postal_Code__c== null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please enter complete Return address'));
                return null;
            }
            If(objOnboarding.Godam_Client_Id__c==null){
                //call create api            
                requestBody = '[{'+
                +'"name": '+'"'+objOnboarding.Desired_HQ_Name__c+'",'+
                '"address": {'+
                '"add1": "'+objOnboarding.Registered_Address_Line_1__c+'",'+
                '"add2": "'+objOnboarding.Registered_Address_Line_2__c+'",'+
                '"city": "'+objOnboarding.Registered_Address_Country__c+'",'+
                '"state": "'+objOnboarding.Registered_Address_State__c+'",'+
                '"country": "'+objOnboarding.Registered_Address_Country__c+'",'+
                '"pin": "'+objOnboarding.Registered_Address_Postal_Code__c+'",'+
                '"ph1": "'+objOnboarding.Contact_number__c+'",'+
                '"ph2": "",'+
                '"ph3": "",'+
                '"email": "'+objOnboarding.Email__c+'",'+
                '"corporate_office_address": "",'+
                '"corporate_office_phone": ""'+
                '},'+
                '"active": true,'+
                '"return_address": {'+
                '"add1": "'+objOnboarding.Return_Address_Line_1__c+'",'+
                '"add2": "'+objOnboarding.Return_Address_Line_2__c+'",'+
                '"city": "'+objOnboarding.Return_Address_City__c+'",'+
                '"state": "'+objOnboarding.Return_Address_State__c+'",'+
                '"country": "'+objOnboarding.Return_Address_Country__c+'",'+
                '"pin": "'+objOnboarding.Return_Address_Postal_Code__c+'",'+
                '"ph1": "'+objOnboarding.Contact_number__c+'",'+
                '"ph2": "",'+
                '"ph3": ""'+
                '},'+
                '"support_phone_number":"'+objOnboarding.Contact_number__c+'",'+
                '"support_email_id": "",'+
                '"is_verified": true,'+
                '"po_level_notification_type": {'+
                '"IAN": "true",'+
                '"IRN": "true",'+
                '"SAM": "true"'+
                '},'+
                '"item_level_notification_type": {'+
                '"IAN": true,'+
                '"IRN": true,'+
                '"SAM": false'+
                '},'+
                '"is_finance_active": false,'+
                '"agn_duration": "7 d",'+
                '"flags": {'+
                '"update_products_via_api": false,'+
                '"create_orders_via_s3": false,'+
                '"modify_product": false'+
                '},'+
                '"tax_flags": {'+
                '"gst_registered": false,'+
                '"hsn_required": "false"'+
                '},'+
                '"billing_entity": "vasu"'+
                '}]';
                system.debug('---requestBody--'+requestBody);
                    
                HttpRequest request = new HttpRequest();
                //HttpResponse response = new HttpResponse();
                request.setEndpoint(URL);
                request.setMethod('POST');
                request.setHeader('Authorization-Token', Authorization_Token);//added manually in future and get the value from label
                request.setHeader('cache-control','no-cache');
                request.setHeader('content-type', 'application/json');
                request.setHeader('request-id', 'request_01');
                request.setBody(requestBody);
                request.setTimeout(120000);
                Http http = new Http();
                HTTPResponse response;
                
                response = http.send(request);
                
                if(response != null)
                {
                    Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    system.debug('responseMap-->'+responseMap);
                    system.debug('responseMap.get----------->'+responseMap.get('details'));
                    list<Object> detailsMap = (list<Object>)responseMap.get('details');
                    system.debug('detailsMap'+detailsMap);
                    Map<String,Object> data;
                    String response1;
                    list<String> error;
                    Map<String,Object> ClintIddataMap;
                    String ClintId;
                    for(Object fld : detailsMap)
                    {    
                        data = (Map<String,Object>)fld;
                        if(data.get('response') != null)
                        {
                            response1= (String)data.get('name');
                            ClintIddataMap=(Map<String,Object>)data.get('data');
                            ClintId=(String)ClintIddataMap.get('access_key');
                            error=(list<String>)data.get('error');                            
                        }
                           
                    }
                    
                    if(response1 !='' || response1 != null)
                    {
                        system.debug('response'+response);
                        if(response.getStatusCode() != 200 )
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Data is not successfully inserted in godam please contact to the system administrator'));
                            Error_Log__c errorRecord= new Error_Log__c();
                            errorRecord.Type__c = 'Godam';
                            errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ response.getBody() + '. Please check following data for null values: Onboarding Email, Onboarding Desired HQ Name, Onboarding Contact First/Last Name, Billing Mode, XRay Amount Limit and Email on Onboarding. Or else, update the HQ name and try again ';
                            //errorRecord.Error_Message__c = objOnboarding.Name + ' : '+ errorMsg + '. Please check following data for null values: Onboarding Email, Onboarding Desired HQ Name, Onboarding Contact First/Last Name, Billing Mode, XRay Amount Limit and Email on Onboarding. Or else, update the HQ name and try again ';
                            insert errorRecord;
                            return null;
                        }
                        if(error!= null && error.size()>0)
                        {
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, error[0]));
                            return null;
                        }
                        if(ClintId != null)
                        {
                            system.debug('ClintId'+ClintId);
                            objOnboarding.Godam_Client_Id__c = ClintId;
                            //updateting the onboarding Godam Client Id 
                            update objOnboarding;
                            //Updating the opportunity status
                            if(objOnboarding.Opportunity__c != null)
                            {
                                Opportunity opp=[Select Id,StageName,AccountId,Account.External_ID__c from Opportunity where id=:objOnboarding.Opportunity__c];
                                if(opp !=null)
                                {
                                    Account acc=new Account(id=opp.AccountId); 
                                    acc.External_ID__c=objOnboarding.Desired_HQ_Name__c;
                                    update acc;
                                    system.debug(acc);
                                    opp.StageName='Live (Outbound)';
                                    //acc.External_ID__c='xyz';
                                    update opp;
                                }
                            }
                                                        
                            objOnboarding.Status__c='Sync to Godam';
                            update objOnboarding;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Data is successfully Sync to Godam'));
                            
                            return null;
                        }
                    }   
                }
            }else
            {
                
                //Update API                
                requestBody = '[{'+
                +'"name": '+'"'+objOnboarding.Desired_HQ_Name__c+'",'+
                '"access_key": "'+objOnboarding.Godam_Client_Id__c+'",'+
                +'"address": {'+
                '"add1": "'+objOnboarding.Registered_Address_Line_1__c+'",'+
                '"add2": "'+objOnboarding.Registered_Address_Line_2__c+'",'+
                '"city": "'+objOnboarding.Registered_Address_Country__c+'",'+
                '"state": "'+objOnboarding.Registered_Address_State__c+'",'+
                '"country": "'+objOnboarding.Registered_Address_Country__c+'",'+
                '"pin": "'+objOnboarding.Registered_Address_Postal_Code__c+'",'+
                '"ph1": "'+objOnboarding.Contact_number__c+'",'+
                '"ph2": "",'+
                '"ph3": "",'+
                '"email": "'+objOnboarding.Email__c+'",'+
                '"corporate_office_address": "",'+
                '"corporate_office_phone": ""'+
                '},'+
                '"active": true,'+
                '"return_address": {'+
                '"add1": "'+objOnboarding.Return_Address_Line_1__c+'",'+
                '"add2": "'+objOnboarding.Return_Address_Line_2__c+'",'+
                '"city": "'+objOnboarding.Return_Address_City__c+'",'+
                '"state": "'+objOnboarding.Return_Address_State__c+'",'+
                '"country": "'+objOnboarding.Return_Address_Country__c+'",'+
                '"pin": "'+objOnboarding.Return_Address_Postal_Code__c+'",'+
                '"ph1": "'+objOnboarding.Contact_number__c+'",'+
                '"ph2": "",'+
                '"ph3": ""'+
                '},'+
                '"support_phone_number":"'+objOnboarding.Contact_number__c+'",'+
                '"support_email_id": "",'+
                '"is_verified": true,'+
                '"po_level_notification_type": {'+
                '"IAN": "true",'+
                '"IRN": "true",'+
                '"SAM": "true"'+
                '},'+
                '"item_level_notification_type": {'+
                '"IAN": true,'+
                '"IRN": true,'+
                '"SAM": false'+
                '},'+
                '"is_finance_active": false,'+
                '"agn_duration": "7 d",'+
                '"flags": {'+
                '"update_products_via_api": false,'+
                '"create_orders_via_s3": false,'+
                '"modify_product": false'+
                '},'+
                '"tax_flags": {'+
                '"gst_registered": false,'+
                '"hsn_required": "false"'+
                '},'+
                '"billing_entity": "vasu"'+
                '}]';
                system.debug('---requestBody--'+requestBody);
                    
                HttpRequest request = new HttpRequest();
                //HttpResponse response = new HttpResponse();
                request.setEndpoint(URL);//'http://release-godam.delhivery.com/services/clientparty/v1/create/'
                request.setMethod('POST');
                request.setHeader('Authorization-Token', Authorization_Token);//added manually in future and get the value from label
                request.setHeader('cache-control','no-cache');
                request.setHeader('content-type', 'application/json');
                request.setHeader('request-id', 'request_01');
                request.setBody(requestBody);
                request.setTimeout(120000);
                Http http = new Http();
                HTTPResponse response;
                
                response = http.send(request);
                
                if(response != null)
                {
                Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                system.debug('responseMap-->'+responseMap);
                system.debug('responseMap.get----------->'+responseMap.get('details'));
                list<Object> detailsMap = (list<Object>)responseMap.get('details');
                system.debug('detailsMap'+detailsMap);
                Map<String,Object> data;
                String response1;
                list<String> error;
                Map<String,Object> ClintIddataMap;
                String ClintId;
                for(Object fld : detailsMap){    
                    data = (Map<String,Object>)fld;
                    if(data.get('response') != null)
                    {
                        response1= (String)data.get('name');
                        ClintIddataMap=(Map<String,Object>)data.get('data');
                        ClintId=(String)ClintIddataMap.get('access_key');
                        error=(list<String>)data.get('error');
                    }
                }
                
                if(response1 !='' || response1 != null)
                {
                    system.debug('response'+response);
                    if(response.getStatusCode() != 200 )
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Data is not successfully inserted in Godam please contact to the system administrator'));
                        return null;
                    }
                    if(error!= null && error.size()>0)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, error[0]));
                        return null;
                    }
                    if(ClintId != null)
                    {
                        objOnboarding.Status__c='Sync to Godam';
                        update objOnboarding;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Data is successfully Sync to Godam'));
                        return null;
                    }
                }
            } 
            }
        }
       return null; 
    }
}