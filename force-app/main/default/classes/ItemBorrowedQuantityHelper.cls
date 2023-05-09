public class ItemBorrowedQuantityHelper {
    
    List<Item_Borrowed__c> itemBorrowedList;
    Map<Id, Item_Borrowed__c> oldItemBorrowedMap;
    
    public ItemBorrowedQuantityHelper(List<Item_Borrowed__c> itemBorrowedList, Map<Id, Item_Borrowed__c> oldItemBorrowedMap)
    {
        this.itemBorrowedList = itemBorrowedList;
        this.oldItemBorrowedMap = oldItemBorrowedMap;
    }
    
    public ItemBorrowedQuantityHelper reduceQuantityOfBookOnIssuance()
    {
        
        List<Book__c> bookToUpdate = new List<Book__c>();
        Set<Id> bookIds =new Set<Id>();
        
        Map<Id, Integer> bookMap = new Map<Id, Integer>();
        
        for(Item_Borrowed__c itemBorrowed : itemBorrowedList)
        {
            if(itemBorrowed.Book_Status__c == 'Issued' && oldItemBorrowedMap.get(itemBorrowed.Id).Book_Status__c != 'Issued')
            {
				bookIds.add(itemBorrowed.Item_Borrowed_Field__c);
            }
        }
        
        System.debug('The bookd ids is : ' + bookIds);
        
        Map<Id, Book__c> bookWithQuantityMap = new Map<Id, Book__c>([
            SELECT Id, Book_Quantity__c FROM Book__c WHERE Id IN : bookIds
        ]);
        
        System.debug('The bookWithQuantityMap is : ' + bookWithQuantityMap);
        
        for(Item_Borrowed__c itemBorrowed: itemBorrowedList)
        {
            if(itemBorrowed.Book_Status__c == 'Issued' && oldItemBorrowedMap.get(itemBorrowed.Id).Book_Status__c != 'Issued'){
				
                if(bookMap.containsKey(itemBorrowed.Item_Borrowed_Field__c)){
                    Integer count = bookMap.get(itemBorrowed.Item_Borrowed_Field__c);
                    bookMap.put(itemBorrowed.Item_Borrowed_Field__c, count - 1);
                }
                else{
                    	bookMap.put(itemBorrowed.Item_Borrowed_Field__c, (Integer)(bookWithQuantityMap.get(itemBorrowed.Item_Borrowed_Field__c).Book_Quantity__c -1));
					}
        	}  
  		}
        
        System.debug('The bookMap is : ' + bookMap);
        
        if(bookMap.size() > 0){
            for(Id bookId : bookMap.keySet()){
				   bookToUpdate.add(new Book__c(
                   		Id = bookId,
                   		Book_Quantity__c = bookMap.get(bookId)
                   ));
            	}
        }
        
        System.debug('The bookToUpdate is : ' + bookToUpdate);
        
        if(bookToUpdate.size()> 0 )
        {
			update bookToUpdate;     
 	   }
        
        return this;
	}
    
     public ItemBorrowedQuantityHelper increaseQuantityOfBookOnReturn()
    {
        
        List<Book__c> bookToUpdate = new List<Book__c>();
        Set<Id> bookIds =new Set<Id>();
        
        Map<Id, Integer> bookMap = new Map<Id, Integer>();
        
        for(Item_Borrowed__c itemBorrowed : itemBorrowedList)
        {
            if(itemBorrowed.Book_Status__c == 'Returned' && oldItemBorrowedMap.get(itemBorrowed.Id).Book_Status__c != 'Returned'){
				bookIds.add(itemBorrowed.Item_Borrowed_Field__c);
            }
        }
        
        System.debug('The bookd ids is : ' + bookIds);
        
        Map<Id, Book__c> bookWithQuantityMap = new Map<Id, Book__c>([
            SELECT Id, Book_Quantity__c FROM Book__c WHERE Id IN : bookIds
        ]);
        
        
        for(Item_Borrowed__c itemBorrowed: itemBorrowedList){
            if(itemBorrowed.Book_Status__c == 'Returned' && oldItemBorrowedMap.get(itemBorrowed.Id).Book_Status__c != 'Returned'){
				
                if(bookMap.containsKey(itemBorrowed.Item_Borrowed_Field__c)){
                    Integer count = bookMap.get(itemBorrowed.Item_Borrowed_Field__c);
                    bookMap.put(itemBorrowed.Item_Borrowed_Field__c, count + 1);
                }
                else{
                    	bookMap.put(itemBorrowed.Item_Borrowed_Field__c, (Integer)(bookWithQuantityMap.get(itemBorrowed.Item_Borrowed_Field__c).Book_Quantity__c +1));
					}
        	}  
  		}
        
        System.debug('The bookMap is : ' + bookMap);
        
        if(bookMap.size() > 0)
        {
            for(Id bookId : bookMap.keySet()){
				   bookToUpdate.add(new Book__c(
                   		Id = bookId,
                   		Book_Quantity__c = bookMap.get(bookId)
                   ));
            	}
        }
        
        System.debug('The bookToUpdate is : ' + bookToUpdate);
        
        if(bookToUpdate.size()>= 0 )
         {
			update bookToUpdate;     
 	  	 }
        
        return this;
	}
}