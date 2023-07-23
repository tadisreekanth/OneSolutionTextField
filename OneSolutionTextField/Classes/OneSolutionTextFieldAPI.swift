//
//  File2.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 08/11/22.
//

import Foundation
import OneSolutionUtility
import OneSolutionAPI

//@available(iOS 13.0.0, *)
//struct OneSolutionTextFieldAPI: AbstractAPI {
//    static let shared: OneSolutionTextFieldAPI { OneSolutionTextFieldAPI() }
//}
//
//extension OneSolutionTextFieldAPI {
//
//    func fetchData(with request: OneSolutionRequest) async -> Result<OneSolutionTextFieldModel, ResultError> {
//        let endPoint = AbstractAPIEndPoint(url: request.url,
//                                           method: .POST,
//                                           body: request.reqParams as? [String : Any])
//        switch await self.callAPI(endPoint: endPoint) {
//        case .success(let responseData):
//            guard let data = responseData else {
//                return .failure(.unknown)
//            }
//            do {
//                let model = try JSONDecoder().decode(OneSolutionTextFieldModel.self, from: data)
//                if model.statusCode == 200 {
//                    return .success(model)
//                } else if let errorMessage = model.message {
//                    //show alert
//                    return .failure(.errorMessage(errorMessage))
//                }
//                return .failure(.unknown)
//            } catch let error {
//                print(log: String(describing: error))
//                return .failure(.decode)
//            }
//        case .failure(let error):
//            return .failure(error)
//        }
//    }
//}
