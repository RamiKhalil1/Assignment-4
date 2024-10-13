//
//  Persistence.swift
//  Assignment 4
//
//  Created by Rami Khalil on 9/10/2024.
//

import CoreData
import UIKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Assignment_4")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveMoodEntry(date: Date, mood: String, quoteText: String?, quoteAuthor: String?, photo: UIImage?) {
        let viewContext = container.viewContext
        let moodEntry = Mood(context: viewContext)
        moodEntry.date = date
        moodEntry.mood = mood
        moodEntry.quoteText = quoteText
        moodEntry.quoteAuthor = quoteAuthor
        
        if let photo = photo, let imageData = photo.jpegData(compressionQuality: 1.0) {
            moodEntry.photo = imageData
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save mood entry: \(error.localizedDescription)")
        }
    }
    
    func fetchMoodEntries() -> [Mood] {
        let viewContext = container.viewContext
        let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch mood entries: \(error.localizedDescription)")
            return []
        }
    }
}
