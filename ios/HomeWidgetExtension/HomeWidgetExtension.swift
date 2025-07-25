import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), title: "Home Widget", description: "Your Flutter app widget")
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, title: "Home Widget", description: "Your Flutter app widget")
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Get data from UserDefaults (shared with Flutter app)
        let userDefaults = UserDefaults(suiteName: "group.com.example.homewidget")
        let title = userDefaults?.string(forKey: "widget_title") ?? "Home Widget"
        let description = userDefaults?.string(forKey: "widget_description") ?? "Your Flutter app widget"

        // Generate a timeline consisting of entries every hour for the next 5 hours.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, title: title, description: description)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let title: String
    let description: String
}

struct HomeWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Spacer()
            
            Text(entry.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(3)
            
            Spacer()
            
            HStack {
                Spacer()
                Text(entry.date, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(entry.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
                
                Spacer()
                
                Text("Updated: \(entry.date, style: .time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "house.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
                
                Text("Flutter")
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct LargeWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "house.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
            }
            
            Text(entry.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(6)
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Status")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Active")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Last Updated")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(entry.date, style: .time)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
            .padding(.top)
        }
        .padding()
        .background(Color(.systemBackground))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct HomeWidgetExtension: Widget {
    let kind: String = "HomeWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            HomeWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Home Widget")
        .description("Display information from your Flutter app.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview(as: .systemSmall) {
    HomeWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, configuration: ConfigurationIntent(), title: "Preview Title", description: "Preview description for the home widget")
}
