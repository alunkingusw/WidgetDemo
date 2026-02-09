//
//  ContentView.swift
//  WidgetDemo Watch App
//
//  Created by Alun King on 04/02/2026.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model:DataModel
    @State var selectedPage:Int = 0
    var hasExceededTarget: Bool {
        model.dataDetails.actualSteps >= model.dataDetails.targetSteps
    }
    var body: some View {
        TabView(selection:$selectedPage){
            VStack{
                Text("Current Steps")
                HStack {
                    /*
                     Let's view the progress here, and add a tab view to set the targets below
                     */
                    Stepper(
                        value: $model.dataDetails.actualSteps,
                        step: 50
                    ) {
                        Text("\(model.dataDetails.actualSteps)")
                            .font(.title2)
                            .monospacedDigit()
                    }
                    .onChange(of: model.dataDetails.actualSteps) {
                        model.save()
                    }
                }
            //let's show progress here as a progress bar.
                ProgressView(value: (Float(model.dataDetails.actualSteps) / Float(model.dataDetails.targetSteps))).tint(hasExceededTarget ? .green : .blue)
            }
            VStack{
                TargetSetting(model:model)
            }
        }
        .padding().tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView(model:DataModel())
}
