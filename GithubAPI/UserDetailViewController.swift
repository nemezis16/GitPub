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
    
//MARK: - Private
    
    private func prepareUI() {
        loadImage()
        loadRepositories()
        
        let userName = user.userName ?? "unknown"
        let company = user.company ?? "unknown"
        let email = user.email ?? "unknown"
        
        userDetailTextView.text = "User name: \(userName)\nCompany: \(company)\nEmail: \(email)"
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
                    
                    self.repositoriesTableView.reloadData()
                } catch {
                    print("error serializing JSON: \(error)")
                }
            })
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
