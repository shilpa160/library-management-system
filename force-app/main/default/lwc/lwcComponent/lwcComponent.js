import { LightningElement ,api , wire , track} from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import getBooks from'@salesforce/apex/customLWCForBooksController.getBookWithContentDocumentId';
import IMAGE_URL_FIELD from '@salesforce/schema/ContentDocument.LatestPublishedVersion.VersionDataUrl';
import { refreshApex } from '@salesforce/apex';

const actions = [
    {label:'Preview', name:'preview'}
];

const COLS = [
    {
        label : 'Book Name',
        fieldName : 'bookurl',
        type : 'url' ,
        sortable : 'true',
        typeAttributes:{label:{ fieldName:'bookname'}, target:'_blank'}   
    },
    {
        label : 'Author',
        fieldName : 'author',
        type : 'text',
        sortable : 'true'
    },
    {
        label : 'Publisher',
        fieldName : 'publisher',
        type : 'text',
        sortable : 'true'
    },
    {
        label : 'BookCover',
        type : 'customImage',
        sortable : 'true', 
        typeAttributes: {
            imageUrl: {fieldName: 'imageurl'},
            contentversionid: { fieldName: 'contentversionid' },
        },
    },
    {
        type: 'action',
        typeAttributes:{rowActions : actions, menuAlignment:'right'}
    }

];

export default class lwcComponent extends NavigationMixin(LightningElement){
        
    columns= COLS;
   
    @api recordId;
    @track error;
    @track  bookList;
    @track searchTerm='';
    @track convertedBookList = [];
    @track bookListPopulated = false;
    @track resultList;
    @wire(getBooks , { searchTerm: '$searchTerm' })
    wiredBook(result){
        this.resultList = result;
        this.convertedBookList = [];
        if(result.data){
            this.bookList = result.data;
            this.bookList.forEach(book => {
                let bookUrl = '/sfc/servlet.shepherd/version/download/' + book.contentversionid;
                let bookRecord = JSON.parse(JSON.stringify(book));
                bookRecord["imageurl"] = bookUrl;
                this.convertedBookList.push(bookRecord);
                
            });
            this.bookListPopulated = true;
        }
        else if (result.error) {
            this.error = result.error ;
        }
    }
   
    handleSearch(event) {
        this.searchTerm = event.target.value;
    }

    handleRowAction(event){
        const actionName = event.detail.action.name;
        if(actionName === 'preview'){
            this[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'filePreview'
                },
                state: {
                    selectedRecordId: event.detail.row.contentdocumentid
                }
            });
        }
    }
    
    
 }