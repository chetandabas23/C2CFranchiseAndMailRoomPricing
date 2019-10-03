/*****************************************************************
* Author: Techila Global Services Pvt Ltd. (Atul Dobhal)
* Class Name: XmlgeneratorUtility
* Created Date: 21-Mar-2018
* Description: utility class for to generate XML file
*******************************************************************/
public class XmlgeneratorUtility {
    public XmlgeneratorUtility(ApexPages.StandardController controller){
        
    }
    public static String generateXML(Customer_Onboarding__c  objCOB){
        String xmlFile;
        
        try{
            XmlStreamWriter xmlDoc = new XmlStreamWriter();
            xmlDoc.writeStartElement(null,'request',null);
            xmlDoc.writeAttribute(null,null,'method','client.create');
            xmlDoc.writeStartElement(null,'client',null);
                        
            xmlDoc.writeStartElement(null,'organization',null);
            xmlDoc.writeCharacters(objCOB.Company_Registered_Name__c);
            xmlDoc.writeEndElement();
            
            xmlDoc.writeStartElement(null,'email',null);
            xmlDoc.writeCharacters(objCOB.Email__c);
            xmlDoc.writeEndElement();
            
            xmlDoc.writeStartElement(null,'work_phone',null);
            xmlDoc.writeCharacters(objCOB.Contact_number__c);
            xmlDoc.writeEndElement();
            
            if(objCOB.Registered_Address_Country__c!=Null && objCOB.Registered_Address_Country__c!=''){
                xmlDoc.writeStartElement(null,'p_country',null);
                xmlDoc.writeCharacters(objCOB.Registered_Address_Country__c);
                xmlDoc.writeEndElement();
            }else{
                
            }
                            
            if(objCOB.Registered_Address_City__c!=Null && objCOB.Registered_Address_City__c!=''){
                xmlDoc.writeStartElement(null,'p_city',null);
                xmlDoc.writeCharacters(objCOB.Registered_Address_City__c);
                xmlDoc.writeEndElement();
            }else{
                
            }
            
            if(objCOB.Registered_Address_Line_1__c!=Null && objCOB.Registered_Address_Line_1__c!=''){
                xmlDoc.writeStartElement(null,'p_street1',null);
                xmlDoc.writeCharacters(objCOB.Registered_Address_Line_1__c);
                xmlDoc.writeEndElement();
            }else{
                
            }
            
            if(objCOB.Registered_Address_Line_2__c!=Null && objCOB.Registered_Address_Line_2__c!=''){
                xmlDoc.writeStartElement(null,'p_street2',null);
                xmlDoc.writeCharacters(objCOB.Registered_Address_Line_2__c);
                xmlDoc.writeEndElement();
            }else{
                
            }
                            
            if(objCOB.Registered_Address_Postal_Code__c!=Null && objCOB.Registered_Address_Postal_Code__c!=''){
                xmlDoc.writeStartElement(null,'p_code',null);
                xmlDoc.writeCharacters(objCOB.Registered_Address_Postal_Code__c);
                xmlDoc.writeEndElement();
            }else{
                
            }
            
            if(objCOB.Registered_Address_State__c!=Null && objCOB.Registered_Address_State__c!=''){
                xmlDoc.writeStartElement(null,'p_state',null);
                xmlDoc.writeCharacters(objCOB.Registered_Address_State__c);
                xmlDoc.writeEndElement();
            }else{
                
            }
            
            if(objCOB.VAT_Number__c!=Null && objCOB.VAT_Number__c!=''){
                xmlDoc.writeStartElement(null,'vat_number',null);
                xmlDoc.writeCharacters(objCOB.VAT_Number__c);
                xmlDoc.writeEndElement();
            }else{
                
            }
                            
            xmlDoc.writeEndElement();
            xmlDoc.writeEndElement();
            xmlFile = xmlDoc.getXmlString();
            xmlDoc.close();
            system.debug(xmlFile);
            return xmlFile;    
        }catch(Exception e){
            system.debug('Error-->'+e.getStackTraceString());
            system.debug('Error-->'+e.getMessage());
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
    }
}