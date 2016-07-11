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
    @IBOutlet weak var bottomScrollViewConstaint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var user: User?
    let networkManager = NetworkManager.sharedManager
    var controllerPushing = false

//MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerForKeyboardNotifications()
        self.user = nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
    
    @IBAction func handleSearchButtonTap(sender: AnyObject) {
        guard self.searchTextField.text != "" && controllerPushing == false else {
            return
        }
        
        let url = self.urlForUser(userName: self.searchTextField.text!)
        
        controllerPushing = true
        networkManager.fetchDataFromURL(url!) { (data, response, error) in
            guard error == nil else {
                Utils.showAlert(title: "Error", messageString: error?.localizedDescription, fromController: self)
                return
            }
            do {
                if let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String : AnyObject] {
                    self.user = CoreDataManager.sharedManager.createNewUser(userProperties: dictionary)
                    
                    self.controllerPushing = false
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
    
    func keyboardWillShow(notification: NSNotification) {
        if let info: Dictionary? = notification.userInfo {
            if let value = info?[UIKeyboardFrameEndUserInfoKey] {
                let keyboardRect = value.CGRectValue()
                bottomScrollViewConstaint.constant = CGRectGetHeight(keyboardRect)
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(keyboardRect), 0)
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        bottomScrollViewConstaint.constant = 0
        scrollView.contentInset = UIEdgeInsetsZero
    }
    
    private func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}

