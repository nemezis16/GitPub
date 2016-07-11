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
    @NSManaged var localImageURL: String?
    @NSManaged var profileURL: String?
    @NSManaged var followersCount: NSNumber?
    @NSManaged var followingCount: NSNumber?
    @NSManaged var publicRepos: NSNumber?
    @NSManaged var publicGists: NSNumber?
    @NSManaged var repositoriesSaved: NSNumber?
    @NSManaged var repositories: NSSet?
    
    @NSManaged func addRepositoriesObject(repository: Repository)
    @NSManaged func removeRepositoriesObject(repository: Repository)
    @NSManaged func addRepositories(repositories: NSSet)
    @NSManaged func removeRepositories(repositories: NSSet)
    
}
