global class FineCalculateBatchClass implements Database.Batchable<sObject> , Schedulable
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
		String query = 'SELECT Id, Due_Date__c FROM Item_Borrowed__c WHERE Due_Date__c < TODAY';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Item_Borrowed__c> lList)
    {
		for(Item_Borrowed__c IB : lList)
        {
			Integer daysLate = IB.Due_Date__c.daysBetween(Date.today());
            
            Integer fineAmount = daysLate * 5 ;
            
            IB.Fine_Amount__c = fineAmount;
        }
        
        update lList;
    }
    
    global void finish(Database.BatchableContext bc)
    { 
        
    }
    
    global void execute(SchedulableContext sc)
	{
    FineCalculateBatchClass batchJob = new FineCalculateBatchClass();
    Database.executeBatch(batchJob);
	}
    
}