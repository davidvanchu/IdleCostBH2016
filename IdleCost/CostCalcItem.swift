//
//  CostCalcItem
//  CostCalcItem
//
//  Created by David Chu on 3/6/16.
//  Copyright © 2016 David Van Chu. All rights reserved.
//

import UIKit

class CostCalcItem : NSObject, NSCoding {
    let idleTimeSeconds: Double
    
    let idleTimeKey = "idleTime"
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(idleTimeSeconds, forKey: idleTimeKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        idleTimeSeconds = aDecoder.decodeObjectForKey(idleTimeKey) as! Double
    }
    
    init(idleTimeSecs: Double) {
        self.idleTimeSeconds = idleTimeSecs
    }
}