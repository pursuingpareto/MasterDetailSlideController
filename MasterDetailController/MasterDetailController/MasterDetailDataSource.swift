//
//  MasterDetailDataSource.swift
//  MasterDetailController
//
//  Created by Andy Brown on 7/6/15.
//  Copyright (c) 2015 Andy Brown. All rights reserved.
//

import UIKit

protocol MasterDetailDataSource {
    
    func numberOfSections() -> Int
    
    func masterDetailController(numberOfRowsInSection section: Int) -> Int
    
    func masterDetailController(masterCellForSection section: Int) -> MasterCell
    
    func masterDetailController(detailCellForRowAtIndexPath indexPath: NSIndexPath) -> DetailCell
    
}
