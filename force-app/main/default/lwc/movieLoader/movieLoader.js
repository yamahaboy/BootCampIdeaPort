import { LightningElement, track, api } from 'lwc';
import importMovies from '@salesforce/apex/movieLoaderController.importMovies';

export default class JSONUploader extends LightningElement {
    @api movieId;
    @track jsonContent = '';

    handleFileChange(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = (e) => {
                const fileContent = e.target.result;
                try {
                    const jsonData = JSON.parse(fileContent);
                    // this.jsonContent = JSON.stringify(jsonData, null, 2); 
                    console.log('Data=>', jsonData);
                    this.uploadJsonToApex(jsonData); 
                } catch (error) {
                    console.error('Error parsing JSON:', error.message);
                }
            };
            reader.readAsText(file);
        }
    }

    async uploadJsonToApex(jsonData) {
        try {
            await importMovies({ jsonData: JSON.stringify(jsonData) });
            console.log('JSON successfully sent to the server for processing');
        } catch (error) {
            console.error('Error sending JSON to the server:', error);
        }
    }
}
