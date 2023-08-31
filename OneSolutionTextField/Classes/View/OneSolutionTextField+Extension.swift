//
//  File.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 08/11/22.
//

import SwiftUI
import OneSolutionUtility
import OneSolutionAPI

extension OneSolutionTextField {
    
    func textChanged() {
        if !viewModel.isClearAction {
            self.viewModel.onTextChange?()
            if viewModel.callAPIWhenTextChanged {
                if !text.trimmed.isEmpty {
                    viewModel.showProgress = true
                    callTextFieldAPI()
                }
            }
        }
        self.viewModel.isClearAction = false
    }
    
    func onClearTapped() {
        self.viewModel.isClearAction = true
        self.viewModel.userInput = ""
        self.viewModel.onClearTap?()
    }
}
    
extension OneSolutionTextField {
    
    func callTextFieldAPI() {
        guard let request = viewModel.request, !request.url.isEmpty else { return }
        viewModel.task?.cancel()
        viewModel.task = Task {
            let result = await OneSolutionTextFieldAPI.instance.fetchData(with: request)
            viewModel.showProgress = false
            switch result {
            case .success(let model):
                if let type = viewModel.objectType {
                    viewModel.update(models: model.models(type))
                }
            case .failure(let error):
                switch error {
                case .errorMessage(let message):
                    ToastPresenter.shared.presentToast(text: message)
                default:
                    break
                }
            }
        }
    }
    
}
