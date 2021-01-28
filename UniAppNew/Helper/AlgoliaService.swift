//
//  AlgoliaService.swift
//  UniAppNew
//
//  Created by Kim on 11/1/21.
//

import Foundation
import AlgoliaSearchClient

class AlgoliaService {
    
    static let shared = AlgoliaService()
    
    
    let client = SearchClient(appID: "NFXHRVUMIH", apiKey: "9b5fdb3ac9aa85aeb6ab5b023d0c4e85")
    let index = SearchClient(appID: "NFXHRVUMIH", apiKey: "9b5fdb3ac9aa85aeb6ab5b023d0c4e85").index(withName: "Posts")
    

    
    private init() {}
}
