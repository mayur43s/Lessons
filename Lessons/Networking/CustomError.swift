//
//  CustomError.swift
//  Lessons
//
//  Created by Mayur Shrivas on 07/01/23.
//

import Foundation

enum CustomError: Error {
    case notFound
    case invalidResponse
    case unexpected(code: Int)
}

extension CustomError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound:
            return "The specified item could not be found."
        case .invalidResponse:
            return "Looks like we received eunexpected response."
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound:
            return NSLocalizedString(
                "The specified item could not be found.",
                comment: "Resource Not Found"
            )
        case .invalidResponse:
            return NSLocalizedString(
                "Looks like we received eunexpected response.",
                comment: "Invalid Response"
            )
        case .unexpected(_):
            return NSLocalizedString(
                "An unexpected error occurred.",
                comment: "Unexpected Error"
            )
        }
    }
}
