//
//  Todo.swift
//  ActionsBoundariesTCA
//
//  Created by Artem Kalinovsky on 08.04.2023.
//

import Foundation

struct Todo: Identifiable, Equatable {
    var id = UUID()

    let name: String
    let complete: Bool
}
