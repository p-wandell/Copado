/*
 * Copyright (c) 2020. 7Summits Inc.
 */

const custom = {
	MAX_FIELDS: 6,
	SEARCH_SEPARATOR: ';',
	FIELD_SEPARATOR: ',',
	SEARCH_FIELD: ':',
	USER_PREFIX: '005'
};

const layout = {
	TILE: 'Tile',
	LIST: 'List'
};

const contact = {
	fields: {
		firstName: 'Contact.FirstName',
		lastName: 'Contact.LastName',
		title: 'Contact.Title',
		country: 'Contact.MailingCountry',
		state: 'Contact.MailingState',
		city: 'Contact.MailingCity',
		account: 'Account.Name',
	},
	dataId: {
		title: 'titleTypeAhead',
		country: 'countryTypeAhead',
		state: 'stateTypeAhead',
		city: 'cityTypeAhead',
		account: 'accountTypeAhead',
	},
	values: {
		title: 'titleValues',
		country: 'countryValues',
		state: 'stateValues',
		city: 'cityValues',
		account: 'accountValues'
	}
};

const changeContactToUserFields = () => {
	contact.fields.firstName = 'FirstName';
	contact.fields.lastName = 'LastName';
	contact.fields.title = 'Title';
	contact.fields.country = 'Country';
	contact.fields.state = 'State';
	contact.fields.city = 'City';
};

export {changeContactToUserFields, custom, layout, contact}