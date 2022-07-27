@IsTest
public class C2CAgreementPDFControllerTest {
    
    public static testMethod void testC2CPDF()
    {
         Account objAccount= new Account();
        objAccount.Name='Test Account';
        objAccount.Invoicing_Mode__c='Prepaid';
        objAccount.Phone__c='7798989898';
        insert objAccount;
        
        // Contacts created to send mail and associate it with Opportunity
        Contact objContact= new Contact();
        objContact.FirstName='Pradeep';
        objContact.LastName='Gore';
        objContact.Email='test1@techilaservices.com';
        objContact.AccountId=objAccount.Id;
        insert objContact;
        
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name='Test opportunity1';
        objOpportunity.StageName='Commercials Agreed';
        objOpportunity.Description='test';
        objOpportunity.Sites_Listed_On__c='test1';
        objOpportunity.CloseDate=System.today();
        objOpportunity.Forward_Base__c=500;
        objOpportunity.AccountId=objAccount.Id;
        objOpportunity.Volume_Potential__c=23.3;
        objOpportunity.Create_Opportunity__c = true;
        
        insert objOpportunity;
        Contract__c objContract3 = new Contract__c();
        objContract3.Type__c= 'B2B';
        objContract3.Opportunity__c=objOpportunity.Id;
        objContract3.Start_Date__c=system.today();
        objContract3.Effective_Date__c=system.today();
        objContract3.End_Date__c=system.today();
        insert objContract3;
        
        List<OpportunityContactRole> OCRList= new List<OpportunityContactRole>();
        OpportunityContactRole objOCR1= new OpportunityContactRole();
        objOCR1.ContactId=objContact.Id;
        objOCR1.OpportunityId=objOpportunity.Id;
        objOCR1.Role='Signing Authority';
        objOCR1.IsPrimary=true;
        OCRList.add(objOCR1);
        insert OCRList;
        
        Test.startTest();
        ApexPages.currentpage().getParameters().put('id',objOpportunity.Id);
        ApexPages.StandardController sc= new ApexPages.StandardController(objOpportunity);
        C2CAgreementPDFController objController= new C2CAgreementPDFController(sc);    
        Test.stopTest();  
    }
}