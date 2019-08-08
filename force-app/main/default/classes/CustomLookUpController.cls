public without sharing class CustomLookUpController
{
    @AuraEnabled
    public static User fetchUser()
    {      
        User u = [SELECT id, ContactId, Name, Profile.Name, Profile.UserLicense.Name FROM User WHERE id=: UserInfo.getUserId()];
        System.debug('User--->'+u);
        return u;
        
    }
    
    @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String ObjectName, String accId, String learningplanid)
    {
    String eventName;
    set<ID> PreachSet= new set<ID>();
    list<ID> Prereqid= new list<ID>();
    
        String rtOrg1='Organization Account';
        String rtOrg2='SB Organization Account';
        
      //String rtOrg='SB Organization Account';
        user u = fetchUser();
        
        system.debug('***ObjectName***' + ObjectName);
        
        //String searchKey = searchKeyWord + '%';
        List<String> searchkey = new List<String> { searchKeyWord + '%', '%' + searchKeyWord + '%', '%' + searchKeyWord}; 
        
        String sQuery = '';
        
        List < sObject > returnList = new List < sObject > ();
        

        if(ObjectName == 'Account')
        {
            if(u.Profile.UserLicense.Name.contains('Customer Community'))
            {
                sQuery =  'select id, Name from ' +ObjectName + ' where id in (SELECT AccountId FROM AccountContactRelation WHERE ContactId = \'' +u.ContactId+'\') and Name LIKE: searchKey order by createdDate DESC limit 5';
            }
            else
            {
                sQuery = 'select id, Name from Account where Name LIKE: searchKey and (Recordtype.name =:rtOrg1 or Recordtype.name = :rtOrg2) order by createdDate DESC limit 5';
            }
        }
        
        else if(ObjectName == 'User')
        {
          if(accId!='All'){
            List<String> ListRolesName= new List<String> {'Administrator','Instructor'};
            if(u.Profile.Name == 'SB PHSS-Partner-Community Plus Login')
            {
            sQuery =  'select id, Name from ' +ObjectName + ' where ContactId in (SELECT ContactId FROM AccountContactRelation WHERE AccountId = \'' +accId +'\' and Roles IN: ListRolesName) AND Name LIKE: searchKey order by createdDate DESC limit 20';
            }
            else{
            sQuery =  'select id, Name from ' +ObjectName + ' where Id != \'' + UserInfo.getUserId() +'\' AND ContactId in (SELECT ContactId FROM AccountContactRelation WHERE AccountId = \'' +accId +'\' and Roles IN: ListRolesName) AND Name LIKE: searchKey order by createdDate DESC limit 20';
            }
           }
            
        }
        
        else
        {
            sQuery = 'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';
        }
        
        system.debug('sQuery'+sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        System.debug('Users in Account Contact Relatioship>>>>>>>>>'+lstOfRecords);
        map<ID,set<ID>> mapuserach = new map<ID,set<ID>>();
        if(ObjectName == 'User'){
        
        // Logic to retrieve the prereqisite of the current course
        System.debug('LPId received'+learningPlanId);
        redwing__Training_Plan_Section_Item__c learningPlanILTEventItem = [Select Id, redwing__Learning__c, redwing__Learning__r.recordtype.Name, redwing__Training_Plan_Section__c
                     from redwing__Training_Plan_Section_Item__c where redwing__Training_Plan_Section__r.redwing__Training_Plan__c =: learningPlanId and redwing__Learning__c != null
                     and redwing__Learning__r.recordtype.Name = 'ILT Event' Limit 1];
                     
        /*List<redwing__ILT_Event__c> event = [Select Name from redwing__ILT_Event__c where redwing__Learning__c =: learningPlanILTEventItem.redwing__Learning__c limit 1];*/
        List<redwing__Learning_Prerequisite__c> learningpreid = [Select Name, redwing__Training_Plan__c, redwing__Learning__c, redwing__Prerequisite__c from redwing__Learning_Prerequisite__c where redwing__Learning__c =:learningPlanILTEventItem.redwing__Learning__c limit 1];

        if(learningpreid.size() > 0){
        List<redwing__Prerequisite__c> Prereqlist = [SELECT ID FROM redwing__Prerequisite__c where ID =:learningpreid[0].redwing__Prerequisite__c];
        for(redwing__Prerequisite__c ObjPreq: Prereqlist)
        {
            Prereqid.add(ObjPreq.id);
        }
        
        
        List<redwing__Prerequisite_Item__c> PrereitemAchv = [Select redwing__Achievement__c from redwing__Prerequisite_Item__c where redwing__Prerequisite__c in:Prereqid and redwing__Required_Status__c = 'Acquired'];
        for(redwing__Prerequisite_Item__c ObjPreItm:PrereitemAchv) {
            PreachSet.add(ObjPreItm.redwing__Achievement__c);
        } 
        }
            
        System.debug('PreachSetValues>>>>>>>>>'+PreachSet);
        // Get Achievement Assignment records
        List<redwing__Achievement_Assignment__c> InstructorAchv = [Select redwing__Achievement__c, redwing__User__c from redwing__Achievement_Assignment__c where redwing__User__c in:lstOfRecords and redwing__Status__c = 'Acquired'];
        system.debug('InstructorAchv  +++++++++++++++++++++++++'+InstructorAchv);

        for(redwing__Achievement_Assignment__c raa:InstructorAchv){
        if(mapuserach.containsKey(raa.redwing__User__c))
        {
        set<ID> AchvmntSet=mapuserach.get(raa.redwing__User__c);
        
        AchvmntSet.add(raa.redwing__Achievement__c);
        mapuserach.put(raa.redwing__User__c,AchvmntSet);
        }
        else{
        set<ID> AchvmntSet=new set<ID>{raa.redwing__Achievement__c};
        mapuserach.put(raa.redwing__User__c,AchvmntSet);

        }
         System.debug('mapuserachValues>>>>>>>>>'+mapuserach);
        }
        }
        if(ObjectName=='User' && PreachSet.size() > 0){
            for(sObject u1:lstOfRecords)
                {
                    if(mapuserach.containskey(u1.ID))
                        {
                        System.debug('Contains respective user');
                            if(mapuserach.get(u1.ID).containsAll(PreachSet))
                            {                        
                    returnList.add(u1);                  
                            }   
                        }
                }
         }

        
        else {
        System.debug('The user list came here');
        for (sObject obj: lstOfRecords)
        {
            returnList.add(obj);
        }
        System.debug('User list available here'+returnList);
        }
        system.debug('returnList'+returnList);
        return returnList;
    
}
}