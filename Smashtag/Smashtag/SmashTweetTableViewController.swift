//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Li Yang on 7/13/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

import UIKit
import Twitter
import CoreData


class SmashTweetTableViewController: TweetTableViewController
{
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets, and: searchText)
    }
    
    
    private func updateDatabase(with tweets: [Twitter.Tweet], and searchTerm: String?) {
        print("starting database load")
        container?.performBackgroundTask { [weak self] context in
            // update tweets and tweeters
            for twitterInfo in tweets {
                _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, in: context)
            }
            // update search terms
            let date = NSDate()
            if searchTerm != nil {
                _ = try? Search.findOrCreateSearchTerm(at: date, matching: searchTerm!, in: context)
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if let tweetCount = try? context.count(for: Tweet.fetchRequest()) {
                    print("\(tweetCount) tweets")
                }
                if let tweeterCount = try? context.count(for: TwitterUser.fetchRequest()) {
                    print("\(tweeterCount) Twitter users")
                }
                if let searchCount = try? context.count(for: Search.fetchRequest()) {
                    print("\(searchCount) searched terms")
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination.contents as? SmashTweetersTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
        if segue.identifier == "Tweet Mentions" {
            if let mentionsTVC = segue.destination.contents as? SmashMentionsTableViewController,
                let senderTweet = (sender as? TweetTableViewCell)?.tweet {
                mentionsTVC.setMentions(with: senderTweet)
            }
        }
    }
}


