/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IActionViewsAction {
    List<ffr.DataViewService.ParameterMetadataType> getParameterMetadataList();
    Set<Id> getRequiredFields(ffr.DataViewService.DataView param0);
    ffr.ActionViewsService.ActionResult invokeAction(ffr.DataViewService.DataView param0, ffr.SelectionService.Result param1, String param2, Map<String,String> param3);
    Boolean isSingleSelect();
}
