//
//  OneSolutionTextField.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 02/11/22.
//

import SwiftUI
import Combine

struct OneSolutionTextField: View {
    
    public var viewModel: OneSolutionTextFieldViewModel
    @State var text: String = ""
    
    public init(viewModel: OneSolutionTextFieldViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
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
            if !(text.trimmed.isEmpty) {
                textResults
            }
        }
        .onAppear {
            self.text = self.viewModel.input
        }
    }
    
    private var textField: some View {
        TextField(viewModel.placeholder ?? "Enter Keyword", text: $text)
            .font(.system(size: textFieldFont))
            .onChange(of: text) { newValue in
                self.textChanged()
            }
            .basicHeight()
            .padding(.leading, 10)
            .disabled(!viewModel.canEdit)
    }
    
    private var canShowRightView: Bool {
        if viewModel.showRightView && viewModel.showClear {
            if text.trimmed.isEmpty {
                if !rightIconName.isEmpty {
                    return true
                }
            } else {
                return true
            }
        } else if viewModel.showRightView {
            if text.trimmed.isEmpty, !rightIconName.isEmpty {
                return true
            }
        } else if viewModel.showClear {
            if !(text.trimmed.isEmpty) {
                return true
            }
        }
        return false
    }
    
    private var textFieldRightView: some View {
        HStack (spacing: 0) {
            if viewModel.showRightView && viewModel.showClear {
                if text.trimmed.isEmpty {
                    if !rightIconName.isEmpty {
                        rightView
                    }
                } else {
                    clearView
                }
            } else if viewModel.showRightView {
                if text.trimmed.isEmpty, !rightIconName.isEmpty {
                    rightView
                }
            } else if viewModel.showClear {
                if !(text.trimmed.isEmpty) {
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
                Image(rightIconName)
                    .resizable()
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
                Image(AssetIcon.close.rawValue)
                    .resizable()
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
            } else if viewModel.showProgress {
                ProgressView()
            }
        }
    }
    
    private var iconWidth: CGFloat {
        if !text.trimmed.isEmpty { return 14 }
        if viewModel.rightIcon == .calender {
            return 34
        }
        return 24
    }
    private var rightIconPadding: CGFloat {
        if !text.trimmed.isEmpty { return 10 }
        if viewModel.rightIcon == .calender {
            return 2
        }
        return 5
    }
    
    private var rightIconName: String {
        viewModel.rightIcon.rawValue
    }
}

//MARK: - Action



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
                        
//            OneSolutionTextField(input: Binding.constant(""),
//                                 showRightView: true,
//                                 rightIconName: icon_down_arrow,
//                                 showClear: true,
//                                 callAPIWhenTextChanged: false,
//                                 objectType: nil)
//            OneSolutionTextField(input: Binding.constant(""),
//                                 showRightView: true,
//                                 rightIconName: icon_calender,
//                                 showClear: true,
//                                 callAPIWhenTextChanged: false)
//            OneSolutionTextField(input: Binding.constant(""),
//                                 showRightView: true,
//                                 rightIconName: icon_camera,
//                                 showClear: true,
//                                 callAPIWhenTextChanged: false)
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .background(Color.app_bg)
    }
}
