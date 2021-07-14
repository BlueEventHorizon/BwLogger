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
                    // バックグラウンドのコーナー
                    .cornerRadius(10)
                    .overlay(
                        // ボーダーライン
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                }
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
