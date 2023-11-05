import { LightningElement, api, wire } from "lwc";
import getMoviePosterUrl from "@salesforce/apex/MoviePosterController.getMoviePosterUrl";

export default class MoviePosterPreview extends LightningElement {
  @api movieId;
  @api posterUrl;
  @api recordId;


  @wire(getMoviePosterUrl, { movieId: "$recordId"})
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
