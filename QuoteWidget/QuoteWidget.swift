import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), mood: "happiness", quote: "Stay happy!", author: "Unknown")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        await getEntry(for: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entry = await getEntry(for: configuration)
        return Timeline(entries: [entry], policy: .atEnd)
    }
    
    private func getEntry(for configuration: ConfigurationAppIntent) async -> SimpleEntry {
            let selectedMood = configuration.mood
            do {
                if let quote = try await APIService.shared.fetchQuote(forMood: selectedMood)?.first {
                    return SimpleEntry(date: Date(), mood: selectedMood, quote: quote.quote ?? "No quote available", author: quote.author)
                }
            } catch {
                print("Error fetching quote: \(error)")
            }
            return SimpleEntry(date: Date(), mood: selectedMood, quote: "Error fetching quote", author: "Unknown")
        }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let mood: String
    let quote: String
    let author: String?
}

struct MoodQuoteWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Mood: \(entry.mood.capitalized)")
                .font(.headline)
                .padding(.bottom, 4)
            
            Text("\"\(entry.quote)\"")
                .font(.body)
                .italic()
            
            if let author = entry.author {
                Text("- \(author)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.2))
    }
}

struct QuoteWidget: Widget {
    let kind: String = "MoodQuoteWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MoodQuoteWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Mood Quote Widget")
        .description("Select a mood and receive a quote to match it.")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    QuoteWidget()
} timeline: {
    SimpleEntry(date: .now, mood: "happiness", quote: "Keep smiling!", author: "Author")
    SimpleEntry(date: .now, mood: "inspiration", quote: "Dream big!", author: "Author")
}
