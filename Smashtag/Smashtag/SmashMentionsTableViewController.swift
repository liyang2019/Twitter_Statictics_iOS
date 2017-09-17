//
//  SmashMentionTableViewController.swift
//  Smashtag
//
//  Created by Li Yang on 7/17/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

import UIKit
import Twitter

class SmashMentionsTableViewController: UITableViewController
{
    // the mentions of a Tweet has four sections
    // section-0 is for images
    // section-1 is for hashtags
    // section-2 is for users
    // section-3 is for urls
    
    // the mentions of a Tweet have two types
    // one is media type inlcuding images
    // the other is plan text type
    private enum Mention {
        case image(Twitter.MediaItem)
        case hashtag(Twitter.Mention)
        case user(Twitter.Mention)
        case url(Twitter.Mention)
    }
    
    // te model data structure
    // there are four sections, whose headers are stored as headers[section]
    private var headers = ["Images", "Hashtags", "Users", "Urls"]
    // for each section, mentions[section] is the mention content for this section
    private var mentions: [Array<Mention>] = [[], [], [], []]
    
    func setMentions(with tweet: Twitter.Tweet) {
        for media in tweet.media {
            mentions[0].append(Mention.image(media))
        }
        for hashtag in tweet.hashtags {
            mentions[1].append(Mention.hashtag(hashtag))
        }
        for userMention in tweet.userMentions {
            mentions[2].append(Mention.user(userMention))
        }
        for url in tweet.urls {
            mentions[3].append(Mention.url(url))
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentions[section].count
    }
        
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].count > 0 ? headers[section] : nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell: UITableViewCell
        switch mentions[indexPath.section][indexPath.row] {
        case .image(let mediaItem):
            cell = tableView.dequeueReusableCell(withIdentifier: "Images Cell", for: indexPath)
            if let mentionImagesCell = cell as? MentionsImageTableViewCell {
                mentionImagesCell.mediaItem = mediaItem
            }
        case .hashtag(let text), .user(let text):
            cell = tableView.dequeueReusableCell(withIdentifier: "Hashtags and Users Cell", for: indexPath)
            cell.textLabel?.text = text.keyword
        case .url(let text):
            cell = tableView.dequeueReusableCell(withIdentifier: "Urls Cell", for: indexPath)
            cell.textLabel?.text = text.keyword
            
        }
        return cell
    }
    
    // set the height for rows containing images
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch mentions[indexPath.section][indexPath.row] {
        case .image(let mediaItem):
            return tableView.frame.size.width / CGFloat(mediaItem.aspectRatio)
        default:
            return tableView.rowHeight
            
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier ?? "" {
        case "Scroll and Zoom Image":
            if let imageVC = (segue.destination.contents as? ImageViewController),
                let image = (sender as? MentionsImageTableViewCell)?.mentionsImageView.image {
                imageVC.image = image
            }
        case "Search Hashtag or User":
            if let smashTweetTVC = segue.destination.contents as? SmashTweetTableViewController,
                let searchText = (sender as? UITableViewCell)?.textLabel?.text {
                smashTweetTVC.searchText = searchText
            }
        case "Open Url in Safari":
            if let urlString = (sender as? UITableViewCell)?.textLabel?.text,
                let url = URL(string: urlString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        default:
            break
        }
    }
    
}
