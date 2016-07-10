//
//  UserDetailViewController.swift
//  GitPub
//
//  Created by Roman Osadchuk on 10.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var userDetailTextView: UITextView!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    var user: User!
    let networkManager = NetworkManager.sharedManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
    }
    
//MARK: - Private
    
    private func prepareUI() {
        loadImage()
        let userName = user.userName ?? "unknown"
        let company = user.company ?? "unknown"
        let email = user.email ?? "unknown"
        
        userDetailTextView.text = "User name: \(userName)\nCompany: \(company)\nEmail: \(email)"
    }
    
    private func loadImage() {
        if let localURL = user.localImageURL {
            if let imageData = NSData(contentsOfFile: localURL) {
                userAvatarImageView.image = UIImage(data: imageData)
            }
        } else if let imageURL = user.imageURL {
            if let url = NSURL(string: imageURL) {
                networkManager.fetchDataFromURL(url, resopnseCompletion: { [weak self] (data, response, error) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    guard let downloadedData = data, userName = strongSelf.user.userName else {
                        return
                    }
                    strongSelf.userAvatarImageView.image = UIImage(data: downloadedData)
                    let localImageURL = Utils.applicationDocumentsDirectory.URLByAppendingPathComponent(userName + ".png")
                    downloadedData.writeToURL(localImageURL, atomically: false)
                    strongSelf.user.localImageURL = localImageURL.absoluteString
                })
            }
        }
    }
    
}

//MARK: - UITableViewDelegate

extension UserDetailViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(RepositoryTableViewCell) , forIndexPath: indexPath) as! RepositoryTableViewCell
        
        
        return cell
    }
}

extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
}
