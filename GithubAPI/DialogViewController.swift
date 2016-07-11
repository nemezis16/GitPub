//
//  DialogViewController.swift
//  GitPub
//
//  Created by Roman Osadchuk on 11.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class DialogViewController: UIViewController {

    @IBOutlet weak var dialogView: UIView!
    
    var tailLayer = CAShapeLayer()
    var user: User?
    
//MARK: - LifeCycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dialogView.layoutIfNeeded()
        configureDialogView()
    }

//MARK: - Actions
    
    @IBAction func handleOpenBrowserTap(sender: AnyObject) {
        if let profileURL = user?.profileURL {
            UIApplication.sharedApplication().openURL(NSURL(string:profileURL)!)
        }
    }
    
    @IBAction func handleSaveTap(sender: AnyObject) {
        CoreDataManager.sharedManager.saveContext()
    }
    
    @IBAction func handleShareTap(sender: AnyObject) {
        if let profileURL = user?.profileURL {
            let objectsToShare = [profileURL]
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = sender as? UIView
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(view)
            if CGRectContainsPoint(dialogView.frame, position) {
                return
            } else {
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
//MARK: - Private
    
    private func configureDialogView() {
        tailLayer.frame = dialogView.bounds
        tailLayer.strokeColor = UIColor.blackColor().CGColor
        tailLayer.fillColor = UIColor.whiteColor().CGColor
        tailLayer.path = self.tailPath()
        
        dialogView.layer.mask = tailLayer
        dialogView.layer.insertSublayer(tailLayer, atIndex: 0)
    }
    
    private func tailPath() -> CGMutablePath {
        let width = dialogView.layer.frame.size.width
        let height = dialogView.layer.frame.size.height
        let bezierPath = CGPathCreateMutable()
        
        CGPathMoveToPoint(bezierPath, nil, 0, 0)
        CGPathAddLineToPoint(bezierPath, nil, width / 2, 0)
        CGPathAddLineToPoint(bezierPath, nil, width / 2 + 50, -20)
        CGPathAddLineToPoint(bezierPath, nil, width / 2 + 40, 0)
        CGPathAddLineToPoint(bezierPath, nil, width, 0)
        CGPathAddLineToPoint(bezierPath, nil, width, height)
        CGPathAddLineToPoint(bezierPath, nil, 0, height)
        CGPathCloseSubpath(bezierPath)
        
        return bezierPath
    }

}