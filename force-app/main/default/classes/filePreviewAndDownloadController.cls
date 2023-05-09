public with sharing class filePreviewAndDownloadController {
    @AuraEnabled(cacheable=true)
        public static Map<ID, String> getRelatedFilesByRecordId() {
            
            Map<Id, Book__c> bookMap = new Map<Id, Book__c>([
                SELECT Id FROM Book__c
            ]);
                  
            List<ContentDocumentLink> files = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :bookMap.keySet()];
            List<ID> fileIDs = new List<ID>();
            for (ContentDocumentLink docLink : files) {
                fileIDs.add(docLink.ContentDocumentId);
            }
     
            List<ContentVersion> docs = [SELECT ContentDocumentId, FileExtension, Title 
                FROM ContentVersion WHERE ContentDocumentId IN : fileIDs];
            Map<ID, String> mapIdTitle = new Map<ID, String>();
            for (ContentVersion docLink : docs) {
                mapIdTitle.put(docLink.ContentDocumentId, docLink.Title);
            }
            return mapIdTitle;
        } 
}