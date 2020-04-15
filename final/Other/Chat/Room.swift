/*
 Heon Lee
 991280638
 
 This is a data class for listing rooms
 2020-04-19
 */

import UIKit

class Room: NSObject {
    
    var name : String?
    var image : String?
    var availability : String?
    
    func initWithData(theName n : String, theAvailability a : String,
                      theImage i : String){
        self.name = n
        self.image = i
        self.availability = a
    }
}
