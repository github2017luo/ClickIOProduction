/*****************************************************************************************************
 
Class    :  cls_Channel_Compensation
Developer:  Kiril Minev
Created  :  July 22, 2014
Modified :  
Objective:  
 
*****************************************************************************************************/ 
public with sharing class cls_Channel_Compensation {
    
    public static void updateTerritoryCodeLookup(List <Channel_Compensation__c> channels) {
        
        try {
            Map<String, Territory__c> territoryMap = new Map<String, Territory__c>();
            List<Territory__c> territoryList = [Select Name, Id FROM Territory__c];
            
            
            if (territoryList != null && territoryList.size() > 0) {
                
                for (Territory__c t :territoryList) {
                    territoryMap.put(t.Name, t);
                }
                
                for (Channel_Compensation__c c :channels) {
                    
                    Territory__c tTemp = territoryMap.get(c.Territory_Code__c);
                    
                    if (tTemp != null) {
                        c.Territory__c = tTemp.Id;
                    } else {
                        c.Territory__c = null;//remove reference
                    }
                }
            }
            
        }catch (System.Exception ex) {
            System.Debug('*** Exception in updateTerritoryCodeLookup');//todo: replace with exception framework
        }
    }
    
    public static void uniqueRecordConstraint(List<Channel_Compensation__c> newChannels) {
        
        try {
            
            Xactly_Integration__c customSetting = Xactly_Integration__c.getInstance();
            
            if (!customSetting.Ignore_Unique_Constraint_Trigger__c) {
                
                Map<String, Channel_Compensation__c> mapChannelsWithUniqueName = new Map<String, Channel_Compensation__c>();
            
                for (Channel_Compensation__c c :newChannels) {
                    mapChannelsWithUniqueName.put(c.DWH_ID__c, c);
                }
                
                Map<String, Channel_Compensation__c> mapChannelsExisting = new Map<String, Channel_Compensation__c>();
                
                for (Channel_Compensation__c ce :[SELECT Id, DWH_ID__c FROM Channel_Compensation__c 
                                                                WHERE DWH_ID__c in :mapChannelsWithUniqueName.keySet() and DWH_ID__c != null]) {
                    mapChannelsExisting.put(ce.DWH_ID__c, ce);
                }
                
                //check if records are unique
                for (Channel_Compensation__c channel :newChannels) {
                    
                    Channel_Compensation__c chTemp = mapChannelsExisting.get(channel.DWH_ID__c);
                    
                    if (chTemp != null && chTemp.Id != channel.Id) {// if ids are the the same this means the same record is being update therefore it can still be unique
                        channel.addError('Record not unique, record with identical key fields already exists on the system!');
                    }
                }   
            }
            
            
        }catch(System.Exception ex) {
            System.Debug('*** Exception in cls_Channel_Compensation.uniqueRecordConstraint, message: ' + ex.getMessage());
            ExLog.log(ex);
        }
    }
    
    public static void updateUniqueIdentifier(List<Channel_Compensation__c> newChannels) {
        
        try {
            
            for (Channel_Compensation__c c :newChannels) {  
                            
                c.DWH_ID__c = c.Org_Id__c + '_' + c.Org_Type__c + '_' + c.BATCH_Id__c + '_' + c.Sales_Module__c + '_' + c.Territory_Code__c + '_' +
                              c.State__c + '_' + c.Fiscal_Month_Abbr__c + '_' + c.Fiscal_Year__c + '_' + c.FOCIS_Category__c + '_' +
                              c.FOCIS_Subject_Area__c + '_' + c.Focis_Location__c + '_' + c.User_Field__c + '_' + c.SubPG__c + '_' + c.Focis_Program__c + '_' + c.Channel__c+ '_' + c.End_Date__c;
            }
            
        }catch (System.Exception ex) {
            System.Debug('*** Exception in cls_Channel_Compensation.updateUniqueIdentifier, message: ' + ex.getMessage());
            ExLog.log(ex);
        }
    }
    
}