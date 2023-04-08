//
//  TodoError.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 08.04.2023.
//

import Foundation

struct TodoError: Error, Equatable {
    let reason: String
}
