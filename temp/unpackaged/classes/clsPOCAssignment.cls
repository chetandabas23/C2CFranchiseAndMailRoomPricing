public class clsPOCAssignment
{
    @future
    public static void PocAssignment(String CusOnboardingId)
    {
        System.debug('CusOnboardingId'+CusOnboardingId);
        
        list<Customer_Onboarding__c>objCob=[Select Opportunity__r.Account.Operating_Account__r.Id,owner.name,Opportunity__r.owner.name,Opportunity_Record_Type__c,Phone_POC1__c,Phone_POC2__c,Name_POC1__c,Name_POC2__c,EMAIL_POC1__c,EMAIL_POC2__c,EMAIL_POC3__c from Customer_Onboarding__c where id=:CusOnboardingId limit 1];
        
        System.debug('objCob[0].Opportunity__r.Account.Operating_Account__r.Id'+objCob[0].Opportunity__r.Account.Operating_Account__r.Id);
        List<User> userName = [select id, Name, Director__r.Name from User where id=:objCob[0].Opportunity__r.OwnerId];
        list<Operating_Account_Poc__c> listOperatingAccount =new list<Operating_Account_Poc__c>();
        
        if(objCob[0].Opportunity__r.Account.Operating_Account__r.Id!=null)
        {   
            listOperatingAccount =[select id,Operating_Account__c,Service_Type__c,POC_Team__c,Name_POC1__c,Name_POC2__c,EMAIL_POC1__c,EMAIL_POC2__c,EMAIL_POC3__c,Phone_POC1__c,Phone_POC2__c,Name from Operating_Account_Poc__c where Operating_Account__r.id=:objCob[0].Opportunity__r.Account.Operating_Account__r.Id and Service_Type__c=:'Express/Surface' ];
            System.debug('listOperatingAccount '+listOperatingAccount );
        }
        
        Operating_Account_Poc__c objacctupdate =new Operating_Account_Poc__c();
        
        String OppId=   objCob[0].Opportunity__c;
        System.debug('objCob'+objCob);
        String Type='';
        if(objCob!=null && objCob.size()>0)
        {
            if(objCob[0].Opportunity_Record_Type__c=='Express Shipping' || objCob[0].Opportunity_Record_Type__c=='Standard Shipping' )
            {
                Type='Express/Surface';
            }
            else if(objCob[0].Opportunity_Record_Type__c=='B2B')
            {
                Type='B2B';
            }
            else if(objCob[0].Opportunity_Record_Type__c=='C2C')
            {
                Type='C2C';
                
            }
            else
            {
                Type=''; 
            }
        }
        System.debug('Type'+Type);
        system.debug('--testclass--'+objCob[0].Opportunity__r.ownerid);
        if(Type!='' && Type=='Express/Surface' && userName[0].Director__r.Name!=null && userName[0].Director__r.Name!='' && objCob[0].Opportunity__r.Account.Operating_Account__r.Id!=null)
        {
            if(listOperatingAccount!=null && listOperatingAccount.size()>0)
            {   
                objCob[0].Phone_POC1__c=listOperatingAccount[0].Phone_POC1__c;
                objCob[0].Phone_POC2__c=listOperatingAccount[0].Phone_POC2__c;
                objCob[0].Name_POC1__c=listOperatingAccount[0].Name_POC1__c;
                objCob[0].Name_POC2__c=listOperatingAccount[0].Name_POC2__c;
                objCob[0].EMAIL_POC1__c=listOperatingAccount[0].EMAIL_POC1__c;
                objCob[0].EMAIL_POC2__c=listOperatingAccount[0].EMAIL_POC2__c;
                objCob[0].EMAIL_POC3__c=listOperatingAccount[0].EMAIL_POC3__c;
                objCob[0].POC_Team__c=listOperatingAccount[0].POC_Team__c;
                if(objCob!=null && objCob.size()>0)
                    update objCob;
                
            }else{
                
                system.debug('--Type--'+Type);
                list<POC_Team__c>listOfPoc=[select Name,Members_Count__c,Directors__c,Round_Robin__c,Type_of_business__c,Volume_potential__c,(select Name,Phone_POC1__c,Phone_POC2__c,Name_POC1__c,Name_POC2__c,EMAIL_POC1__c,EMAIL_POC2__c,EMAIL_POC3__c from POC_Team_Members__r) from POC_Team__c where Type_of_business__c=: Type ]; 
                System.debug('listOfPoc'+listOfPoc);
                
                for(POC_Team__c eachPOC:listOfPoc)
                {
                    system.debug('--testclass--'+objCob[0].Opportunity__r.owner.name);
                    system.debug('--testclass director--'+userName[0].Director__r.Name);
                    if(eachPOC.Directors__c.contains(userName[0].Director__r.Name))
                    {
                        
                        for(POC_Team_Member__c eachTeamMem:eachPOC.POC_Team_Members__r )
                        {
                            
                            if(eachPOC.Round_Robin__c==Integer.ValueOf(eachTeamMem.Name))
                            {
                                System.debug('insideIf');
                                
                                objCob[0].Phone_POC1__c=eachTeamMem.Phone_POC1__c;
                                objCob[0].Phone_POC2__c=eachTeamMem.Phone_POC2__c;
                                objCob[0].Name_POC1__c=eachTeamMem.Name_POC1__c;
                                objCob[0].Name_POC2__c=eachTeamMem.Name_POC2__c;
                                objCob[0].EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
                                objCob[0].EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
                                objCob[0].POC_Team__c=eachPOC.Name;
                                objCob[0].EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
                                
                                objacctupdate.Phone_POC1__c=eachTeamMem.Phone_POC1__c;
                                objacctupdate.Phone_POC2__c=eachTeamMem.Phone_POC2__c;
                                objacctupdate.Name_POC1__c=eachTeamMem.Name_POC1__c;
                                objacctupdate.Name_POC2__c=eachTeamMem.Name_POC2__c;
                                objacctupdate.EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
                                objacctupdate.EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
                                objacctupdate.EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
                                objacctupdate.POC_Team__c=eachPOC.Name;
                                objacctupdate.Service_Type__c='Express/Surface';
                                objacctupdate.Operating_Account__c=objCob[0].Opportunity__r.Account.Operating_Account__r.Id;
                                objacctupdate.Poc_Team_Member_Id__c=eachTeamMem.id;
                                System.debug('objacctupdateInner'+objacctupdate);
                                
                                // Added for SF-382
                                if(objacctupdate!=null && objacctupdate.Operating_Account__c != null )
                                {
                                    insert objacctupdate;
                                }
                                else
                                {
                                    if(objCob[0].Opportunity_Record_Type__c != 'SaaS' && objCob[0].Opportunity_Record_Type__c != 'Fulfillment')
                                        emailHelper.sendEmail(objCob[0].Opportunity__r.ownerid,objCob[0].Id);
                                }
                            }
                            
                        }
                        if(eachPOC.Round_Robin__c==eachPOC.Members_Count__c)
                        {
                            eachPOC.Round_Robin__c=1;
                        }
                        else
                        {
                            eachPOC.Round_Robin__c=eachPOC.Round_Robin__c+1;
                        }
                        
                        break;
                    }
                    
                }
                
                
                if(listOfPoc!=null && listOfPoc.size()>0)
                    update listOfPoc;
                
                if(objCob!=null && objCob.size()>0)
                    update objCob;
                System.debug('objacctupdateOuter'+objacctupdate);
                
            }
        }else if(Type!='' && Type=='B2B' && userName[0].Director__r.Name!=null && userName[0].Director__r.Name!='' && objCob[0].Opportunity__r.Account.Operating_Account__r.Id!=null)
        {
            list<Opportunity>lstOpp=[Select Volume_Potential_Tonnes_Month__c,id from Opportunity where id=:OppId];
            if(lstOpp[0].Volume_Potential_Tonnes_Month__c>10 || userName[0].Director__r.Name.contains(Label.B2B_Directors))
            {  
                system.debug('--Type1--'+Type);
                list<POC_Team__c>listOfPoc=[select Name,Members_Count__c,Directors__c,Round_Robin__c,Type_of_business__c,Volume_potential__c,(select Name,Phone_POC1__c,Phone_POC2__c,Name_POC1__c,Name_POC2__c,EMAIL_POC1__c,EMAIL_POC2__c,EMAIL_POC3__c from POC_Team_Members__r) from POC_Team__c where Type_of_business__c=: Type and name<>'LT CSM']; 
                System.debug('listOfPoc'+listOfPoc);
                
                
                for(POC_Team__c eachPOC:listOfPoc)
                {
                    
                    if(eachPOC.Directors__c.contains(userName[0].Director__r.Name))
                    {
                        
                        for(POC_Team_Member__c eachTeamMem:eachPOC.POC_Team_Members__r )
                        {
                            if(eachPOC.Round_Robin__c==Integer.ValueOf(eachTeamMem.Name))
                            {
                                
                                objCob[0].Phone_POC1__c=eachTeamMem.Phone_POC1__c;
                                objCob[0].Phone_POC2__c=eachTeamMem.Phone_POC2__c;
                                objCob[0].Name_POC1__c=eachTeamMem.Name_POC1__c;
                                objCob[0].Name_POC2__c=eachTeamMem.Name_POC2__c;
                                objCob[0].EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
                                objCob[0].EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
                                objCob[0].EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
                                
                                objCob[0].POC_Team__c=eachPOC.Name;
                                
                                objacctupdate.Phone_POC1__c=eachTeamMem.Phone_POC1__c;
                                objacctupdate.Phone_POC2__c=eachTeamMem.Phone_POC2__c;
                                objacctupdate.Name_POC1__c=eachTeamMem.Name_POC1__c;
                                objacctupdate.Name_POC2__c=eachTeamMem.Name_POC2__c;
                                objacctupdate.EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
                                objacctupdate.EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
                                objacctupdate.EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
                                objacctupdate.POC_Team__c=eachPOC.Name;
                                objacctupdate.Service_Type__c='B2B';
                                objacctupdate.Operating_Account__c=objCob[0].Opportunity__r.Account.Operating_Account__r.Id;
                                objacctupdate.Poc_Team_Member_Id__c= eachTeamMem.id;
                                
                            }
                            
                        }
                        if(eachPOC.Round_Robin__c==eachPOC.Members_Count__c)
                        {
                            eachPOC.Round_Robin__c=1;
                        }
                        else
                        {
                            eachPOC.Round_Robin__c=eachPOC.Round_Robin__c+1;
                        }
                        
                        break;
                    }
                    
                }
                
                if(listOfPoc!=null && listOfPoc.size()>0)
                    update listOfPoc;
                
                if(objCob!=null && objCob.size()>0)
                    update objCob;
                System.debug('oppid'+objacctupdate);
                
                if(objacctupdate!=null && objacctupdate.Operating_Account__c != null )
                {
                    insert objacctupdate;
                }
                else
                {                 
                    if(objCob[0].Opportunity_Record_Type__c != 'SaaS' && objCob[0].Opportunity_Record_Type__c != 'Fulfillment')
                        emailHelper.sendEmail(objCob[0].Opportunity__r.ownerid,objCob[0].Id);
                }
            }else
            {
                list<POC_Team__c>listOfPoc=[select Name,Members_Count__c,Directors__c,Round_Robin__c,Type_of_business__c,Volume_potential__c,(select Name,Phone_POC1__c,Phone_POC2__c,Name_POC1__c,EMAIL_POC3__c,Name_POC2__c,EMAIL_POC1__c,EMAIL_POC2__c from POC_Team_Members__r) from POC_Team__c where Type_of_business__c=: Type and name='LT CSM']; 
                
                for(POC_Team__c eachPOC:listOfPoc)
                {
                    
                    for(POC_Team_Member__c eachTeamMem:eachPOC.POC_Team_Members__r )
                    {
                        if(eachPOC.Round_Robin__c==Integer.ValueOf(eachTeamMem.Name))
                        {
                            
                            objCob[0].Phone_POC1__c=eachTeamMem.Phone_POC1__c;
                            objCob[0].Phone_POC2__c=eachTeamMem.Phone_POC2__c;
                            objCob[0].Name_POC1__c=eachTeamMem.Name_POC1__c;
                            objCob[0].Name_POC2__c=eachTeamMem.Name_POC2__c;
                            objCob[0].EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
                            objCob[0].EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
                            objCob[0].EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
                            objCob[0].POC_Team__c=eachPOC.Name;
                            
                            objacctupdate.Phone_POC1__c=eachTeamMem.Phone_POC1__c;
                            objacctupdate.Phone_POC2__c=eachTeamMem.Phone_POC2__c;
                            objacctupdate.Name_POC1__c=eachTeamMem.Name_POC1__c;
                            objacctupdate.Name_POC2__c=eachTeamMem.Name_POC2__c;
                            objacctupdate.EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
                            objacctupdate.EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
                            objacctupdate.EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
                            objacctupdate.POC_Team__c=eachPOC.Name;
                            objacctupdate.Service_Type__c='B2B';
                            objacctupdate.Operating_Account__c=objCob[0].Opportunity__r.Account.Operating_Account__r.Id;
                            objacctupdate.Poc_Team_Member_Id__c=eachTeamMem.id;
                            
                        }
                        
                    }
                    if(eachPOC.Round_Robin__c==eachPOC.Members_Count__c)
                    {
                        eachPOC.Round_Robin__c=1;
                    }
                    else
                    {
                        eachPOC.Round_Robin__c=eachPOC.Round_Robin__c+1;
                    }
                    
                    break;
                    
                }
                
                if(listOfPoc!=null && listOfPoc.size()>0)
                    update listOfPoc;
                
                if(objCob!=null && objCob.size()>0)
                    update objCob;
                // Added for SF-382
                if(objacctupdate!=null && objacctupdate.Operating_Account__c != null)
                {
                    insert objacctupdate;
                }
                else
                {
                    if(objCob[0].Opportunity_Record_Type__c != 'SaaS' && objCob[0].Opportunity_Record_Type__c != 'Fulfillment')
                        emailHelper.sendEmail(objCob[0].Opportunity__r.ownerid,objCob[0].Id);
                }
            }
            
        } 
        else if(Type!='' && Type=='C2C' && userName[0].Director__r.Name!=null && userName[0].Director__r.Name!='' && objCob[0].Opportunity__r.Account.Operating_Account__r.Id!=null)
        {
            if(userName[0].Director__r.Name.contains(Label.C2C_Directors ))
            {
                System.debug('The value of type is '+Type);
                List<POC_Team__c> lstPOC = [Select Name,Members_Count__c,Directors__c,Round_Robin__c,Type_of_business__c,Volume_potential__c,(Select Name,Name_POC1__c,Name_POC2__c,Phone_POC1__c,Phone_POC2__c,EMAIL_POC1__c,EMAIL_POC2__c,EMAIL_POC3__c from POC_Team_Members__r) from POC_Team__c where Type_of_business__c=:Type];
                System.debug('Value in List of POC team is '+lstPOC);
                for(POC_Team__c eachPOC:lstPOC)
                {
                    if(eachPOC.Directors__c.contains(userName[0].Director__r.Name))
                    {
                        for(POC_Team_Member__c eachTeamMem:eachPOC.POC_Team_Members__r)
                        {
                            if(eachPOC.Round_Robin__c==Integer.ValueOf(eachTeamMem.Name))
                            {
                                objCob[0].Phone_POC1__c=eachTeamMem.Phone_POC1__c;
                                objCob[0].Phone_POC2__c=eachTeamMem.Phone_POC2__c;
                                objCob[0].Name_POC1__c=eachTeamMem.Name_POC1__c;
                                objCob[0].Name_POC2__c=eachTeamMem.Name_POC2__c;
                                objCob[0].EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
                                objCob[0].EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
                                objCob[0].EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
                                
                                objCob[0].POC_Team__c=eachPOC.Name;
                                
                                /* objacctupdate.Phone_POC1__c=eachTeamMem.Phone_POC1__c;
objacctupdate.Phone_POC2__c=eachTeamMem.Phone_POC2__c;
objacctupdate.Name_POC1__c=eachTeamMem.Name_POC1__c;
objacctupdate.Name_POC2__c=eachTeamMem.Name_POC2__c;
objacctupdate.EMAIL_POC1__c=eachTeamMem.EMAIL_POC1__c;
objacctupdate.EMAIL_POC2__c=eachTeamMem.EMAIL_POC2__c;
objacctupdate.EMAIL_POC3__c=eachTeamMem.EMAIL_POC3__c;
objacctupdate.POC_Team__c=eachPOC.Name;
objacctupdate.Service_Type__c='C2C';
objacctupdate.Operating_Account__c=objCob[0].Opportunity__r.Account.Operating_Account_r.id;
objacctupdate.Poc_Team_Member_Id__c=eachTeamMem.id;*/
                            }
                        }
                        if(eachPOC.Round_Robin__c==eachPOC.Members_Count__c)
                        {
                            eachPOC.Round_Robin__c=1;
                        }
                        else{
                            eachPOC.Round_Robin__c=eachPOC.Round_Robin__c+1;
                        }
                        break;
                    }
                }
                if(lstPoc!=null && lstPoc.size()>0)
                    update lstPOC;
                if(objCob!=null && objCob.size()>0)
                    update objCob;
                /* if(objacctupdate!=null && objacctupdate.Operating_Account__c!=null)
insert objacctupdate;*/
                
                
            }
        }      
    }
    
}