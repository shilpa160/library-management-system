import { LightningElement,api,wire} from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/filePreviewAndDownloadController.getRelatedFilesByRecordId'

export default class FilePreviewAndDownloads extends LightningElement {
    @api files

    @wire(getRelatedFilesByRecordId, {recordId: '$files'})
    wiredResult({data, error}){
        if(data){
            console.log(data)
            this.filesList = Object.keys(data).map(item => ({"label":data[item],
            "value":item,
            "url": `/sfc/servlet.shepherd/document/download/${item}`
    }))
        }
        if(error){
            console.log(error)
        }
    }

    previewHandler(event){
        console.log(event.target.dataset.id)
    }

}