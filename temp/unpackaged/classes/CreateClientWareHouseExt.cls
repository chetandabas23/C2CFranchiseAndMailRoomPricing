/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: CreateClientWareHouseExt
* Created Date: 18-May-2018
* Description: Extension class for: CreateClientWareHousePage
*******************************************************************/
public class CreateClientWareHouseExt {
    
    public Customer_Onboarding__c objOnboarding{get;set;} 
    public Customer_Onboarding__c objOnboardingRecord{get;set;} 
    public string recordId;
    public string authToken;
    public string url;
    public List<Customer_Onboarding__c> listOnBoarding ;
    String requestBody;
    public Error_Log__c errorRecord;
    
    public CreateClientWareHouseExt(ApexPages.StandardController controller){
        objOnboarding = (Customer_Onboarding__c) controller.getRecord();
        listOnBoarding =  getOnBoardingRecord(objOnboarding.Id);
        errorRecord = new Error_Log__c();
    }
    
    public List<Customer_Onboarding__c> getOnBoardingRecord(Id recId){
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        DescribeSObjectResult describeResult = Customer_Onboarding__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
       
        String query = 'SELECT ' + String.join( fieldNames, ',' );
        query += ', Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Email__c,Account__r.Phone__c,Account__r.Name,Opportunity__r.StageName';
        query += ' FROM '+ describeResult.getName() + ' WHERE id = '+ '\''+ recId + '\''; 
        
        try{
            listOnboarding = Database.query(query);
        }catch(Exception e){
            system.debug('Error caught >>'+e);
        }
        return listOnboarding;
        
    }
    
    public PageReference pushDataSwagger(){
        Blob basiAuth;
        HttpResponse responseFile;
        String successResponseXML;
        authToken = Label.Swagger_Authentication_Token;
        url = Label.Swagger_End_Point_URL;
        String errorMsg ='';
        String requestBody;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        system.debug('authToken>>'+authToken);
        system.debug('url>>'+url);
        system.debug('listOnboarding>>'+listOnboarding);
        if(!listOnboarding.isEmpty() && listOnboarding[0].Status__c=='Completed' ){
            objOnboardingRecord = listOnboarding[0];
            //String clientName = objOnboardingRecord.Desired_HQ_Name__c + objOnboardingRecord.Success__c;
            String clientName = objOnboardingRecord.Desired_HQ_Name__c;
            String address='';
            if(objOnboardingRecord.Pickup_Location__c != null  && objOnboardingRecord.Pickup_Location__c !=''){
                
                address = objOnboardingRecord.Pickup_Location__c;
           
            }
            address = address.replace('null','');
            
            //address = address+'.';
            
            
            
            requestBody = '{   "name": "'+clientName+'","client_name": "'+objOnboardingRecord.Desired_HQ_Name__c+'","city":"'+objOnboardingRecord.Pickup_Address_City__c+'", "pin_code":'+ objOnboardingRecord.Pickup_Location_Pin_code__c+',   "address_details": {     "contact_person": "'+objOnboardingRecord.Contact__r.Name+'",     "email": "'+objOnboardingRecord.Email__c+'",     "phone_number": "'+objOnboardingRecord.Contact_number__c+'",     "address": "'+address+'",     "company": "'+objOnboardingRecord.Company_Registered_Name__c+'"   } '+',"same_as_fwd_add" :true}';
            
            request.setEndpoint(url);
            request.setMethod('POST');
            request.setHeader('Authorization', authToken);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(requestBody);
            request.setTimeout(120000);
            HttpResponse response = new HttpResponse();
            system.debug('requestBody >>'+requestBody);
            system.debug('request >>'+request);
            
            if(!Test.isRunningTest()){
                response = http.send(request);
                System.debug('response>>>>'+response);
                System.debug('response body>>>>'+response.getbody());
            }else{
                response.setStatusCode(201);
                response.setBody('{     "success": true,     "message": "Create successful!",     "error": {},     "result": {         "id": "197c2836-441b-493d-9933-8a945d8445d3",         "uuid_key": "delhivery::clientwarehouse::e0fefe0d-336d-4983-81a7-5e4c779b9bb1",         "registered_name": null,         "name": "tes234",         "client_name": "temp-name",         "client_id": "cms::client::05165060-186f-11e7-8398-0266029ab815",         "client_serial": 0,         "return_address": "qwerty",         "tin_number": null,         "cst_number": null,         "warehouse_type": null,         "accessibility_id": null,         "use_client_state": false,         "incoming_center": "IND302014AAA",         "rto_center": "IND302022AAB",         "dto_center": "IND302022AAB",         "active": true,         "business_days": null,         "business_hours": null,         "pick_up_days": null,         "pick_up_hours": null,         "drop_days": null,         "drop_hours": null,         "add_fix_status": "created",         "add_fix": null,         "tag": null,         "pin_code": 302018,         "city": null,         "state": "RAJASTHAN",         "country": "India",         "address_details": {             "email": "test@test.com",             "address": "string",             "company": "string",             "phone_number": "9876541230",             "contact_person": "string"         },         "created_at": "2018-05-24T07:10:05.827Z",         "updated_at": "2018-05-24T07:10:05.827Z",         "changed_by": "ums::user::e5da2fd6-42ee-11e8-813f-0e4be2ada50c",         "changed_by_username": "dev-super-admin",         "store_type": null,         "is_warehouse": true,         "appointment_required": false,         "store_capacity": null,         "restricted_entry": false,         "can_handle_palletised_load": false,         "consignee_gst": null,         "verified": false,         "pin_checked": true,         "manual_center_override": false,         "suggest": "tes234"     } }');
            }
            
            if(response.getStatusCode() == 201){
                system.debug('response body>>'+ response.getBody());
                JSONParser parser = JSON.createParser(response.getBody());
                System.debug('parser>>'+parser);
                while (parser.nextToken() != null) {
                    System.debug('parser.getCurrentToken()  '+parser.getCurrentToken());
                    
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'uuid_key')) {
                        system.debug('parser.getText()@@'+parser.getText());
                        parser.nextToken();
                        objOnboardingRecord.UUID_Key__c = parser.getText();
                    }
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'client_id')) {
                        system.debug('parser.getText()@@'+parser.getText());
                        parser.nextToken();
                        objOnboardingRecord.Warehouse_Client_Id__c = parser.getText();
                    }
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'client_serial')) {
                        system.debug('parser.getText()@@'+parser.getText());
                        parser.nextToken();
                        objOnboardingRecord.Client_Serial_No__c = parser.getText();
                    }
                }
                system.debug('objOnboarding updated values>>'+objOnboardingRecord);
                update objOnboardingRecord;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Client Warehouse created successfully!'));
                return null;
            }else{
                system.debug('response body>>'+ response.getBody());
                JSONParser parser = JSON.createParser(response.getBody());
                System.debug('parser>>'+parser);
                while (parser.nextToken() != null) {
                    System.debug('parser.getCurrentToken()  '+parser.getCurrentToken());
                    if (parser.getText() == 'error_message') {
                        parser.nextToken();
                        errorMsg = parser.getText();
                    }
                }
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Something went wrong. Please check the error logs for more information!'+response.getBody()));  
                errorRecord = new Error_Log__c();
                errorRecord.Type__c = 'Client Warehouse';
                errorRecord.Error_Message__c = objOnboardingRecord.Name + ' - ' + response.getStatus() + ', ' + response.getStatusCode() + ', '+ errorMsg;
                insert errorRecord;
                return null;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,' Please send the welcome mail before activating the warehouse!'));  
                
        }
        return null;
    }
    
}