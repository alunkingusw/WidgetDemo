//
//  WidgetDemoWidget.swift
//  WidgetDemoWidget
//
//  Created by Alun King on 05/02/2026.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), targetSteps: 10000, actualSteps:4500)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        //get the current step data - load the data
        let stepData:DataModel = DataModel()
        stepData.load()
        //use this data in the view snapshot
        let entry = SimpleEntry(date: Date(), targetSteps:stepData.dataDetails.targetSteps, actualSteps: stepData.dataDetails.actualSteps)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        //get the current data
        let stepData:DataModel = DataModel()
        stepData.load()
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, targetSteps:stepData.dataDetails.targetSteps, actualSteps: stepData.dataDetails.actualSteps)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

/*
 This is where we define the data that we want to use in our widgets
 */
struct SimpleEntry: TimelineEntry {
    var date: Date
    
    //we define the data that we want to display in our widget here
    let targetSteps: Int
    let actualSteps: Int
}

struct WidgetDemoWidgetEntryView : View {
    var entry: Provider.Entry
    //get the widget display type
    @Environment(\.widgetFamily) var family
    var body: some View {
        var progress: Double {
            Double(entry.actualSteps) / Double(entry.targetSteps)
        }
        //calculate progress based on time
        //use entry.date to work out time of day.
        switch family{
        case .accessoryCircular, .accessoryCorner:
            VStack{
                //just a circular progress bar
                ProgressView(value: progress)
                            .progressViewStyle(.circular)
                            .tint(entry.actualSteps >= entry.targetSteps ? .green : .blue)
            }
        default:
            VStack {
                    Text("Progress: \((progress*100).formatted(.number.precision(.fractionLength(0))))%")
            }
        }
        
    }
}

struct WidgetDemoWidget: Widget {
    let kind: String = "WidgetDemoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                WidgetDemoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                WidgetDemoWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("StepCount")
        .description("This is an example widget.")
        
        //this is where we define the types of widget you are compatible with
        .supportedFamilies([.accessoryCircular,
                                    .accessoryRectangular, .accessoryInline])
    }
}

#Preview(as: .accessoryRectangular) {
    WidgetDemoWidget()
} timeline: {
    SimpleEntry(date: .now, targetSteps:10000, actualSteps:5000)
    SimpleEntry(date: .now, targetSteps:1000, actualSteps:1000)
}
