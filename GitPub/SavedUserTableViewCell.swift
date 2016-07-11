//
//  SavedUserTableViewCell.swift
//  GitPub
//
//  Created by Roman Osadchuk on 11.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class SavedUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImageView: UIImageView!

    @IBOutlet weak var userDetailTextView: UITextView!

    @IBOutlet weak var additionalInfoTextView: UITextView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userAvatarImageView.image = UIImage()
        userDetailTextView.text = ""
        additionalInfoTextView.text = ""
    }

}
