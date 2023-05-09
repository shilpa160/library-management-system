public class customLWCForBooksController {
		@AuraEnabled(cacheable=true)
     public static List<Object> getBookWithContentDocumentId(String searchTerm){
           
      List<Object> bookList = new List<Object>();
        
        searchTerm =  '%' + searchTerm + '%';
         
   		Map<Id , Book__c> bookMap = new Map<Id, Book__c>([
       		SELECT Id, Book_Name__c, Author_Name__c, Publisher__c FROM Book__c WHERE Book_Name__c LIKE :searchTerm
    	]);
        
        List<contentDocumentLink> contentDocumentLinkList = [
            SELECT LinkedEntityId, contentDocument.LatestPublishedVersionId,ContentDocumentId FROM contentDocumentLink WHERE LinkedEntityId IN : bookMap.keySet()
        ];
        
         
        Map<Id, Id> bookIdContentVersionIdMap = new Map<Id, Id>();
         Map<Id, Id> bookIdContentDocumentIdMap = new Map<Id, Id>();
        	for(contentDocumentLink cdLink : contentDocumentLinkList){
           bookIdContentVersionIdMap.put(cdLink.LinkedEntityId, cdLink.contentDocument.LatestPublishedVersionId);
                bookIdContentDocumentIdMap.put(cdLink.LinkedEntityId, cdLink.ContentDocumentId);
        }
        
        for(Id bookId : bookMap.keySet())
        {
         	Map<String, String> bookInfo = new Map<String, String>();
            bookInfo.put('bookid', bookId);
            bookInfo.put('bookurl', '/' + bookId);
            bookInfo.put('bookname', bookMap.get(bookId).Book_Name__c);
            bookInfo.put('author', bookMap.get(bookId).Author_Name__c);
            bookInfo.put('publisher', bookMap.get(bookId).Publisher__c);
            bookInfo.put('contentversionid',bookIdContentVersionIdMap.get(bookId));
            bookInfo.put('contentdocumentid', bookIdContentDocumentIdMap.get(bookId));
            
            System.debug('The bookInfo is : ' + bookInfo);
            
            bookList.add(bookInfo);
            
            System.debug('The bookList is : ' + bookList);
		}
         
         return bookList;
    }
}