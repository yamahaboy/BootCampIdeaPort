import { LightningElement, api} from "lwc";
import { NavigationMixin } from "lightning/navigation";

export default class MovieCard extends NavigationMixin(LightningElement) {
  @api movie;
  @api movieId;
  @api posterUrl;
  @api recordId;

  get show18Plus() {
    return this.movie && this.movie.Genre__c .includes("Horror");
  }

  navigateToDetailsPage() {
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId: this.movie.Id,
        objectApiName: 'MovieObject__c',
        actionName: 'view'
      },
    });
  }
    getDetails() {
      this.navigateToDetailsPage();
    }
  }

