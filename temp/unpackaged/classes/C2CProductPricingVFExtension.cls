public class C2CProductPricingVFExtension {
     public List<Hyperlocal_Price__c> hpList{get;set;}
    public List<Hyperlocal_Price__c> hpListproduct{get;set;}
    public List<B2B_Price__c> B2blist{get;set;}
    public String oppId{get;set;}
    Public String strProductName{get; set;}
    Public String strProductName1{get; set;}
    public Opportunity opp{get;set;}
    public String oliId{get;set;}
    public String description{get;set;}
    public OpportunityLineItem objectOLI{get; set;}
    Public OpportunityLineItem ObjectOLI1{get; set;}
    public List<OpportunityLineItem> oliList= new List<OpportunityLineItem>();
    public List<Slab_Price__c>  slabList{get; set;}
    public List<Slab_Price__c>  BaseList{get; set;}
    public List<Slab_Price__c>  RTOList{get; set;}
    public List<Slab_Price__c>  DTOList{get; set;}
    public Product2 product{get;set;}
    public Boolean displayPricing{get; set;}
    public Contract__c con{get;set;}   
    public String conid{get;set;}  
    public OpportunityLineItem olt{get;set;}
    public Contact contact{get;set;}
    public string contactId{get;set;}
    public String CODStatement{get; set;}
    public String WalletStatement{get;set;}
    public String DBCardDeliveryChargesLeft {get;set;}
    public String DBCardDeliveryChargesRight {get;set;}
    public String FOVStatement {get;set;}
    public String FSCStatement{get; set;}
    public String MaxLiabilityReverse{get; set;}
    public String AccountRegisteredName{get; set;}
    Public String strVersion{get; set;}
    public String msg{get;set;}
    public String successError{get;set;}
    public Boolean hasOLI{get;set;}
    
    //  Initialize getter setter variables and Check recordType of Opportunity
    public C2CProductPricingVFExtension(ApexPages.StandardController controller){
        msg = '';
        hasOLI = false;
        successError = '';
        hpList = new List<Hyperlocal_Price__c>();
        hpListproduct = new List<Hyperlocal_Price__c>();
        B2blist = new List<B2B_Price__c>();
        objectOLI= new OpportunityLineItem();
        ObjectOLI1 = new OpportunityLineItem();
        slabList= new List<Slab_Price__c>();
        List <Opportunity> OpportunityList= new List <Opportunity>();
        List <Product2> productList= new List <Product2>();
        displayPricing = false;
        
        opp= new Opportunity();
        oppId = ApexPages.currentPage().getParameters().get('id');
        conid = ApexPages.currentPage().getParameters().get('ContractId');
        contactId = ApexPages.currentPage().getParameters().get('ContactId');
        if(conid!=null){
            con = [select Status__c,Type__c,Start_Date__c,End_Date__c,Agreement_Signed_by_User_IP_Address__c,Accepted_Time__c,Contact__r.Email,Effective_Date__c from Contract__c where id=:conid];
        }
        if(contactId!=null){
            contact = [select id,Name from Contact where id=:contactId];
        }
        productList = [select id, Maximum_liability_per_consignment__c,Maximum_Liability_for_Reverse_Percent__c,Maximum_Liability_for_Reverse__c from Product2 where Name =: 'Hyperlocal'];
        if(productList.size()>0) {
            product=productList[0];
        }
        OpportunityList = [select id,Name,Counter__c,Pricing__c,Sub_Category_Formula__c,Sub_Category__c,HasOpportunityLineItem,Account.Name,Account.Registered_Name__c,RecordType.Name,RecordType.DeveloperName,(Select Id, Status__c,IsCustom__c ,Frieght_Value_Factor__c, PricebookEntryId,COD_Remittance__c, Description__c, COD_Charges__c, Service_Charges__c, Debit_After_Rates__c,Debit_Before_Rates__c,Threshold_Charge__c,Credit_Card_Rates__c,COD_Value__c,Wallet_Transaction_Charge__c,Credit_Card_Transaction_Charge__c,Transaction_Charge__c,Wallet_Transaction_Rate__c, Volumetric_Formulae__c, Fuel_Surcharge__c, Rural_Pin_Code_Pricing__c, Maximum_liability_per_consignment__c,Maximum_Liability_for_Reverse_Percent__c,Maximum_Liability_for_Reverse__c From OpportunityLineItems WHERE IsActive__c=TRUE limit 1) from Opportunity where id=:oppId];
        strVersion = 'Version ';
        strVersion += OpportunityList[0].Counter__c;
        strVersion += '.0';
        System.debug('Value of strVersion is '+strVersion);
        if(OpportunityList.size()>0){
            opp=OpportunityList[0];
            AccountRegisteredName=opp.Account.Registered_Name__c;
        }
        system.debug('opp.OpportunityLineItems.size()---------'+opp.OpportunityLineItems.size());
        if(opp.OpportunityLineItems.size()>0){
            
            // For Display of COD Statement on VF Page for Custom Pricing Table
            if( opp.OpportunityLineItems[0].COD_Charges__c != null && opp.OpportunityLineItems[0].COD_Value__c != null ){
                CODStatement='INR '+opp.OpportunityLineItems[0].COD_Charges__c+' or '+opp.OpportunityLineItems[0].COD_Value__c +' % of product bill value whichever is higher';
            }
            else if(opp.OpportunityLineItems[0].COD_Value__c != null && opp.OpportunityLineItems[0].COD_Charges__c == null)
            {
                CODStatement= opp.OpportunityLineItems[0].COD_Value__c + ' % of product bill value';
            }
            else if(opp.OpportunityLineItems[0].COD_Value__c == null && opp.OpportunityLineItems[0].COD_Charges__c != null)
            {
                CODStatement='INR '+opp.OpportunityLineItems[0].COD_Charges__c ;
            }
            else{
                CODStatement='';
            }
            
             System.debug('SectionOf Wallet');
            System.debug('opp.OpportunityLineItems[0].Wallet_Transaction_Charge__c-->>'+opp.OpportunityLineItems[0].Wallet_Transaction_Charge__c);
            System.debug('opp.OpportunityLineItems[0].Wallet_Transaction_Rate__c -->>'+opp.OpportunityLineItems[0].Wallet_Transaction_Rate__c );
            if(opp.OpportunityLineItems[0].Wallet_Transaction_Charge__c != null && opp.OpportunityLineItems[0].Wallet_Transaction_Rate__c != null){
               WalletStatement = 'Per Applicable shipment Transaction Charge of the flat Wallet charges of INR '+opp.OpportunityLineItems[0].Wallet_Transaction_Charge__c+' + '+opp.OpportunityLineItems[0].Wallet_Transaction_Rate__c+' % of Invoice Value';
            }else{
                WalletStatement = '';
            }
            
            System.debug('SectionOf Right');
            System.debug('Credit_Card_Transaction_Charge__c-->>'+opp.OpportunityLineItems[0].Credit_Card_Transaction_Charge__c);
            System.debug('Credit_Card_Transaction_Charge__c-->>'+opp.OpportunityLineItems[0].Transaction_Charge__c);
            if(opp.OpportunityLineItems[0].Credit_Card_Transaction_Charge__c != null || opp.OpportunityLineItems[0].Transaction_Charge__c != null){
               
                DBCardDeliveryChargesLeft = 'MDR rates + Flat transaction charge for'; 
                if(opp.OpportunityLineItems[0].Transaction_Charge__c != null) {
                    DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft +  ' Debit Card will be INR '+ opp.OpportunityLineItems[0].Transaction_Charge__c;
                }
                if(opp.OpportunityLineItems[0].Transaction_Charge__c != null && opp.OpportunityLineItems[0].Credit_Card_Transaction_Charge__c != null) {
                     DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft + ' and';
                }
                if(opp.OpportunityLineItems[0].Credit_Card_Transaction_Charge__c != null) {
                    DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft +  ' Credit Card will be INR '+ opp.OpportunityLineItems[0].Credit_Card_Transaction_Charge__c;
                }
                
           
            }else{
                DBCardDeliveryChargesLeft = 'None';
            }
            
            System.debug('SectionOf Left');
            System.debug('opp.OpportunityLineItems[0].Credit_Card_Rates__c--->>>'+opp.OpportunityLineItems[0].Credit_Card_Rates__c);
            System.debug('opp.OpportunityLineItems[0].Debit_Before_Rates__c--->>'+opp.OpportunityLineItems[0].Debit_Before_Rates__c);
            System.debug('Threshold_Charge__c-->>'+opp.OpportunityLineItems[0].Threshold_Charge__c);
            System.debug('opp.OpportunityLineItems[0].Debit_After_Rates__c -->>'+opp.OpportunityLineItems[0].Debit_After_Rates__c );
            if(opp.OpportunityLineItems[0].Credit_Card_Transaction_Charge__c != null || opp.OpportunityLineItems[0].Transaction_Charge__c != null){
                DBCardDeliveryChargesRight = 'Where MDR rates are as follows: <br/>' ;
                if(opp.OpportunityLineItems[0].Credit_Card_Transaction_Charge__c != null && opp.OpportunityLineItems[0].Credit_Card_Rates__c != null)  { 
                    DBCardDeliveryChargesRight = DBCardDeliveryChargesRight + '• Credit Card rates: '+opp.OpportunityLineItems[0].Credit_Card_Rates__c+' % (Total Invoice Value)<br/>';
                }
                if(opp.OpportunityLineItems[0].Transaction_Charge__c != null && opp.OpportunityLineItems[0].Threshold_Charge__c != null && opp.OpportunityLineItems[0].Debit_Before_Rates__c != null && opp.OpportunityLineItems[0].Debit_After_Rates__c != null)
                    DBCardDeliveryChargesRight = DBCardDeliveryChargesRight + '• Debit card rates: Transaction Amount up to INR '+ opp.OpportunityLineItems[0].Threshold_Charge__c + ' -- ' + opp.OpportunityLineItems[0].Debit_Before_Rates__c + 
                            ' %  <br/> > INR '+opp.OpportunityLineItems[0].Threshold_Charge__c + ' - ' +  opp.OpportunityLineItems[0].Debit_After_Rates__c +' % of Transaction Amount';
                            
            }else{
                DBCardDeliveryChargesRight = 'None';
            }
            
            if(opp.OpportunityLineItems[0].Frieght_Value_Factor__c != null && opp.OpportunityLineItems[0].Frieght_Value_Factor__c != 0){
                FOVStatement = String.valueOF(opp.OpportunityLineItems[0].Frieght_Value_Factor__c) +' % ';
            }else if(opp.OpportunityLineItems[0].Frieght_Value_Factor__c == 0){
                FOVStatement = 'Default to be 0';
            }else{
                FOVStatement = 'None';
            }
            
            
            
            // For Display of Fuel Surcharge Statement on VF Page for Custom Pricing Table
            if(opp.OpportunityLineItems[0].Fuel_Surcharge__c!=null){
                FSCStatement= opp.OpportunityLineItems[0].Fuel_Surcharge__c+' % on Freight Charges';
            }
            else{
                FSCStatement='None';
            }
            
            // For Display of Maximum Liability for Reverse_Percent Surcharge Statement on VF Page for Custom Pricing Table
            if( opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse_Percent__c != null && opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse__c != null ){
                MaxLiabilityReverse='Lower of '+ opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse_Percent__c+' % of product value or  INR '+opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse__c;
            }
            else if(opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse_Percent__c != null && opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse__c == null)
            {
                MaxLiabilityReverse= 'Lower of '+opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse_Percent__c+' % of product value';  
            }
            else if(opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse_Percent__c == null && opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse__c != null)
            {
                MaxLiabilityReverse='INR '+opp.OpportunityLineItems[0].Maximum_Liability_for_Reverse__c; 
            }
            else{
                MaxLiabilityReverse='';
            }
            
            olt = [select id,Maximum_liability_per_consignment__c,Maximum_Liability_for_Reverse_Percent__c,Maximum_Liability_for_Reverse__c,Insurance__c,IsCustom__c,COD_Remittance__c from OpportunityLineItem where OpportunityId=:oppId AND IsActive__c=true limit 1];
        }
        hpListproduct = [select id, Number_of_Order_per_trip__c, Base_Range_in_Km__c, Base_Charge_per_Order_INR__c, Name,
                         Additional_Charge_INR_per_Km__c, Additional_Range__c, COD_Charges_in__c, COD_Charges__c from Hyperlocal_Price__c where Product__c =: product.id ORDER BY Number_of_Order_per_trip__c
                        ];
        
        String oliString;   
        if(opp.OpportunityLineItems.size()>0){
            oliString = String.valueOf(opp.OpportunityLineItems[0].Id);
            if(oliString.length()<=15){
                oliString += '%';
            }
            slabList=[SELECT Id from Slab_Price__c WHERE Opportunity__c =:oppId AND Opportunity_Line_Item_Id__c like: oliString];
            BaseList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c WHERE Opportunity__c=:oppId AND Type__c='Base' AND Opportunity_Line_Item_Id__c like: oliString ORDER BY Start_Range__c];
            RTOList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c  WHERE Opportunity__c=:oppId AND Type__c='RTO' AND Opportunity_Line_Item_Id__c like: oliString ORDER BY Start_Range__c];
            DTOList=[SELECT Id,Start_Range__c,End_Range__c,Opportunity__c,Slab__c,Type__c,Zone_A_Custom_Price__c,Zone_B_Custom_Price__c,Zone_C_Custom_Price__c,Zone_C_N1_Custom_Price__c,Zone_C_N2_Custom_Price__c,Zone_D_Custom_Price__c,Zone_D_N1_Custom_Price__c,Zone_D_N2_Custom_Price__c,Zone_E_Custom_Price__c FROM Slab_Price__c  WHERE Opportunity__c=:oppId AND Type__c='DTO' AND Opportunity_Line_Item_Id__c like: oliString ORDER BY Start_Range__c];
        }
        System.debug('slabList ->'+slabList);
        for(OpportunityLineItem oli : opp.OpportunityLineItems){
            oliId = oli.id;
        }
        System.debug('OLI Id ->>'+oliString);
        hpList = [select id,Number_of_Order_per_trip__c,Base_Range_in_Km__c,Base_Charge_per_Order_INR__c ,COD_Charges__c,
                  Additional_Charge_INR_per_Km__c,Additional_Range__c,COD_Charges_in__c from Hyperlocal_Price__c
                  where Opportunity_Line_Item_Id__c like : oliString ORDER BY Number_of_Order_per_trip__c];          
        System.debug('hpList ->'+hpList+'Size ->'+hpList.size());
        
        B2blist = [SELECT Id, Name, Source__c, Destination__c, Amount__c FROM B2B_Price__c where Opportunity_Line_Item_Id__c=:oliId];   
        
        if(opp.RecordType.DeveloperName == 'Express_Shipping'){
            DisplayMatrix('%Express%','%%',False,strVersion);                
        }            
        if(opp.RecordType.DeveloperName == 'Standard_Shipping'){
            DisplayMatrix('%Standard%','%%',False,strVersion);                    
        }
        if(opp.RecordType.DeveloperName == 'C2C' && opp.Sub_Category__c == 'Franchise'){
            DisplayMatrix('%'+System.Label.Franchise_Standard+'%','%'+System.Label.Franchise_Express+'%',True,strVersion);
           // DisplayMatrix('%Delhivery Commercial Standard - C2C%','%Delhivery Commercial Express - C2C%',True,strVersion);
        }
        if(opp.RecordType.DeveloperName == 'C2C' && opp.Sub_Category__c == 'Mail-Room'){
            DisplayMatrix('%'+System.Label.MailRoom_Standard+'%','%'+System.Label.MailRoom_Express+'%',True,strVersion);
            // DisplayMatrix('%Delhivery Commercial Standard - C2C MailRoom%','%Delhivery Commercial Express - C2C MailRoom%',True,strVersion);
        }
            
    }
    
    // Get all the fields of OLI in query. Query result is assigned to getter setter OLI Instance   
    public void DisplayMatrix(String ProductName,String ProductName1,Boolean C2CFranchise,String strCurrentVersion){
        System.debug('Value of Current Version is '+strCurrentVersion);
        Schema.DescribesObjectResult r= OpportunityLineItem.sObjectType.getDescribe();
        Map<String, Schema.SObjectField> mapFields = new Map<String, Schema.SObjectField>();
        mapFields=r.fields.getMap();
        String oliQuery='SELECT ';
        String fieldNames='';
        for(String apiName: mapFields.KeySet()){
            fieldNames+=apiName+',';
        }
        fieldNames =fieldNames.subString(0,fieldNames.length() - 1 );
        if(!C2CFranchise){        
            if(!Test.isRunningTest())
        oliQuery = oliQuery+ fieldNames+' FROM OpportunityLineItem WHERE OpportunityId=:oppId AND (NAME LIKE :ProductName OR NAME LIKE :ProductName1) AND IsActive__c = true LIMIT 1';  
         if(Test.isRunningTest())
            {
                 oliQuery = oliQuery+ fieldNames+' From OpportunityLineItem WHERE OpportunityId =: oppId '; 
                 System.debug('Value of oliQuery'+oliQuery.replaceALL(',','\n'));
            }
        }else if(C2CFranchise){            
            if(!Test.isRunningTest())
          oliQuery = oliQuery+ fieldNames+' From OpportunityLineItem WHERE OpportunityId=:oppId AND (NAME LIKE :ProductName OR NAME LIKE :ProductName1) AND IsActive__c = true AND Version__c Like : strCurrentVersion';
            if(Test.isRunningTest())
            {
                 oliQuery = oliQuery+ fieldNames+' From OpportunityLineItem WHERE OpportunityId =: oppId ';
            }
        }
        System.debug('oliQuery ->'+oliQuery.ReplaceALL(',','\n'));
        
        List<OpportunityLineItem> oliList= Database.Query(oliQuery);
        System.debug('Value in oliList '+oliList);
        System.debug('oliList'+ oliList);
        if(oliList.size() != 0) {
            
            objectOLI=oliList[0];
            strProductName = objectOLI.Name;
            System.debug('strPRoductName is '+strProductName);
            String strOppName = opp.Name;
            System.debug('strOppName is '+strOppName);
            if(strProductName.contains(strOppName) && C2CFranchise)
            {
                System.debug('if OLI Name contains Opp Name');
               strProductName= strProductName.removeStartIgnoreCase(strOppName);
                System.debug('Value of str Product Name after update is '+strPRoductName);
            }
            // For Display of COD Statement on VF Page for Custom Pricing Table
            if( objectOLI.COD_Charges__c != null && objectOLI.COD_Value__c != null ){
                CODStatement='INR '+objectOLI.COD_Charges__c+' or '+objectOLI.COD_Value__c +' % of product bill value whichever is higher';
            }
            else if(objectOLI.COD_Value__c != null && objectOLI.COD_Charges__c == null)
            {
                CODStatement= objectOLI.COD_Value__c + ' % of product bill value';
            }
            else if(objectOLI.COD_Value__c == null && objectOLI.COD_Charges__c != null)
            {
                CODStatement='INR '+objectOLI.COD_Charges__c ;
            }
            else{
                CODStatement='';
            }
            
                       System.debug('SectionOf Wallet');
            System.debug('opp.OpportunityLineItems[0].Wallet_Transaction_Charge__c-->>'+objectOLI.Wallet_Transaction_Charge__c);
            System.debug('opp.OpportunityLineItems[0].Wallet_Transaction_Rate__c -->>'+objectOLI.Wallet_Transaction_Rate__c );
            if(objectOLI.Wallet_Transaction_Charge__c != null && objectOLI.Wallet_Transaction_Rate__c != null){
               WalletStatement = 'Per Applicable shipment Transaction Charge of the flat Wallet charges of INR '+objectOLI.Wallet_Transaction_Charge__c+' + '+objectOLI.Wallet_Transaction_Rate__c+' % of Invoice Value';
            }else{
                WalletStatement = '';
            }
            
            System.debug('SectionOf Right');
            System.debug('Credit_Card_Transaction_Charge__c-->>'+objectOLI.Credit_Card_Transaction_Charge__c);
            System.debug('Credit_Card_Transaction_Charge__c-->>'+objectOLI.Transaction_Charge__c);
            if(objectOLI.Credit_Card_Transaction_Charge__c != null || objectOLI.Transaction_Charge__c != null){
               
                DBCardDeliveryChargesLeft = 'MDR rates + Flat transaction charge for';
                if(objectOLI.Transaction_Charge__c != null) {
                    DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft +  ' Debit Card will be INR '+ objectOLI.Transaction_Charge__c;
                }
                
                 if(objectOLI.Transaction_Charge__c != null && objectOLI.Credit_Card_Transaction_Charge__c != null) {
                     DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft + ' and';
                }
                
                if(objectOLI.Credit_Card_Transaction_Charge__c != null) {
                    DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft +  ' Credit Card will be INR '+ objectOLI.Credit_Card_Transaction_Charge__c;
                }
                
           
            }else{
                DBCardDeliveryChargesLeft = 'None';
            }
            
            System.debug('SectionOf Left');
            System.debug('objectOLI.Credit_Card_Rates__c--->>>'+objectOLI.Credit_Card_Rates__c);
            System.debug('objectOLI.Debit_Before_Rates__c--->>'+objectOLI.Debit_Before_Rates__c);
            System.debug('Threshold_Charge__c-->>'+objectOLI.Threshold_Charge__c);
            System.debug('objectOLI.Debit_After_Rates__c -->>'+objectOLI.Debit_After_Rates__c );
            if(objectOLI.Credit_Card_Transaction_Charge__c != null || objectOLI.Transaction_Charge__c != null){
                DBCardDeliveryChargesRight = 'Where MDR rates are as follows: <br/>' ;
                if(objectOLI.Credit_Card_Transaction_Charge__c != null && objectOLI.Credit_Card_Rates__c != null)  { 
                    DBCardDeliveryChargesRight = DBCardDeliveryChargesRight + '• Credit Card rates: '+objectOLI.Credit_Card_Rates__c+' % (Total Invoice Value)<br/>';
                }
                if(objectOLI.Transaction_Charge__c != null && objectOLI.Threshold_Charge__c != null && objectOLI.Debit_Before_Rates__c != null && objectOLI.Debit_After_Rates__c != null)
                    DBCardDeliveryChargesRight = DBCardDeliveryChargesRight + '• Debit card rates: Transaction Amount up to INR '+ objectOLI.Threshold_Charge__c + ' -- ' + objectOLI.Debit_Before_Rates__c + 
                            ' % <br/>  > INR '+objectOLI.Threshold_Charge__c + ' - ' +  objectOLI.Debit_After_Rates__c +' % of Transaction Amount';
                            
            }else{
                DBCardDeliveryChargesRight = 'None';
            }            
            if(objectOLI.Frieght_Value_Factor__c != null && objectOLI.Frieght_Value_Factor__c != 0){
                FOVStatement = String.valueOF(objectOLI.Frieght_Value_Factor__c) + ' % ';
            }else if(objectOLI.Frieght_Value_Factor__c == 0){
                FOVStatement = 'Default to be 0';
            }else{
                FOVStatement = 'None';
            }
            
            
            
            // For Display of Fuel Surcharge Statement on VF Page for Custom Pricing Table
            if(objectOLI.Fuel_Surcharge__c!=null){
                FSCStatement= objectOLI.Fuel_Surcharge__c+' % on Freight Charges';
            }
            else{
                FSCStatement='No Fuel Surcharge';
            }
            
            // For Display of Maximum Liability for Reverse_Percent Surcharge Statement on VF Page for Custom Pricing Table
            if( objectOLI.Maximum_Liability_for_Reverse_Percent__c != null && objectOLI.Maximum_Liability_for_Reverse__c != null ){
                MaxLiabilityReverse='Lower of '+ objectOLI.Maximum_Liability_for_Reverse_Percent__c+' % of product value or  INR '+objectOLI.Maximum_Liability_for_Reverse__c;
            }
            else if(objectOLI.Maximum_Liability_for_Reverse_Percent__c != null && objectOLI.Maximum_Liability_for_Reverse__c == null)
            {
                MaxLiabilityReverse= 'Lower of '+objectOLI.Maximum_Liability_for_Reverse_Percent__c+' % of product value';  
            }
            else if(objectOLI.Maximum_Liability_for_Reverse_Percent__c == null && objectOLI.Maximum_Liability_for_Reverse__c != null)
            {
                MaxLiabilityReverse='INR '+objectOLI.Maximum_Liability_for_Reverse__c; 
            }
            else{
                MaxLiabilityReverse='';
            }
            
           
            
         if(C2CFranchise)
        {          
            objectOLI1=oliList[1];
             strProductName1 = objectOLI1.Name;
            System.debug('strPRoductName1 is '+strProductName1);
            String strOppName1 = opp.Name;
            System.debug('strOppName is '+strOppName1);
            if(strProductName1.contains(strOppName1) && C2CFranchise)
            {
                System.debug('if OLI Name contains Opp Name');
               strProductName1= strProductName1.removeStartIgnoreCase(strOppName1);
                System.debug('Value of str Product Name after update is '+strPRoductName1);
            }
            // For Display of COD Statement on VF Page for Custom Pricing Table
            if( objectOLI1.COD_Charges__c != null && objectOLI1.COD_Value__c != null ){
                CODStatement='INR '+objectOLI1.COD_Charges__c+' or '+objectOLI1.COD_Value__c +' % of product bill value whichever is higher';
            }
            else if(objectOLI1.COD_Value__c != null && objectOLI1.COD_Charges__c == null)
            {
                CODStatement= objectOLI1.COD_Value__c + ' % of product bill value';
            }
            else if(objectOLI1.COD_Value__c == null && objectOLI1.COD_Charges__c != null)
            {
                CODStatement='INR '+objectOLI1.COD_Charges__c ;
            }
            else{
                CODStatement='';
            }
            
                       System.debug('SectionOf Wallet');
            System.debug('opp.OpportunityLineItems[0].Wallet_Transaction_Charge__c-->>'+objectOLI1.Wallet_Transaction_Charge__c);
            System.debug('opp.OpportunityLineItems[0].Wallet_Transaction_Rate__c -->>'+objectOLI1.Wallet_Transaction_Rate__c );
            if(objectOLI1.Wallet_Transaction_Charge__c != null && objectOLI1.Wallet_Transaction_Rate__c != null){
               WalletStatement = 'Per Applicable shipment Transaction Charge of the flat Wallet charges of INR '+objectOLI1.Wallet_Transaction_Charge__c+' + '+objectOLI1.Wallet_Transaction_Rate__c+' % of Invoice Value';
            }else{
                WalletStatement = '';
            }
            
            System.debug('SectionOf Right');
            System.debug('Credit_Card_Transaction_Charge__c-->>'+objectOLI1.Credit_Card_Transaction_Charge__c);
            System.debug('Credit_Card_Transaction_Charge__c-->>'+objectOLI1.Transaction_Charge__c);
            if(objectOLI1.Credit_Card_Transaction_Charge__c != null || objectOLI1.Transaction_Charge__c != null){
               
                DBCardDeliveryChargesLeft = 'MDR rates + Flat transaction charge for';
                if(objectOLI1.Transaction_Charge__c != null) {
                    DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft +  ' Debit Card will be INR '+ objectOLI1.Transaction_Charge__c;
                }
                
                 if(objectOLI1.Transaction_Charge__c != null && objectOLI1.Credit_Card_Transaction_Charge__c != null) {
                     DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft + ' and';
                }
                
                if(objectOLI1.Credit_Card_Transaction_Charge__c != null) {
                    DBCardDeliveryChargesLeft = DBCardDeliveryChargesLeft +  ' Credit Card will be INR '+ objectOLI1.Credit_Card_Transaction_Charge__c;
                }
                
           
            }else{
                DBCardDeliveryChargesLeft = 'None';
            }
            
            System.debug('SectionOf Left');
            System.debug('objectOLI.Credit_Card_Rates__c--->>>'+objectOLI1.Credit_Card_Rates__c);
            System.debug('objectOLI.Debit_Before_Rates__c--->>'+objectOLI1.Debit_Before_Rates__c);
            System.debug('Threshold_Charge__c-->>'+objectOLI1.Threshold_Charge__c);
            System.debug('objectOLI.Debit_After_Rates__c -->>'+objectOLI1.Debit_After_Rates__c );
            if(objectOLI1.Credit_Card_Transaction_Charge__c != null || objectOLI1.Transaction_Charge__c != null){
                DBCardDeliveryChargesRight = 'Where MDR rates are as follows: <br/>' ;
                if(objectOLI1.Credit_Card_Transaction_Charge__c != null && objectOLI1.Credit_Card_Rates__c != null)  { 
                    DBCardDeliveryChargesRight = DBCardDeliveryChargesRight + '• Credit Card rates: '+objectOLI1.Credit_Card_Rates__c+' % (Total Invoice Value)<br/>';
                }
                if(objectOLI1.Transaction_Charge__c != null && objectOLI1.Threshold_Charge__c != null && objectOLI1.Debit_Before_Rates__c != null && objectOLI1.Debit_After_Rates__c != null)
                    DBCardDeliveryChargesRight = DBCardDeliveryChargesRight + '• Debit card rates: Transaction Amount up to INR '+ objectOLI1.Threshold_Charge__c + ' -- ' + objectOLI1.Debit_Before_Rates__c + 
                            ' % <br/>  > INR '+objectOLI1.Threshold_Charge__c + ' - ' +  objectOLI1.Debit_After_Rates__c +' % of Transaction Amount';
                            
            }else{
                DBCardDeliveryChargesRight = 'None';
            }
            
            if(objectOLI1.Frieght_Value_Factor__c != null && objectOLI1.Frieght_Value_Factor__c != 0){
                FOVStatement = String.valueOF(objectOLI1.Frieght_Value_Factor__c) + ' % ';
            }else if(objectOLI1.Frieght_Value_Factor__c == 0){
                FOVStatement = 'Default to be 0';
            }else{
                FOVStatement = 'None';
            }
            
            
            
            // For Display of Fuel Surcharge Statement on VF Page for Custom Pricing Table
            if(objectOLI1.Fuel_Surcharge__c!=null){
                FSCStatement= objectOLI1.Fuel_Surcharge__c+' % on Freight Charges';
            }
            else{
                FSCStatement='No Fuel Surcharge';
            }
            
            // For Display of Maximum Liability for Reverse_Percent Surcharge Statement on VF Page for Custom Pricing Table
            if( objectOLI1.Maximum_Liability_for_Reverse_Percent__c != null && objectOLI1.Maximum_Liability_for_Reverse__c != null ){
                MaxLiabilityReverse='Lower of '+ objectOLI1.Maximum_Liability_for_Reverse_Percent__c+' % of product value or  INR '+objectOLI1.Maximum_Liability_for_Reverse__c;
            }
            else if(objectOLI1.Maximum_Liability_for_Reverse_Percent__c != null && objectOLI1.Maximum_Liability_for_Reverse__c == null)
            {
                MaxLiabilityReverse= 'Lower of '+objectOLI1.Maximum_Liability_for_Reverse_Percent__c+' % of product value';  
            }
            else if(objectOLI1.Maximum_Liability_for_Reverse_Percent__c == null && objectOLI1.Maximum_Liability_for_Reverse__c != null)
            {
                MaxLiabilityReverse='INR '+objectOLI1.Maximum_Liability_for_Reverse__c; 
            }
            else{
                MaxLiabilityReverse='';
            }
            
        }
        }
        if(objectOLI.isCustom__c == false && ObjectOLI1.isCustom__c == false){
            displayPricing = true;
        }
        
   
        
    }
    
    Public PageReference directToPricing(){
        PageReference Pricingpage= new PageReference('/apex/ProductPricingEditableVFNew?scontrolCaching=1&id='+opp.Id);
        return Pricingpage;   
    }
    
    // To display Addendum and Contracts in Print Layout  
    public String getPrintView()
    {
        return
            '<!--[if gte mso 9]>' +
            '<xml>' +
            '<w:WordDocument>' +
            '<w:View>Print</w:View>' +
            '<w:Zoom>100</w:Zoom>' +
            '<w:DoNotOptimizeForBrowser/>' +
            '</w:WordDocument>' +
            '</xml>' +
            '<![endif]>';
    }
    public PageReference downloadContract(){
        System.debug('In Metghod downloadContract ');
        PageReference pageRef;
        if(opp.HasOpportunityLineItem){
            System.debug('opp.id'+opp.id);
            hasOLI = false;
            //return new pageReference('/'+opp.id);
            return null;
            
        }
        else{
            hasOLI = true; 
            successError = 'warning';
            msg ='No pricing is available to download a Contract.';
            return null;
            //alert('No pricing is available to download a Contract.'); 
        }
    }
    
    public PageReference redirectToOpp(){
        System.debug('In Metghod downloadContract Redirect');
        PageReference Opppage= new PageReference('/'+opp.Id);
        Opppage.setRedirect(true);
        return Opppage;
    }
    
    public PageReference generatePricingPDF(){
        System.debug('generatePricingPDF>>>'+opp);
        System.debug('opp.Pricing__c>>>'+opp.Pricing__c);
        //Opportunity objOpp = [SELECT Pricing__c From Opportunity WHERE ID=:opp.id];
        //System.debug('generatePricingPDF>>>'+objOpp);
        PageReference pageRef;
        //if(objOpp.Pricing__c =='' || objOpp.Pricing__c == null){ 
        if(!opp.HasOpportunityLineItem){ 
            //alert('No pricing is available to generate a Pricing PDF.'); 
            hasOLI = true; 
            successError = 'warning';
            msg ='No pricing is available to generate a Pricing PDF.';
            return null;
        } 
        else{ 
            System.debug('opp.Pricing__c>>>'+hasOLI);
            //pageRef = new PageReference('/'+opp.ID);
            //hasOLI = false; 
            //window.open('/apex/GeneratePricingPDF?id={!Opportunity.Id}','_blank');
            return null;
        }
    }

}