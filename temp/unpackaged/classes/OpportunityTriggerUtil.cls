/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: OpportunityTriggerUtil
* Created Date: 24-May-2017
* Description: Utility class for Opportunity Trigger
*******************************************************************/

public class OpportunityTriggerUtil{
    //public static Boolean IsRecursive = false;
    //If Service Account is not created ,insert service account and link account to Opportunity
    public static Boolean convertedFromLead = false;
    public static void createServiceAccount(List<Opportunity> opportunityList){
        String rtId = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND DeveloperName = 'Service_Account' LIMIT 1].Id;
        Set <Id> operatingAccountId = new Set <Id>();
        Map <Id, String> frsAccountMap = new Map <Id, String>();
        Map <Id, String> accOperatingAccountMap = new Map <Id, String>();
        
        
        //Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service_Account').getRecordTypeId();
        Map<Id,String> opportunityRTMap= new Map<Id,String>();
        for(RecordType objRecordType:[Select Id, Name ,DeveloperName FROM RecordType WHERE sObjectType='Opportunity' AND (DeveloperName='B2B' or DeveloperName='SaaS' or DeveloperName='Express_Shipping' or DeveloperName='Fulfillment' or DeveloperName='Standard_Shipping' or DeveloperName='X_Border_Large' or DeveloperName='X_Border_Medium' or DeveloperName='X_Border_Small' or DeveloperName='FTL')]){
            opportunityRTMap.put(objRecordType.Id,objRecordType.Name);  
        }
        
        // Fetch Registered Name of Operating Account 
       /*  List<Account> OperatingAccountList = [SELECT Id,Registered_Name__c, FRS_Code__c FROM Account WHERE RecordType.DeveloperName='Operating_Account'];
        system.debug('OperatingAccountList >>'+OperatingAccountList); */
        
