//
//  userModel.swift
//  fetchOA
//
//  Created by Donal Higgins on 2/17/23.
//

import Foundation

struct Item: Codable, Identifiable {
    let id: Int
    let listId: Int
    let name: String?
}

