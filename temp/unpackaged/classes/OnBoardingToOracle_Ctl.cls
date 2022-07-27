/*****************************************************************************************
* Author : Nikhil K. Tyagi
* Created Date : 8-07-2018
* Description : Action Button[Send To Oracle] on COB.
* Dependencies : OnBoardingToOracle VF Page
* Test Class : OnBoardingToOracle_Ctl_Test
******************************************************************************************/

public class OnBoardingToOracle_Ctl {
    
    Public Customer_Onboarding__c objOnboarding{get;set;}
    Public List<Customer_Onboarding__c> listOnBoarding {get;set;}
    Public Boolean IsResponsed {get;set;}
    Public List<String> listOf_mandatoryFields {get;set;}
    Public Boolean IsreadyToDeploy {get;set;}
    Public Boolean IsreadyForUpdate {get;set;}
    Public ID OperatingAccID {get;set;}
    
    List<State__c> update_listOf_State ;
    Customer_Onboarding__c cob_Obj ;
    Account acc_Obj ;
    
    public OnBoardingToOracle_Ctl(ApexPages.StandardController controller){
        objOnboarding = (Customer_Onboarding__c) controller.getRecord();
        listOnBoarding = new List<Customer_Onboarding__c>(OnBoardingRecord(objOnboarding.Id));
        listOf_mandatoryFields = new List<String>();
        IsreadyToDeploy = false;
        IsResponsed = false;
        IsreadyForUpdate = false; 
    }
    
    public List<Customer_Onboarding__c> OnBoardingRecord(Id recId){
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        DescribeSObjectResult describeResult = Customer_Onboarding__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        system.debug('fieldNames****** '+fieldNames);
        String query = 'SELECT ' + String.join( fieldNames, ',' );
        query += ', Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Contract_Start_Date__c,Account__r.Contract_End_Date__c,Account__r.Email__c,Account__r.Phone__c,Account__r.Name,Account__r.Client_Alias__c,Account__r.RecordType.Name,Opportunity__r.StageName,Opportunity__r.Operating_Account__c';
        query += ', (Select id, Name,tolabel(State__c),HQ_State__c,Registered_Address_Line_1__c,Registered_Address_City__c,Registered_Address_Postal_Code__c,GST_Number__c,Oracle_Site_ID__c from States__r) ';
        query += ' FROM '+ describeResult.getName() + ' WHERE id = '+ '\''+ recId + '\''; 
        System.debug('Query ->'+query);
        try{
            listOnboarding = Database.query(query); 
        }catch(Exception e){
            System.debug('Error caught >>'+e);
        }
        return listOnboarding;
    }
    
