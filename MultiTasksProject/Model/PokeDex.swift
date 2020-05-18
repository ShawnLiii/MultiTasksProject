//
//  PokeDex.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/17/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import Foundation

struct Pokemon: Decodable
{
    var id: Int
    var name: [String: String]
    var type: [String]
    var base: [String: Int]
}

