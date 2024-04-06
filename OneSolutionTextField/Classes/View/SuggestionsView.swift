//
//  SuggestionView.swift
//  OneSolutionTextField
//
//  Created by Sreekanth Reddy Tadi on 19/03/24.
//

import SwiftUI
import OneSolutionAPI
import OneSolutionUtility

struct SuggestionsView: View {
    let models: [OneSolutionModel]?
    let showProgress: Bool
    let onSelection: OnSuggestionSelection?
    
    var body: some View {
        if let models = models {
            ScrollView {
                VStack {
                    ForEach(models, id: \.uuid) { model in
                        SuggestionView(
                            model: model,
                            onSelection: onSelection
                        )
                    }
                }
            }
        } else if showProgress {
            if #available(iOS 14.0, *) {
                ProgressView()
            }
        }
    }
}

struct SuggestionView: View {
    let model: OneSolutionModel
    let onSelection: OnSuggestionSelection?
    
    var body: some View {
        Button {
            onSelection?(model)
        } label: {
            HStack {
                Text(model.displayName)
                    .font(.system(size: appFont12))
                    .foregroundColor(.app_black)
                    .padding(.leading, 10)
                Spacer()
            }
        }
        .frame(minHeight: 40)
        .background(Color.white)
        .padding(.horizontal, 10)
    }
}
