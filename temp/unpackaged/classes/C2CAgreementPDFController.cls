public class C2CAgreementPDFController {
    public String OppId{get;set;}
    public Contract__c objContract{get;set;}
    public Opportunity objOpportunity{get;set;}
    Public Integer subDate{get;set;}
    public String startDate{get;set;}
    public String ipAdress{get;set;}
    public List<OpportunityContactRole> contactRoleList{get;set;}
    Public OpportunityLineItem ObjectOLI{get; set;}
    Public OpportunityLineItem ObjectOLI1{get; set;}
    Public String strProductName{get; set;}
    Public String strProductName1{get; set;}
    public C2CAgreementPDFController(ApexPages.StandardController controller)
    {
        objContract = new Contract__c();
        objOpportunity = new Opportunity(); 
        contactRoleList = new List<OpportunityContactRole>();
        OppId = ApexPages.currentPage().getParameters().get('id'); 
        ipAdress = ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        system.debug('OppId--->'+OppId);
        if(OppId !=null)
        {
            objContract = [SELECT Status__c,Agreement_Signed_by_User_IP_Address__c,Start_Date__c,End_Date__c,Accepted_Time__c,
                           Contact__r.Email,Type__c,CreatedBy.Director__c,Effective_Date__c,Opportunity__c 
                           FROM Contract__c 
                           WHERE Opportunity__c=:OppId LIMIT 1];
            objOpportunity = [SELECT id,Name,Registered_Name__c,City__c,Director__c,
                              (SELECT Contact.Name FROM OpportunityContactRoles) 
                              FROM Opportunity 
                              WHERE id =:OppId LIMIT 1];
            contactRoleList = [SELECT id,ContactId,Contact.Name 
                               FROM OpportunityContactRole 
                               WHERE OpportunityId=:oppid LIMIT 1];
            Schema.DescribesObjectResult r= OpportunityLineItem.sObjectType.getDescribe();
            String ProductName = '%Delhivery Commercial Standard - C2C%';
            String ProductName1 = '%Delhivery Commercial Express - C2C%';
        Map<String, Schema.SObjectField> mapFields = new Map<String, Schema.SObjectField>();
        mapFields=r.fields.getMap();
        String oliQuery='SELECT ';
        String fieldNames='';
        for(String apiName: mapFields.KeySet()){
            fieldNames+=apiName+',';
        }
        fieldNames =fieldNames.subString(0,fieldNames.length() - 1 );
            oliQuery = oliQuery+ fieldNames+' From OpportunityLineItem WHERE OpportunityId=:oppId AND (NAME LIKE :ProductName OR NAME LIKE :ProductName1) AND IsActive__c = true Order By Version__c DESC LIMIT 2';
          List<OpportunityLineItem> oliList= Database.Query(oliQuery);
            ObjectOLI = new OpportunityLineItem();
            ObjectOLI1 = new OpportunityLineItem();
            if(oliList.size() != 0)
            {
            ObjectOLI = oliList[0];
                ObjectOLI.Zone_A_0_250gm__c = oliList[0].Zone_A_0_250gm__c;
            System.debug('Value in the ObjectOLI is '+ObjectOLI);
            strProductName = objectOLI.Name;
            System.debug('strPRoductName is '+strProductName);
            String strOppName = objOpportunity.Name;
            System.debug('strOppName is '+strOppName);
            if(strProductName.contains(strOppName))
            {
                System.debug('if OLI Name contains Opp Name');
               strProductName= strProductName.removeStartIgnoreCase(strOppName);
                System.debug('Value of str Product Name after update is '+strPRoductName);
            }
            ObjectOLI1 = oliList[1];
            System.debug('Value in the ObjectOLI1 is '+ObjectOLI1);
            strProductName1 = objectOLI1.Name;
            System.debug('strPRoductName is '+strProductName1);
            String strOppName1 = objOpportunity.Name;
            System.debug('strOppName is '+strOppName1);
            if(strProductName1.contains(strOppName1))
            {
                System.debug('if OLI Name contains Opp Name');
               strProductName1= strProductName1.removeStartIgnoreCase(strOppName1);
                System.debug('Value of str Product Name after update is '+strPRoductName1);
            }
            }
            if(objContract.Start_Date__c !=null)
            {
            subDate = objContract.Start_Date__c.Day(); 
            Datetime dt = (Datetime)objContract.Start_Date__c; 
            startDate = dt.format('MM/dd/yyyy');
            system.debug('objOpportunity--->'+objOpportunity);
            }
        }
    }
}