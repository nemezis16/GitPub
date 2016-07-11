//
//  SavedUsersViewController.swift
//  GitPub
//
//  Created by Roman Osadchuk on 11.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class SavedUsersViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var savedUsers = CoreDataManager.sharedManager.getSavedUsers()
    
//MARK: - Actions 
    
    @IBAction func handleClearUsersTap(sender: AnyObject) {
        CoreDataManager.sharedManager.deleteAllEntities()
        savedUsers = []
        usersTableView.reloadData()
    }
}

extension SavedUsersViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let savedUsersCount = savedUsers?.count {
            return savedUsersCount
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(SavedUserTableViewCell) , forIndexPath: indexPath) as! SavedUserTableViewCell
        
        let user = savedUsers?[indexPath.row]
        
        let userName = user?.userName ?? "unknown"
        let company = user?.company ?? "unknown"
        let email = user?.email ?? "unknown"
        let followersCount = user?.followersCount?.stringValue ?? "unknown"
        let followingsCount = user?.followingCount?.stringValue ?? "unknown"
        let publicGists = user?.publicGists?.stringValue ?? "unknown"
        let publicRepos = user?.publicRepos?.stringValue ?? "unknown"
        
        cell.userDetailTextView.text = "User name: \(userName)\nCompany: \(company)\nEmail: \(email)"
        cell.additionalInfoTextView.text = "Followers count: \(followersCount)\nFlollowings count: \(followingsCount)\nPublic gists: \(publicGists)\nPublic repos: \(publicRepos)"
        
        if let localImageURL = user?.localImageURL {
            let localImage = UIImage(contentsOfFile: localImageURL)
            cell.userAvatarImageView.image = localImage
        }
        
        return cell
    }
    
}

extension SavedUsersViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let user: User? = savedUsers?[indexPath.row] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier(String(UserDetailViewController)) as! UserDetailViewController
            viewController.user = user
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
}
