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

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 10) {
                    Button {
                        log.fault(text)
                    } label: {
                        ImageText(title: "fault", image: "flame.fill", backgroundColor: .red)
                    }

                    Button {
                        log.error(text)
                    } label: {
                        ImageText(title: "error", image: "flame.fill", backgroundColor: .red)
                    }

                    Button {
                        log.debug(text)
                    } label: {
                        ImageText(title: "debug", image: "ant", backgroundColor: .orange)
                    }
                }
                .padding(5)

                HStack(spacing: 10) {
                    Button {
                        log.warning(text)
                    } label: {
                        ImageText(title: "warning", image: "exclamationmark.triangle", backgroundColor: .yellow)
                    }

                    Button {
                        log.info(text)
                    } label: {
                        ImageText(title: "info", image: "info.circle", backgroundColor: .blue)
                    }
                }
                .padding(5)

                HStack(spacing: 10) {
                    Button {
                        log.entered(self)
                    } label: {
                        ImageText(title: "entered", image: "arrow.right.to.line.alt", backgroundColor: .green)
                    }

                    Button {
                        log.deinit()
                    } label: {
                        ImageText(title: "deinit", image: "arrow.down.to.line.alt", backgroundColor: .black)
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
            fullText += "\n" + message
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
