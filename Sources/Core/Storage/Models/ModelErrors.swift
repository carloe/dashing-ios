//
//  ModelErrors.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
    case missingEntity
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
