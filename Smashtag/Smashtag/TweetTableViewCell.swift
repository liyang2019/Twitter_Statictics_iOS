//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Li Yang on 7/12/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? { didSet {updateUI() } }
    
    private func updateUI() {
        if tweet != nil {
            let attributedString = NSMutableAttributedString(string: tweet!.text)
            for hashtag in tweet!.hashtags {
                attributedString.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor.blue,
                    range: hashtag.nsrange
                )
            }
            for url in tweet!.urls {
                attributedString.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor.lightGray,
                    range: url.nsrange
                )
            }
            for userMention in tweet!.userMentions {
                attributedString.addAttribute(
                    NSForegroundColorAttributeName,
                    value: UIColor.orange,
                    range: userMention.nsrange
                )
            }
            tweetTextLabel?.attributedText = attributedString
        }
        
        tweetUserLabel?.text = tweet?.user.description
        
        if let url = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.tweet?.user.profileImageURL {
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24 * 60 * 60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}
