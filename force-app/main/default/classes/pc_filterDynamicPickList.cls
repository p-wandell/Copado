/*
 * Copyright (c) 2017. 7Summits inc.
 */

/**
 * Created by francois korb on 7/27/17.
 */

public class pc_filterDynamicPickList extends VisualEditor.DynamicPickList {

	final static String OBJECT_NAME = 'Product2';
	final static String FIELD_NAME  = 'Family';

	public override VisualEditor.DataRow getDefaultValue() {
		String value = Label.ss_pc_selectAll;
		VisualEditor.DataRow defaultValue = new VisualEditor.DataRow(value, value);

		return defaultValue;
	}

	public override VisualEditor.DynamicPickListRows getValues() {
		List<String> values = pc_filterController.getPicklistValues(OBJECT_NAME, FIELD_NAME);
		values.add(0, Label.ss_pc_selectAll);

		VisualEditor.DynamicPickListRows picklistValues = new VisualEditor.DynamicPickListRows();

		if (values.size() > 0)
		{
			for (String value : values)
			{
				VisualEditor.DataRow row = new VisualEditor.DataRow(value, value);
				picklistValues.addRow(row);
			}
		}

		return picklistValues;
	}
}