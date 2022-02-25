/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesCriteriaController {
	private static final String DEFAULT_LOGIC = 'AND';

	public static x7sFilesCriteriaListModel getCriteriaListModel(String fileCriteriaSet) {
		if (String.isNotBlank(fileCriteriaSet)) {
			try {
				x7sFilesCriteriaListModel criteriaListModel = new x7sFilesCriteriaListModel();
				criteriaListModel.id = fileCriteriaSet;

				X7S_Files_Criteria_Set__mdt criteriaAssignment =  X7S_Files_Criteria_Set__mdt.getInstance(fileCriteriaSet);
				criteriaListModel.defaultLogic = criteriaAssignment.Default_Logic__c != null ? criteriaAssignment.Default_Logic__c : DEFAULT_LOGIC;
				criteriaListModel.customLogic = criteriaAssignment.Custom_Logic__c;

				List<X7S_Files_Criteria_Set_Assignment__mdt> criteriaSetAssignment = X7S_Files_Criteria_Set_Assignment__mdt.getAll().values();

				for (X7S_Files_Criteria_Set_Assignment__mdt criteriaItem : criteriaSetAssignment) {

					if (criteriaItem.X7S_Files_Criteria_Set__c == fileCriteriaSet) {
						if (criteriaSetAssignment.size() > 0) {
							List<X7S_Files_Criteria_Set__mdt> criteriaSet = X7S_Files_Criteria_Set__mdt.getAll().values();

							for (X7S_Files_Criteria_Set__mdt criteria : criteriaSet) {
								if (criteria.Id == criteriaItem.X7S_Files_Criteria_Set__c) {
									X7S_Files_Criteria__mdt criteriaField = X7S_Files_Criteria__mdt.getInstance(criteriaItem.X7S_Files_Criteria__c);

									if (criteriaField != null && String.isNotBlank(criteriaField.API_Name__c)) {
										criteriaListModel.criteriaFieldList.add(setCriteriaFieldModel(criteriaItem.X7S_Files_Criteria__c, criteriaItem.Logic_Id__c, criteriaField));
									}
								}
							}
						}
					}
				}

				criteriaListModel.criteriaFieldList.sort();
				//System.debug('criteriaListModel----' + criteriaListModel);
				return criteriaListModel;
			}
			catch (QueryException ex) {
				System.debug('Error getting Criteria set assignment: ' + ex.getMessage());
			}
		}

		return null;
	}

	private static x7sFilesCriteriaFieldModel setCriteriaFieldModel(String id, Decimal logicId, X7S_Files_Criteria__mdt criteriaField) {
		x7sFilesCriteriaFieldModel model = new x7sFilesCriteriaFieldModel();

		if (criteriaField.API_Name__c != null) {
			model.id = id;
			model.logicId = logicId;
			model.fieldName = criteriaField.API_Name__c;
			model.fieldValue = criteriaField.Field_Value__c;
			model.operator = criteriaField.Operator__c;
			model.type = criteriaField.Field_Type__c;
		}

		return model;
	}
}