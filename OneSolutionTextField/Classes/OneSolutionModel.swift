//
//  File.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 23/11/22.
//

import Foundation

public protocol OneSolutionModel: Decodable {
    public var uuid: UUID { get set }
    public var id: String? { get set }
    public var name: String? { get set }
    public var params: [String: QuantumValue]? { get set }
    
    public init(dict: [String: QuantumValue])
}

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
