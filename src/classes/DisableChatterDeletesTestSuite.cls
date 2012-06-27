/**
 * Test Suite for testing Chatter Disable Delete app
 * 
 * Author: Marcus Ericsson - mericsson@salesforce.com
 */
@isTest
private class DisableChatterDeletesTestSuite {

    static void deleteAllCustomSettings() {
        Chatter_Delete_Settings__c[] settings = [select id from Chatter_Delete_Settings__c];
        delete(settings);
    }
    
    static Id insertDummyContact() {
        // lets do User instead because some orgs don't have Feeds enabled on Contacts.
        Profile prof = [select id from profile where name = 'System Administrator'];
        User u = new User(alias = 'standt', email = 'testFeedItemDeleteDummy@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDeleteDummy@testorg.com');
        Database.SaveResult sr = Database.Insert(u);
        System.assert(sr.isSuccess());
        return sr.getId();
    }

    static testMethod void testFeedItemDeleteSysAdmin() {
        deleteAllCustomSettings();
        
        Profile prof = [select id from profile where name = 'System Administrator'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');

        System.runAs(u) {
            //insert a dummy contact we can post on
            Id cid = insertDummyContact();

            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = cid;
            p.Body = 'force.com labs is great!';
            insert(p);
            delete(p);
        }
    }
    
    static testMethod void testFeedItemDeleteSysAdminFrench() {
        deleteAllCustomSettings();
        
        Profile prof = [select id from profile where name = 'System Administrator'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'fr', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');

        System.runAs(u) {
            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = u.id;
            p.Body = 'force.com labs is great!';
            insert(p);
            delete(p);
        }
    }

    static testMethod void testFeedCommentDeleteSysAdmin() {
        deleteAllCustomSettings();

        Profile prof = [select id from profile where name = 'System Administrator'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');

        System.runAs(u) {    
            Id cid = insertDummyContact();
    
            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = cid;
            p.Body = 'force.com labs is great!';
    
            Database.SaveResult sr = Database.Insert(p);
            System.assert(sr.isSuccess());
            Id pId = sr.getId();
    
            FeedComment c = new FeedComment();
            c.feedItemId = pid;
            c.CommentBody = 'this is a comment';
            insert(c);

            delete(c);
        }
    }

    static testMethod void testFeedItemDelete() {
        deleteAllCustomSettings();

        Profile prof = [select id from profile where name = 'Standard User'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');


        System.runAs(u) {
            // The following code runs as user 'u'   
            //insert a dummy contact we can post on
            Id cid = insertDummyContact();

            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = cid;
            p.Body = 'force.com labs is great!';
            insert(p);
            try {
                delete(p);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }


            // now test bulk delete
            FeedItem[] ps = new FeedItem[150];
            for (Integer i = 0; i < 150; i++) {
                ps[i] = new FeedItem();
                ps[i].parentId = cid;
                ps[i].body = 'force.com labs is great!';
            }
            insert(ps);
            try {
                delete(ps);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }
        }
    }
    
    static testMethod void testFeedItemDeleteFrench() {
        deleteAllCustomSettings();

        Profile prof = [select id from profile where name = 'Standard User'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'fr', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');


        System.runAs(u) {
            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = u.id;
            p.Body = 'force.com labs is great!';
            insert(p);
            try {
                delete(p);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }
        }
    }

    static testMethod void testFeedCommentDelete() {
        deleteAllCustomSettings();
        Profile prof = [select id from profile where name = 'Standard User'];
        User u = new User(alias = 'standt', email = 'testFeedCommentDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedCommentDelete@testorg.com');


        System.runAs(u) {
            // The following code runs as user 'u'   
            //insert a dummy contact we can post on
            Id cid = insertDummyContact();

            // test single item delete
            FeedItem p = new FeedItem();
            p.parentId = cid;
            p.Body = 'force.com labs is great!';

            Database.SaveResult sr = Database.Insert(p);
            System.assert(sr.isSuccess());
            Id pId = sr.getId();

            FeedComment c = new FeedComment();
            c.feedItemId = pid;
            c.CommentBody = 'this is a comment';
            insert(c);

            try {
                delete(c);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }


            // now test bulk delete
            FeedComment[] cs = new FeedComment[150];
            for (Integer i = 0; i < 150; i++) {
                cs[i] = new FeedComment();
                cs[i].feeditemid = pid;
                cs[i].CommentBody = 'force.com labs is great!';
            }
            insert(cs);
            try {
                delete(cs);
                System.assert(false);
            } catch (System.DmlException e) {
                System.assert(e.getMessage().contains('disabled'));
            }
        }
    }

    static testMethod void testFeedItemDeleteCustomSetting() {
        deleteAllCustomSettings();

        Profile prof = [select id from profile where name = 'Standard User'];
        User u = new User(alias = 'standt', email = 'testFeedItemDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedItemDelete@testorg.com');
        Chatter_Delete_Settings__c settings = new Chatter_Delete_Settings__c();
        settings.Allow_Feed_Post_And_Comment_deletes__c = true;
        settings.SetupOwnerId = prof.id;
        upsert(settings);
        try {
            System.runAs(u) {
                // The following code runs as user 'u'   
                //insert a dummy contact we can post on
                Id cid = insertDummyContact();

                // test single item delete
                FeedItem p = new FeedItem();
                p.parentId = cid;
                p.Body = 'force.com labs is great!';
                insert(p);
                delete(p);

                // now test bulk delete
                FeedItem[] ps = new FeedItem[150];
                for (Integer i = 0; i < 150; i++) {
                    ps[i] = new FeedItem();
                    ps[i].parentId = cid;
                    ps[i].body = 'force.com labs is great!';
                }
                insert(ps);
                delete(ps);
            }
        } finally {
            settings.Allow_Feed_Post_And_Comment_deletes__c = false;
            update(settings);
        }
    }

    static testMethod void testFeedCommentDeleteCustomSetting() {
        deleteAllCustomSettings();
    
        Profile prof = [select id from profile where name = 'Standard User'];
        User u = new User(alias = 'standt', email = 'testFeedCommentDelete@testorg.com', emailencodingkey = 'UTF-8', lastname = 'Testing', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = prof.Id, timezonesidkey = 'America/Los_Angeles', username = 'testFeedCommentDelete@testorg.com');
        Chatter_Delete_Settings__c settings = new Chatter_Delete_Settings__c();
        settings.Allow_Feed_Post_And_Comment_deletes__c = true;
        settings.SetupOwnerId = prof.id;
        upsert(settings);
        try {


            System.runAs(u) {
                // The following code runs as user 'u'   
                //insert a dummy contact we can post on
                Id cid = insertDummyContact();

                // test single item delete
                FeedItem p = new FeedItem();
                p.parentId = cid;
                p.Body = 'force.com labs is great!';

                Database.SaveResult sr = Database.Insert(p);
                System.assert(sr.isSuccess());
                Id pId = sr.getId();

                FeedComment c = new FeedComment();
                c.feedItemId = pid;
                c.CommentBody = 'this is a comment';
                insert(c);


                delete(c);

                // now test bulk delete
                FeedComment[] cs = new FeedComment[150];
                for (Integer i = 0; i < 150; i++) {
                    cs[i] = new FeedComment();
                    cs[i].feeditemid = pid;
                    cs[i].CommentBody = 'force.com labs is great!';
                }
                insert(cs);
                delete(cs);
            }
        } finally {
            settings.Allow_Feed_Post_And_Comment_deletes__c = false;
            update(settings);
        }

    }

}