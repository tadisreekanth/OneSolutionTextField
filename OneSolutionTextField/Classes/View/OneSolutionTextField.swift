//
//  OneSolutionTextField.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 02/11/22.
//

import SwiftUI
import Combine
import OneSolutionUtility

public struct OneSolutionTextField: View {
    
    @ObservedObject public var viewModel: OneSolutionTextFieldViewModel
    
    public init(viewModel: OneSolutionTextFieldViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            HStack (spacing: 0) {
                textField
                if canShowRightView {
                    textFieldRightView
                }
            }
            .background(Color.app_white)
            .cornerRadius(textFieldCornerRadius)
            .overlay(
                VStack {
                    Spacer()
                    Divider()
                        .frame(height: 1)
                        .background(Color.app_green_border)
                        .padding([.leading, .trailing], textFieldCornerRadius/2)
                        .cornerRadius(0.5)
                }
            )
            if !(text.isEmpty) {
                textResults
            }
        }
    }
    
    private var textField: some View {
        TextField(viewModel.placeholder ?? "Enter Keyword", text: $viewModel.userInput)
            .font(.system(size: textFieldFont))
            .basicHeight()
            .padding(.leading, 10)
            .disabled(!viewModel.canEdit)
    }
    
    private var canShowRightView: Bool {
        if viewModel.showRightView && viewModel.showClear {
            if text.isEmpty {
                if !rightIconName.isEmpty {
                    return true
                }
            } else {
                return true
            }
        } else if viewModel.showRightView {
            if text.isEmpty, !rightIconName.isEmpty {
                return true
            }
        } else if viewModel.showClear {
            if !text.isEmpty {
                return true
            }
        }
        return false
    }
    
    private var textFieldRightView: some View {
        HStack (spacing: 0) {
            if viewModel.showRightView && viewModel.showClear {
                if text.isEmpty {
                    if !rightIconName.isEmpty {
                        rightView
                    }
                } else {
                    clearView
                }
            } else if viewModel.showRightView {
                if text.isEmpty, !rightIconName.isEmpty {
                    rightView
                }
            } else if viewModel.showClear {
                if !(text.isEmpty) {
                    clearView
                }
            }
        }
        .frame(width: iconWidth+rightIconPadding)
    }
    
    private var rightView: some View {
        HStack (spacing: 0) {
            let width = iconWidth
            let padding = rightIconPadding
            Spacer()
            Button {
                //down arrow action
                viewModel.onRightImageTap?()
                if self.viewModel.callAPIWhenTextChanged {
                    self.callTextFieldAPI()
                }
            } label: {
                viewModel.rightIcon.image
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: width, maxHeight: width, alignment: .center)
            }
            .padding(.trailing, padding)
            .alignmentGuide(VerticalAlignment.center) { _ in 0 }
        }
    }
    
    private var clearView: some View {
        HStack (spacing: 0) {
            let width = iconWidth
            let padding = rightIconPadding
            Spacer()
            Button {
                self.viewModel.onClearTap?()
                self.onClearTapped()
            } label: {
                AssetIcon.close.image
                    .frame(width: width, height: width, alignment: .center)
            }
            .padding(.trailing, padding)
            .alignmentGuide(VerticalAlignment.center) { _ in 0 }
        }
    }
    
    private var textResults: some View {
        VStack {
            if let models = viewModel.models {
                List {
                    ForEach(models, id: \.uuid) { model in
                        Text(model.name ?? "")
                    }
                }
                .listStyle(.plain)
            }
            //            else if viewModel.showProgress {
            //                Progress()
            //            }
        }
    }
    
    private var iconWidth: CGFloat {
        if !text.isEmpty { return 14 }
        if viewModel.rightIcon == .calender {
            return 34
        }
        return 24
    }
    private var rightIconPadding: CGFloat {
        if !text.isEmpty { return 10 }
        if viewModel.rightIcon == .calender {
            return 2
        }
        return 5
    }
    
    private var rightIconName: String {
        viewModel.rightIcon.rawValue
    }
}

//MARK: Helper
extension OneSolutionTextField {
    var text: String {
        viewModel.userInput.trimmed
    }
}

//MARK: Action



//MARK: - Preview
struct OneSolutionTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            OneSolutionTextField(viewModel:
                                    OneSolutionTextFieldViewModel(input: "",
                                                                  placeholder: "Placeholder",
                                                                  showRightView: true,
                                                                  rightIcon: .down_arrow))
            OneSolutionTextField(viewModel:
                                    OneSolutionTextFieldViewModel(input: "",
                                                                  placeholder: "Placeholder",
                                                                  showRightView: true,
                                                                  rightIcon: .calender))
            
            OneSolutionTextField(viewModel:
                                    OneSolutionTextFieldViewModel(input: "",
                                                                  placeholder: "Placeholder",
                                                                  showRightView: true,
                                                                  rightIcon: .camera))
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .background(Color.app_bg)
    }
}
