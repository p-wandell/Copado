/*
 * Copyright (c) 2021. 7Summits Inc.
 */

import LightningDatatable from 'lightning/datatable';
import customTypeControl from './x7sAdventureLeaderboardCustomTypeImage.html';

export default class X7sLeaderboardExtendTable extends LightningDatatable {
    
    static customTypes = {
        image: {template: customTypeControl,
            standardCellLayout: true}
    };
    
}