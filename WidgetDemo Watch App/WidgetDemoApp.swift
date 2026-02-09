//
//  WidgetDemoApp.swift
//  WidgetDemo Watch App
//
//  Created by Alun King on 04/02/2026.
//

import SwiftUI

@main
struct WidgetDemo_Watch_AppApp: App {
    @StateObject var dataModel:DataModel = DataModel()
    var body: some Scene {
        WindowGroup {
            
            ContentView(model:dataModel)
        }
    }
}
