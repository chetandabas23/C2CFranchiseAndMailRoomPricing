/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: CallOutUtil
* Created Date: 6 July 2017
* Description: HQ system calloututil
*******************************************************************/
public class CallOutUtil{
    public static HttpResponse calloutMethod(String endpoint,string body)
    {
        //HQ_API__c hqAPI = HQ_API__c.getValues('Token');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('POST');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', System.Label.Token);
        //request.setHeader('Content-Type', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        //request.setHeader('Accept','application/json');
        request.setBody(body);
        request.setTimeout(120000);
        //System.debug('response>>>>'+endPoint);
        //System.debug('response>>>>'+body);
        //system.debug('http.send(request)@@'+http.send(request));
        HttpResponse response = new HttpResponse();
        System.debug('response>>>>'+response.getBody());
        if(!Test.isRunningTest())           
            response = http.send(request);
        //System.debug('response>>>>'+response);
        
           //return response.getBody();
        return response;   
    
    }
    public static HttpResponse calloutPutMethod(String endpoint,string body)
    {
        //HQ_API__c hqAPI = HQ_API__c.getValues('Token');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('PUT');
        request.setHeader('Accept', 'application/json');
        request.setHeader('Authorization', System.Label.Token);
        //request.setHeader('Content-Type', 'application/json');
        request.setHeader('Content-Type', 'application/json');
        //request.setHeader('Accept','application/json');
        request.setBody(body);
        request.setTimeout(120000);
        //System.debug('response>>>>'+endPoint);
        //System.debug('response>>>>'+body);
        //system.debug('http.send(request)@@'+http.send(request));
        HttpResponse response = new HttpResponse();
        System.debug('response>>>>'+response.getBody());
        if(!Test.isRunningTest())           
            response = http.send(request);
        //System.debug('response>>>>'+response);
        
           //return response.getBody();
        return response;   
    
    }
}