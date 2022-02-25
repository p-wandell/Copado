/*
 * Copyright (c) 2020. 7Summits Inc.
 */

@IsTest
public with sharing class x7sExpRSSTest {
    private class mockCallout implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            String body = '<?xml version="1.0" encoding="UTF-8" ?> <rss version="2.0"> <channel> <title>Title</title> <link>http://www.google.com</link> <description>Description</description> <item> <title>Title</title> <link>http://www.google.com/xml/xml_rss.asp</link> <author>Test Author</author> <category> Dublin, Ireland </category> <pubdate> 8/5/2017 </pubdate> <description>Description</description> <guid>1234</guid> </item> </channel> </rss>';
            res.setBody(body);
            return res;
        }
    }

    @IsTest
    static void testGetRSSFeedList() {
        Test.setMock(HttpCalloutMock.class, new mockCallout());
        Test.startTest();
        List<x7sExpRSS.RSSWrapper> wrapper = x7sExpRSS.getRSSFeedList('TestURL', '10');
        System.assertNotEquals(null, wrapper);
        Test.stopTest();
    }
}