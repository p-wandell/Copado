/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

global with sharing class x7sFilesCMTDynamicPicklist extends VisualEditor.DynamicPickList {
	final String DEFAULT_CMT = 'Default';

	global override VisualEditor.DataRow getDefaultValue() {
		X7S_Files_Setting__mdt setting = X7S_Files_Setting__mdt.getInstance(DEFAULT_CMT);

		VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(setting.Label, setting.DeveloperName);

		return defaultValue;
	}

	global override VisualEditor.DynamicPickListRows getValues() {
		VisualEditor.DynamicPickListRows pickListValues = new VisualEditor.DynamicPickListRows();
		List<X7S_Files_Setting__mdt> settingsName = X7S_Files_Setting__mdt.getAll().values();

		for (X7S_Files_Setting__mdt setting : settingsName) {
			VisualEditor.DataRow row = new VisualEditor.DataRow(setting.Label, setting.DeveloperName);
			pickListValues.addRow(row);
		}

		return pickListValues;
	}
}