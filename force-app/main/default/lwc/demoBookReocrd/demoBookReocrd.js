import { LightningElement, api } from 'lwc';
import { NavigationMixin }  from 'lightning/navigation';
import BOOK_OBJECT from '@salesforce/schema/Book__c';



export default class DemoBookReocrd extends NavigationMixin(LightningElement)  {
    @api recordId;

    objectApiName = BOOK_OBJECT;

    handleSuccess(event){
        
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    actionName: 'view',
                },
            });

            const recordCreatedEvent = new CustomEvent("pagereload");
            this.dispatchEvent(recordCreatedEvent);
    }
}