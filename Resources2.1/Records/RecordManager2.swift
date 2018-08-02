//
//  RecordManager2.swift
//  Resources2.1
//
//  Created by B_Litwin on 7/31/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

/*

Basic operations we want to perform are insert and delete in not-outrageous time
inserts/ deletes should update a variety of others analytics..
 -personal records
 -rep maxes
 -oneRM info
 -weekly/monthly info (could filter for that maybe)
 
 sort the exerciseMetrics
 
Insert: 2 possibilities
 
 A) if it's not a PR: insert it into the appropriate subtree (find the PR that it is greater than, and insert it into that PR's parent node's subtree
 B) if it's a PR: update the PR Tree: go down the tree, and if the new PR is greater than an exisitng PR, appropriate that old PR's subtree. If you find a PR that the new PR is not a PR over, stop the search.
 
 Delete:
 
 
 
*/



class RecordManager2 {
    
}



























