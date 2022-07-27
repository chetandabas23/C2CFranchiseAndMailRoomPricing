/*****************************************************************************************
* Author : Prakhar Goyal
* Created Date : 19-02-2019
* Description : Get username based on email id from UMS and update POC to HQ 
* Dependencies :pocCalloutMock class, SendPOCtoHQ VF Page
* Test Class : cls_PocSendtoHq_Test
******************************************************************************************/

global class cls_PocSendtoHq {
    
    public static Customer_Onboarding__c objOnboarding{get;set;}
    public static String ClientName;
    public static String Username1;
    public static String Username2;
    public static String Username3;
    
    
    public cls_PocSendtoHq(id objOnboardingid) {
        system.debug('Inside Constructor');
      
        }
    public static List<Customer_Onboarding__c> getOnBoardingRecord(Id recId){
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        
        try{
            listOnboarding = [select id,name,Desired_HQ_Name__c,EMAIL_POC1__c,EMAIL_POC2__c,EMAIL_POC3__c,Name_POC1__c,Name_POC2__c,Phone_POC1__c,Phone_POC2__c,
                              Operating_Account__c,Opportunity__c,POC_Team__c,HQ_UUID__c,POC_HQ_Response__c,Account__r.Id from Customer_Onboarding__c
                              Where id =:recId ];
            system.debug('listOnboarding--->'+listOnboarding);
            
        }catch(Exception e){
            system.debug('Error caught >>'+e);
        }
        return listOnboarding;
    }
    
    @future(callout = true)
    public static void sendPOCtoHq(id objOnboardingid)
    {
        
        List<Customer_Onboarding__c> listOnBoarding =  getOnBoardingRecord(objOnboardingid);//get all the fields from cob
        
        if(listOnBoarding!=null && listOnBoarding.size()>0){
            objOnboarding = listOnBoarding[0];
            
            HqPocAPI__c HQAPI = HqPocAPI__c.getValues('Get Username');
            String URL =HQAPI.URL__c;
        system.debug('URL-->'+URL);
        
        Id serviceAccId ;
        List<Account> serviceAcc = new List<Account>();
        
        if(objOnboarding.Account__r.Id != null)
        {
            serviceAccId = objOnboarding.Account__r.Id;
        }
        
        boolean getresponse1 = false;
        boolean getresponse2 = false;
        
        if(objOnboarding.Desired_HQ_Name__c != null)
        {
            if(objOnboarding.EMAIL_POC1__c != null && objOnboarding.EMAIL_POC2__c != null && objOnboarding.EMAIL_POC3__c != null) 
            {
                
                String emailPoc1 = objOnboarding.EMAIL_POC1__c ;
                String emailPoc2= objOnboarding.EMAIL_POC2__c ;
                String emailPoc3= objOnboarding.EMAIL_POC3__c ;
                ClientName =objOnboarding.Desired_HQ_Name__c;
                
                system.debug('objOnboarding details ---->>'+objOnboarding);
                system.debug('Start Getting User name based on Email ID');
                
                // For POC EMAIL 1
                if(emailPoc1 != null)
                {
                    HttpRequest request = new HttpRequest();
                    //HttpResponse response = new HttpResponse();
                    request.setEndpoint(URL + '?is_active=true&page=1&page_size=20&q='+emailPoc1);
                    request.setMethod('GET');
                    request.setHeader('Authorization',System.Label.HQPOCToken);
                    request.setTimeout(120000);
                    Http http = new Http();
                    system.debug('HTTP Request created');
                    
                    try{
                        HttpResponse response = new HttpResponse();
                        response = http.send(request);
                        
                        System.debug('RESPONSE STRING: ' + response.toString());
                        System.debug('RESPONSE STATUS: '+response.getStatus());
                        System.debug('STATUS_CODE: '+response.getStatusCode());
                        System.debug('Body: '+response.getBody());
                        
                        if(response != null && response.getStatusCode() == 200)
                        {    
                            Map<String,Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                            system.debug('responseMap-->'+responseMap);
                            system.debug('responseMap.get----------->'+responseMap.get('users'));
                            list<Object> detailsMap = (list<Object>)responseMap.get('users');
                            system.debug('detailsMap'+detailsMap);
                            Map<String,Object> data;
                            list<String> error;
                            Map<String,Object> ClintIddataMap;
                            String ClintId;
                            for(Object fld : detailsMap)
                            {    
                                data = (Map<String,Object>)fld;
                                if(data.get('username') != null)
                                {
                                    Username1= (String)data.get('username');
                                    getresponse1 = true;
                                }
                                
                            }
                            system.debug('Username1-->'+Username1);
                        }
                        if(Username1 == null)
                        {
                            objOnBoarding.Status__c = 'Error';
                            update objOnBoarding;
                            Error_log__c objError = new Error_log__c();
                            objError.Type__c ='POC HQ';
                            objError.Error_Message__c=objOnboarding.name+'-Username1'+' '+string.valueof(response.getBody());
                            insert objError;
                        } 
                        
                    }
                    catch(System.CalloutException e)
                    {
                        system.debug('POC 1 Callout Exception: ' + e.getMessage());
                    }
                }
                
                // For POC EMAIL 2
                if(emailPoc2 != null && getresponse1)
                {
                    HttpRequest request2 = new HttpRequest();
                    request2.setEndpoint(URL + '?is_active=true&page=1&page_size=20&q='+emailPoc2);
                    request2.setMethod('GET');
                    request2.setHeader('Authorization',System.Label.HQPOCToken);
                    request2.setTimeout(120000);
                    Http http2 = new Http();
                    system.debug('HTTP Request created');
                    
                    try
                    {
                        HttpResponse response2 = new HttpResponse();
                        response2 = http2.send(request2);
                        
                        System.debug('RESPONSE STRING 2: ' + response2.toString());
                        System.debug('RESPONSE STATUS 2: '+response2.getStatus());
                        System.debug('STATUS_CODE 2: '+response2.getStatusCode());
                        System.debug('Body2: '+response2.getBody());
                        
                        
                        if(response2 != null && response2.getStatusCode() == 200)
                        {    
                            Map<String,Object> responseMap2 = (Map<String, Object>) JSON.deserializeUntyped(response2.getBody());
                            system.debug('responseMap2-->'+responseMap2);
                            system.debug('responseMap2.get----------->'+responseMap2.get('users'));
                            list<Object> detailsMap2 = (list<Object>)responseMap2.get('users');
                            system.debug('detailsMap2'+detailsMap2);
                            Map<String,Object> data2;
                            for(Object fld : detailsMap2)
                            {    
                                data2 = (Map<String,Object>)fld;
                                if(data2.get('username') != null)
                                {
                                    Username2= (String)data2.get('username');
                                    getresponse2 = true;
                                }
                                
                            }
                            system.debug('Username2-->'+Username2);
                        }
                        
                        if(Username2 == null)
                        {
                            objOnBoarding.Status__c = 'Error';
                            update objOnBoarding;
                            Error_log__c objError = new Error_log__c();
                            objError.Type__c ='POC HQ';
                            objError.Error_Message__c=objOnboarding.name+'-Username2'+' '+string.valueof(response2.getBody());
                            insert objError;
                            
                        } 
                        
                    } catch(System.CalloutException e)
                    {
                        system.debug('POC 2 Callout Exception: ' + e.getMessage());
                    }
                }
                
                // For POC EMAIL 3
                if(emailPoc3 != null && getresponse2)
                {
                    HttpRequest request3 = new HttpRequest();
                    request3.setEndpoint(URL + '?is_active=true&page=1&page_size=20&q='+emailPoc3);
                    request3.setMethod('GET');
                    request3.setHeader('Authorization',System.Label.HQPOCToken);
                    request3.setTimeout(120000);
                    Http http3 = new Http();
                    system.debug('HTTP Request created');
                    
                    try
                    {
                        HttpResponse response3 = new HttpResponse();
                        response3 = http3.send(request3);
                        
                        System.debug('RESPONSE STRING 3: ' + response3.toString());
                        System.debug('RESPONSE STATUS 3: '+response3.getStatus());
                        System.debug('STATUS_CODE 3: '+response3.getStatusCode());
                        System.debug('Body3: '+response3.getBody());
                        
                        
                        if(response3 != null)
                        {    
                            Map<String,Object> responseMap3 = (Map<String, Object>) JSON.deserializeUntyped(response3.getBody());
                            system.debug('responseMap3-->'+responseMap3);
                            system.debug('responseMap3.get----------->'+responseMap3.get('users'));
                            list<Object> detailsMap3 = (list<Object>)responseMap3.get('users');
                            system.debug('detailsMap3'+detailsMap3);
                            Map<String,Object> data3;
                            for(Object fld : detailsMap3)
                            {    
                                data3 = (Map<String,Object>)fld;
                                if(data3.get('username') != null)
                                {
                                    Username3= (String)data3.get('username');
                                }
                                
                            }
                            system.debug('Username3-->'+Username3);
                        }
                        if(Username3 == null)
                        {
                            objOnBoarding.Status__c = 'Error';
                            update objOnBoarding;
                            Error_log__c objError = new Error_log__c();
                            objError.Type__c ='POC HQ';
                            objError.Error_Message__c=objOnboarding.name+'-Username3'+' '+string.valueof(response3.getBody());
                            insert objError;
                            
                        } 
                        
                    } 
                    catch(System.CalloutException e)
                    {
                        system.debug('POC 3 Callout Exception: ' + e.getMessage());
                    }
                }
                
                if(ClientName != null && Username1 != null && Username2 != null && Username3 != null)
                {
                    
                    HqPocAPI__c HQPOCupdtae = HqPocAPI__c.getValues('Send to HQ');
                    String URLHQ =HQPOCupdtae.URL__c;
                    
                    String Body = '{'+
                        +'"client_name": '+'"'+ClientName+'",'+
                        +'"user_name": '+'"'+Username1+'",'+
                        +'"poc1_name": '+'"'+Username2+'",'+
                        +'"poc2_name": '+'"'+Username3+'"'+
                        '}';
                    
                    system.debug('Body--->'+Body);
                    
                    HttpRequest requestPoc = new HttpRequest();
                    requestPoc.setEndpoint(URLHQ);
                    requestPoc.setMethod('POST');
                    requestPoc.setHeader('Authorization',System.Label.HQPOCUpdate);
                    requestPoc.setHeader('accept','application/json');            
                    requestPoc.setHeader('Content-Type','application/json');   
                    requestPoc.setBody(body);
                    requestPoc.setTimeout(120000);
                    Http httpPOC = new Http();
                    system.debug('HTTP Request created for POC to HQ');
                    
                    try {
                        
                        HttpResponse responsePOC = new HttpResponse();
                        responsePOC = httpPOC.send(requestPoc);
                        
                        System.debug('responsePOC STRING: ' + responsePOC.toString());
                        System.debug('responsePOC STATUS: '+responsePOC.getStatus());
                        System.debug('STATUS_CODE poc: '+responsePOC.getStatusCode());
                        System.debug('Body poc: '+responsePOC.getBody());
                        
                        String dataJson;
                        String success;
                        String error;
                        
                        if(responsePOC != null && responsePOC.getStatusCode() == 200)
                        {    
                         //   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'POC Updated Successfully'));
                          system.debug('POC Updated Successfully');  
                            Map<String,Object> responseMapPoc = (Map<String, Object>) JSON.deserializeUntyped(responsePOC.getBody());
                            system.debug('responseMapPoc-->'+responseMapPoc);
                            
                            dataJson= string.valueof(responseMapPoc.get('data'));
                            success = string.valueof(responseMapPoc.get('success'));
                            error = string.valueof(responseMapPoc.get('error'));
                            
                            system.debug('dataJson-->'+dataJson);
                            system.debug('success-->'+success);
                            system.debug('error-->'+error);
                            
                            objOnBoarding.POC_HQ_Response__c = string.valueof(responsePOC.getBody());
                            update objOnBoarding;
                            
                            if(objOnboarding.id != null)
                            {
                                serviceAcc = [select id,name,recordtype.name,EMAIL_POC_1__c,EMAIL_POC_2__c,EMAIL_POC_3__c,NAME_POC_1__c,NAME_POC_2__c,Phone_POC1__c,Phone_POC2__c  
                                              From account 
                                              where recordtype.name ='service account' and id =: serviceAccId];
                                
                                if(serviceAcc.size() > 0 && serviceAcc[0].Id != null)
                                {
                                    serviceAcc[0].EMAIL_POC_1__c = objOnboarding.EMAIL_POC1__c;
                                    serviceAcc[0].EMAIL_POC_2__c = objOnboarding.EMAIL_POC2__c;
                                    serviceAcc[0].EMAIL_POC_3__c = objOnboarding.EMAIL_POC3__c;
                                    serviceAcc[0].NAME_POC_1__c = objOnboarding.Name_POC1__c;
                                    serviceAcc[0].NAME_POC_2__c = objOnboarding.Name_POC2__c;
                                    serviceAcc[0].Phone_POC1__c = objOnboarding.Phone_POC1__c;
                                    serviceAcc[0].Phone_POC2__c = objOnboarding.Phone_POC2__c;
                                    serviceAcc[0].POC_TEAM__c = objOnboarding.POC_Team__c;
                                    update serviceAcc;
                                }
                                else
                                    
                                {
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'POC-HQ Sync :There is no Service Account available'));
                                }
                            } 
                            
                            
                        }
                        else
                        {   
                            
                            if(responsePOC != null )
                                objOnBoarding.POC_HQ_Response__c = string.valueof(responsePOC.getBody());
                            objOnBoarding.Status__c = 'Error';
                            update objOnBoarding;
                            Error_log__c objError = new Error_log__c();
                            objError.Type__c ='POC HQ';
                            objError.Error_Message__c=objOnboarding.name+'-HQ'+' '+string.valueof(responsePOC.getBody());
                            insert objError;
                            
                        }
                        
                    } catch(System.CalloutException e)
                    {
                        system.debug('HQ Service Callout Exception: ' + e.getMessage());
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'POC-HQ Sync :Something went wrong ! Please contact with System Admin.'));

                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'POC-HQ Sync :Please check the POC Emails.'));
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'POC-HQ Sync :Please Insert the Desired Hq name for respective Service.'));
        }
        
    }
}
    
}