    //will get a call from vf page to initiate class [action]
    public void sendToOracle(){
        
        //Check for mandatory Fields
        if(listOnBoarding != null && listOnBoarding.size() > 0 && XMLRequest_Insert_Class.findOperatingAccount(listOnBoarding) != null){// Conditions
            
            //mandatory fields check
            if(!XMLRequest_Insert_Class.GSTDeclarationCheck(listOnBoarding[0].ID) && listOnBoarding[0].states__r.size() == 0){
                listOf_mandatoryFields.add('Related States');
                
                //throw error
            }
            else if(listOnBoarding[0].Company_Registered_Name__c == '' || listOnBoarding[0].Company_Registered_Name__c == null){
                listOf_mandatoryFields.add('Company Registered Name');
                
                //throw error
            }
            else if(listOnBoarding[0].Registered_Address_Line_1__c == '' || listOnBoarding[0].Registered_Address_Line_1__c == null || listOnBoarding[0].Registered_Address_City__c == null || listOnBoarding[0].Registered_Address_Postal_Code__c == null || listOnBoarding[0].Registered_Address_State__c == null || listOnBoarding[0].Registered_Address_Country__c == null){
                listOf_mandatoryFields.add('Complete Registered Address(Registered Address Line 1/City/State/PostalCode/Country)');
                
                //throw error
            }
            else if(listOnBoarding[0].PAN_card__c == '' || listOnBoarding[0].PAN_card__c == null){
                listOf_mandatoryFields.add('Pan Card');
                
                //throw error
            }
            else if(listOnBoarding[0].Desired_HQ_Name__c == '' || listOnBoarding[0].Desired_HQ_Name__c == null){
                listOf_mandatoryFields.add('Desired HQ Name');
                
                //throw error
            }
            else if(listOnBoarding[0].Opportunity_Record_Type__c != 'B2B' && (listOnBoarding[0].Bank_Name__c == null || listOnBoarding[0].Bank_A_c_Number__c == null || listOnBoarding[0].RTGS_IFSC_code__c == null || listOnBoarding[0].Beneficiary_name__c == null)){
                listOf_mandatoryFields.add('Bank Details on COB');
                //Bank Detail is not mandatory for B2b services..
                //throw error
            }
            else if(listOnBoarding[0].Contact_First_Name__c == null || listOnBoarding[0].Contact_Last_Name__c == null || listOnBoarding[0].Email__c == null || listOnBoarding[0].Contact_number__c == null ){
                listOf_mandatoryFields.add('Contact Details on COB');
                
                //throw error
            }else if(listOnBoarding[0].Account__c == null || listOnBoarding[0].Account__r.RecordType.Name != 'Service Account'){
                listOf_mandatoryFields.add('Service Account');
                
                //throw error
            }else if(listOnBoarding[0].Account__r.Contract_Start_Date__c == null || listOnBoarding[0].Account__r.Contract_End_Date__c == null){
                listOf_mandatoryFields.add('Service Account need to have \'Contract Start Date\' and \'Contract End Date\'');
                
                //throw error
            }
            else if(listOnBoarding[0].Opportunity__c == null){
                listOf_mandatoryFields.add('COB\'s Opportunity with relevent Operating Account');
                
                //throw error
            }
            else if(listOnBoarding[0].Opportunity__r.Operating_Account__c == null){
                listOf_mandatoryFields.add('Opportunity with relevent Operating Account');
                
                //throw error
            }
            else if(listOnBoarding[0].Status__c == 'Viewed' || listOnBoarding[0].Status__c == 'Final' || listOnBoarding[0].Status__c == 'Accepted' ||
                    listOnBoarding[0].Status__c == 'Submitted'){
                        listOf_mandatoryFields.add('"Status" of COB must be "Synced To HQ" or "Completed"');
                        
                        //throw error
                    }
            else if(XMLRequest_Insert_Class.findOperatingAccount(listOnBoarding).Oracle_ID__c != null){
                listOf_mandatoryFields.add('-- Present in Oracle --');
                IsreadyForUpdate = true;
                
                /*ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                                                           'Present in Oracle with Oracle ID :'+XMLRequest_Insert_Class.findOperatingAccount(listOnBoarding).Oracle_ID__c));
*/
                OperatingAccID = XMLRequest_Insert_Class.findOperatingAccount(listOnBoarding).ID; // Use : For VF Page Display
                //Update Process
            }else{
                IsreadyToDeploy = true; 
                OperatingAccID = XMLRequest_Insert_Class.findOperatingAccount(listOnBoarding).ID; // Use : For VF Page Display
                
                //Insert Process
            }
            
        }else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                                                       'Please Fill the Opportunity with relevent Operating Account'));
        }
        
        System.debug('IsreadyToDeploy After Check -- > '+ IsreadyToDeploy);
        System.debug('IsreadyToDeploy After Check -- > '+ IsreadyForUpdate);
        //Intiating request if all the mandatory fields are available .
        
            System.debug('End Point Used -- >> '+System.Label.Oracle_End_Point);
            String body ;
            Http htp = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            
            req.setEndpoint(System.Label.Oracle_End_Point);
            req.setMethod('POST');
            req.setHeader('Content-Type','text/xml'); 
            req.setTimeout(50000);
            
            if(IsreadyToDeploy){
                body = XMLRequest_Insert_Class.XML_String(listOnBoarding).replaceALL('&', '&amp;') ; // Insert Request
            }else if(IsreadyForUpdate){
                body = XMLRequest_Update_Class.XML_String(listOnBoarding).replaceALL('&', '&amp;') ; // Update Request
            }else{
                // Cannot do anything in this case
            }
            System.debug('body-->>'+body);
        if(body != null && body != ''){
            
            req.setBody(body);
            res = htp.send(req);
            if(res != null && res.getStatusCode() == 200){
                processRequest(res.getBody()); //throw for parsing [code:200]
                IsResponsed = true;
            }else{
                //Error While creating the record in oracle
                System.debug('res.getStatus()---->>>>' +res.getStatus());
                IsResponsed = false;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                           'Please Contact System Administrator.['+res.getStatus()+']'));
            }
            
        }
        
    }
    
    //Response parsing method Step 1 [code:200]
    public void processRequest(String response){
        DOM.Document doc = new DOM.Document();      
        try {
            doc.load(response);
            DOM.XMLNode root = doc.getRootElement();
            System.debug('walkThrough(root)-->>'+walkThrough(root));
            finishMethod(walkThrough(root)); // End Of Execution Method of this class 
        } catch (System.XMLException e) {  // invalid XML
            System.debug('e-->> '+e.getMessage());
        }
    }
    
    //Once response is parsed. Initiate final procedures.
    public void finishMethod(String response_String){
        
        //if response does not contain any error than update 
        if(!validateResponse(response_String)){
            try{
                update update_listOf_State;
                update cob_Obj; // Updating Oracle ID in it to find out client creation source
                update acc_Obj;
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                                                           'Record Inserted To Oracle Successfully. Thank you!'));
            }catch(Exception E){
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING,
                                                           'Something went wrong while updating records in salesforce ['+e.getMessage()+']'));  
            }
        }     
        
    }
    
    //Back button Method 
    public PageReference backToCOB(){
        PageReference pageRef = new PageReference('/'+objOnboarding.ID);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    // Response parsing method Step 2 [code:200]
    private String walkThrough(DOM.XMLNode node){
        String result = '\n';
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            result += node.getName();
            if (node.getText().trim() != '') {
                result += ',' + node.getText().trim();
            }
            
            for (Dom.XMLNode child: node.getChildElements()) {
                result += walkThrough(child);
            }
            return result;
        }
        return '';  //should never reach here 
    }
    
    
    // Response parsing method Step 3 [code:200]
    private Boolean validateResponse(String String_Response){
        
        Map<String,ID> mapOf_String = new Map<String,ID>();
        List<String> listOf_response = new List<String>();
        Boolean IsError = false;
        
        update_listOf_State = new List<State__c>();
        
        listOf_response.addAll(String_Response.split('\n'));
        for(State__c each_st : listOnBoarding[0].States__r){
            //State#GSTNumber is what we receive in response
            
            mapOf_String.put(each_st.State__c+'#'+each_st.GST_Number__c,each_st.ID);
        }
        
        if(listOf_response != null && listOf_response.size() > 0){
            for(Integer index_i = 0 ; index_i < listOf_response.size() ; index_i++){
                
                if(listOf_response[index_i].contains('RETURN_MESSAGE'))
                {
                    String after_Message = listOf_response[index_i].subStringAfter('RETURN_MESSAGE');
                    if(after_Message.length() != 0){
                        //Found Error
                        IsError = true;
                        System.debug('<<<--Error-->>>');
                        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.WARNING
                                                                   ,'Please verify all the mandatory fields mentioned below.['
                                                                   +listOf_response[index_i].subStringAfter('RETURN_MESSAGE,')+']'));
                        break;
                    }
                }
                
                if(listOf_response[index_i].substringBefore(',') == 'PARTY_ID' && listOf_response[index_i].substringAfter(',') != '')
                {
                    
                    //providing COB's Update Info 
                    cob_Obj = new Customer_Onboarding__c(
                        Id = objOnboarding.Id , 
                        Status__c = 'Synced To Oracle',
                        Oracle_ID__c = Integer.valueOf(listOf_response[index_i].substringAfter(',')) // main oracle id
                    );
                   
                    
                    //providing Account's Update Info 
                    acc_Obj = new Account(
                        id = XMLRequest_Insert_Class.findOperatingAccount( listOnBoarding ).id,
                        Oracle_ID__c = Integer.valueOf(listOf_response[index_i].substringAfter(',')) // main oracle id
                    );
                }
                
                if(listOf_response[index_i] == 'SITE_DETAILS_ITEM' && listOf_response[index_i + 1].subStringAfter(',') != '' 
                   && listOf_response[index_i + 2].subStringAfter(',') != '' )
                {
                    
                    if(!XMLRequest_Insert_Class.GSTDeclarationCheck(listOnBoarding[0].ID)){ // No States will be available if it is true
                        //providing State's Update Info 
                        if(mapOf_String != null && mapOf_String.containsKey(listOf_response[index_i + 2].subStringAfter(','))){
                            State__c update_state_Obj = new State__c(
                                Oracle_Site_ID__c = Integer.valueOf(listOf_response[index_i + 1].subStringAfter(',')), // oracle site id
                                id = mapOf_String.get(listOf_response[index_i + 2].subStringAfter(',')) //name of state to id
                            );
                            update_listOf_State.add(update_state_Obj);
                        }
                    }else{
                        cob_Obj.Registered_Address_Oracle_ID__c = Integer.valueOf(listOf_response[index_i + 1].subStringAfter(',')); // oracle site id
                    }
                }
                
            }
        }
        
        return IsError;
        
    }
    
}