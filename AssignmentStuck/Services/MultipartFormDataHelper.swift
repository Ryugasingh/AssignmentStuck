//
//  MultipartFormDataHelper.swift
//  AssignmentStuck
//
//  Created by Sambhav Singh on 06/03/25.
//

import Foundation

func createMultipartBody(
    parameters: [String: String],
    fileData: Data?,
    fileName: String?,
    boundary: String
) -> Data {
    var body = Data()
    
    for (key, value) in parameters {
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.appendString("\(value)\r\n")
    }
    
    if let fileData = fileData, let fileName = fileName {
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"files[]\"; filename=\"\(fileName)\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(fileData)
        body.appendString("\r\n")
    }
    
    body.appendString("--\(boundary)--\r\n")
    return body
}

