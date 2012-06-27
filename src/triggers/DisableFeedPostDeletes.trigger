/**
 * Author: Marcus Ericsson - mericsson@salesforce.com
 */
trigger DisableFeedPostDeletes on FeedItem (before delete) 
{
    if (!DisableChatterDeleteDelegate.allowDelete()) {
        for(FeedItem f : Trigger.old){
            if (((String)f.parentId).startsWith('00Q') && f.type == 'TrackedChange') {
                // ok to ignore
            }
            else {
                f.addError('Your administrator has disabled feed post and comment deletions.'); 
            }
        }
    }
}