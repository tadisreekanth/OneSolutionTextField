//
//  OneSolutionTexFieldViewModel.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 16/05/23.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import OneSolutionUtility
import OneSolutionAPI

public typealias OnSuggestionSelection = (OneSolutionModel) -> Void

public class OneSolutionTextFieldViewModel: ObservableObject {
    
    public static var defaultInstance: OneSolutionTextFieldViewModel {
        OneSolutionTextFieldViewModel(input: "")
    }
    
    public private(set) var placeholder: String?
    public private(set) var canEdit: Bool
//    public private(set) var canChangeRightMode: Bool
    public private(set) var isUpperCasedText: Bool
        
    @Published public var userInput: String
    private(set) var oldInput: String?
    @Published public private(set) var showRightView: Bool
    @Published public private(set) var rightIcon: AssetIcon
    @Published public private(set) var showClear: Bool
    
    public var request: OneSolutionRequest?
    public var callAPIWhenTextChanged: Bool
    public private(set) var callAPIWhenRightIconTap: Bool
    public var objectType: OneSolutionModel.Type?
    
    public var onRightImageTap: EmptyParamsHandler?
    public var onTextChange: EmptyParamsHandler?
    public var onClearTap: EmptyParamsHandler?
    public var onAPIResponse: ((Data) -> Void)?
    public var onSelected: OnSuggestionSelection?
    
    @Published public private(set) var models: [OneSolutionModel]?
    private var progressCount: Int = 0
    private var isClearAction = false
    private var task: Task<Void, Never>?
    private var cancellable: AnyCancellable?
        
    public init(input: String,
                placeholder: String = "",
                isUpperCasedText: Bool = false,
                showRightView: Bool = false,
                rightIcon: AssetIcon = .empty,
                showClear: Bool = false,
                canEdit: Bool = true,
//                canChangeRightMode: Bool = false,
                callAPIWhenTextChanged: Bool = false,
                callAPIWhenRightIconTap: Bool = false,
                request: OneSolutionRequest? = nil,
                objectType: OneSolutionModel.Type? = nil,
                onRightImageTap: EmptyParamsHandler? = nil,
                onTextChange: EmptyParamsHandler? = nil,
                onClearTap: EmptyParamsHandler? = nil,
                onAPIResponse: ((Data) -> Void)? = nil,
                onSelected: ((OneSolutionModel) -> Void)? = nil) {
        self.userInput = input
        self.placeholder = placeholder
        self.isUpperCasedText = isUpperCasedText
        self.showRightView = showRightView
        self.rightIcon = rightIcon
        self.showClear = showClear
        self.callAPIWhenTextChanged = callAPIWhenTextChanged
        self.callAPIWhenRightIconTap = callAPIWhenRightIconTap
        self.request = request
        self.canEdit = canEdit
//        self.canChangeRightMode = canChangeRightMode
        self.objectType = objectType
        self.onRightImageTap = onRightImageTap
        self.onTextChange = onTextChange
        self.onClearTap = onClearTap
        self.onAPIResponse = onAPIResponse
        self.onSelected = onSelected
    }
}

//MARK: - Helper
extension OneSolutionTextFieldViewModel {
    var showProgress: Bool {
        self.progressCount > 0
    }
    public func editable(_ value: Bool = false) {
        self.canEdit = value
    }
}

//MARK: Subscribers
extension OneSolutionTextFieldViewModel {
    func subscribeToInput() {
        cancellable = self.$userInput
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatedInput in
                guard self?.oldInput != updatedInput else { return }
                
                self?.oldInput = updatedInput
                self?.textChanged()
                print(log: "userInput \(self?.userInput ?? "")")
            }
    }
    
    var displayName: String? {
        let name = self.request?.selectedObject?.displayName
        return self.isUpperCasedText ? name?.uppercased() : name
    }
}

//MARK: - Request updates
public extension OneSolutionTextFieldViewModel {
    
    func updateSearchValue () {
        if let _ = request?.reqParams,
           let searchKey = request?.searchKey {
            if !searchKey.isEmpty {
                request?.update(value: userInput, for: searchKey)
            }
        }
    }
    
    func updateRequest(request: OneSolutionRequest) {
        self.request = request
    }
}

//MARK: - Repsonse Updates
public extension OneSolutionTextFieldViewModel {
    func update(models: [OneSolutionModel]?) {
        DispatchQueue.main.async {
            self.models = models
            self.objectWillChange.send()
        }
    }
    
    func clearModels() {
        self.models = nil
        self.request?.selectedObject = nil
    }
    
    func cancelTask() {
        self.task?.cancel()
    }
}

//MARK: update UserInput
public extension OneSolutionTextFieldViewModel {
    func update(input: String) {
        let updatedInput = isUpperCasedText ? input.uppercased() : input
        if !isClearAction {
            self.oldInput = updatedInput
        }
        self.userInput = updatedInput
    }
}

//MARK: - Actions
extension OneSolutionTextFieldViewModel {
    func rightImageAction() {
        self.onRightImageTap?()
        if self.callAPIWhenRightIconTap {
            self.callTextFieldAPI()
        }
    }
    
    func textChanged() {
        if !isClearAction {
            self.onTextChange?()
            if callAPIWhenTextChanged {
                if !userInput.trimmed.isEmpty {
                    updateSearchValue()
                    callTextFieldAPI()
                }
            }
        }
        self.isClearAction = false
    }
    
    func onClearTapped() {
        self.isClearAction = true
        self.update(input: "")
        self.update(models: nil)
        self.onClearTap?()
    }
    
    func onSuggestionSelection(model: OneSolutionModel) {
        self.update(models: nil)
        self.request?.update(model)
        self.update(input: model.displayName)
        self.onSelected?(model)
    }
}

//MARK: - API
extension OneSolutionTextFieldViewModel {
    
    func callTextFieldAPI() {
        guard let request = request, !request.url.isEmpty else { return }
        progressCount += 1
        self.update(models: nil)
        task?.cancel()
        task = Task {
            let result = await OneSolutionTextFieldAPI.instance.fetchData(with: request)
            progressCount -= 1
            switch result {
            case .success(let model):
                if let type = objectType {
                    self.update(models: model.models(type))
                } else {
                    self.update(models: nil)
                }
            case .failure(let error):
                switch error {
                case .errorMessage(let message):
                    if message.lowercased() != "cancelled" {
                        ToastPresenter.shared.presentToast(text: message)
                        self.update(models: nil)
                    }
                default:
                    break
                }
            }
        }
    }
}
