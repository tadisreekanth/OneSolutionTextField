//
//  OneSolutionTexFieldViewModel.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 16/05/23.
//

import Foundation
import SwiftUI
import Combine

public class OneSolutionTextFieldViewModel: ObservableObject {

    public private(set) var placeholder: String?
    public private(set) var canEdit: Bool
    public private(set) var canChangeRightMode: Bool

    @Published var input: String
    @Published public private(set) var showRightView: Bool
    @Published public private(set) var rightIcon: AssetIcon
    @Published public private(set) var showClear: Bool
    public private(set) var request: OneSolutionRequest?
    @Published public private(set) var callAPIWhenTextChanged: Bool
    
    public private(set) var onRightImageTap: noParamsHandler?
    public private(set) var onTextChange: noParamsHandler?
    public private(set) var onClearTap: noParamsHandler?
    public private(set) var onAPIResponse: ((Data) -> Void)?
    public private(set) var onSelected: ((OneSolutionModel) -> Void)?
    public private(set) var objectType: OneSolutionModel.Type?
    
    
    @Published public private(set) var models: [OneSolutionModel]?
    var showProgress = false
    var isClearAction = false
    var task: Task<Void, Never>?
    
    init(input: String,
         placeholder: String = "",
         showRightView: Bool = false,
         rightIcon: AssetIcon = .empty,
         showClear: Bool = false,
         callAPIWhenTextChanged: Bool = false,
         request: OneSolutionRequest? = nil,
         canEdit: Bool = true,
         canChangeRightMode: Bool = false,
         onRightImageTap: noParamsHandler? = nil,
         onTextChange: noParamsHandler? = nil,
         onClearTap: noParamsHandler? = nil,
         onAPIResponse: ((Data) -> Void)? = nil,
         onSelected: ((OneSolutionModel) -> Void)? = nil,
         objectType: OneSolutionModel.Type? = nil) {
        self.input = input
        self.placeholder = placeholder
        self.showRightView = showRightView
        self.rightIcon = rightIcon
        self.showClear = showClear
        self.callAPIWhenTextChanged = callAPIWhenTextChanged
        self.request = request
        self.canEdit = canEdit
        self.canChangeRightMode = canChangeRightMode
        self.onRightImageTap = onRightImageTap
        self.onTextChange = onTextChange
        self.onClearTap = onClearTap
        self.onAPIResponse = onAPIResponse
        self.onSelected = onSelected
        self.objectType = objectType
    }
}

//MARK: - Request updates
public extension OneSolutionTextFieldViewModel {
    
    public func updateSearchValue () {
        if let _ = request?.reqParams,
           let searchKey = request?.searchKey {
            if !searchKey.isEmpty {
                request?.update(key: searchKey, value: input)
            }
        }
    }
    
    public func updateRequest(request: OneSolutionRequest) {
        self.request = request
    }
}

//MARK: - Repsonse Updates
public extension OneSolutionTextFieldViewModel {
    public func update(models: [OneSolutionModel]?) {
        self.models = models
        objectWillChange.send()
    }
}

public extension OneSolutionTextFieldViewModel {
    private func updateClosure (action: noParamsHandler?) {
        self.onTextChange = action
    }
}
