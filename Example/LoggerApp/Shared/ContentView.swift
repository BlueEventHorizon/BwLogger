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
    @State private var text: String = ""
    @State var placeHolder: String = "ここに何か書いてボタンを押す"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(fullText)
                .font(.footnote)
                .padding()
            
            Spacer()

            TextFeild(text: $text, placeHolder: $placeHolder)

            VStack {
                HStack(spacing: 20) {
                    Button {
                        log.error(text)
                    } label: {
                        ImageText(title: "as Error", image: "flame.fill", backgroundColor: .red)
                    }
                    
                    Button {
                        log.debug(text)
                    } label: {
                        ImageText(title: "as Debug", image: "ant", backgroundColor: .orange)
                    }
                }
                .padding(5)
                
                HStack(spacing: 20) {
                    Button {
                        log.warning(text)
                    } label: {
                        ImageText(title: "as Warnig", image: "exclamationmark.triangle", backgroundColor: .yellow)
                    }
                    
                    Button {
                        log.info(text)
                    } label: {
                        ImageText(title: "as Info", image: "info.circle", backgroundColor: .blue)
                    }
                }
                .padding(5)
            }

        }
        .onAppear {
            // TextEditorのplaceholder表示のため
            UITextView.appearance().backgroundColor = .clear
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
