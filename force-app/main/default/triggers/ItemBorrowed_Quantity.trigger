trigger ItemBorrowed_Quantity on Item_Borrowed__c (after update) {
	  if (Trigger.isAfter && Trigger.isUpdate) {
        ItemBorrowedQuantityHelper processor = new ItemBorrowedQuantityHelper(Trigger.New, Trigger.oldMap);
          processor.reduceQuantityOfBookOnIssuance().
              increaseQuantityOfBookOnReturn();
    }
}