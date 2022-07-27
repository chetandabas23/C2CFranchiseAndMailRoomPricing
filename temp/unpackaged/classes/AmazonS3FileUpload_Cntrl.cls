public class AmazonS3FileUpload_Cntrl
{
    public Customer_Onboarding__c objOnboarding{get;set;} 
    private String bucket;
    //private String accessKeyId='AKIAJLZNH2N67B7GHHQQ';
    //private String secret='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';
    private String policy;
    public String recordString= '';
    public String header= '';
  //  public blob csv {get;set;}
    public String oid{get;set;}
    public String aid{get;set;} 
    public List<B2B_Price__c> b2bPriceList;
    public List<OpportunityLineItem> oliList;
    public List<Customer_Onboarding__c> listOnBoarding ;
    public List<Slab_Price__c>  slabList{get; set;}
    public List<Slab_Price__c>  BaseList{get; set;}
    public List<Slab_Price__c>  RTOList{get; set;}
    public List<Slab_Price__c>  DTOList{get; set;}
    public AmazonS3FileUpload_Cntrl(Apexpages.StandardController Controller)
    {
        objOnboarding = (Customer_Onboarding__c) controller.getRecord();
        listOnBoarding =  getOnBoardingRecord(objOnboarding.Id);
    }

    public List<Customer_Onboarding__c> getOnBoardingRecord(Id recId)
    {
        List<Customer_Onboarding__c> listOnboarding = new List<Customer_Onboarding__c>();
        DescribeSObjectResult describeResult = Customer_Onboarding__c.getSObjectType().getDescribe();
        List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());
        //system.debug('fieldNames****** '+fieldNames);
        String query = 'SELECT ' + String.join( fieldNames, ',' );
        query += ', Contact__r.Name,Contact__r.FirstName,Contact__r.LastName,Account__r.Email__c,Account__r.Phone__c,Account__r.Name,Opportunity__r.StageName';
        query += ' FROM '+ describeResult.getName() + ' WHERE id = '+ '\''+ recId + '\''; 
        //System.debug('Query ->'+query);
        try{
            listOnboarding = Database.query(query);
             System.debug('Success');
            
        }catch(Exception e){
            system.debug('Error caught >>'+e);
        }
        return listOnboarding;
        
    }

    public void AmazonS3FileUpload()
    {

        //Create File for the record to be uploaded on Amazon S3
        List<Customer_Onboarding__c > cobId = new List<Customer_Onboarding__c>();
        cobId= [Select Id,Opportunity__r.Id,Account__r.Id,Name from Customer_Onboarding__c where Id IN:listOnBoarding];
        //string header = 'COB#, Opportunity Name,Type of Opportunity \n';
        string finalstr ;
        System.debug('Success1');
        System.debug('OppId-->'+cobId[0].Opportunity__r.Id);
        String AccId;
        Decimal version;
        
        for(Customer_Onboarding__c c: cobId){
         oid= c.Opportunity__r.Id;
         aid=c.Account__r.Id;
        List<Opportunity> opplist = new List<Opportunity>();
        opplist = [Select Id, Name,RecordType.Name,Status__c from Opportunity where Id=:oid];
       // String Status=opplist[0].Status__c;
        List<Account> acclist = new List<Account>();
        acclist = [Select Id, External_ID__c from Account where Id=:aid];
        AccId=accList[0].Id;
        
        String header1='Opportunity ID, Service Account ID, External Id';
        string recordString1=oid+','+aid+','+acclist[0].External_ID__c;
        String RecordTypeName =opplist[0].RecordType.Name;
       
          
       If(RecordTypeName=='B2B' && opplist[0].Status__c=='Corporate Approved')
       {
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            oliList = [SELECT ID,Name,IsActive__c,Version__c,CFT__c,Divisor__c,counter__c, Updated_Product_Name__c, Average_Diesel_Price__c,Diesel_Tolerance_Value__c,Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c, Fuel_Surcharge__c,RoV_Surcharge__c,RoV_Surcharge_RS_10_000__c,Max_Dead_weight_package__c,Discount__c,Status__c,AWB_Charges__c,Minimum_Chargeable_Amount__c,Minimum_Chargeable_Weight__c,Free_Storage_Period__c,DemurrageCharges_Per_awb_per_consignment__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_Rs__c,ODA_Per_MAwb__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Per_Kg__c,Mall_Deliveries_Per_Mawb__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Liability_per_consignment__c,Description__c FROM OpportunityLineItem WHERE OpportunityId =: opplist[0].Id AND IsActive__c = true Order BY counter__c DESC LIMIT 1];
            version=oliList[0].counter__c;
            string header2='CFT__c,Divisor__c,Updated_Product_Name__c, Min_Billable_Weight__c,Way_Bill_Charge__c,Insurance__c,Entry_Tax_Service_Charge__c, Fuel_Surcharge__c,RoV_Surcharge__c,RoV_Surcharge_RS_10_000__c,Max_Dead_weight_package__c,Discount__c,Status__c,AWB_Charges__c,Minimum_Chargeable_Amount__c,Minimum_Chargeable_Weight__c,Free_Storage_Period__c,DemurrageCharges_Per_awb_per_consignment__c,Demurrage_Charges_Per_Kg_Per_day__c,Public_holiday_SundayPickup_Delivery_Rs__c,ODA_Per_MAwb__c,ODA_Per_Kg__c,CSD_Army_Deliveries_Rs_Per_MAwb__c,Time_specific_deliveries_Per_KG__c,Time_specific_deliveries_Per_MAwb__c,Mall_Deliveries_Per_Kg__c,Mall_Deliveries_Per_Mawb__c,Delivery_re_attempt_charge_Per_Kg__c,Delivery_re_attempt_charge_Per_MAwb__c,ROV_on_invoice_value__c,Liability_per_consignment__c,Average_Diesel_Price__c,Diesel_Tolerance_Value__c,Description__c';
            If(oliList[0].IsActive__c==True)
            {
            
              String recordstring2=oliList[0].CFT__c+','+oliList[0].Divisor__c+','+oliList[0].Updated_Product_Name__c+','+oliList[0].Min_Billable_Weight__c+','+oliList[0].Way_Bill_Charge__c
              +','+oliList[0].Insurance__c+'%,'+oliList[0].Entry_Tax_Service_Charge__c+','+oliList[0].Fuel_Surcharge__c+'%,'+oliList[0].RoV_Surcharge__c+','+oliList[0].RoV_Surcharge_RS_10_000__c+','+oliList[0].Max_Dead_weight_package__c+','+oliList[0].Discount__c+','+oliList[0].Status__c+','+oliList[0].AWB_Charges__c
              +','+oliList[0].Minimum_Chargeable_Amount__c+','+oliList[0].Minimum_Chargeable_Weight__c+','+oliList[0].Free_Storage_Period__c+','+oliList[0].DemurrageCharges_Per_awb_per_consignment__c+','+oliList[0].Demurrage_Charges_Per_Kg_Per_day__c+','+oliList[0].Public_holiday_SundayPickup_Delivery_Rs__c
              +','+oliList[0].ODA_Per_MAwb__c+','+oliList[0].ODA_Per_Kg__c+','+oliList[0].CSD_Army_Deliveries_Rs_Per_MAwb__c+','+oliList[0].Time_specific_deliveries_Per_KG__c
              +','+oliList[0].Time_specific_deliveries_Per_MAwb__c+','+oliList[0].Mall_Deliveries_Per_Kg__c+','+oliList[0].Mall_Deliveries_Per_Mawb__c+','+oliList[0].Delivery_re_attempt_charge_Per_Kg__c
              +','+oliList[0].Delivery_re_attempt_charge_Per_MAwb__c+','+oliList[0].ROV_on_invoice_value__c+','+oliList[0].Liability_per_consignment__c+','+oliList[0].Average_Diesel_Price__c+','+oliList[0].Diesel_Tolerance_Value__c+','+oliList[0].Description__c;
              
                List<B2B_Price__c> B2BPrice = new List<B2B_Price__c>();
                B2BPrice = [Select ID, Name, Source__c, Destination__c,Amount__c from B2B_Price__c where Opportunity_Line_Item_Id__c =:oliList[0].Id] ;
                Integer size= B2BPrice.size();
                System.debug('Size'+size);
        
                header='';
                recordstring='';
           for(Integer i = 0; i<size;i++){
           header=B2BPrice[i].Source__c+'/'+B2BPrice[i].Destination__c+','+header;
           recordString=B2BPrice[i].Amount__c+','+recordString;
           }
           header=header+header2;
           recordstring=recordstring+recordstring2;
           }else
           {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No Active pricing present for this Customer. Please create an active pricing.'));
           }
      }
      else if(RecordTypeName=='Express Shipping' && opplist[0].Status__c=='Corporate Approved')
           {
           oliList = [SELECT ID,IsActive__c,Version__c,counter__c,OpportunityId,COD_Value__c,Zone_A_Upto_500_gms__c,Zone_A_Every_additional_500_gms__c,Zone_A_RTO_every_500_gms__c,Zone_A_DTO_Upto_500gm__c, Zone_A_DTO_every_add_500gm__c, 
           Zone_B_DTO_every_add_500gm__c,Zone_B_DTO_Upto_500gm__c,Zone_B_RTO_every_500_gms__c, Zone_B_Every_additional_500_gms__c,Zone_B_Upto_500_gms__c,
           Zone_C_DTO_every_add_500gm__c,Zone_C_DTO_Upto_500gm__c,Zone_C_Every_additional_500_gms__c,Zone_C_RTO_every_500_gms__c,Zone_C_Upto_500_gms__c,
           Zone_D_DTO_every_add_500gm__c,Zone_D_DTO_Upto_500gm__c,Zone_D_Every_additional_500_gms__c,Zone_D_RTO_every_500_gms__c,Zone_D_Upto_500_gms__c,
           Zone_E_DTO_every_add_500gm__c,Zone_E_DTO_Upto_500gm__c,Zone_E_Every_additional_500_gms__c,Zone_E_RTO_every_500_gms__c,Zone_E_Upto_500_gms__c,
           COD_Charges__c,Volumetric_Formulae__c, Service_Charges__c,Fuel_Surcharge__c,COD_Remittance__c,Maximum_liability_per_consignment__c, Maximum_Liability_for_Reverse__c, Maximum_Liability_for_Reverse_Percent__c FROM OpportunityLineItem WHERE OpportunityId =: opplist[0].Id AND IsActive__c = true Order BY counter__c DESC LIMIT 1];
           version=oliList[0].counter__c;
           slabList=[SELECT Id from Slab_Price__c WHERE Opportunity__c =:opplist[0].Id AND Opportunity_Line_Item_Id__c =: oliList[0].Id];
           if(oliList[0].isActive__c==True)
           {
           If(slabList.size()!=0)
           {
            BaseList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_D_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c WHERE Opportunity__c=:opplist[0].Id AND Type__c='Base' AND Opportunity_Line_Item_Id__c =: oliList[0].Id ORDER BY Start_Range__c];
            RTOList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_D_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c  WHERE Opportunity__c=:opplist[0].Id AND Type__c='RTO' AND Opportunity_Line_Item_Id__c =: oliList[0].Id ORDER BY Start_Range__c];
            DTOList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_D_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c  WHERE Opportunity__c=:opplist[0].Id AND Type__c='DTO' AND Opportunity_Line_Item_Id__c =: oliList[0].Id ORDER BY Start_Range__c];
            
            for(Integer a=0; a<BaseList.size();a++){
            header='Type__c,Slab__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_D_Custom_Price__c,Zone_E_Custom_Price__c,'+header;
            recordstring='Forward,'+BaseList[a].Slab__c+','+BaseList[a].Zone_A_Custom_Price__c+','+BaseList[a].Zone_B_Custom_Price__c+','+BaseList[a].Zone_C_Custom_Price__c+','+BaseList[a].Zone_D_Custom_Price__c+','+BaseList[a].Zone_E_Custom_Price__c+','+recordstring;
            }
            
            for (Integer b=0; b<RTOList.size();b++){
             header='Type__c,Slab__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_D_Custom_Price__c,Zone_E_Custom_Price__c,'+header;
            recordstring=RTOList[b].Type__c+','+RTOList[b].Slab__c+','+RTOList[b].Zone_A_Custom_Price__c+','+RTOList[b].Zone_B_Custom_Price__c+','+RTOList[b].Zone_C_Custom_Price__c+','+RTOList[b].Zone_D_Custom_Price__c+','+RTOList[b].Zone_E_Custom_Price__c+','+recordstring;
            }
            for (Integer e=0; e<DTOList.size();e++){
             header='Type__c,Slab__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_D_Custom_Price__c,Zone_E_Custom_Price__c,'+header;
            recordstring=DTOList[e].Type__c+','+DTOList[e].Slab__c+','+DTOList[e].Zone_A_Custom_Price__c+','+DTOList[e].Zone_B_Custom_Price__c+','+DTOList[e].Zone_C_Custom_Price__c+','+DTOList[e].Zone_D_Custom_Price__c+','+DTOList[e].Zone_E_Custom_Price__c+','+recordstring;
            }
            
            header=header+'COD_value__c,COD_Charges__c,Volumetric_Formulae__c, Service_Charges__c,Fuel_Surcharge__c,COD_Remittance__c,Maximum_liability_per_consignment__c, Maximum_Liability_for_Reverse__c, Maximum_Liability_for_Reverse_Percent__c';
            recordstring= recordstring+oliList[0].COD_Value__c+'%,'+oliList[0].COD_Charges__c+','+oliList[0].Volumetric_Formulae__c+','+oliList[0].Service_Charges__c+','+oliList[0].Fuel_Surcharge__c+'%,'+oliList[0].COD_Remittance__c+','+oliList[0].Maximum_liability_per_consignment__c+','+oliList[0].Maximum_Liability_for_Reverse__c+','+oliList[0].Maximum_Liability_for_Reverse_Percent__c+'%';
           
           }else{
           header='Zone_A_Upto_500_gms__c,Zone_A_Every_additional_500_gms__c,Zone_A_RTO_every_500_gms__c,Zone_A_DTO_Upto_500gm__c, Zone_A_DTO_every_add_500gm__c, Zone_B_DTO_every_add_500gm__c,Zone_B_DTO_Upto_500gm__c,Zone_B_RTO_every_500_gms__c, Zone_B_Every_additional_500_gms__c,Zone_B_Upto_500_gms__c,Zone_C_DTO_every_add_500gm__c,Zone_C_DTO_Upto_500gm__c,Zone_C_Every_additional_500_gms__c,Zone_C_RTO_every_500_gms__c,Zone_C_Upto_500_gms__c,Zone_D_DTO_every_add_500gm__c,Zone_D_DTO_Upto_500gm__c,Zone_D_Every_additional_500_gms__c,Zone_D_RTO_every_500_gms__c,Zone_D_Upto_500_gms__c,Zone_E_DTO_every_add_500gm__c,Zone_E_DTO_Upto_500gm__c,Zone_E_Every_additional_500_gms__c,Zone_E_RTO_every_500_gms__c,Zone_E_Upto_500_gms__c,COD_Value__c,COD_Charges__c,Volumetric_Formulae__c, Service_Charges__c,Fuel_Surcharge__c,COD_Remittance__c,Maximum_liability_per_consignment__c, Maximum_Liability_for_Reverse__c, Maximum_Liability_for_Reverse_Percent__c  ';
           recordstring=oliList[0].Zone_A_Upto_500_gms__c+','+oliList[0].Zone_A_Every_additional_500_gms__c+','+oliList[0].Zone_A_RTO_every_500_gms__c+','+oliList[0].Zone_A_DTO_Upto_500gm__c +','+oliList[0].Zone_A_DTO_every_add_500gm__c 
           +','+oliList[0].Zone_B_DTO_every_add_500gm__c+','+oliList[0].Zone_B_DTO_Upto_500gm__c+','+oliList[0].Zone_B_RTO_every_500_gms__c +','+oliList[0].Zone_B_Every_additional_500_gms__c+','+oliList[0].Zone_B_Upto_500_gms__c
           +','+oliList[0].Zone_C_DTO_every_add_500gm__c+','+oliList[0].Zone_C_DTO_Upto_500gm__c+','+oliList[0].Zone_C_Every_additional_500_gms__c+','+oliList[0].Zone_C_RTO_every_500_gms__c+','+oliList[0].Zone_C_Upto_500_gms__c
           +','+oliList[0].Zone_D_DTO_every_add_500gm__c+','+oliList[0].Zone_D_DTO_Upto_500gm__c+','+oliList[0].Zone_D_Every_additional_500_gms__c+','+oliList[0].Zone_D_RTO_every_500_gms__c+','+oliList[0].Zone_D_Upto_500_gms__c
           +','+oliList[0].Zone_E_DTO_every_add_500gm__c+','+oliList[0].Zone_E_DTO_Upto_500gm__c+','+oliList[0].Zone_E_Every_additional_500_gms__c+','+oliList[0].Zone_E_RTO_every_500_gms__c+','+oliList[0].Zone_E_Upto_500_gms__c
           +','+oliList[0].COD_Value__c+'%,'+oliList[0].COD_Charges__c+','+oliList[0].Volumetric_Formulae__c+','+oliList[0].Service_Charges__c+','+oliList[0].Fuel_Surcharge__c+'%,'+oliList[0].COD_Remittance__c+','+oliList[0].Maximum_liability_per_consignment__c+','+oliList[0].Maximum_Liability_for_Reverse__c+','+oliList[0].Maximum_Liability_for_Reverse_Percent__c+'%';
          } }else
           {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No Active pricing present for this Customer. Please create an active pricing.'));
           }
           
           }
           
           else if (RecordTypeName=='Standard Shipping' && opplist[0].Status__c=='Corporate Approved')
           {
           oliList = [SELECT ID,IsActive__c,Version__c,counter__c,COD_Value__c,Zone_A_Upto_500_gms__c,Zone_A_RTO_every_1_kg__c,Zone_A_Every_Add_500_gms_upto_3_kgs__c,Zone_A_DTO_Upto_500gm__c, Zone_A_DTO_every_add_500gm__c, 
           Zone_B_DTO_every_add_500gm__c,Zone_B_DTO_Upto_500gm__c,Zone_B_RTO_every_1_kg__c,Zone_B_Every_Add_500_gms_upto_3_kgs__c,Zone_B_Upto_500_gms__c,Zone_B_Every_Additional_Slab_1_Kg__c,
           Zone_C_N1_DTO_every_add_500gm__c, Zone_C_N1_DTO_Upto_500gms__c,Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c, Zone_C_N1_Every_Additional_Slab_1_Kg__c, Zone_C_N1_RTO_every_1_kg__c, Zone_C_N1_Upto_500_gms__c,Zone_C_N2_DTO_every_add_500gm__c,Zone_C_N2_DTO_Upto_500gms__c,Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c, Zone_C_N2_Every_Additional_Slab_1_Kg__c, Zone_C_N2_RTO_every_1_kg__c,Zone_C_N2_Upto_500_gms__c,
           Zone_D_N1_DTO_every_add_500gm__c, Zone_D_N1_DTO_Upto_500gms__c,Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c, Zone_D_N1_Every_Additional_Slab_1_Kg__c, Zone_D_N1_RTO_every_1_kg__c, Zone_D_N2_DTO_every_add_500gm__c, Zone_D_N2_DTO_Upto_500gms__c, Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c, Zone_D_N2_Every_Additional_Slab_1_Kg__c, Zone_D_N2_RTO_every_1_kg__c, Zone_D_N2_Upto_500_gms__c, 
           Zone_E_DTO_every_add_500gm__c,Zone_E_DTO_Upto_500gm__c,Zone_E_RTO_every_1_kg__c,Zone_E_Upto_500_gms__c,Zone_E_Every_Additional_Slab_1_Kg__c,Zone_E_Every_additional_500_gms__c,
           COD_Charges__c,Volumetric_Formulae__c, Service_Charges__c,Fuel_Surcharge__c,COD_Remittance__c,Maximum_liability_per_consignment__c, Maximum_Liability_for_Reverse__c, Maximum_Liability_for_Reverse_Percent__c FROM OpportunityLineItem WHERE OpportunityId =: opplist[0].Id AND IsActive__c = true Order BY counter__c DESC LIMIT 1];
           version=oliList[0].counter__c;
           slabList=[SELECT Id from Slab_Price__c WHERE Opportunity__c =:opplist[0].Id AND Opportunity_Line_Item_Id__c =: oliList[0].Id];
           
           
           if(oliList[0].isActive__c==True)
           {
           If(slabList.size()!=0){
           BaseList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c WHERE Opportunity__c=:opplist[0].Id AND Type__c='Base' AND Opportunity_Line_Item_Id__c =: oliList[0].Id ORDER BY Start_Range__c];
            RTOList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c  WHERE Opportunity__c=:opplist[0].Id AND Type__c='RTO' AND Opportunity_Line_Item_Id__c =: oliList[0].Id ORDER BY Start_Range__c];
            DTOList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c  WHERE Opportunity__c=:opplist[0].Id AND Type__c='DTO' AND Opportunity_Line_Item_Id__c =: oliList[0].Id ORDER BY Start_Range__c];
            
            for(Integer a=0; a<BaseList.size();a++){
            header='Type__c,Slab__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c,'+header;
            recordstring='Forward,'+BaseList[a].Slab__c+','+BaseList[a].Zone_A_Custom_Price__c+','+BaseList[a].Zone_B_Custom_Price__c+','+BaseList[a].Zone_C_N1_Custom_Price__c+','+BaseList[a].Zone_C_N2_Custom_Price__c+','+BaseList[a].Zone_D_N1_Custom_Price__c+','+BaseList[a].Zone_D_N2_Custom_Price__c+','+BaseList[a].Zone_E_Custom_Price__c+','+recordstring;
            }
            
            for (Integer b=0; b<RTOList.size();b++){
             header='Type__c,Slab__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c,'+header;
            recordstring=RTOList[b].Type__c+','+RTOList[b].Slab__c+','+RTOList[b].Zone_A_Custom_Price__c+','+RTOList[b].Zone_B_Custom_Price__c+','+RTOList[b].Zone_C_N1_Custom_Price__c+','+RTOList[b].Zone_C_N2_Custom_Price__c+','+RTOList[b].Zone_D_N1_Custom_Price__c+','+RTOList[b].Zone_D_N2_Custom_Price__c+','+RTOList[b].Zone_E_Custom_Price__c+','+recordstring;
            }
            for (Integer e=0; e<DTOList.size();e++){
             header='Type__c,Slab__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c,'+header;
            recordstring=DTOList[e].Type__c+','+DTOList[e].Slab__c+','+DTOList[e].Zone_A_Custom_Price__c+','+DTOList[e].Zone_B_Custom_Price__c+','+DTOList[e].Zone_C_N1_Custom_Price__c+','+DTOList[e].Zone_C_N2_Custom_Price__c+','+DTOList[e].Zone_D_N1_Custom_Price__c+','+DTOList[e].Zone_D_N2_Custom_Price__c+','+DTOList[e].Zone_E_Custom_Price__c+','+recordstring;
            }
            header=header+'COD_Charges__c,Volumetric_Formulae__c, Service_Charges__c,Fuel_Surcharge__c,COD_Remittance__c,Maximum_liability_per_consignment__c, Maximum_Liability_for_Reverse__c, Maximum_Liability_for_Reverse_Percent__c';
            recordstring= recordstring+oliList[0].COD_Value__c+'%,'+oliList[0].COD_Charges__c+','+oliList[0].Volumetric_Formulae__c+','+oliList[0].Service_Charges__c+','+oliList[0].Fuel_Surcharge__c+'%,'+oliList[0].COD_Remittance__c+','+oliList[0].Maximum_liability_per_consignment__c+','+oliList[0].Maximum_Liability_for_Reverse__c+','+oliList[0].Maximum_Liability_for_Reverse_Percent__c+'%';          
           }
           else{
           header='Zone_A_Upto_500_gms__c,Zone_A_RTO_every_1_kg__c,Zone_A_Every_Add_500_gms_upto_3_kgs__c,Zone_A_DTO_Upto_500gm__c, Zone_A_DTO_every_add_500gm__c, Zone_B_DTO_every_add_500gm__c,Zone_B_DTO_Upto_500gm__c,Zone_B_RTO_every_1_kg__c,Zone_B_Every_Add_500_gms_upto_3_kgs__c,Zone_B_Upto_500_gms__c,Zone_B_Every_Additional_Slab_1_Kg__c,Zone_C_N1_DTO_every_add_500gm__c, Zone_C_N1_DTO_Upto_500gms__c,Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c, Zone_C_N1_Every_Additional_Slab_1_Kg__c, Zone_C_N1_RTO_every_1_kg__c, Zone_C_N1_Upto_500_gms__c,Zone_C_N2_DTO_every_add_500gm__c,Zone_C_N2_DTO_Upto_500gms__c,Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c, Zone_C_N2_Every_Additional_Slab_1_Kg__c, Zone_C_N2_RTO_every_1_kg__c,Zone_C_N2_Upto_500_gms__c,Zone_D_N1_DTO_every_add_500gm__c, Zone_D_N1_DTO_Upto_500gms__c,Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c, Zone_D_N1_Every_Additional_Slab_1_Kg__c, Zone_D_N1_RTO_every_1_kg__c, Zone_D_N2_DTO_every_add_500gm__c, Zone_D_N2_DTO_Upto_500gms__c, Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c, Zone_D_N2_Every_Additional_Slab_1_Kg__c, Zone_D_N2_RTO_every_1_kg__c, Zone_D_N2_Upto_500_gms__c, Zone_E_DTO_every_add_500gm__c,Zone_E_DTO_Upto_500gm__c,Zone_E_RTO_every_1_kg__c,Zone_E_Upto_500_gms__c,Zone_E_Every_Additional_Slab_1_Kg__c,Zone_E_Every_additional_500_gms__c,COD_Value__c,COD_Charges__c,Volumetric_Formulae__c, Service_Charges__c,Fuel_Surcharge__c,COD_Remittance__c,Maximum_liability_per_consignment__c, Maximum_Liability_for_Reverse__c, Maximum_Liability_for_Reverse_Percent__c';
           recordstring=oliList[0].Zone_A_Upto_500_gms__c+','+oliList[0].Zone_A_RTO_every_1_kg__c+','+oliList[0].Zone_A_Every_Add_500_gms_upto_3_kgs__c+','+oliList[0].Zone_A_DTO_Upto_500gm__c+','+oliList[0].Zone_A_DTO_every_add_500gm__c 
           +','+oliList[0].Zone_B_DTO_every_add_500gm__c+','+oliList[0].Zone_B_DTO_Upto_500gm__c+','+oliList[0].Zone_B_RTO_every_1_kg__c+','+oliList[0].Zone_B_Every_Add_500_gms_upto_3_kgs__c+','+oliList[0].Zone_B_Upto_500_gms__c+','+oliList[0].Zone_B_Every_Additional_Slab_1_Kg__c
           +','+oliList[0].Zone_C_N1_DTO_every_add_500gm__c+','+oliList[0].Zone_C_N1_DTO_Upto_500gms__c+','+oliList[0].Zone_C_N1_Every_Add_500_gms_Upto_3_kgs__c+','+oliList[0]. Zone_C_N1_Every_Additional_Slab_1_Kg__c+','+oliList[0].Zone_C_N1_RTO_every_1_kg__c +','+oliList[0].Zone_C_N1_Upto_500_gms__c+','+oliList[0].Zone_C_N2_DTO_every_add_500gm__c+','+oliList[0].Zone_C_N2_DTO_Upto_500gms__c+','+oliList[0].Zone_C_N2_Every_Add_500_gms_Upto_3_kgs__c+','+oliList[0].Zone_C_N2_Every_Additional_Slab_1_Kg__c +','+oliList[0].Zone_C_N2_RTO_every_1_kg__c+','+oliList[0].Zone_C_N2_Upto_500_gms__c
           +','+oliList[0].Zone_D_N1_DTO_every_add_500gm__c+','+oliList[0].Zone_D_N1_DTO_Upto_500gms__c+','+oliList[0].Zone_D_N1_Every_Add_500_gms_Upto_3_kgs__c +','+oliList[0].Zone_D_N1_Every_Additional_Slab_1_Kg__c+','+oliList[0].Zone_D_N1_RTO_every_1_kg__c+','+oliList[0].Zone_D_N2_DTO_every_add_500gm__c+','+oliList[0].Zone_D_N2_DTO_Upto_500gms__c+','+oliList[0].Zone_D_N2_Every_Add_500_gms_Upto_3_kgs__c+','+oliList[0].Zone_D_N2_Every_Additional_Slab_1_Kg__c +','+oliList[0].Zone_D_N2_RTO_every_1_kg__c+','+oliList[0].Zone_D_N2_Upto_500_gms__c 
           +','+oliList[0].Zone_E_DTO_every_add_500gm__c+','+oliList[0].Zone_E_DTO_Upto_500gm__c+','+oliList[0].Zone_E_RTO_every_1_kg__c+','+oliList[0].Zone_E_Upto_500_gms__c+','+oliList[0].Zone_E_Every_Additional_Slab_1_Kg__c+','+oliList[0].Zone_E_Every_additional_500_gms__c
           +','+oliList[0].COD_Value__c+'%,'+oliList[0].COD_Charges__c+','+oliList[0].Volumetric_Formulae__c+','+oliList[0].Service_Charges__c+','+oliList[0].Fuel_Surcharge__c+'%,'+oliList[0].COD_Remittance__c+','+oliList[0].Maximum_liability_per_consignment__c+','+oliList[0]. Maximum_Liability_for_Reverse__c+','+oliList[0].Maximum_Liability_for_Reverse_Percent__c+'%';
           }}else
           {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'No Active pricing present for this Customer. Please create an active pricing.'));
           }
           }
           
           else {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The pricing you are trying to send is not approved'));
           }
          
           finalstr = header1+','+header+'\n' +recordstring1+','+recordString;
           }
         
        System.debug('finalstr '+finalstr);
        
        blob csvBlob = Blob.valueOf(finalstr);
        String key='';    
        String secret='';
        
        AmazonS3Key__c objAmazonS3Key = AmazonS3Key__c.getValues('AmazonS3Key');
        if(objAmazonS3Key!=null)
        {
             key=objAmazonS3Key.accessKeyId__c;    
             secret=objAmazonS3Key.secretKey__c;
        }
        System.debug('Key'+key);
        System.debug('secret'+secret);
        String Date1 = Datetime.now().formatGMT('EEE,   dd MMM yyyy HH:mm:ss z');
        String bucketname = 'salesforce-client-price';
        String method = 'PUT';
        String csv=EncodingUtil.base64Encode(csvBlob);
        string csvname= AccId+'-Version'+version+'.csv';
        system.debug('filename'+csvname);
        String host = 's3.amazonaws.com';
        
        System.debug('Date1 '+Date1);
        
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setTimeout(120000);
        req.setEndpoint('https://' + bucketname + '.' + host + '/' + csvname);
        req.setHeader('Host', bucketname + '.' + host);
        req.setHeader('Content-Length', string.valueOf(csv.length()));
        req.setHeader('Content-Encoding', 'base64');
        req.setHeader('Content-Type', 'text/csv');
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Date', Date1);
        req.setHeader('ACL', 'public-read-write');
             
          
        //get signature string
        String stringToSign = 'PUT\n\ntext/csv\n'+Date1+'\n/'+bucketname+'/'+csvname;
        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(stringToSign),blob.valueof(secret)); 
        String signed = EncodingUtil.base64Encode(mac); 
        system.debug('Signature-->'+signed);
        
        String authHeader = 'AWS' + ' ' + key + ':' + signed;
        System.debug('authHeader '+authHeader);
        
        req.setHeader('Authorization',authHeader);
        String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');
        System.debug('decoded '+decoded);
        
        Blob csvblob1 = EncodingUtil.base64Decode(csv);
        req.setBodyasBlob(csvblob1);
        system.debug('Body-->'+req.getBody());
        Http http = new Http();
        system.debug('HTTP Request created');

        try {
            //Execute web service call
            HTTPResponse res = http.send(req);
            System.debug('RESPONSE STRING: ' + res.toString());
            System.debug('RESPONSE STATUS: '+res.getStatus());
            System.debug('STATUS_CODE: '+res.getStatusCode());
            System.debug('Body: '+res.getBody());
            
             if(res.getStatusCode() == 200)
             {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'File Uploaded Successfully'));
             }
             else
             {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Something went wrong. Please connect with Admin team.'));
             }

        } catch(System.CalloutException e) {
            system.debug('AWS Service Callout Exception: ' + e.getMessage());
        }
    }
   
}