        for(Opportunity opp : opportunityList){
            operatingAccountId.add(opp.AccountId);
        }
        system.debug('operatingAccountId >>'+operatingAccountId);
        List <Account> frsCodeAccountList = [SELECT Id, FRS_Code__c, Registered_Name__c FROM Account WHERE Id=:operatingAccountId];
        if(!frsCodeAccountList.isEmpty()){
            for(Account acc: frsCodeAccountList){
                frsAccountMap.put(acc.Id, acc.FRS_Code__c);
                accOperatingAccountMap.put(acc.Id, acc.Registered_Name__c);
            }
        }
        
        
        for(Opportunity objOpportunity : opportunityList){   
            
            //if(objOpportunity.isClosed && objOpportunity.isWon && objOpportunity.Service_Account_Created__c == false){            
            if(objOpportunity.StageName=='Contract Signed' && objOpportunity.Service_Account_Created__c == false){
                try{
                   /*String recTypeName;
                    for( Id recTypeId:opportunityRTMap.keyset()){
                        if(recTypeId == objOpportunity.RecordTypeId){
                            recTypeName=opportunityRTMap.get(recTypeId);
                        }   
                    }
                    System.debug('recTypeName ->'+recTypeName);
                    */
                    String recTypeName=opportunityRTMap.get(objOpportunity.RecordTypeId);
                    System.debug('-ris-recTypeName--'+recTypeName);
                    Double monthlyvol=0;
                    If((recTypeName=='Express Shipping' || recTypeName=='Standard Shipping') && objOpportunity.Volume_Potential__c!=null){
                        monthlyvol=objOpportunity.Volume_Potential__c;
                    }else if(recTypeName=='B2B' && objOpportunity.Volume_Potential_Tonnes_Month__c!=null ){
                        monthlyvol=objOpportunity.Volume_Potential_Tonnes_Month__c;
                    }else if(recTypeName=='FTL' && objOpportunity.No_Of_Trips_For_Delhivery_Monthly__c!=null){
                        monthlyvol=objOpportunity.No_Of_Trips_For_Delhivery_Monthly__c;
                    }else if(recTypeName=='SaaS' && objOpportunity.Monthly_Expected_Waybill_Saas__c!=null){
                        monthlyvol=objOpportunity.Monthly_Expected_Waybill_Saas__c;
                    }else if(recTypeName=='Fulfillment' && objOpportunity.Inventory_Size__c!=null){
                        monthlyvol=objOpportunity.Inventory_Size__c;
                    }
                    
                    
                    Account objServiceAccount = new Account();
                    objServiceAccount.Name = objOpportunity.Name;
                    objServiceAccount.ParentId = objOpportunity.AccountId;
                    objServiceAccount.Operating_Account__c=objOpportunity.AccountId;
                    objServiceAccount.Monthly_Volume__c = monthlyvol;

                    /* for(Account objOperatingAccount: OperatingAccountList){
                        if(objOperatingAccount.Id==objOpportunity.AccountId){
                            objServiceAccount.Registered_Name__c=objOperatingAccount.Registered_Name__c; 
                            System.debug('objOperatingAccount.Registered_Name__c->'+objOperatingAccount.Registered_Name__c);  
                            //Start SF - 104 : Mapping Operating Account's FRS on Service Account's FRS
                            objServiceAccount.FRS_Code__c = frsAccountMap.get(objOperatingAccount.Id);  
                            //End SF - 104 : Mapping Operating Account's FRS on Service Account's FRS                           
                        }
                    } */
                    
                    
                    if(accOperatingAccountMap.containsKey(objOpportunity.AccountId)){
                        objServiceAccount.Registered_Name__c=accOperatingAccountMap.get(objOpportunity.AccountId);
                          
                        //Start SF - 104 : Mapping Operating Account's FRS on Service Account's FRS
                        objServiceAccount.FRS_Code__c = frsAccountMap.get(objOpportunity.AccountId);  
                        //End SF - 104 : Mapping Operating Account's FRS on Service Account's FRS                           
                    }
                    
                    //objServiceAccount.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Service_Account').getRecordTypeId();
                    objServiceAccount.recordTypeId = rtId;
                    objServiceAccount.Phone__c = objOpportunity.Phone__c;
                    objServiceAccount.Email__c = objOpportunity.Email__c;
                    objServiceAccount.Client_Category__c = objOpportunity.Client_Category__c;
                    objServiceAccount.Sub_Category__c = objOpportunity.Sub_Category__c;
                    objServiceAccount.Employee_Id__c = objOpportunity.Employee_Id__c;
                    //Start SF-137: Account owner should not be site guest user
                    objServiceAccount.OwnerId = objOpportunity.OwnerId;
                    //End SF-137: Account owner should not be site guest user
                    system.debug('objServiceAccount >>'+objServiceAccount);
                    
                    insert objServiceAccount;
                    /*for(Account objAccount : OperatingAccountList){
                        if(objOpportunity.AccountId == objAccount.Id){
                            if(recTypeName != null && recTypeName !=''){
                                objAccount.OpportunityRecordType__c=objAccount.OpportunityRecordType__c+ ' , ' +recTypeName;
                                System.debug('objAccount.OpportunityRecordType__c ->'+objAccount.OpportunityRecordType__c);
                            }   
                        }
                    }*/

                    objOpportunity.Operating_Account__c =objOpportunity.AccountId;
                    objOpportunity.AccountId = objServiceAccount.Id;
                    objOpportunity.Service_Account_Created__c = true;
                }catch(Exception e){
                    objOpportunity.addError('Duplicate Accounts Found, Please change the Opportunity Name');
                }
            }
        }        
        
