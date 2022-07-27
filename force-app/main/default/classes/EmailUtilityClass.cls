/*****************************************************************
* Author: Techila Global Services Pvt Ltd.
* Class Name: EmailUtilityClass
* Created Date: 19-May-2017
* Description: Utility class to send single email.  
*******************************************************************/
Public class EmailUtilityClass
{
    // Input essential parameters and dispatch mail 
    public static void SendEmail(string[] toaddress,string htmlBody,String subject){
        System.debug('Inside Method EmailUtilityClass');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toaddress);
         System.debug('toaddress =>'+toaddress);
        mail.setSubject(subject);
         System.debug('toaddress =>'+subject);
        mail.setHtmlBody(htmlBody);
          System.debug('toaddress =>'+htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}