//
//  EntryController.swift
//  Journal+NSFRC
//
//  Created by Karl Pfister on 5/9/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let sharedInstance = EntryController()
    var fetchedResultController: NSFetchedResultsController<Entry>
    
    // NSFRC:
    init () {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        let resultsController: NSFetchedResultsController<Entry> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultController = resultsController
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("There was an error performing the fetch \(#function) \(error.localizedDescription)")
        }
    }
    
//    /// Entries is a computed Property. its getting its value from the results of a NSFetchRequest. The <Model> defines the generic type. This ensures that our entries array can ONLY hold Entry Objects
//    var entries: [Entry] {
//        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
//        return (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
//    }
    
    //CRUD
    /// We dfine a createEntry method that takes in two string: Title, and body. Then we are using the convienience init we extended the Entry Class with and pass in those strings. This creates our entry onjects with all required data
    func createEntry(withTitle: String, withBody: String) {
        let _ = Entry(title: withTitle, body: withBody)
        
        saveToPersistentStore()
        
    }
    
    func updateEntry(entry: Entry, newTitle: String, newBody: String) {
        entry.title = newTitle
        entry.body = newBody
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        entry.managedObjectContext?.delete(entry)
        saveToPersistentStore()
    }
    
    /// We are attempting to save all our Entry Data to our CoreDataStack(s) Persistent Store
    func saveToPersistentStore() {
        do {
             try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object. Items not saved!! \(#function) : \(error.localizedDescription)")
        }
    }
}
