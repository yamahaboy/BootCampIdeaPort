import { LightningElement, wire, api, track } from 'lwc';
import getMovieList from '@salesforce/apex/movieListController.getMovieList';

const RECORDS_PER_PAGE = 12;

export default class MovieList extends LightningElement {
    @api movieId;
    selectedGenre = 'Select an Option';
    currentPage = 1;
    @track perPage = RECORDS_PER_PAGE; 

    @track movies;

    @wire(getMovieList, { selectedGenre: '$selectedGenre' }) 
    wiredMovies({error, data}) {
        if (data) {
            this.movies = data;
            this.currentPage = 1; 
        } else if (error) {
            console.log('Error', error);
        }
    }

    handleGenreChange(event) {
        this.selectedGenre = event.detail.selectedGenre;
        this.currentPage = 1; 
    }

    get filteredMovies() {
        if (this.selectedGenre === 'Select an Option') {
            return this.movies;
        } else if (this.movies) {
            return this.movies.filter(movie =>movie.Genre__c && movie.Genre__c.includes(this.selectedGenre) );
        }
        return [];
    }

    get pagedMovies() {
        const startIndex = (this.currentPage - 1) * this.perPage;
        const endIndex = startIndex + this.perPage;
        return this.filteredMovies.slice(startIndex, endIndex);
    }

    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return (
            !this.filteredMovies ||
            this.currentPage * this.perPage >= this.filteredMovies.length
        );
    }

    get getPageNumbers() {
        const totalPageCount = Math.ceil(this.filteredMovies.length / this.perPage);
        return Array.from({ length: totalPageCount }, (_, index) => index + 1);
    }

    handlePageNumberClick(event) {
        this.currentPage = parseInt(event.target.dataset.pageNumber, 10);
    }

    handlePrevious() {
        this.currentPage -= 1;
    }

    handleNext() {
        this.currentPage += 1;
    }

    handlePerPageBlur(event) {
        this.perPage = parseInt(event.target.value, 10);
        this.currentPage = 1; 
    }
}
