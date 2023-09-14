//
//  OneSolutionTexFieldViewModel.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 16/05/23.
//

import Foundation
import SwiftUI
import Combine
import OneSolutionUtility
import OneSolutionAPI

public class OneSolutionTextFieldViewModel: ObservableObject {

    public private(set) var placeholder: String?
    public private(set) var canEdit: Bool
    public private(set) var canChangeRightMode: Bool

    @Published public var userInput: String
    @Published public private(set) var showRightView: Bool
    @Published public private(set) var rightIcon: AssetIcon
    @Published public private(set) var showClear: Bool
    public private(set) var request: OneSolutionRequest?
    @Published public private(set) var callAPIWhenTextChanged: Bool
    public var objectType: OneSolutionModel.Type?

    public var onRightImageTap: EmptyParamsHandler?
    public var onTextChange: EmptyParamsHandler?
    public var onClearTap: EmptyParamsHandler?
    public var onAPIResponse: ((Data) -> Void)?
    public var onSelected: ((OneSolutionModel) -> Void)?
    
    
    @Published public private(set) var models: [OneSolutionModel]?
    var showProgress = false
    var isClearAction = false
    var task: Task<Void, Never>?
    var cancellables = Set<AnyCancellable>()
    
    public init(input: String,
                placeholder: String = "",
                showRightView: Bool = false,
                rightIcon: AssetIcon = .empty,
                showClear: Bool = false,
                callAPIWhenTextChanged: Bool = false,
                request: OneSolutionRequest? = nil,
                canEdit: Bool = true,
                canChangeRightMode: Bool = false,
                objectType: OneSolutionModel.Type? = nil,
                onRightImageTap: EmptyParamsHandler? = nil,
                onTextChange: EmptyParamsHandler? = nil,
                onClearTap: EmptyParamsHandler? = nil,
                onAPIResponse: ((Data) -> Void)? = nil,
                onSelected: ((OneSolutionModel) -> Void)? = nil) {
        self.userInput = input
        self.placeholder = placeholder
        self.showRightView = showRightView
        self.rightIcon = rightIcon
        self.showClear = showClear
        self.callAPIWhenTextChanged = callAPIWhenTextChanged
        self.request = request
        self.canEdit = canEdit
        self.canChangeRightMode = canChangeRightMode
        self.objectType = objectType
        self.onRightImageTap = onRightImageTap
        self.onTextChange = onTextChange
        self.onClearTap = onClearTap
        self.onAPIResponse = onAPIResponse
        self.onSelected = onSelected
        
        self.subscribeToInput()
    }
}

//MARK: Subscribers
extension OneSolutionTextFieldViewModel {
    func subscribeToInput() {
        self.$userInput.sink { [weak self] _ in
            self?.updateSearchValue()
        }
        .store(in: &cancellables)
    }
}


//MARK: - Request updates
public extension OneSolutionTextFieldViewModel {
    
    func updateSearchValue () {
        if let _ = request?.reqParams,
           let searchKey = request?.searchKey {
            if !searchKey.isEmpty {
                request?.update(key: searchKey, value: userInput)
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
        self.models = models
//        objectWillChange.send()
    }
}

public extension OneSolutionTextFieldViewModel {
    private func updateClosure (action: EmptyParamsHandler?) {
        self.onTextChange = action
    }
}
    
//MARK: update UserInput
public extension OneSolutionTextFieldViewModel {
    func update(input: String) {
        self.userInput = input
    }
}
