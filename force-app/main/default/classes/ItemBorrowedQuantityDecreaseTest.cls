@isTest
public class ItemBorrowedQuantityDecreaseTest {
    
    static testMethod void givenBookWithOneItemBorrowed_WhenIssued_ThenReducedBookQuantityByOne() {
        
      //Arrange: Create book with book quantity = 5 and item borrowed with status Pending 
		Book__c book = new Book__c();
		book.Book_Quantity__c = 5;
		book.Author_Name__c = 'Test Name';
		insert book;
      
      
        Item_Borrowed__c itemBorrowed = new Item_Borrowed__c(
            Book_Status__c = 'None',
            Borrowed_Date__c = Date.today(),
            Item_Borrowed_Field__c = book.Id
        );
      
        insert itemBorrowed;
               
        //Act: Set status to Issued
        itemBorrowed.Book_Status__c = 'Issued';
        update itemBorrowed;
        
        //Assert: The quantity of the book should be reduced by 1
        Book__c updatedBook = [SELECT Book_Quantity__c FROM Book__c WHERE Id = :book.Id];
        System.assertEquals(4, updatedBook.Book_Quantity__c);
    }

   static testMethod void givenBookWithTwoItemBorrowed_WhenIssued_ThenReducedBookQuantityByTwo() {
        
      //Arrange: Create book with book quantity = 5 and item borrowed with status Pending 
		Book__c book = new Book__c();
		book.Book_Quantity__c = 5;
		book.Author_Name__c = 'Test Name';
		insert book;

        
        List<Item_Borrowed__c> itemBorrowedList = new List<Item_Borrowed__c>();
        
        Item_Borrowed__c itemBorrowed1 = new Item_Borrowed__c(
            Book_Status__c = 'None',
            Borrowed_Date__c = Date.today(),
            Item_Borrowed_Field__c = book.Id
        );
        
        itemBorrowedList.add(itemBorrowed1);
        
        Item_Borrowed__c itemBorrowed2 = new Item_Borrowed__c(
            Book_Status__c = 'None',
            Borrowed_Date__c = Date.today(),
            Item_Borrowed_Field__c = book.Id
        );
        
        itemBorrowedList.add(itemBorrowed2);
        
        insert itemBorrowedList;
       
        //Act: Set status to Issued
        itemBorrowed1.Book_Status__c = 'Issued';
        itemBorrowed2.Book_Status__c = 'Issued';
        update itemBorrowedList;
        
          //Assert: The quantity of the book should be reduced by 1
        Book__c updatedBook = [SELECT Book_Quantity__c FROM Book__c WHERE Id = :book.Id];
        System.assertEquals(3, updatedBook.Book_Quantity__c);
    }
    
    static testMethod void givenBookWithOneItemBorrowed_WhenReturned_ThenIncreasedBookQuantityByOne() {
        
		Book__c book = new Book__c();
		book.Book_Quantity__c = 5;
		book.Author_Name__c = 'Test Name';
	
        insert book;
        Item_Borrowed__c itemBorrowed = new Item_Borrowed__c(
            Book_Status__c = 'Issued',
            Borrowed_Date__c = Date.today(),
            Item_Borrowed_Field__c = book.Id
        );
        
        insert itemBorrowed;
               
        itemBorrowed.Book_Status__c = 'Returned';
        update itemBorrowed;
        
        Book__c updatedBook = [SELECT Book_Quantity__c FROM Book__c WHERE Id = :book.Id];
        System.assertEquals(6, updatedBook.Book_Quantity__c);
    }
    
    static testMethod void givenBookWithTwoItemBorrowed_WhenReturned_ThenIncreasedBookQuantityByTwo() {
        
		Book__c book = new Book__c();
		book.Book_Quantity__c = 5;
		book.Author_Name__c = 'Test Name';
		insert book;
        
        List<Item_Borrowed__c> itemBorrowedList = new List<Item_Borrowed__c>();
        
        Item_Borrowed__c itemBorrowed1 = new Item_Borrowed__c(
            Book_Status__c = 'Issued',
            Borrowed_Date__c = Date.today(),
            Item_Borrowed_Field__c = book.Id
        );
        itemBorrowedList.add(itemBorrowed1);
        
        Item_Borrowed__c itemBorrowed2 = new Item_Borrowed__c(
            Book_Status__c = 'Issued',
            Borrowed_Date__c = Date.today(),
            Item_Borrowed_Field__c = book.Id
        );
        itemBorrowedList.add(itemBorrowed2);
        
        insert itemBorrowedList;     
        
        itemBorrowed1.Book_Status__c = 'Returned';
        itemBorrowed2.Book_Status__c = 'Returned';
        update itemBorrowedList;
          
        Book__c updatedBook = [SELECT Book_Quantity__c FROM Book__c WHERE Id = :book.Id];
        System.assertEquals(7, updatedBook.Book_Quantity__c);
    }

}