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
                if let quote = try await APIService.shared.fetchQuote(forMood: selectedMood.rawValue)?.first {
                    return SimpleEntry(date: Date(), mood: selectedMood.rawValue, quote: quote.quote ?? "No quote available", author: quote.author)
                }
            } catch {
                print("Error fetching quote: \(error)")
            }
        return SimpleEntry(date: Date(), mood: selectedMood.rawValue, quote: "Error fetching quote", author: "Unknown")
        }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let mood: String
    let quote: String
    let author: String?
}

struct MoodQuoteWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily

    var body: some View {
        VStack {
            Text("Mood: \(entry.mood.capitalized)")
                .font(quoteFontSize)
                .bold()
                .padding(.bottom, 4)
            
            Text("\(entry.quote)")
                .font(quoteFontSize)
                .italic()
            
            if let author = entry.author {
                Text("- \(author)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .font(.body)
    }
    
    var quoteFontSize: Font {
        switch widgetFamily {
        case .systemSmall:
            return .caption2
        case .systemMedium:
            return .caption
        case .systemLarge:
            return .body
        default:
            return .body
        }
    }
}

struct QuoteWidget: Widget {
    let kind: String = "MoodQuoteWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MoodQuoteWidgetEntryView(entry: entry)
                .containerBackground(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing).opacity(0.7), for: .widget)
        }
        .configurationDisplayName("Mood Quote Widget")
        .description("Select a mood and receive a quote to match it.")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
}

#Preview(as: .systemSmall) {
    QuoteWidget()
} timeline: {
    SimpleEntry(date: .now, mood: "happiness", quote: "Keep smiling!", author: "Author")
    SimpleEntry(date: .now, mood: "inspiration", quote: "Dream big!", author: "Author")
}
