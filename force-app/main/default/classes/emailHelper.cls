Global class emailHelper {
    
    public static void sendEmail(Id recipient, Id cob) {
        
        Id templateid = label.POCTemplate;
        
        Messaging.SingleEmailMessage email = Messaging.renderStoredEmailTemplate(templateid, recipient, cob);
        String emailSubject = email.getSubject();
        String emailTextBody = email.getPlainTextBody();
        
        email.setTargetObjectId(recipient);
        email.setBccSender(false);       
        email.setUseSignature(false);      
        email.setSenderDisplayName('SFDC TEAM');      
        email.setSaveAsActivity(false); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }     
}