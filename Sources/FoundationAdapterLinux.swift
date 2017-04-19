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

#if os(Linux)
public class FoundationAdapter: FoundationAdapterProtocol {
    #if swift(>=3.1)
        public typealias RegularExpression = Foundation.NSRegularExpression
    #else
        public typealias RegularExpression = Foundation.RegularExpression
    #endif
    public typealias NSMatchingOptions = Foundation.NSMatchingOptions

    /// Return the path component of a URL
    ///
    /// - Parameter from: The `URL`
    /// - Returns: The path component
    public static func getPath(from url: URL) -> String? {
        return url.path
    }

    /// Return the bundle the class belongs to
    ///
    /// - Parameter for: The class
    /// - Returns: The bundle
    public static func getBundle(for aClass: AnyClass) -> Bundle {
        // Bundle(for:) is not yet implemented on Linux
        //TODO remove this ifdef once Bundle(for:) is implemented
        // issue https://bugs.swift.org/browse/SR-953

        // meanwhile return a Bundle whose resource path points to /Resources directory
        //     inside the resourcePath of Bundle.main (e.g. .build/debug/Resources)
        return Bundle(path: (Bundle.main.resourcePath ?? ".") + "/Resources") ?? Bundle.main
    }

    /// Converts error to NSError
    ///
    /// - Parameter from: The error
    /// - Returns: The converted `NSError`
    public static func getNSError(from error: Error?) -> NSError? {
	return error as? NSError
    }
}
#endif
