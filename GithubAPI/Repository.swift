//
//  Repository.swift
//  GitPub
//
//  Created by Roman Osadchuk on 7/10/16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import Foundation
import CoreData


class Repository: NSManagedObject {

    @NSManaged var title: String?
    @NSManaged var language: String?
    @NSManaged var forksCount: NSNumber?
    @NSManaged var starsCount: NSNumber?
    @NSManaged var owner: User?
    
}
