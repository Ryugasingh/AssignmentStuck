//
//  Data+Extensions.swift
//  AssignmentStuck
//
//  Created by Sambhav Singh on 06/03/25.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

