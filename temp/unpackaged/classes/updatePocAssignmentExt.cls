public class updatePocAssignmentExt {
    public String CobRecordId{get;set;}
    
    public updatePocAssignmentExt(ApexPages.StandardController controller) {
        CobRecordId=ApexPages.currentPage().getParameters().get('id');
        system.debug('--CobRecordId--'+CobRecordId);
    }
    
    public PageReference checkValidation(){
        If(CobRecordId!='' && CobRecordId!=null){
            Customer_Onboarding__c objcustomer=[Select id,Name_POC1__c,Opportunity__r.OwnerId,Name_POC2__c,POC_Team__c,EMAIL_POC1__c,EMAIL_POC2__c,EMAIL_POC3__c From Customer_Onboarding__c where id=:CobRecordId limit 1 ];
            If(objcustomer!=null){
                If(objcustomer.Name_POC1__c==null || objcustomer.Name_POC2__c==null || objcustomer.EMAIL_POC1__c==null || objcustomer.EMAIL_POC1__c==null ||
                objcustomer.EMAIL_POC1__c=='' || objcustomer.EMAIL_POC1__c=='' ||objcustomer.Name_POC1__c=='' || objcustomer.Name_POC2__c=='' ){
                    List<User> userName = [select id, Name, Director__r.Name from User where id=:objcustomer.Opportunity__r.OwnerId];
                    List<POC_Team__c>listOfPoc=[select Name,Members_Count__c,Directors__c from POC_Team__c];
                    List<String> listofdirector=new List<String>();
                    system.debug('--listofdirector--'+listofdirector);
                    if(userName!=null){
                        if(userName[0].Director__r.Name!=null && userName[0].Director__r.Name!=''){
                        boolean checkdirector=false;
                           for(POC_Team__c each : listOfPoc)
                            {
                                if(each.Directors__c.contains(userName[0].Director__r.Name)){
                                    checkdirector=True;
                                }
                            }
                            if(checkdirector){
                                clsPOCAssignment.PocAssignment(CobRecordId);
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'POC assignment request sent successfully'));
                            }
                            else{
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Opportunity owner\'s director is not present in Poc assignment'));
                            }
                        }
                        
                    }        
                }
                else{
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'COB is already assigned to POC Team'));
                }
            }
        }
    return null;
    }

}