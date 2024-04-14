//
//  BorderLine.swift
//  OneSolutionTextField
//
//  Created by Sreekanth Reddy Tadi on 27/03/24.
//

import SwiftUI
import OneSolutionUtility

public struct BorderLine: View {
    var color: Color
    
    public init(color: Color = Color.app_green_border) {
        self.color = color
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Divider()
                .frame(height: 1)
                .background(color)
                .padding(.horizontal, textFieldCornerRadius/2)
                .cornerRadius(0.5)
        }
    }
}

#Preview {
    BorderLine()
}
