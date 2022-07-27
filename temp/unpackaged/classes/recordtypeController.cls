/*****************************************************************************************
* Author : Nikhil K. Tyagi
* Created Date : 7-11-2018
* Description : Action Button[ New Service ] on Operating Account.
* Dependencies : selectRecordTypeComp.cmp/js
* Test Class : recordtypeController_Test
******************************************************************************************/
public class recordtypeController {
    
    public static Map<Id, String> recordtypemap {get;set;}
    
    @AuraEnabled        
    public static List<String> fetchRecordTypeValues(){
        List<Schema.RecordTypeInfo> recordtypes = Opportunity.SObjectType.getDescribe().getRecordTypeInfos();    
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master' && rt.isAvailable())
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(String recordTypeLabel){
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();        
        return recid;
    }      
}