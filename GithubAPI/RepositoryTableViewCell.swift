//
//  TableViewCell.swift
//  GitPub
//
//  Created by Roman Osadchuk on 10.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryTitleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var forkCountLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        repositoryTitleLabel.text = ""
        languageLabel.text = ""
        forkCountLabel.text = ""
        starsCountLabel.text = ""
    }

}
