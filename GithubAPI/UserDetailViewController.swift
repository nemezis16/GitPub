//
//  UserDetailViewController.swift
//  GitPub
//
//  Created by Roman Osadchuk on 10.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var repositoriesTableView: UITableView!
    @IBOutlet weak var userDetailTextView: UITextView!
    @IBOutlet weak var additionalInfoTextView: UITextView!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    var user: User!
    let networkManager = NetworkManager.sharedManager
    var repositoriesArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prepareUI()
    }
    
//MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(DialogViewController) {
            let controller = segue.destinationViewController as? DialogViewController
            controller?.user = user
        }
    }
    
//MARK: - Private
    
    private func prepareUI() {
        loadImage()
        loadRepositories()
        
        let unknown = "unknown".localized
        
        let userName = user.userName ?? unknown
        let company = user.company ?? unknown
        let email = user.email ?? unknown
        let followersCount = user.followersCount?.stringValue ?? unknown
        let followingsCount = user.followingCount?.stringValue ?? unknown
        let publicGists = user.publicGists?.stringValue ?? unknown
        let publicRepos = user.publicRepos?.stringValue ?? unknown
        
        
        userDetailTextView.text = String.localizedStringWithFormat("User details".localized, userName, company, email)
        additionalInfoTextView.text = String.localizedStringWithFormat("Additional info".localized, followersCount, followingsCount, publicGists, publicRepos)
        //"Followers count: \(followersCount)\nFlollowings count: \(followingsCount)\nPublic gists: \(publicGists)\nPublic repos: \(publicRepos)".localized
    }
    
    private func loadRepositories() {
        if user.repositoriesSaved?.boolValue == false {
            guard let repositoriesURLString = user.publicReposURL else {
                return
            }
            guard let repositoriesURL = NSURL(string: repositoriesURLString) else {
                return
            }
            networkManager.fetchDataFromURL((repositoriesURL), resopnseCompletion: { (data, response, error) in
                do {
                    guard let repositoriesArray = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [[String: AnyObject]] else {
                        return
                    }
                    
                    let manager = CoreDataManager.sharedManager
                    let set = NSMutableSet()
                    for repositoryDict in repositoriesArray {
                        if let repository = manager.createRepository(repositoryProperties: repositoryDict) {
                            set.addObject(repository)
                        }
                    }
                    
                    self.user.addRepositories(set as NSSet)
                    self.user.repositoriesSaved = true
                    self.repositoriesArray = set.allObjects
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.repositoriesTableView.reloadData()
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                }
            })
        } else {
            if let array = user?.repositories?.allObjects as? [Repository] {
                repositoriesArray = array
            }
        }
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
                    
                    dispatch_async(dispatch_get_main_queue(), { 
                        strongSelf.userAvatarImageView.image = UIImage(data: downloadedData)
                    })
                    
                    let localImageURL = Utils.applicationDocumentsDirectory.URLByAppendingPathComponent(userName + ".png")
                    downloadedData.writeToURL(localImageURL, atomically: false)
                    strongSelf.user.localImageURL = localImageURL.path
                })
            }
        }
    }
    
}

//MARK: - UITableViewDelegate

extension UserDetailViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repositoriesCount = user.repositories?.count {
            return repositoriesCount
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(RepositoryTableViewCell) , forIndexPath: indexPath) as! RepositoryTableViewCell
        
        if let repository = repositoriesArray[indexPath.row] as? Repository {
            cell.repositoryTitleLabel.text = repository.title
            cell.languageLabel.text = repository.language
            cell.forkCountLabel.text = repository.forksCount?.stringValue
            cell.starsCountLabel.text = repository.starsCount?.stringValue
        }
        
        return cell
    }
}

extension UserDetailViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init()
    }
    
}
