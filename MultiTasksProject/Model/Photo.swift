//
//  Photo.swift
//  MultiTasksProject
//
//  Created by Shawn Li on 5/17/20.
//  Copyright © 2020 ShawnLi. All rights reserved.
//

import Foundation

struct Media: Decodable
{
   let m: URL
}
struct Item: Decodable
{
   let title: String
   let media: Media
}
struct FeedData: Decodable
{
   let items: [Item]
}
