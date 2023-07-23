//
//  File.swift
//  OneSolution
//
//  Created by sreekanth reddy Tadi on 08/11/22.
//

import Foundation
import OneSolutionAPI

public struct OneSolutionRequest {
    
    var url = ""
    var reqParams: NSDictionary?
    var searchKey: String?
    
    var responseObject: NSDictionary?
    
    var selectedObject: OneSolutionModel?
    
    public init() {
        url = ""
        reqParams = NSDictionary ()
        searchKey = ""
    }
    
    public init (url_String: String, requestParams: NSDictionary, searchValueKey: String) {
        url = url_String
        reqParams = requestParams
        searchKey = searchValueKey
    }
}

public extension OneSolutionRequest {
    
    mutating func updateRequestParams (requestParams: NSDictionary) {
        reqParams = requestParams
    }
    
    mutating func update (key: String, value: Any) {
        if let params = reqParams?.mutableCopy() as? NSMutableDictionary {
            params.setValue(value, forKey: key)
            reqParams = params as NSDictionary
        }
    }
    
    mutating func setReponse (_ serviceResponse: NSDictionary?) -> Void {
        if let serResponse = serviceResponse {
            self.responseObject = serResponse
        }else {
            self.responseObject = nil
        }
    }
    
    mutating func setSelectedObject (_ seleted: OneSolutionModel?) -> Void {
        if let obj = seleted {
            self.selectedObject = obj
        }else {
            self.selectedObject = nil
        }
    }
}
