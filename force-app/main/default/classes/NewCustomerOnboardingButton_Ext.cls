/******************************************************************************************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: NewCustomerOnboardingButton_Ext
* Created Date: 04-December-2017
* Description: To restrict users other than System Administartor and Customer Onboarding profile to have access to New button from tab.
*******************************************************************************************************************************************/
public class NewCustomerOnboardingButton_Ext{  
    public NewCustomerOnboardingButton_Ext(ApexPages.StandardController stdCntrl){         
        
    } 
    public pageReference toShow(){
        id currentProfileId = userinfo.getProfileId();
        Profile p = [Select id,Name From Profile Where Id=:currentProfileId];
        if(p.Name=='System Administrator' || p.Name=='Customer Onboarding Profile')
            return new pageReference('/a1t/e?nooverride=1');
        else
            return null;
    }
    public pageReference toCancel(){
        return new pageReference('/a1t/o');
    }
}