        /*try{
            // Update for Record Type Names of Service Accounts on Operating Accounts
            //update OperatingAccountList;
            
            for(Account objOperatingAccount : OperatingAccountList ){
                if(objOperatingAccount.OpportunityRecordType__c !=null){
                    Boolean isB2BPresent=false,isFulfillmentPresent=false,isShippingPresent=false,isCrossBorderPresent=false ;
                    Decimal Counter=0;
                    if(objOperatingAccount.OpportunityRecordType__c.contains('B2B')  ){
                        isB2BPresent=True;
                        if(isB2BPresent){
                            Counter++;
                        }
                    }
                    if(objOperatingAccount.OpportunityRecordType__c.contains('Shipping')  ){
                        isShippingPresent=True;
                        if(isShippingPresent){
                            Counter++;  
                        }
                        
                    }
                    if(objOperatingAccount.OpportunityRecordType__c.contains('Border')  ){
                        isCrossBorderPresent=True;
                        if(isCrossBorderPresent){
                            Counter++;  
                        }
                    }
                    if(objOperatingAccount.OpportunityRecordType__c.contains('Fulfillment') ){
                        isFulfillmentPresent=True;
                        if(isFulfillmentPresent){
                            Counter++;  
                        }
                    }
                    
                    if(counter!=0){
                        System.debug('Counter ->'+Counter );
                        System.debug('isB2BPresent ->'+isB2BPresent);
                        System.debug('isShippingPresent ->'+isShippingPresent);
                        System.debug('isCrossBorderPresent ->'+isCrossBorderPresent);
                        System.debug('isFullfillmentPresent ->'+isFulfillmentPresent);
                        System.debug('(Counter/ 4) ->'+ (Counter/4));
                        System.debug('(Counter/ 4) * 100) ->'+ ((Counter/4) * 100));
                        objOperatingAccount.Service_Penetration__c=((Counter/ 4) * 100);
                        //objOperatingAccount.Service_Penetration__c=75;                                               
                    }   
                }
            }
            System.debug('OperatingAccountList ->'+OperatingAccountList);
            // Update for Service Penetration % on Operating Accounts
            update OperatingAccountList;  
            
            
        }catch(Exception e){
            System.debug('Exception on ->'+e.getLineNumber() );
            System.debug('Exception Cause ->'+e.getStackTraceString());
            for (Integer i = 0; i < e.getNumDml(); i++) {
                // Process exception here
                System.debug(e.getDmlMessage(i)); 
            }
        } */               
    }
    
    //Assign opportunity status to OLI Status   
    public static void changeActiveOListatus(List<Opportunity> opportunityList){
        Set<Id> oppIdSet = new Set<Id>();
        String strStatus = '';
        List<OpportunityLineItem> lstOLI = new List<OpportunityLineItem>();
        Map<Id, OpportunityLineItem> oppMap = new Map<Id, OpportunityLineItem>();
        for(Opportunity objOpportunity : opportunityList){
            oppIdSet.add(objOpportunity.Id); 
            strStatus= objOpportunity.Status__c;
        }
        
        for(Opportunity objOpportunity : [SELECT Id, Status__c, (SELECT Id, Name, Status__c FROM OpportunityLineItems WHERE IsActive__c = true) FROM Opportunity WHERE Id IN : oppIdSet]){
         if(objOpportunity.OpportunityLineItems.size()>0)
         {
            for(OpportunityLineItem oli:ObjOpportunity.OpportunityLineItems)
           {
               oli.Status__c = strStatus;
               lstOLI.add(oli);
           }
         }
        }
      /*  for(Opportunity objOpportunity : opportunityList){
            if(oppMap.get(objOpportunity.Id) != null && objOpportunity.Status__c != null){
                oppMap.get(objOpportunity.Id).Status__c = objOpportunity.Status__c;
            }
        }*/
        update lstOLI;
    }
    
    //Utility class to delete all related B2B Prices when OLI gets deleted    
    public static void deleteRelatedPrices(List<Opportunity> opportunityList){
        
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id, List<OpportunityLineItem>> oppMap = new Map<Id, List<OpportunityLineItem>>();
        List<Hyperlocal_Price__c> hyperLocalPriceList = new List<Hyperlocal_Price__c>();
        List<B2B_Price__c> b2bPriceList = new List<B2B_Price__c>();
        List<Slab_Price__c> slabPriceList = new List<Slab_Price__c>();
        
        for(Opportunity objOpportunity : opportunityList){
            oppIdSet.add(objOpportunity.Id);
        }
        for(Opportunity objOpportunity : [SELECT Id, (SELECT Id, Updated_Product_Name__c FROM OpportunityLineItems) FROM Opportunity WHERE Id IN : oppIdSet]){
            if(objOpportunity.OpportunityLineItems.size()>0){
                oppMap.put(objOpportunity.Id, objOpportunity.OpportunityLineItems);
            }
        }
        for(Opportunity objOpportunity : opportunityList){
            if(oppMap.get(objOpportunity.Id) != null){
                for(OpportunityLineItem objOLI : oppMap.get(objOpportunity.Id)){            
                    String oListring = String.valueOf(objOLI.Id);
                    if(oListring.length()<=15){
                        oListring += '%';
                    }
                    if(objOLI.Updated_Product_Name__c=='Hyperlocal'){
                        hyperLocalPriceList.addAll([SELECT id FROM Hyperlocal_Price__c WHERE Opportunity_Line_Item_Id__c like: oListring]);
                    }else if(objOLI.Updated_Product_Name__c=='B2B 5*5' || objOLI.Updated_Product_Name__c=='B2B 15*15' || objOLI.Updated_Product_Name__c=='B2B Lanewise'){
                        b2bPriceList.addAll([SELECT id FROM B2B_Price__c WHERE Opportunity_Line_Item_Id__c like: oListring]);
                    }else if(objOLI.Updated_Product_Name__c=='Express Shipping' || objOLI.Updated_Product_Name__c=='Standard Shipping'){
                        slabPriceList.addAll([SELECT id FROM Slab_Price__c WHERE Opportunity_Line_Item_Id__c like: oListring]);
                    }            
                }                
            }
        }
        if(hyperLocalPriceList.size()>0){
            delete hyperLocalPriceList;
        }
        if(b2bPriceList.size()>0){
            delete b2bPriceList;
        }
        if(slabPriceList.size()>0){
            delete slabPriceList;
        }        
    }
    public static void updateOpportunityFields(List<Opportunity> opportunityList){
        system.debug('in insert');
        //to populate opportunity fields after inserting or updating opportunity manually
        List<Id> AccountIds = new List<Id>();
        set<Id> opportunityIDs = new set<Id>();
        Set<Id> idset = new Set<Id>();
        List<Opportunity> opportunityUpdateList = new List<Opportunity>();
        for (Opportunity objOppAcc : opportunityList){
            AccountIds.add(objOppAcc.AccountId);
             idset.add(objOppAcc.OwnerId);
        }  
        
        //To Populate Director's Name Field On Insert or update
        system.debug('idset-->'+idset);
        Map<String,String> ownerRoleMap = new Map<String,String>();
        Set<Id> parentIds = new Set<Id>();
        Set<Id> ManagerparentIds = new Set<Id>();
        Map<String,String> managerUserMap = new Map<String,String>();
        //List<User> userList = [SELECT Id, Name, UserRoleId,UserRole.Name,ManagerId,Manager.UserRole.Name, Manager.ManagerId FROM User WHERE Id IN :idset ];
        Map<String, User> userMap = new Map<String, User>();
        /* for(User objUser : userList){
            userMap.put(objUser.Id, objUser);
            if(objUser.UserRole.Name == 'Director'){
                ownerRoleMap.put(objUser.Id,objUser.Name);
            }else if(objUser.UserRole.Name == 'Associate'){
                    
                    parentIds.add(objUser.ManagerId);
                    managerUserMap.put(objUser.ManagerId,objUser.Id);
                    
                }
                else if(objUser.UserRole.Name == 'Manager'){
                    ManagerparentIds.add(objUser.ManagerId);
                    managerUserMap.put(objUser.ManagerId,objUser.Id);
                    
                }else{
                ownerRoleMap.put(objUser.Id,'');
            }
        }
        Set<Id> managerIds = new Set<Id>();
        List<User> parentUserList = [SELECT Id, Name, UserRoleId,UserRole.Name,ManagerId,Manager.UserRole.Name FROM User WHERE Id IN :parentIds ];
        List<User> MparentUserList = [SELECT Id, Name, UserRoleId,UserRole.Name,ManagerId,Manager.UserRole.Name FROM User WHERE Id IN :ManagerparentIds ];
        for(User objUser : parentUserList){
            if(objUser.UserRole.Name == 'Director'){
                ownerRoleMap.put(managerUserMap.get(objUser.Id),objUser.Name);
            }
            if(objUser.UserRole.Name == 'Manager'){
                managerIds.add(objUser.ManagerId);
                managerUserMap.put(objUser.ManagerId,managerUserMap.get(objUser.Id));
                ownerRoleMap.put(managerUserMap.get(objUser.Id),objUser.Name);
            }
            else{
                ownerRoleMap.put(objUser.Id,'');
            }
        
        }
        for(User objUser : MparentUserList){
                if(objUser.UserRole.Name == 'Director'){
                    ownerRoleMap.put(managerUserMap.get(objUser.Id),objUser.Name);
                }
                else{
                    ownerRoleMap.put(objUser.Id,'');
                }
                
            }
        List<User> managerUserList = [SELECT Id, Name, UserRoleId,UserRole.Name,ManagerId,Manager.UserRole.Name FROM User WHERE Id IN :managerIds ];
        for(User objUser : managerUserList){
            if(objUser.UserRole.Name == 'Director' ){
                ownerRoleMap.put(managerUserMap.get(objUser.Id),objUser.Name);
            }
            else if(objUser.Manager.UserRole.Name != 'Director'){
                    ownerRoleMap.put(objUser.Id,'');
                }
            else{
                ownerRoleMap.put(objUser.Id,'');
            }
        }
        Set<Id> tempListId = new Set<Id>();
        for(Opportunity objOpp : opportunityList){
        
             if(userMap.get(objOpp .OwnerId) != null && userMap.get(objOpp .OwnerId).UserRole.Name == 'Associate' && userMap.get(objOpp .OwnerId).Manager.ManagerId == null){
                    objOpp .Director_Name__c  = '';
                }
            else if(objOpp.OwnerId != null && ownerRoleMap.containsKey(objOpp.OwnerId)){
                objOpp.Director_Name__c = ownerRoleMap.get(objOpp.OwnerId);
            }
            else{
                objOpp.Director_Name__c  = '';
            }
        
      
        } */
        
        //related account
        map<Id,Account> RelatedAccounts = new map<Id,Account>([SELECT Id, Name,Email__c,Phone__c,Client_Category__c,Sub_Category__c, BillingStreet,  BillingCity, BillingState, BillingCountry, BillingPostalCode FROM Account WHERE Id IN :AccountIds]);
        
        for(Opportunity objOpp : [SELECT Id, Name, CloseDate, Account.Name, Account.Email__c, Account.Phone__c, Account.Client_Category__c, Account.Sub_Category__c, City__c, Street__c, Country__c, Zip_Postal_Code__c, State_Province__c FROM Opportunity WHERE Id NOT IN (SELECT ConvertedOpportunityId FROM Lead) and Id=:opportunityList]){
            opportunityIDs.add(objOpp.id);
            system.debug('opportunityIDs--->'+opportunityIDs);
        }

        for(Opportunity objOpportunity : opportunityList){
            //sf-95:Stage to update as Commercials agreed if it is corporate approved- samruddhi
            if(objOpportunity.Status__c=='Corporate Approved' && objOpportunity.StageName=='Proposal Shared' )
                objOpportunity.StageName='Commercials Agreed';
            if(opportunityIDs.contains(objOpportunity.id)){                
                Account RelatedAccount = RelatedAccounts.get(objOpportunity.AccountId);
                if(RelatedAccount!=null){
                    System.debug('objOpportunity.Name---->'+objOpportunity.Name);
                    if(objOpportunity.Email__c==null && RelatedAccount.Email__c!=null){
                        System.debug('Email null');
                        objOpportunity.Email__c = RelatedAccount.Email__c;
                    }
                    if(objOpportunity.Phone__c==null && RelatedAccount.Phone__c!=null){
                        objOpportunity.Phone__c = RelatedAccount.Phone__c;
                    }
                    if((objOpportunity.Client_Category__c==null || objOpportunity.Sub_Category__c==null) && (RelatedAccount.Client_Category__c!=null || RelatedAccount.Sub_Category__c!=null)){
                        objOpportunity.Client_Category__c = RelatedAccount.Client_Category__c;
                        objOpportunity.Sub_Category__c = RelatedAccount.Sub_Category__c;                    
                    }
                    
                    if(objOpportunity.City__c==null || RelatedAccount.BillingCity!=null ){
                        objOpportunity.City__c = RelatedAccount.BillingCity;
                    }
                    
                    if(objOpportunity.Street__c==null || RelatedAccount.BillingStreet!=null ){
                        objOpportunity.Street__c = RelatedAccount.BillingStreet;
                    }
                    
                    if(objOpportunity.Country__c==null || RelatedAccount.BillingCountry!=null ){
                        objOpportunity.Country__c = RelatedAccount.BillingCountry;
                    }
                    
                    if(objOpportunity.State_Province__c==null || RelatedAccount.BillingState!=null ){
                        objOpportunity.State_Province__c = RelatedAccount.BillingState;
                    }
                    
                    if(objOpportunity.Zip_Postal_Code__c==null || RelatedAccount.BillingPostalCode!=null ){
                        objOpportunity.Zip_Postal_Code__c = RelatedAccount.BillingPostalCode;
                    }
                    
                   
                    System.debug('objOpportunity---->'+objOpportunity);                    
                }
            }
        }
    }
    public static void validationsOnApproval(List<Opportunity> opportunityList){
        map<Id, Schema.RecordTypeInfo> rt_map = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosById();
        for(Opportunity opp : opportunityList){
        system.debug('opp.Contribution_Margin__c--->'+opp.Contribution_Margin__c);
            system.debug('opp.Sub_Category__c--->'+opp.Sub_Category__c);
            //system.debug('opp.RecordType.DeveloperName--->'+rt_map.get(opp.recordTypeID).getName().containsIgnoreCase('Express'));
            system.debug('opp'+opp);
            //sf-83
            if(opp.Status__c == 'Submitted' && opp.New_B2B_Pricing__c==false && rt_map.get(opp.recordTypeID).getName().containsIgnoreCase('B2B')==true && opp.Approval_for_Upload_Contract__c==false)
                opp.addError('You are using old Pricing. Please save new Pricing on record and try again.');
            //sf-40,41
            //contribution validation to be commented---samruddhi 13/3/2018
            /*if(opp.Status__c == 'Submitted' && opp.Contribution_Margin__c==null && opp.Sub_Category__c!='Long tail e-tailers and platform sellers' && opp.Maximum_Discount__c>0)
                opp.addError('Please fill Contribution margin before submitting for approval.');             */
            if(opp.Status__c == 'Submitted' && opp.Volume_Potential__c==null && (rt_map.get(opp.recordTypeID).getName().containsIgnoreCase('Express')==true || rt_map.get(opp.recordTypeID).getName().containsIgnoreCase('Standard')==true))
                opp.Volume_Potential__c.addError('Please enter a value Volume Potential(Monthly) to submit this pricing for approval.');
            if(opp.Status__c == 'Submitted' && opp.Volume_Potential_Tonnes_Month__c==null && rt_map.get(opp.recordTypeID).getName().containsIgnoreCase('B2B')==true)
                opp.Volume_Potential_Tonnes_Month__c.addError('Please enter a value Volume Potential(Tonnes/Month) to submit this pricing for approval.');  
        }
    }
    /*public static void UpdateInvoiceModeCOB(List<Opportunity> opportunityList){
        IsRecursive = true;
        system.debug('After trigger');
        set<id> oppIdSet = new set<id>();
        List<Customer_Onboarding__c> customerOnboardingList = new List<Customer_Onboarding__c>();
        for(Opportunity oppObj : opportunityList){
            system.debug('oppObj--->'+oppObj); 
            oppIdSet.add(oppObj.id);            
        }
        system.debug('oppIdSet--->'+oppIdSet);
        for(Customer_Onboarding__c objCOB : [select id,Invoicing_mode__c,Opportunity__r.Invoicing_mode__c from Customer_Onboarding__c where Opportunity__c=:oppIdSet]){
            system.debug('objCOB.Opportunity__r.Invoicing_mode__c--->'+objCOB.Opportunity__r.Invoicing_mode__c);
            objCOB.Invoicing_mode__c = objCOB.Opportunity__r.Invoicing_mode__c;
                customerOnboardingList.add(objCOB); 
        }
        if(customerOnboardingList.size()>0){
            update customerOnboardingList;
        }
    }*/
    
    /*Start SF-121: On updating Opportunity Record Type, update the associated PriceBook*/
    public static void updatePriceBook(Map <Id, Opportunity> oppIdMap){
        system.debug('In updatePriceBook : oppIdMap >>' + oppIdMap);
        
        Set <String> recordTypeNames = new Set <String>();
        List <PriceBook2> pbList = new List <PriceBook2>();
        List <Opportunity> updateOppRecordType = new List <Opportunity>();
        List <Opportunity> oppList = new List <Opportunity>();
        Map <String, Id> pbMap = new Map <String, Id>();
        
        oppList = [SELECT Id, RecordTypeId, RecordType.Name, PriceBook2Id FROM Opportunity WHERE Id=:oppIdMap.keySet()];
            
        system.debug('In else : oppList >>' + oppList);
        
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                recordTypeNames.add(opp.RecordType.Name);
            }
        }
        system.debug('In else : recordTypeNames >>' + recordTypeNames);
        if(recordTypeNames.size()>0){
            pbList  = [SELECT Id, Name FROM Pricebook2 WHERE Name=: recordTypeNames];
        }
        system.debug('In else : pbList >>' + pbList);
        if(!pbList.isEmpty()){
            for(PriceBook2 pb : pbList){
                pbMap.put(pb.Name, pb.Id);
            }
        }
        system.debug('In else : pbMap >>' + pbMap);
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                if(pbMap.containsKey(opp.RecordType.Name)){
                    opp.PriceBook2Id = pbMap.get(opp.RecordType.Name);
                    updateOppRecordType.add(opp);
                }
            }
        }
        system.debug('In else : updateOppRecordType >>' + updateOppRecordType);
        if(!updateOppRecordType.isEmpty()){
            try{
                update updateOppRecordType;
            }catch(Exception e){
                system.debug('Exception caught while updating record type >>'+e);
            }    
        }
    }
    /*End SF-121: On updating Opportunity Record Type, update the associated PriceBook*/
    
    /*Start SF-130: While creating Opportunity from accounts all the related fields should be automatically filled in new opportunity
                    Contact Roles: should get replicated from the account */
    public static void addOpportunityContact (List<Opportunity> opportunityList){
        List <Id> AccountIds = new List<Id>();
        List <Contact> relatedContactList = new List<Contact>();
        List <Lead> relatedLead = new List<Lead>();
        Map <Id, Id> relatedOpportunityMap = new Map <Id, Id>();
        Set <Id> idSet = new Set <Id>(); 
        
        
        for (Opportunity objOppAcc : opportunityList){
            AccountIds.add(objOppAcc.AccountId);
            relatedOpportunityMap.put(objOppAcc.AccountId, objOppAcc.Id);
            idSet.add(objOppAcc.Id);
        }
        system.debug('relatedOpportunityMap  >>'+relatedOpportunityMap  );
        /*relatedLead = [SELECT Id, IsConverted, ConvertedOpportunityId from Lead WHERE IsConverted=true];
        system.debug('relatedLead>>'+relatedLead );
        system.debug('idSet>>'+idSet );
        
        if(!relatedLead.isEmpty()){
            for(Lead ltest : relatedLead){
                system.debug('idSet>>'+idSet );
                system.debug('ltest.ConvertedOpportunityId>>'+ltest.ConvertedOpportunityId );
                if(idSet.contains(ltest.ConvertedOpportunityId)){
                    convertedFromLead = true;
                }
            }
        }
        */
        
        system.debug('convertedFromLead  >>'+convertedFromLead );
        if(!convertedFromLead){
            List <OpportunityContactRole> oppContactList = new List <OpportunityContactRole> ();
            OpportunityContactRole oppContact ;
            Map <Id, Id> relatedContactMap = new Map <Id, Id>();
            relatedContactList = [SELECT Id, Email, Phone, AccountId FROM Contact WHERE AccountId IN :AccountIds];
            
            if(!relatedContactList.isEmpty()){
                for(Contact con: relatedContactList){
                    relatedContactMap.put(con.AccountId, con.Id);
                }
            }
            
            if(relatedContactMap.size()>0){
                for(Contact con: relatedContactList){
                    oppContact = new OpportunityContactRole();
                    oppContact.ContactId = relatedContactMap.get(con.AccountId);
                    oppContact.OpportunityId = relatedOpportunityMap.get(con.AccountId);
                    oppContactList.add(oppContact);
                }
            }
            system.debug('oppContactList >>'+oppContactList);
            if(!oppContactList.isEmpty()){
                insert oppContactList;
            }
        }
        
    }
    /*End SF-130*/
    //added by rishabh to inactive ftl account base on  is account inactive field
    public static void inactiveFtlAccount(List<Opportunity> opportunityList,Map<Id,Opportunity> oldMap){
        System.debug('--inside inactiveFtlAccount--');
        List<Account> lstacc=new List<Account>();
        Id FTLTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('FTL').getRecordTypeId();
        For(Opportunity eachopp:  opportunityList){
            if(eachopp.recordTypeId==FTLTypeId && eachopp.Is_Account_Inactive__c==true && oldMap.get(eachopp.id).Is_Account_Inactive__c==false){
                Account objacc=new Account(id=eachopp.AccountId);
                objacc.Client_Status__c='Inactive';
                lstacc.add(objacc);
            }
        }
        if(lstacc!=null && lstacc.size()>0){
            update lstacc;
        }
        
    }
    
    
}