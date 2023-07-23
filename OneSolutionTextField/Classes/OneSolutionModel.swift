//
//  File.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 23/11/22.
//

import Foundation
import OneSolutionAPI

public struct Serial: OneSolutionModel {
    public var uuid = UUID()
    public var id: String?
    public var name: String?
    public var params: [String : QuantumValue]?
    
    public init(dict: [String: QuantumValue]) {
        id = dict["id"]?.stringValue
        name = dict["name"]?.stringValue
        params = dict
    }
}
