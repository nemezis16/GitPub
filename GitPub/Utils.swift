//
//  Utils.swift
//  GitPub
//
//  Created by Roman Osadchuk on 10.07.16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    static var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    class func showAlert(title title: String?, messageString message: String?, fromController controller: UIViewController!) {
        dispatch_async(dispatch_get_main_queue(), {
            
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .Default) { (action: UIAlertAction) -> Void in }
            
            alert.addAction(cancelAction)
            
            controller.presentViewController(alert,
                                  animated: true,
                                  completion: nil)
        })
    }
    
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}
