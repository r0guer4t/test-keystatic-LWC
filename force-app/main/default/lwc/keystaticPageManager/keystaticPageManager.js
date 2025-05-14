import { LightningElement, track } from 'lwc';
import fetchPage from '@salesforce/apex/KeystaticAPIController.fetchPage';
import createPage from '@salesforce/apex/KeystaticAPIController.createPage';

export default class KeystaticPageManager extends LightningElement {
    @track slug = '';
    @track title = '';
    @track content = '';
    @track pageContent = '';
    @track statusMessage = '';

    handleSlugChange(event) {
        this.slug = event.target.value;
    }

    handleTitleChange(event) {
        this.title = event.target.value;
    }

    handleContentChange(event) {
        this.content = event.target.value;
    }

    loadPage() {
        this.statusMessage = '';
        fetchPage({ slug: this.slug })
            .then(result => {
                this.pageContent = result;
            })
            .catch(error => {
                this.pageContent = '';
                this.statusMessage = 'Error loading page: ' + JSON.stringify(error.body.message);
            });
    }

    savePage() {
        this.statusMessage = '';
        createPage({ slug: this.slug, content: this.content, title: this.title })
            .then(result => {
                this.statusMessage = 'Page saved successfully!';
            })
            .catch(error => {
                this.statusMessage = 'Error saving page: ' + JSON.stringify(error.body.message);
            });
    }
}
