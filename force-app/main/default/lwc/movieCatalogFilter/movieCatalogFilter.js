
import { LightningElement, wire, api } from 'lwc';
import getAllGenres from '@salesforce/apex/MovieCatalogFilterController.getAllGenres';

export default class MovieCatalogFilter extends LightningElement {
    @api movieId;
    genreOptions = [{ label: 'Select an Option', value: 'Select an Option' }];
    selectedGenre = 'Select an Option';

    @wire(getAllGenres)
    wiredGenres({ error, data }) {
        if (data) {
            this.genreOptions = [...this.genreOptions, ...data.map(option => ({
                label: option,
                value: option
            }))];
        }
    }

    handleGenreChange(event) {
        this.selectedGenre = event.detail.value;
        const genreChangeEvent = new CustomEvent('genrechange', {
            detail: { selectedGenre: this.selectedGenre }
        });
        this.dispatchEvent(genreChangeEvent);
    }
}
