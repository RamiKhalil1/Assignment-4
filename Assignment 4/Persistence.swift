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
    
    func saveMoodEntry(date: Date, mood: String, quoteText: String?, quoteAuthor: String?, photo: UIImage?, journalText: String?) {
        let viewContext = container.viewContext
        let moodEntry = Mood(context: viewContext)
        moodEntry.date = date
        moodEntry.mood = mood
        moodEntry.quoteText = quoteText
        moodEntry.quoteAuthor = quoteAuthor
        moodEntry.journalText = journalText
        
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
    
    func updateMoodEntry(entry: Mood, mood: String, quoteText: String?, quoteAuthor: String?, photo: UIImage?, journalText: String?) {
        entry.mood = mood
        entry.quoteText = quoteText
        entry.quoteAuthor = quoteAuthor
        entry.journalText = journalText
        if let photo = photo, let imageData = photo.jpegData(compressionQuality: 1.0) {
            entry.photo = imageData
        }
        
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to update mood entry: \(error.localizedDescription)")
        }
    }
    
    func deleteMoodEntry(_ entry: Mood) {
        let viewContext = container.viewContext
        viewContext.delete(entry)
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to delete mood entry: \(error.localizedDescription)")
        }
    }
}
