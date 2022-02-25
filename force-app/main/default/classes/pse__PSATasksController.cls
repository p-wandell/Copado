/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PSATasksController {
    global PSATasksController() {

    }
    global PSATasksController(ApexPages.StandardController controller) {

    }
    @RemoteAction
    global static void assignResourcesToTasks(List<String> taskIds, List<String> resourceIds) {

    }
    @RemoteAction
    global static void changeTaskParent(String taskId, String newParentTaskId) {

    }
    @RemoteAction
    global static String createProjectTask(String projectId, String parentTaskId, String taskName, String startDateStr, String endDateStr) {
        return null;
    }
    @RemoteAction
    global static void deleteTasks(List<String> taskIds) {

    }
    @RemoteAction
    global static List<pse.ProjectTaskDependency> getProjectTaskDependentTasks(String taskId) {
        return null;
    }
    @RemoteAction
    global static List<pse.ProjectTask> getProjectTaskDetail(List<String> taskIds) {
        return null;
    }
    @RemoteAction
    global static List<pse.ProjectTask> getProjectTasksBySearchParameter(String searchParam) {
        return null;
    }
    @RemoteAction
    global static List<pse.PSATasksFLSCheck.ObjectDetail> getTaskManagementFLSDetails() {
        return null;
    }
    @RemoteAction
    global static String getUserLocal() {
        return null;
    }
    @RemoteAction
    global static void markTasksAsBlocker(List<String> taskIds, Boolean blocked) {

    }
    @RemoteAction
    global static void updateDependentTasks(String selectedTaskId, List<String> dependentTaskIds) {

    }
    @RemoteAction
    global static void updateMultipleTaskDetails(List<String> taskIds, Map<String,String> valueMap) {

    }
    @RemoteAction
    global static void updateTask(String taskId, String taskName, String startDateStr, String endDateStr, Boolean blocked, String points, String percentcompletetasks) {

    }
    @RemoteAction
    global static void updateTaskDetails(String taskId, Map<String,String> valueMap) {

    }
}
