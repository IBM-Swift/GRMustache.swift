/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

// This file defines on OSX and iOS the various _bridgeToSwift() functions that are currently
// only defined in the Linux version of Foundation

#if !os(Linux)

    import Foundation

    // Array related _bridgeToSwift() functions

//    extension Array {
//        func _bridgeToSwift() -> NSArray {
//            return NSArray(array: map { return $0 as Any } )
//        }
//    }

    extension NSArray {
        func _bridgeToSwift() -> Array<AnyObject> {
            return self as Array<AnyObject>
        }
    }


    // Dictionary related _bridgeToSwift() functions

//    extension Dictionary {
//        func _bridgeToSwift() -> NSDictionary {
//            return [NSObject : AnyObject](dictionaryLiteral: self)
//        }
//    }

    extension NSDictionary {
        func _bridgeToSwift() -> [NSObject: AnyObject] {
            return self as [NSObject: AnyObject]
        }
    }


    // String related _bridgeToSwift() functions

    extension NSString {
        func _bridgeToSwift() -> String {
            return self as String
        }
    }

#endif
