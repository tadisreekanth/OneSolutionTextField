//
//  OneSolutionModel.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 23/11/22.
//

import Foundation

struct OneSolutionTextFieldModel: Decodable {
    let message: String?
    let status: String?
    let statusCode: Int?
    let data: [[String: QuantumValue]]?
    enum codingKeys: String, CodingKey {
        case message, status, statusCode
        case data = "Data"
    }
    
    func models(of type: OneSolutionModel.Type) -> [OneSolutionModel] {
        var models = [OneSolutionModel]()
        if let modelsData = data {
            for model in modelsData {
                models.append(type.init(dict: model))
            }
        }
        return models
    }
}
