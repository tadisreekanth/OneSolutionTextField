//
//  BorderLine.swift
//  OneSolutionTextField
//
//  Created by Sreekanth Reddy Tadi on 27/03/24.
//

import SwiftUI
import OneSolutionUtility

struct BorderLine: View {
    var body: some View {
        VStack {
            Spacer()
            Divider()
                .frame(height: 1)
                .background(Color.app_green_border)
                .padding(.horizontal, textFieldCornerRadius/2)
                .cornerRadius(0.5)
        }
    }
}

#Preview {
    BorderLine()
}
