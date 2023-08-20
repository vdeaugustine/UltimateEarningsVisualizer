//
//  SearchBar.swift
//  UltimateMoneyVisualizer
//
//  Created by Vincent DeAugustine on 8/20/23.
//

import SwiftUI

// MARK: - SearchBar

struct SearchBarX: View {
    @Binding var text: String
    @FocusState var isFocused: Bool
    var body: some View {
        VStack {
            ZStack {
                // background
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.searchGray)
                    .frame(height: 36)

                HStack(spacing: 6) {
                    Spacer()
                        .frame(width: 0)

                    // 􀊫
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)

                    // TextField
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty, color: .gray) {
                            Text("Search")
                        }
                        .focused($isFocused)

                    // 􀁑
                    if !text.isEmpty {
                        Button {
                            text.removeAll()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 6)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

extension View {
    func placeholder<Content: View>(when shouldShow: Bool,
                                    alignment: Alignment = .leading,
                                    color: Color,
                                    @ViewBuilder placeholder: () -> Content)
        -> some View {
        ZStack(alignment: alignment) {
            placeholder()
                .opacity(shouldShow ? 1 : 0)
                .foregroundColor(color)
            self
        }
    }
}

struct SearchBarX_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarX(text: .constant(""))
    }
}
