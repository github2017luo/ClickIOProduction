public class PHSS_VoucherListController {

    @AuraEnabled
    public static List<Voucher__c> getVoucherList(String recId) {
        List<Voucher__c> vouchList = [Select Id,Name,User__r.Name,Voucher_Claim__c,Status__c,ILT_Class__c,ILT_Class__r.Request_Type__c,User__c,QR_Code_Web_Address__c From Voucher__c 
                                      Where ILT_Class__c = :recId]; 
        return vouchList;
    }
}