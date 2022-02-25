public class trailheadLeaderBoardController
{
    public List<ContactWrapper> contacts{get;set;}
    public Trailhead_Leaderboard_Settings__c trailsettings{get;set;}
    
    public trailheadLeaderBoardController()
    {
    
        initdata();
    }

    private void initData()
    {
        trailsettings = Trailhead_Leaderboard_Settings__c.getinstance();
        
        contacts = new List<ContactWrapper>();
        
        Integer x = 0;
        for(Contact c :  [Select Id, Name, Total_Points__c, Active_Upload__c,
                                 Twitter_Url__c, Trailhead_URL__c, SF_Dev_User_Id__c, 
                                 Badges__c, Active__c, Trails__c
                        from Contact 
                        Where Active__c = True
                        Order by Trails__c DESC, Badges__c DESC, Total_Points__c DESC])
        {
            x++;
            contacts.add(new ContactWrapper(c,x));
        
        }
    }
    
    public class ContactWrapper
    {
        public Integer count{get;set;}
        public Contact c {get;set;}
        public Integer badgeTotal {get;set;}
        public Integer pointsToday{get;set;}
        public Integer totalPoints{get;set;}
        public Integer trails{get;set;}
        public String name{get;set;}

        public ContactWrapper(Contact c, Integer x)
        {
            this.c = c;
            this.Name = c.Name;
            count = x;
            if(c.Badges__c == null){
                Integer badgesUpload = 0;
                
                if (c.Badges__c != null){
                    badgesUpload = (Integer)c.Badges__c;
                }        

                this.badgeTotal =  badgesUpload;

            }
            else{
                this.badgeTotal = (Integer)c.Badges__c;
            }
            trails = 0;
            if(c.Trails__c != null){
                trails = (Integer)c.Trails__c;
            }
                
            totalPoints = 0;
             if (c.Total_Points__c != null){
                totalPoints = (Integer)c.Total_Points__c;
            }
   
        }
    
    }


}