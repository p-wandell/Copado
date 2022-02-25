/* eslint-disable no-console */
/* eslint-disable no-else-return */
import { LightningElement, api } from 'lwc';

export default class x7sAudioTile extends LightningElement {

    @api mediaFile = '';
    @api title = '';
    @api width = '';
    @api isAudio = false;
    @api fileBorder = false;
    @api hasOneFile = false;

    get inlineStyle() {
        if(this.hasOneFile){
            return 'width:' + this.width + '%; margin: auto;';
        }else{
            
            return 'width:' + this.width + 'px; margin: 5px;';

        }
        
    }
    
    get tileBorder() {
        let tag ='video-m ';
        if(this.fileBorder && !this.isAudio){
            tag += 'slds-box';
            return tag ;
        }
        else {
            return tag;
        }
    }
}