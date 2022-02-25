/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

const formattedFileSize = (Size) =>{
    let size = Size;

    // map containing b,kb,mb,gb,tb actual bit values
    let map = {
        b: 1,
        kb: 1 << 10,
        mb: 1 << 20,
        gb: 1 << 30,
        tb: (1 << 30) * 1024
    };

    // get absolute value of the size
    let absSize = Math.abs(size);

    // determine which type of data size we have
    let unit = '';
    if (absSize >= map.tb) {
        unit = 'TB';
    } else if (absSize >= map.gb) {
        unit = 'GB';
    } else if (absSize >= map.mb) {
        unit = 'MB';
    } else if (absSize >= map.kb) {
        unit = 'KB';
    } else {
        unit = 'B';
    }

    // convert to unit type
    let convertedSize = size / map[unit.toLowerCase()];

    // remove decimals
    let results = convertedSize.toFixed();

    return results + unit;
};

const criteriaActions = {
    EDIT: 'edit',
    VIEW: 'view'
}

export {
    criteriaActions, formattedFileSize
}