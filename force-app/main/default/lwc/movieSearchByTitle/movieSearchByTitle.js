import { getRecord } from "lightning/uiRecordApi";
import { LightningElement, api, wire } from "lwc";
import searchMovie from "@salesforce/apex/MovieSearchByTitleController.searchMovie";
import getGenreNameById from "@salesforce/apex/MovieSearchByTitleController.getGenreNameById";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { updateRecord } from "lightning/uiRecordApi";

export default class MovieSearchByTitle extends LightningElement {
  @api movieId;
  @api recordId;
  movieTitle;
  movies;
  title;
  @wire(getRecord, {
    recordId: "$recordId",
    fields: ["MovieObject__c.Title__c"],
  })
  wiredRecord({ error, data }) {
    if (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error loading URL",
          message,
          variant: "error",
        })
      );
    } else if (data) {
      this.movieTitle = data.fields.Title__c.value;
      this.title = this.movieTitle;
    }
  }

  @wire(searchMovie, { title: "$title" })
  getMovies({ error, data }) {
    if (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error loading URL",
          message,
          variant: "error",
        })
      );
    } else if (data) {
      this.movies = data;
      console.log("Movies", this.movies);
    }
  }

  get serializedMovies() {
    return JSON.stringify(this.movies);
  }

  handleSelectMovie(event) {
    const serializedMovies = event.target.dataset.movie;
    const selectedMovies = JSON.parse(serializedMovies);

    if (selectedMovies && selectedMovies.length > 0) {
      const selectedMovie = selectedMovies[0];

      if (selectedMovie.tmdbId__c) {
        this.showErrorMessage("Data already copied from Movie DB");
      } else {
        if (!selectedMovie.tmdbId__c) {
          this.updateRecordFields(selectedMovie);
        } else {
          this.showErrorMessage("Data already copied from Movie DB");
        }
      }
    }
  }

  updateRecordFields(selectedMovie) {
    const fields = {};
    fields.Id = this.recordId;
    fields.tmdbId__c = selectedMovie.id;
    fields.Description__c = selectedMovie.overview;
    fields.Title__c = selectedMovie.title;
    fields.Raiting__c = selectedMovie.vote_average;
    fields.PosterURL__c = selectedMovie.poster_path;
    fields.TMDBSyncDate__c = new Date().toISOString().slice(0, 10);

    console.log('FIELD =>', fields);

    if (selectedMovie.genre_ids && selectedMovie.genre_ids.length > 0) {
      this.getGenreName(selectedMovie.genre_ids[0]).then((genreName) => {
        if (genreName) {
          fields.Genre__c = genreName;
        }
        this.updateRecordWithFields(fields);
      });
    } else {
      this.updateRecordWithFields(fields);
    }
  }

  async getGenreName(genreId) {
    try {
      const genreName = await getGenreNameById({ genreId });
      console.log('GENRE ID=>', genreId);
      console.log('GENRE NAME=>', genreName);
      return genreName;
    } catch (error) {
      console.error("Error fetching genre name:", error);
      return null;
    }
  }

  updateRecordWithFields(fields) {
    const recordInput = { fields };
    updateRecord(recordInput)
      .then(() => {
        this.showSuccessMessage("Record updated successfully!");
      })
      .catch((error) => {
        this.showErrorMessage("Error updating record: " + error.body.message);
      });
  }
}
