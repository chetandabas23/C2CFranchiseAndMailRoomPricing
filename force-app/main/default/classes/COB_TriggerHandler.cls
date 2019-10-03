public class COB_TriggerHandler 
{
// Method to create unique Desired HQ name in COB compare with Account External Ids
public static void insertHqNameMethod(List<Customer_Onboarding__c> newonboarding)
{   
    system.debug('-----insertHqmethod------');
    List<Account> listofallAccount = [select id,recordType.Name ,External_Id__c ,Name, Registered_Name__c  from Account where recordType.Name ='Service Account' and Registered_Name__c !='' Limit 30000];
    Set<String> setOfaccExtId = new Set<String>();//Fill Unique External_Id
    
    //fetch all account to check duplicate External_Id
    for(Account eachAcc : listofallAccount){
        setOfaccExtId.add(eachAcc.External_Id__c);
    }
    
    List<Customer_Onboarding__c> listofallcob = [Select id,Desired_HQ_Name__c,createdDate from Customer_Onboarding__c  order By createdDate Desc Limit 10000 ];
    
    //fetch all COB to check duplicate desired HQ
    for(Customer_Onboarding__c eachHqName : listofallcob){
        setOfaccExtId.add(eachHqName.Desired_HQ_Name__c);
    }
    setOfaccExtId.remove(null);
    String CustomlabelDate = label.COB_FilterDate;
    List<String> tempDate = CustomlabelDate.split('-');
    Date custDate = Date.valueOf(date.parse(tempDate [2]+'/'+tempDate [1]+'/'+tempDate [0]));
    //Iterate through each Trigger.new of COB
    for(Customer_Onboarding__c eachCOB : newonboarding ){
            
            system.debug('---eachCOBdate---'+eachCOB.createdDate);
            system.debug('--eachCOB.Opportunity_Name__c--'+eachCOB.Opportunity_Name__c);
            If( eachCOB.Opportunity_Name__c!=null && eachCOB.Opportunity_Record_Type__c != null )
            {  
                String HqName = eachCOB.Opportunity_Name__c.substringbefore('-').toUpperCase().replaceAll('[^a-zA-Z0-9 ]','');// convert to upper case and remove special character
                List<String> tempHqName = HqName.split(' ');
                String finalHqname ='';
                Boolean isDuplicate = true ; // Check External id is Duplicate with COB Desired HQ Name
                System.debug('Value of Each COB Opp Records Type is '+eachCOB.Opportunity_Record_Type__c);
                System.debug('Value of Their Respective Sub Category is '+eachCOB.Opportunity__r.Sub_Category__c);
                // Create Unique Desire HQ Name based on spaces present in External Id Before '-'
                for(integer i=0 ; i< tempHqName.size() ; i++){
                    if(isDuplicate ){  
                        finalHqname = finalHqname.substringbefore(' '); // to remove record type name through each iteration
                        finalHqname = finalHqname+tempHqName[i];
                        if(finalHqname.length()>20){
                            finalHqname = finalHqname.substring(0, 19);
                        }
                        // Add suffix with record type name
                        if(eachCOB.Opportunity_Record_Type__c.contains('B2B')){
                            finalHqname = finalHqname +' B2B';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Standard')){
                            finalHqname = finalHqname +' SURFACE';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('SaaS')){
                            finalHqname = finalHqname +' SAAS';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Express')){
                            finalHqname = finalHqname +' EXPRESS';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Fulfillment')){
                            finalHqname = finalHqname +' FULFILL';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('B2R')){
                            finalHqname = finalHqname +' B2R';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Cash')){
                            finalHqname = finalHqname +' CASH';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Customer')){
                            finalHqname = finalHqname +' CUSTACQ';
                        }                       
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Heavy')){
                            finalHqname = finalHqname +' HEAVY';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Hyperlocal')){
                            finalHqname = finalHqname +' HYLOCAL';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('International')){
                            finalHqname = finalHqname +' INTL';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('MPP')){
                            finalHqname = finalHqname +' MPP';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('Others')){
                            finalHqname = finalHqname +' OTHER';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('X Border Large')){
                            finalHqname = finalHqname +' XBL';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('X Border Medium')){
                            finalHqname = finalHqname +' XBM';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.contains('X Border Small')){
                            finalHqname = finalHqname +' XBS';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.Contains('C2C') && eachCOB.Opportunity_SubCategory__c=='Franchise')
                        {
                            finalHqname = finalHqname +' FRANCHISE';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.Contains('C2C') && eachCOB.Opportunity_SubCategory__c=='Mail-Room')
                        {
                            finalHqname = finalHqname +' MAILROOM';
                        }
                        else if(eachCOB.Opportunity_Record_Type__c.Contains('C2C') && eachCOB.Opportunity_SubCategory__c=='C2C')
                        {
                            finalHqname = finalHqname +' C2C';
                        }
                        isDuplicate = setOfaccExtId.contains(finalHqname); //False when no duplicate found in case of true repeat each iteration 
                        If(finalHqname.substringbefore(' ').length()<5){
                            isDuplicate = true;
                        }
                    }
                    
                }
                
                //If Desired HQ Name is not present
                
                system.debug('Enter whern hq name blank'); 
                system.debug('---isDuplicate---'+isDuplicate);
                system.debug('--finalHqname---'+finalHqname);
                If(isDuplicate){
                    // when no unique found through loop iteration
                    eachCOB.Desired_HQ_Name__c = '';
                    //eachCOB.isDuplicate_DesiredHq__c = true;
                    If(eachCOB.RTGS_IFSC_code__c!=null && eachCOB.RTGS_IFSC_code__c!=''){
                        eachCOB.RTGS_IFSC_code__c =eachCOB.RTGS_IFSC_code__c.toUpperCase();
                    }
                }
                else {
                    // when unique desire HQ name is found
                    eachCOB.Desired_HQ_Name__c = finalHqname;
                    eachCOB.CL_PANEL_User_Name__c = finalHqname.replaceAll(' ','');
                    If(eachCOB.RTGS_IFSC_code__c!=null && eachCOB.RTGS_IFSC_code__c!=''){
                        eachCOB.RTGS_IFSC_code__c =eachCOB.RTGS_IFSC_code__c.toUpperCase();
                    }
                    
                }
            }
            
    }
}

