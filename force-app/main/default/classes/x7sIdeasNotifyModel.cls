/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sIdeasNotifyModel {
	public String id, name, context, detail, url;

	public x7sIdeasNotifyModel(String id, String name, String context, String detail, String url) {
		this.id = id;
		this.name = name;
		this.context = context;
		this.detail = detail;
		this.url = url;
	}

	public void Dump(String message) {
		System.debug('Notification  : ' + message);
		System.debug('    id        : ' + this.id);
		System.debug('    name      : ' + this.name);
		System.debug('    context   : ' + this.context);
		System.debug('    detail    : ' + this.detail);
		System.debug('    url       : ' + this.url);
	}
}