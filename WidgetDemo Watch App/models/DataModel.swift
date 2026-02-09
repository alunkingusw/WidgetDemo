//
//  DataModel.swift
//  WidgetDemo
//
//  Created by Alun King on 04/02/2026.
//

import SwiftUI
internal import Combine
import WidgetKit


class DataModel:ObservableObject{
    
    @Published var dataDetails: DataDetails = DataDetails()
    
    init(){
        load()
    }
    
    
    
    func save(){
        do{
            let data = try JSONEncoder().encode(dataDetails)
            let url = URL.documentsDirectory.appending(path:"WidgetDemo")
            try data.write(to:url, options:[.atomic, .completeFileProtection])
            WidgetCenter.shared.reloadTimelines(ofKind: "WidgetDemoWidget")
        } catch {
            print ("Save failed")
        }
    }
    
    func load(){
        do{
            let url = URL.documentsDirectory.appending(path:"WidgetDemo")
            let data = try Data(contentsOf:url)
            dataDetails = try JSONDecoder().decode(DataDetails.self, from: data)
        }catch{
            print ("model not found")
            //return empty model
            dataDetails = DataDetails()
        }
    }
    
}

/*
 This is the struct that we want to store our data.
 For this example, we will store target steps and actual steps.
 */
struct DataDetails:Codable{
    var targetSteps:Int
    var actualSteps:Int
    
    
    init(){
        targetSteps = 10000
        actualSteps = 0
    }
}
