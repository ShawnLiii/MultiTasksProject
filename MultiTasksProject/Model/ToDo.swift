//
//  ToDo.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/16/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import Foundation

struct ToDo: Decodable
{
    var completed: Bool
    var id: Int
    var title: String
    var userId: Int
}
