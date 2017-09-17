//
//  MentionsImageTableViewCell.swift
//  Smashtag
//
//  Created by Li Yang on 7/18/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

import UIKit
import Twitter

class MentionsImageTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var mentionsImageView: UIImageView!
    
    var mediaItem: Twitter.MediaItem? { didSet { updateUI() } }
    
    private func updateUI() {
        if let url = mediaItem?.url {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.mediaItem!.url {
                    DispatchQueue.main.async {
                        self?.mentionsImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
}
