/**
 * Copyright (c) 2020. 7Summits Inc.
 */

/**
 * scrolls to a particular set of coordinates + offset inside the window object
 * https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollTo
 * note: behavior: 'smooth' is required for this to work in an LWC for some reason
 * @param element
 * @param offset
 */
const scrollTo = (element, offset = 0) => {
    return window.scrollTo({behavior: "smooth", left: 0, top: element.offsetTop + offset});
};

/**
 * trim string, convert to lowercase and replace all non alphanumeric chars with '-'
 * @param str
 * @returns {*|string}
 */
const kebabCase = (str) => {
    return str && str.trim().toLowerCase().replace(/[^A-Z0-9]+/ig, "-").replace(/\-$/, '');
};

export {
    scrollTo,
    kebabCase
};