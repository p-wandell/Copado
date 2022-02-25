/*
 * Copyright (c) 2020. 7Summits Inc.
 */

import {LightningElement, api, track} from 'lwc';

// Class name constants
const progressClass = 'x7s-progress-circle_svg-progress-bar';
const progressDefaultClass = `${progressClass} ${progressClass}-default`;
const remainingClass = 'x7s-progress-circle_svg-base';
const remainingDefaultClass = `${remainingClass} ${remainingClass}-default`;
const over100Class = 'over100';

// Size var for setting height/width and circle calculations.
const innerSize = 100;

export default class X7sExpProgressCircle extends LightningElement {
	@api totalProgress;
	@api actualProgress;
	@api resultFormat = 'Percentage';
	@api size = 100;
	@api strokeWidth = 5;
	@api strokeLineCap = 'butt';
	@api direction = 'clockwise'; // clockwise/counter-clockwise
	@api progressColor;
	@api remainingColor;
	@api thresholdPercent;
	@api thresholdColor;
	@api customClass;

	@api
		get innerCircleColor() {
			return this._innerCircleColor;
		}
		set innerCircleColor(x) {
			this._innerCircleColor = x ? x : 'none'; // If null, set to 'none'.
		}

	@track _innerCircleColor = 'none';

	// - Value getters --------------------------------------------------------

	/**
	 * return CSS class(es) on outer element
	 *
	 * @returns {string}
	 */
	get componentClass() {
		let classes = ['x7s-progress-circle'];
		if (this.isOver100) classes.push(over100Class);
		if (this.customClass) classes.push(this.customClass);
		return classes.join(' ');
	}

	/**
	 * Set the stroke color on the progress circle.
	 * Swap to the threshold color if the threshold is met/exists.
	 *
	 * @returns {string}
	 */
	get progressColorValue() {
		let color = this.progressColor;

		if (this.thresholdPercent && this.thresholdPercent <= Math.floor(this.progressPercent)) {
			color = this.thresholdColor ? this.thresholdColor : color;
		}

		return color;
	}

	/**
	 * Set the class on the progress circle.
	 * The default class allows theSVG to inherit from the default tokens.
	 *
	 * @returns {string}
	 */
	get progressColorClass() {
		return this.progressColorValue ? progressClass : progressDefaultClass;
	}

	/**
	 * Set the class on the remaining circle.
	 * The default class allows theSVG to inherit from the default tokens.
	 *
	 * @returns {string}
	 */
	get remainingColorClass() {
		return this.remainingColor ? remainingClass : remainingDefaultClass;
	}

	/**
	 * Set the SVG viewBox attribute.
	 *
	 * @returns {string}
	 */
	get viewBox() {
		return `0 0 ${innerSize} ${innerSize}`;
	}

	/**
	 * Set the SVG circle radius.
	 *
	 * @returns {number}
	 */
	get radius() {
		return innerSize / 2;
	}

	/**
	 * Set the SVG circle circumference. Also used to set the stroke-dasharray.
	 *
	 * @returns {number}
	 */
	get circumference() {
		return Math.PI * this.radius * 2;
	}

	/**
	 * Set the SVG transform so that it’s rotated to start at the top.
	 *
	 * @returns {string}
	 */
	get transform() {
		return `rotate(-90 ${this.radius} ${this.radius})`;
	}

	/**
	 * Set the SVG stroke-dashoffset by converting the progress percentage
	 * into a decimal value and multiplying by the circumference.
	 * Change the direction by changing to a negative value.
	 *
	 * @returns {number}
	 */
	get dashOffset() {
		let percentageDecimal = (100 - this.progressPercent) / 100;
		if (this.direction === 'counter-clockwise') {
			percentageDecimal = -percentageDecimal;
		}
		return (percentageDecimal * this.circumference);
	}

	/**
	 * If 'totalProgress' has no value (or is zero), set to "1"; no div-by-zero allowed here
	 *
	 * @returns {number}
	 */
	get progressPercent() {
		const actualProgress = (this.actualProgress !== null || this.actualProgress !== '')
			? parseInt(this.actualProgress) : 0;
		const totalProgress = (this.totalProgress !== null || this.totalProgress !== '' || this.totalProgress != 0)
			? parseInt(this.totalProgress) : 1;
		return Math.floor(Math.round((actualProgress / totalProgress) * 100));
	}

	/**
	 * This test is used to add an additional CSS class to the component, if our progress is over 100%
	 *
	 * @returns {boolean}
	 */
	get isOver100() {
		return (this.progressPercent > 100);
	}

	/**
	 * Set a height and width on the component.
	 * If blank, the component will scale to the size of it’s parent.
	 *
	 * @returns {string}
	 */
	get sizeWidthHeight() {
		if (this.size) {
			return `width: ${this.size}px; height: ${this.size}px;`;
		} else {
			return ``;
		}
	}

	/**
	 * Test for format style "Percent only"
	 *
	 * @returns {boolean}
	 */
	get isFormatPercentage() {
		return (this.resultFormat === 'Percentage');
	}

	/**
	 * Test for format style "Actual number (actualProgress value)"
	 *
	 * @returns {boolean}
	 */
	get isFormatActualNumber() {
		return (this.resultFormat === 'Actual Number');
	}

	/**
	 * Test for format style "Actual number/Total number"
	 *
	 * @returns {boolean}
	 */
	get isFormatMix() {
		return (this.resultFormat === 'Mix');
	}

	/**
	 * Test for format style "Percent<newline>Actual number/Total number"
	 *
	 * @returns {boolean}
	 */
	get isFormatPercentageMix() {
		return (this.resultFormat === 'Percentage Mix');
	}

	/**
	 * Modifies the stroke width to scale with the size.
	 * Strokes are centered on the line, so the value is doubled.
	 * The excess width is "trimmed" off using CSS overflow: hidden
	 * and border-radius: 50%.
	 */
	get strokeWidthMod() {
		const halfSize = this.size / 2;
		// Prevent the strokeWidth from exceed half the size of the circle
		const strokeWidth = (halfSize < this.strokeWidth) ? halfSize : this.strokeWidth;

		return Math.ceil(((strokeWidth * innerSize) / this.size) * 2);
	}
}