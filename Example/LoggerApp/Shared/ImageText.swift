//
//  ImageText.swift
//  LoggerApp
//
//  Created by Katsuhiko Terada on 2021/08/07.
//

import SwiftUI

struct ImageText: View {
    var title: String
    var image: String
    var backgroundColor: Color

    var body: some View {
        VStack {
            HStack {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/ .center/*@END_MENU_TOKEN@*/)
                Text(title)
            }
            .multilineTextAlignment(.center)
            .lineLimit(1)
            .font(.system(size: 18.0, weight: .bold))
            .padding(10)
            .background(backgroundColor)
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

struct ImageText_Previews: PreviewProvider {
    static var previews: some View {
        ImageText(title: "as Error", image: "flame.fill", backgroundColor: .red)
    }
}
