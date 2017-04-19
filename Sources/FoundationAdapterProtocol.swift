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

import Foundation

// a protocol to compensate for discrepancies between old Foundation on macOS/iOS/tvOS/watchOS
// and the new Foundation on Linux
// it is called protocol to distinguish it from FoundationAdapter class
// it is a random collection of methods used in various IBM@Swift repositories
// it is not itended to contain an exhaustive list of discrepancies

protocol FoundationAdapterProtocol {
    /// Return the path component of a URL
    ///
    /// - Parameter from: The `URL`
    /// - Returns: The path component
    static func getPath(from: URL) -> String?

    /// Return the bundle the class belongs to
    ///
    /// - Parameter for: The class
    /// - Returns: The bundle
    static func getBundle(for aClass: AnyClass) -> Bundle

    /// Converts error to NSError
    ///
    /// - Parameter from: The error
    /// - Returns: The converted `NSError`
    static func getNSError(from: Error?) -> NSError?
}
