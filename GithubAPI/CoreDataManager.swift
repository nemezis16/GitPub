//
//  CoreDataManager.swift
//  GitPub
//
//  Created by Roman Osadchuk on 7/10/16.
//  Copyright © 2016 Roman Osadchuk. All rights reserved.
//

import Foundation
import CoreData

struct userPropertyKeys {
    static let name = "login"
    static let publicRepos = "public_repos"
    static let publicGists = "public_gists"
    static let followers = "followers"
    static let following = "following"
    static let email = "email"
    static let company = "company"
    static let repositoriesList = "repositoriesList"
    static let imageURL = "avatar_url"
    static let publicReposURL = "repos_url"
}

struct repositoryPropertyKeys {
    static let name = "name"
    static let language = "language"
    static let forksCount = "forks_count"
    static let stargazersCount = "stargazers_count"
}

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("GithubAPI", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = Utils.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    func createNewUser(userProperties properties: [String: AnyObject]) -> User? {
        guard let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: managedObjectContext) as? User else {
            return nil
        }
        user.publicReposURL = properties[userPropertyKeys.publicReposURL] as? String
        user.imageURL = properties[userPropertyKeys.imageURL] as? String
        user.company = properties[userPropertyKeys.company] as? String
        user.userName = properties[userPropertyKeys.name] as? String
        user.email = properties[userPropertyKeys.email] as? String
        user.followersCount = properties[userPropertyKeys.followers] as? NSNumber
        user.followingCount = properties[userPropertyKeys.following] as? NSNumber
        user.publicGists = properties[userPropertyKeys.publicGists] as? NSNumber
        user.publicRepos = properties[userPropertyKeys.publicRepos] as? NSNumber
        
        return user
    }
    
    func createRepository(repositoryProperties properties: [String: AnyObject]) -> Repository? {
        guard let repository = NSEntityDescription.insertNewObjectForEntityForName("Repository", inManagedObjectContext: managedObjectContext) as? Repository else {
            return nil
        }
        repository.language = properties[repositoryPropertyKeys.language] as? String
        repository.title = properties[repositoryPropertyKeys.name] as? String
        repository.forksCount = properties[repositoryPropertyKeys.forksCount] as? NSNumber
        repository.starsCount = properties[repositoryPropertyKeys.stargazersCount] as? NSNumber
        return repository
    }
}




