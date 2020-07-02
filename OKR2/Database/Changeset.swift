//
//  Changeset.swift
//  Core
//
//  Created by Alex on 21.06.2020.
//  Copyright © 2020 Windmill. All rights reserved.
//

import Foundation

public struct Changeset {
    /// the indexes in the collection that were deleted
    public let deleted: [Int]

    /// the indexes in the collection that were inserted
    public let inserted: [Int]

    /// the indexes in the collection that were modified
    public let updated: [Int]
}
