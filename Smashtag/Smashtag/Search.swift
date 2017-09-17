//
//  SearchTerm.swift
//  Smashtag
//
//  Created by Li Yang on 7/20/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

import UIKit
import CoreData

class Search: NSManagedObject
{
    static let maxSearchTerms = 100
    
    class func findOrCreateSearchTerm(at date: NSDate, matching searchTerm: String, in context: NSManagedObjectContext) throws -> Search
    {
        let request: NSFetchRequest<Search> = Search.fetchRequest()
        request.predicate = NSPredicate(format: "searchTerm like[c] %@", searchTerm)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Search.findOrCreateSearch -- database inconsistency")
                matches[0].created = date
                return matches[0]
            }
        } catch {
            throw error
        }
        
        // if already have 100 search terms, delete the earlest one
        request.predicate = nil
        if let count = try? context.count(for: request), count >= maxSearchTerms {
            request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: true)]
            request.fetchLimit = 1
            if let earlestSearch = try? context.fetch(request) {
                context.delete(earlestSearch[0])
            }
        }
        
        let newSearch = Search(context: context)
        newSearch.searchTerm = searchTerm
        newSearch.created = date
        return newSearch
    }
    

}
