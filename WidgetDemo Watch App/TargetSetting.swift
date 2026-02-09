//
//  ContentView.swift
//  WidgetDemo Watch App
//
//  Created by Alun King on 04/02/2026.
//

import SwiftUI

struct TargetSetting: View {
    @ObservedObject var model:DataModel
    var body: some View {
        VStack {
            /*
             Here we load the datamodel and set the targets using forms
             */
            Text("Target Steps")
            HStack{
                Button("-"){
                    model.dataDetails.targetSteps -= 500
                    model.save()
                }
                Text(String(model.dataDetails.targetSteps)).font(Font.title2)
                Button("+"){
                    model.dataDetails.targetSteps += 500
                    model.save()
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    TargetSetting(model:DataModel())
}
