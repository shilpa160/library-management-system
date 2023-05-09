@isTest
private class customLWCForBooksControllerTest {
    
    @testSetup
    static void setup() {
        // Create test data
        Book__c testBook1 = new Book__c(
            Book_Name__c = 'Test Book',
            Author_Name__c = 'Test Author',
            Publisher__c = 'Test Publisher'
        );
        insert testBook1;
          
        ContentVersion testContentVersion1 = new ContentVersion(
            VersionData = Blob.valueOf('Test Content'),
            Title = 'Test Content',
            PathOnClient = 'TestContent.txt',
            FirstPublishLocationId = testBook1.Id
        );
        insert testContentVersion1;
        
        Book__c testBook2 = new Book__c(
        Book_Name__c = 'Another Test Book',
        Author_Name__c = 'Another Test Author',
        Publisher__c = 'Test Publisher'
    );
    insert testBook2;

    ContentVersion testContentVersion2 = new ContentVersion(
        VersionData = Blob.valueOf('Test Content'),
        Title = 'Test Content',
        PathOnClient = 'TestContent.txt',
        FirstPublishLocationId = testBook2.Id
    );
    insert testContentVersion2;
    }
    
    @isTest
    static void testGetBookWithContentDocumentId() {
        // Call the controller method with a search term
        List<Object> bookList = customLWCForBooksController.getBookWithContentDocumentId('Test');
        
        // Verify the book list has expected values
        System.assertEquals(2, bookList.size());
        Map<String, String> bookInfo = (Map<String, String>)bookList.get(0);
        System.assertEquals('Test Book', bookInfo.get('bookname'));
        System.assertEquals('Test Author', bookInfo.get('author'));
        System.assertEquals('Test Publisher', bookInfo.get('publisher'));
        
        // Verify the content version id and content document id
        ContentVersion cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :bookInfo.get('contentversionid')];
        System.assertEquals(cv.ContentDocumentId, bookInfo.get('contentdocumentid'));
    }
    
}