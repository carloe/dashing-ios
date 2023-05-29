//
//  BaseModel.swift
//  Dashing
//
//  Created by Carlo Eugster on 28.05.23.
//

import Foundation
import CoreData

protocol BaseModel: NSManagedObject, Codable, Identifiable {}
