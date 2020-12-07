//
//  Settings.swift
//  PetesQuotes
//
//  Created by Peter Ent on 11/18/20.
//

import SwiftUI
import WidgetKit

/**
 * The Settings are what's remembered between app invocations:
 *  - backgroundColor of the quotation
 *  - textColor of the quotation and the author
 *  - refreshReate - how often to bring up a new quotation
 *
 *  Note that since the Widget is an app extension it cannot read the app's
 *  local storage. Instead, the app and the widget using a named storage
 *  group - a suiteName.
 */
class Settings: NSObject, ObservableObject {
    
    enum RefreshRate: Int {
        case every10minutes = 10
        case every5minutes = 5
        case every2minutes = 2
    }
    
    @Published var backgroundColor = Color("QuoteBackground")
    @Published var textColor = Color("DefaultTextColor")
    @Published var refreshRate: RefreshRate = .every5minutes
    
    let suiteName = "group.PetesQuotes"
        
    override init() {
        super.init()
        loadSettings()
    }
    
    func loadSettings() {
        if let myDefaults = UserDefaults(suiteName: suiteName) {
            if let colorValues = myDefaults.array(forKey: "backgroundColor") as? [Double] {
                let color = Color(red: colorValues[0], green: colorValues[1], blue: colorValues[2], opacity: colorValues[3])
                DispatchQueue.main.async {
                    self.backgroundColor = color
                }
            }
            if let colorValues = myDefaults.array(forKey: "textColor") as? [Double] {
                let color = Color(red: colorValues[0], green: colorValues[1], blue: colorValues[2], opacity: colorValues[3])
                DispatchQueue.main.async {
                    self.textColor = color
                }
            }
            let rate = myDefaults.integer(forKey: "refreshRate")
            DispatchQueue.main.async {
                self.refreshRate = RefreshRate(rawValue: rate) ?? .every2minutes
            }
        }
    }
    
    func saveSettings() {
        if let myDefaults = UserDefaults(suiteName: suiteName) {
            if let components = backgroundColor.cgColor?.components?.map({ Double($0) }) {
                myDefaults.setValue(components, forKey: "backgroundColor")
            }
            if let components = textColor.cgColor?.components?.map({ Double($0) }) {
                myDefaults.setValue(components, forKey: "textColor")
            }
            
            myDefaults.setValue(refreshRate.rawValue, forKey: "refreshRate")
            
            WidgetCenter.shared.reloadTimelines(ofKind: "com.keaura.petesquotes.widget")
        }
    }
}