public static void updateHqNameMethod(List<Customer_Onboarding__c> newonboarding,Map<Id,Customer_Onboarding__c> oldMap)
{
    system.debug('--inside updatehqnamemethod--');
    List<Customer_Onboarding__c> listofdiffhqCOB = new List<Customer_Onboarding__c>();
    Set<Id> setofnew = new Set<Id>();
    For(Customer_Onboarding__c eachnew : newonboarding)
    {
        If(eachnew.RTGS_IFSC_code__c!=null && eachnew.RTGS_IFSC_code__c!=''){
            eachnew.RTGS_IFSC_code__c=eachnew.RTGS_IFSC_code__c.toUpperCase();
        }
        IF(eachnew.Desired_HQ_Name__c != oldMap.get(eachnew.Id).Desired_HQ_Name__c)
        {
            listofdiffhqCOB.add(eachnew);
            setofnew.add(eachnew.id);
        }
    }
    
    If(listofdiffhqCOB != null && listofdiffhqCOB.size()>0)
    {
        system.debug('-----inside updateHqmethod hqdifferent------');
        List<Account> listofallAccount = [select id,recordType.Name ,External_Id__c ,Name, Registered_Name__c  from Account where recordType.Name ='Service Account' and Registered_Name__c !=''];
          
        Set<String> setOfaccExtId = new Set<String>();//Fill Unique External_Id
       
        //fetch all account to check duplicate External_Id
        for(Account eachAcc : listofallAccount){
            setOfaccExtId.add(eachAcc.External_Id__c);
        }
        
        List<Customer_Onboarding__c> listofallcob = [Select id,Desired_HQ_Name__c,createdDate from Customer_Onboarding__c where id NOT IN: setofnew order By createdDate Desc Limit 10000 ];
        //fetch all COB to check duplicate desired HQ
        for(Customer_Onboarding__c eachHqName : listofallcob){
            setOfaccExtId.add(eachHqName.Desired_HQ_Name__c);
        }
        setOfaccExtId.remove(null);
        String CustomlabelDate = label.COB_FilterDate;
        List<String> tempDate = CustomlabelDate.split('-');
        Date custDate = Date.valueOf(date.parse(tempDate [2]+'/'+tempDate [1]+'/'+tempDate [0]));
        for(Customer_Onboarding__c eachCOB : listofdiffhqCOB ){
            If(eachCOB.createdDate >= custDate && setOfaccExtId.contains(eachCOB.Desired_HQ_Name__c)){
                    // when no unique found through loop iteration
                    system.debug('--setofaccextId----'+setOfaccExtId);
                    eachCOB.addError(label.COB_DesireHQError);
                    
                }
        }

    }
}
}