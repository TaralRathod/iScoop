//
//  CoreDataManager.swift
//  iScoop
//
//  Created by Taral Rathod on 17/02/22.
//

import Foundation
import CoreData
//import UIKit

class CoreDataManager {
    static let sharedManager = CoreDataManager()
    
    private init() {}
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "iScoop")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Entity Related Operations
    func fetchEntity<T: NSManagedObject>(_ entity: T.Type,
                                           predicate: NSPredicate? = nil,
                                           sortDescriptor: [NSSortDescriptor]? = nil,
                                     context: NSManagedObjectContext = CoreDataManager.sharedManager.persistentContainer.viewContext) -> [NSManagedObject]? {

        let entityName = NSStringFromClass(T.self)
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)

        if predicate != nil {
            fetchRequest.predicate = predicate!
        }

        if sortDescriptor != nil {
            fetchRequest.sortDescriptors = sortDescriptor!
        }

        fetchRequest.returnsObjectsAsFaults = false

        if entity == TopHeadlines.self {
            fetchRequest.relationshipKeyPathsForPrefetching = ["articles"]
        }

        do {
            var resultsArray: [NSManagedObject] = []
            let searchResult = try context.fetch(fetchRequest)
            if searchResult.count > 0 {
                // returns mutable copy of result array
                resultsArray.append(contentsOf: searchResult)
                return resultsArray

            } else {
                // returns nil in case no object found
                return nil
            }

        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchEntity(entityName: String) -> [NSManagedObject]? {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            return try context.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            return nil
        }
    }
    
    func insertTopHeadlines(headlines: TopHeadline) -> TopHeadlines? {
        var topHeadlines: TopHeadlines! = nil
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.topHeadlinesEntity, in: context) else {return topHeadlines}
        guard let result = fetchEntity(entityName: Constants.topHeadlinesEntity) else {return topHeadlines}
        if(result.count == 0) {
            topHeadlines = NSManagedObject(entity: entity, insertInto: context) as? TopHeadlines
        } else {
            topHeadlines = result.first as? TopHeadlines
        }

        guard let artlicles = headlines.articles else {return topHeadlines}
        topHeadlines = saveArticles(articlesList: artlicles, headlines: topHeadlines)
        topHeadlines.status = headlines.status
        topHeadlines.totalResults = Int16(headlines.totalResults ?? 0)
        do {
            try context.save()
            return topHeadlines
        } catch {
            debugPrint("TopHeadlines failed")
            return topHeadlines
        }
    }
    
    func saveArticles(articlesList: [Article], headlines: TopHeadlines) -> TopHeadlines {
        var article: Articles! = nil
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.articlesEntity, in: context) else {return headlines}
        guard let result = fetchEntity(entityName: Constants.articlesEntity) else {return headlines}
        for articl in articlesList {
            if(result.count == 0) {
                article = NSManagedObject(entity: entity, insertInto: context) as? Articles
            } else {
                article = result.first as? Articles
            }

            article.author = articl.author
            article.content = articl.content
            article.publishedAt = articl.publishedAt
            article.urlToImage = articl.urlToImage
            article.url = articl.url
            article.title = articl.title
            article.descriptions = articl.description
            headlines.addToArticles(article)
        }
        do {
            try context.save()
            return headlines
        } catch {
            debugPrint("Articles failed")
            return headlines
        }
    }
    
    func saveSources(source: Sources, article: Articles) -> Articles {
        var sources: Sources! = nil
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.sourceEntity, in: context) else {return article}
        guard let result = fetchEntity(entityName: Constants.articlesEntity) else {return article}
        if(result.count == 0) {
            sources = NSManagedObject(entity: entity, insertInto: context) as? Sources
        } else {
            sources = result.first as? Sources
        }

        sources.id = source.id
        sources.name = source.name
        article.sources = sources
        do {
            try context.save()
            return article
        } catch {
            debugPrint("Sources failed")
            return article
        }
    }
}
