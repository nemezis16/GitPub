//
//  User.swift
//  GitPub
//
//  Created by Roman Osadchuk on 7/10/16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

    @NSManaged var publicReposURL: String?
    @NSManaged var imageURL: String?
    @NSManaged var company: String?
    @NSManaged var email: String?
    @NSManaged var userName: String?
    @NSManaged var followersCount: NSNumber?
    @NSManaged var followingCount: NSNumber?
    @NSManaged var localImageURL: String?
    @NSManaged var publicRepos: NSNumber?
    @NSManaged var publicGists: NSNumber?
    @NSManaged var repositories: NSSet?
    
    @NSManaged func addRepositoriesObject(course: Repository)
    @NSManaged func removeRepositoriesObject(course: Repository)
    @NSManaged func addRepositories(courses: NSSet)
    @NSManaged func removeRepositories(courses: NSSet)
    
}
