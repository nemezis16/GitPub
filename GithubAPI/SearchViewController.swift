//
//  ViewController.swift
//  GithubAPI
//
//  Created by Roman Osadchuk on 08.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var user: User?
    let networkManager = NetworkManager.sharedManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.user = nil
    }
    
//MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == String(UserDetailViewController) {
            let controller = segue.destinationViewController as? UserDetailViewController
            controller?.user = user
        }
    }
    
//MARK: - Actions
    
    @IBAction func handleGitHubButtonTap(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: GitHubLink)!)
    }
    
    @IBAction func handleSavedUsers(sender: AnyObject) {
       
    }
    
    @IBAction func handleSearchButtonTap(sender: AnyObject) {
        guard self.searchTextField.text != "" else {
            return
        }
        
        let url = self.urlForUser(userName: self.searchTextField.text!)
        
        networkManager.fetchDataFromURL(url!) { (data, response, error) in
            guard error == nil else {
                Utils.showAlert(title: "Error", messageString: error?.localizedDescription, fromController: self)
                return
            }
            do {
                if let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String : AnyObject] {
                    self.user = CoreDataManager.sharedManager.createNewUser(userProperties: dictionary)
                    
                    self.performSegueToProfileController()
                }
            } catch {
                print("error serializing JSON: \(error)")
            }
        }
    }
    
//MARK: - Private
    
    private func urlForUser(userName user: String) -> NSURL? {
        let url = NSURL(string: GitHubAPIEndpoint)
        return url?.URLByAppendingPathComponent(GitHubAPIUsersPart).URLByAppendingPathComponent(user)
    }

    private func performSegueToProfileController() {
        dispatch_async(dispatch_get_main_queue(), {
            if self.user != nil {
                self.performSegueWithIdentifier(String(UserDetailViewController),sender: self)
            }
        })
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

