//
//  ContentView.swift
//  Shared
//
//  Created by Katsuhiko Terada on 2021/07/10.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var logger: PublishedLogger = PublishedLogger.shared
    @State private var fullText: String = ""
    @State private var text: String = "ここに何か書いてボタンを押す"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(fullText)
                .font(.footnote)
                .padding()
            
            Spacer()

            TextEditor(text: $text)
                .frame(height: 44)
                .lineLimit(nil)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )

            HStack {
                Button {
                    log.error(text)
                } label: {
                    HStack {
                        Image(systemName: "flame.fill")
                        Text("as Error")
                    }
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .font(.system(size: 18.0, weight: .bold))
                    .padding(10)
                    .background(Color.red)
                    .foregroundColor(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
            }
        }
        .onReceive(logger.$logMessage) { message in
            fullText = fullText + "\n" + message
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
