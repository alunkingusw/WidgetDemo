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
    
    @Published var dataDetails: DataDetails
    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ac.uk.southwales.WidgetDemo")?.appendingPathComponent("WidgetDemo.json")
    init(){
        dataDetails = DataDetails()
        load()
    }
    
    
    
    func save(){
        do{
            let data = try JSONEncoder().encode(dataDetails)
            
            if let validURL = url {
                try data.write(to:validURL, options:[.atomic])
            }else{
                print ("Save failed - invalid path")
            }
           
            WidgetCenter.shared.reloadTimelines(ofKind: "WidgetDemo")
        } catch {
            print ("Save failed")
        }
    }
    
    func load(){
        do{
            if let validURL = url {
                let data = try Data(contentsOf:validURL)
                
                dataDetails = try JSONDecoder().decode(DataDetails.self, from: data)
            }else{
                print ("Load failed - invalid path")
                dataDetails = DataDetails()
            }
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
