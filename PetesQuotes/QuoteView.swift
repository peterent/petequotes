//
//  QuoteView.swift
//  PetesQuotes
//
//  Created by Peter Ent on 11/18/20.
//

import SwiftUI

/**
 * This is the view presented in the app and the widget. Its given all it needs
 * to display the quote, colors, etc.
 */
struct QuoteView: View {
    let quotation: String
    let author: String
    let textSize: CGFloat
    let background: Color
    let textColor: Color
        
    var body: some View {
        GeometryReader { reader in
        ZStack(alignment: .center) {
            
            self.background
                .edgesIgnoringSafeArea(.all)
            
            Image("OpenQuotes")
                .opacity(0.10)
                .offset(x: 0 - (reader.size.width * 0.5 - 50),
                        y: 0 - (reader.size.height * 0.5 - 50))
            
            Image("CloseQuotes")
                .opacity(0.10)
                .offset(x: reader.size.width * 0.5 - 50,
                        y: reader.size.height * 0.5 - 50)
            
            VStack(alignment: .leading) {
                Group {
                    Text("      ")
                        .fontWeight(.regular) +
                    Text(quotation)
                        .fontWeight(.regular)
                        .font(.system(size: textSize))
                        .foregroundColor(textColor)
                }
                .padding(.bottom, 10)
                
                HStack {
                    Spacer()
                    Text("-"+author)
                        .fontWeight(.medium)
                        .font(.system(size: textSize))
                        .foregroundColor(textColor)
                }
            }.padding()
        } //
        }
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(
            quotation: "Wherever you go, there you are.",
            author: "Buckaroo Banzi",
            textSize: 10,
            background: Color.blue,
            textColor: Color.white)
            .frame(width: 150, height: 180)
    }
}
