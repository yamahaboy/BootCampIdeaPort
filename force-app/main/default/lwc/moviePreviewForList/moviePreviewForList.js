import { LightningElement, api, wire } from 'lwc';
import getMoviePosterUrl from "@salesforce/apex/MoviePosterController.getMoviePosterUrl";


export default class MoviePreviewForList extends LightningElement {
  @api movieId;
  @api posterUrl;

  @wire(getMoviePosterUrl, { movieId: "$movieId"})
  wiredMoviePosterUrl({ error, data }) {
    if (data) {
      this.posterUrl = data;
      console.log("link", data);
    } else if (error) {
      console.error("Error load URL", error);
    }
  }

  get isPosterUrl() {
    return this.posterUrl !== undefined && this.posterUrl !== null;
  }

  connectedCallback() {
    console.log(this.movieId);
  }
}
