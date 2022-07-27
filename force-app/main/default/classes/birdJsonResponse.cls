/*****************************************************************************************
* Author : Prakhar Goyal
* Created Date : 16-11-2018
* Description : To receive and send JSON response and save error logs of the response
* Test Class : birdPricingcheck_test
******************************************************************************************/
@RestResource(urlMapping='/api/birdResponseReceiver/*')
global with sharing class birdJsonResponse
{
    @HttpPost 
    global static birdWrapper doPost(String File_Name,boolean Success,String Message,String RequestId) {
        system.debug('File_Name--->'+File_Name);
        String filename =File_Name.substringBefore('-');
        
        if(filename!=null && Success!=null && Message!=null && RequestId!=null)
        {
            list<Customer_Onboarding__c> LstCub = new list<Customer_Onboarding__c>();
            LstCub = [select id, name,Bird_Request_Id__c,status__c,Bird_Response_Status_Addendum__c,Bird_Request_Id_Addendum__c,Bird_Response_Message_Addendum__c,File_Uploaded__c,Bird_Response_Message__c,Bird_Response_Status__c,Synced_to_Bird_As_Addendum__c from Customer_Onboarding__c where Id =:filename limit 1];
            system.debug('LstCub-->'+LstCub);
            
            List<Customer_Onboarding__History> onBoardHistory = new List<Customer_Onboarding__History>();

            if(filename != null)
            {
                onBoardHistory = [SELECT ParentId, OldValue, NewValue, Field, CreatedById, CreatedDate 
                                  FROM Customer_Onboarding__History where Field = 'Status__c' and ParentId =:filename ORDER BY createddate DESC ];
            }
            system.debug('onBoardHistory-->'+onBoardHistory);
            
           
            if(LstCub!=null && 	LstCub.size()>0)
            {
                if(LstCub[0].File_Uploaded__c == true && LstCub[0].Synced_to_Bird_As_Addendum__c == false )
                {
                    LstCub[0].Bird_Response_Message__c=Message;
                    LstCub[0].Bird_Request_Id__c=RequestId;
                    LstCub[0].Bird_Response_Status__c = string.valueof(Success);
                    
                    if(LstCub[0].Bird_Response_Status__c == 'False')
                    {
                        LstCub[0].File_Uploaded__c = false;
                        LstCub[0].Status__c = string.valueof(onBoardHistory[0].OldValue);
                    }
                }
                if(LstCub[0].File_Uploaded__c == true && LstCub[0].Synced_to_Bird_As_Addendum__c == true)
                {
                    LstCub[0].Bird_Response_Message_Addendum__c=Message;
                    LstCub[0].Bird_Request_Id_Addendum__c=RequestId;
                    LstCub[0].Bird_Response_Status_Addendum__c = string.valueof(Success);
                    
                    if(LstCub[0].Bird_Response_Status_Addendum__c == 'False')
                    {
                        LstCub[0].Synced_to_Bird_As_Addendum__c = false;
                    }
                }
                           
                Database.SaveResult[] srList = database.update(LstCub);
                
                if(srList[0].isSuccess())
                {
                    System.debug('Successfull' );
                    birdWrapper clsWrapper = new birdWrapper('200', 'Successfully Updated');
                    return clsWrapper;
                    
                }
                else
                {
                    System.debug('Failed' );
                    
                    Error_Log__c objError = new Error_Log__c();
                    objError.Error_Message__c = Message;
                    objError.Type__c = 'Bird Pricing';
                    insert objError;
                    birdWrapper clsWrapper = new birdWrapper('422', 'Request failed');
                    return clsWrapper;
                }
            } 
        }
        else
        {
            Error_Log__c objError = new Error_Log__c();
            objError.Error_Message__c = Message;
            objError.Type__c = 'Bird Pricing';
            insert objError;
            birdWrapper clsWrapper = new birdWrapper('400', 'Bad Request Error');
            return clsWrapper;
        }
        
        Error_Log__c objError = new Error_Log__c();
        objError.Error_Message__c = Message;
        objError.Type__c = 'Bird Pricing';
        insert objError;
        birdWrapper clsWrapper = new birdWrapper('400', 'Internal Server Error');
        return clsWrapper;
        
    }
    global class birdWrapper
    {
        global String Message;
        global String SuccessCode;
        
        global birdWrapper(String SuccessCode, String Message )
        {
            this.Message = Message;
            this.SuccessCode = SuccessCode;
        }
    }
    
}