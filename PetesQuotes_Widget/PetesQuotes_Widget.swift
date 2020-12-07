//
//  PetesQuotes_Widget.swift
//  PetesQuotes_Widget
//
//  Created by Peter Ent on 11/18/20.
//

import WidgetKit
import SwiftUI

/**
 * Provides a timeline when requested. This really sets up a single quotation request and then tells
 * the system to request a fresh timeline after the Settings.refreshRate expires.
 */
struct QuoteProvider: TimelineProvider {
    
    let settings: Settings
    let quoteService: QuoteService
    
    func placeholder(in context: Context) -> SimpleEntry {
        settings.loadSettings()
        return SimpleEntry(date: Date(), quote: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        settings.loadSettings()
        let entry = SimpleEntry(date: Date(), quote: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
                
        // refresh the settings before generating a new timeline so the display syncs with the data.
        settings.loadSettings()
        
        // ask the QuoteService for a quote. this will return immediately because its cache has one or
        // it will make a remote call, fill its cache, then return
        quoteService.getQuote {
            let currentDate = Date()
            entries.append(SimpleEntry(date: currentDate, quote: quoteService.randomQuote()))
            
            // we want a new timeline once the refreshRate expires (eg, 10 minutes from now).
            let nextTime = Calendar.current.date(byAdding: .minute, value: settings.refreshRate.rawValue, to: currentDate)!
            
            let timeline = Timeline(entries: entries, policy: .after(nextTime))
            completion(timeline)
        }
    }
}

/**
 * This is the model that holds the data to be displayed in the widget.
 */
struct SimpleEntry: TimelineEntry {
    let date: Date
    var quote: Quote?
    var counter: Int = 0
}

/**
 * This is the actual widget view which uses QuoteView to display it.
 */
struct PetesQuotes_WidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: SimpleEntry
    var backgroundColor: Color
    var textColor: Color
    
    // use the widget's size to determine how large the
    // text should be
    func textSize() -> CGFloat {
        switch family {
        case .systemSmall:
            return 10
        case .systemLarge:
            return 25
        default:
            return 17
        }
    }
    
    var body: some View {
        QuoteView(
            quotation: entry.quote?.text ?? "Computers are hard to use and unreliable.",
            author: entry.quote?.author ?? "Unknown",
            textSize: textSize(),
            background: backgroundColor,
            textColor: textColor)
    }
}

@main
struct PetesQuotes_Widget: Widget {
    let kind: String = "com.keaura.petesquotes.widget"
    
    @ObservedObject var quoteService = QuoteService()
    @ObservedObject var settings = Settings()
    
    init() {
        print("QuoteWidget: initialing")
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuoteProvider(settings: settings, quoteService: quoteService)) { entry in
            PetesQuotes_WidgetEntryView(entry: entry,
                                        backgroundColor: settings.backgroundColor,
                                        textColor: settings.textColor)
        }
        .configurationDisplayName("Pete's Quotes")
        .description("Occaisonally Inspring Quotations")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct PetesQuotes_Widget_Previews: PreviewProvider {
    static var previews: some View {
        PetesQuotes_WidgetEntryView(entry: SimpleEntry(date: Date(), quote: nil),
                                    backgroundColor: Color("QuoteBackground"),
                                    textColor: Color("DefaultTextColor"))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
