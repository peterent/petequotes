//
//  ContentView.swift
//  PetesQuotes
//
//  Created by Peter Ent on 11/17/20.
//

import SwiftUI
import WidgetKit


struct ContentView: View {
    
    @StateObject private var settings = Settings()
    @ObservedObject private var quoteService = QuoteService()
    
    @State private var quotation = "Loading Quotes"
    @State private var author = "Please wait"
    
    var body: some View {
        VStack {
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(self.settings.backgroundColor)
                    .frame(height: 300)
                    .shadow(radius: 20)
                
                QuoteView(quotation: quotation,
                          author: author,
                          textSize: 24,
                          background: Color.clear,
                          textColor: self.settings.textColor)
                    .frame(height: 300)
            }.edgesIgnoringSafeArea(.all)
            
            ColorPicker("Text Color", selection: self.$settings.textColor)
                .padding()
                .onChange(of: settings.textColor, perform: { value in
                    settings.saveSettings()
                })
            
            ColorPicker("Quote Background", selection: self.$settings.backgroundColor)
                .padding()
                .onChange(of: settings.backgroundColor, perform: { value in
                    settings.saveSettings()
                })
            
            Picker("Update Frequency", selection: self.$settings.refreshRate) {
                Text("Refresh Every 10 Minutes").tag(Settings.RefreshRate.every10minutes)
                Text("Refresh Every 5 Minutes").tag(Settings.RefreshRate.every5minutes)
                Text("Refresh Every 2 Minutes").tag(Settings.RefreshRate.every2minutes)
            }
            .onChange(of: settings.refreshRate) { (value) in
                settings.saveSettings()
            }
            
            Spacer()
        }
        .onAppear {
            self.fetchQuote()
        }
    }
    
    func fetchQuote() {
        quoteService.getQuote {
            let quote = quoteService.randomQuote()
            self.quotation = quote?.text ?? "Gibberish"
            self.author = quote?.author ?? "Unknown"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
