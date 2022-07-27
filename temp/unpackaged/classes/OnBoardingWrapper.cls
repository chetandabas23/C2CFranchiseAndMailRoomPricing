public class OnBoardingWrapper{
    public Boolean qrod;
    public Boolean plod;
    public cls_bank_detail bank_detail;
    public class cls_bank_detail{
        public String ifsc_code;
        public String bank_name;
        public String beneficiary_name;
        public String account_number;
    }
    public String ndr_report_recipients;    //net@gmail.com
    public String report_recipients;    //n@gmail.com, new@gmail.com
    public String rto_email_recipients; //a@gmail.com
    public String dto_email_recipients; //b@h.com
    public String rem_email;    //r@gmail.com
    public String upload_recipients;    //wer@gmail.com
    public Integer vat_number;  //2322
    public Integer cst_number;  //234
    public Integer eco_code;    //3243
    public Integer frs_code;    //3234
    public String return_add;   //weq
    public String address;  //weq
    public String reg_name; //we
    public String push_url; //ew
    public String product_type; //B2B
    //public boolean is_prepaid;
    public String wallet_provider;  //DEL-MILES
    public String wallet_notification_mobile;   //
    public String wallet_notification_email;    //
    public boolean mps_service;
    public boolean send_mail_pickup;
    public boolean send_sms_prepaid;
    public boolean send_sms_cash;
    public boolean send_sms_cod;
    public boolean send_sms_reverse;
    public boolean send_sms_ndr;
    public boolean auto_pickup;
    public boolean allow_no_data;
    public String billing_mode; //Surface
    public String client_user_name;
    //public String client_xray_amount;
    public String xray_amount_limit;
    public String client_billing_mode; 
    public cls_services services;
    public String postal_cat;   //CatB
    public String phone;   //7832142123
    public String billing_client_config;    //
    public String movement_config;  //
    public String ho_state; //Nagaland
    
    //SF-211: Adding fields to request body
    public String billing_method;
    public String salesforce_id;
    public String client_type;
    
    public cls_gst_states gst_states;
    public class cls_gst_states {
        public String AndamanandNicobarIslands;
        public String AndhraPradesh;
        public String ArunachalPradesh;
        public String Assam;
        public String Bihar;
        public String Chandigarh;
        public String Chhattisgarh;
        public String DadraandNagarHaveli;
        public String DamanandDiu;
        public String Delhi;
        public String Goa;
        public String Gujarat;
        public String Haryana;
        public String HimachalPradesh;
        public String JammuandKashmir;
        public String Jharkhand;
        public String Karnataka;
        public String Kerala;
        public String LakshadweepIslands;
        public String MadhyaPradesh;
        public String Maharashtra;
        public String Manipur;
        public String Meghalaya;
        public String Mizoram;
        public String Nagaland;
        public String Orissa;
        public String Pondicherry;
        public String Punjab;
        public String Rajasthan;
        public String Sikkim;
        public String TamilNadu;
        //public String Telangana;
        public String Tripura;
        public String UttarPradesh;
        public String Uttarakhand;
        public String WestBengal;
    }
    /*public class cls_gst_states {
        public cls_Nagaland Nagaland;
        public cls_Maharashtra Maharashtra;
        public cls_State states;
    }
    public class cls_State {
        public String gst_tin;  //12-UR
        public String state;    //Maharashtra
    }
    
    public class cls_Nagaland {
        public String gst_tin;  //12-UR
        public String state;    //Nagaland
    }
    public class cls_Maharashtra {
        public String gst_tin;  //12-UR
        public String state;    //Maharashtra
    }*/
    public class cls_services {
        public boolean REPL;
        public boolean Prepaid;
        public boolean Pickup;
        public boolean COD;
    }
   
    public static List<OnBoardingWrapper> parse(String json){
        if(!Test.isRunningTest())
            return (List<OnBoardingWrapper>) System.JSON.deserialize(json, List<OnBoardingWrapper>.class);
        else 
            return null;
    }
}