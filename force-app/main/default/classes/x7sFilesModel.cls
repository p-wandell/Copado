/*
 * Copyright (c) 2021. 7Summits, an IBM Company. All rights reserved.
 */

public with sharing class x7sFilesModel {
    @AuraEnabled
    public List<x7sFilesItemModel> files {
        get;
        set;
    }

    @AuraEnabled
    public Decimal total {
        get;
        set;
    }

    @AuraEnabled
    public Decimal pageCount {
        get;
        set;
    }

    @AuraEnabled
    public Decimal pageSize {
        get;
        set;
    }

    @AuraEnabled
    public Decimal pageCurrent {
        get;
        set;
    }

    @AuraEnabled
    public Boolean pageHasNext {
        get;
        set;
    }

    @AuraEnabled
    public Boolean pageHasPrevious {
        get;
        set;
    }

    public x7sFilesModel() {
        this.files                     = new List<x7sFilesItemModel>();
        this.total                     = 0;
        this.pageCount                 = 0;
        this.pageSize                  = 0;
        this.pageCurrent               = 0;
        this.pageHasNext               = false;
        this.pageHasPrevious           = false;
    }
}