public with sharing class SS_CommunitySiteGroupsController {

    public PageReference forwardToGroupPage() {
        String groupId;
        for (Account acct : [SELECT Id, Group_Id__c FROM Account WHERE Id IN (SELECT AccountId FROM User WHERE Id =: UserInfo.getUserId())]) {
            groupId = acct.Group_Id__c;
        }

        PageReference pr;
        if (SS_CommunitySiteConstants.getShowGroupList()) {
            pr = new PageReference(SS_CommunitySiteConstants.GROUP_LIST_URL);
        } else {
            if (String.isBlank(groupId)) {
                return null;
            } else {
                pr = new PageReference(SS_CommunitySiteConstants.GROUP_PROFILE_URL + groupId);
            }
        }
        pr.setRedirect(true);
        System.debug(pr);
        return pr;
    }
/*
   	public static List<GroupOptions> getGroupOptions() {
        List<GroupOptions> options = new List<GroupOptions>();
        Integer page = 0;        
        Integer pageSize = 100;
        ConnectApi.UserGroupPage groupPage = ConnectApi.ChatterUsers.getGroups(Network.getNetworkId(), UserInfo.getUserId(), page, pageSize);
        Integer total = groupPage.total;
        while (page * pageSize < total) {
            for (ConnectApi.ChatterGroup grp : groupPage.groups) {
                options.add(new GroupOptions(grp.id, grp.name));
            }
            page++;
            if (page * pageSize < total) {
                groupPage = ConnectApi.ChatterUsers.getGroups(Network.getNetworkId(), UserInfo.getUserId(), page, pageSize);
            }
        }
        return options;
    }

    public class GroupOptions {
    	public String groupId {get; set;}
    	public String groupName {get; set;}

    	public GroupOptions(String groupId, String groupName) {
    		this.groupId = groupId;
    		this.groupName = groupName;
    	}
    }
*/
}