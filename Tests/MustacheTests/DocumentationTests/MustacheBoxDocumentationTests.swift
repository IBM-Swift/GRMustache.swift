// The MIT License
//
// Copyright (c) 2015 Gwendal Roué
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import XCTest
import Mustache

class MustacheBoxDocumentationTests: XCTestCase {

// GENERATED: allTests required for Swift 3.0
    static var allTests : [(String, (MustacheBoxDocumentationTests) -> () throws -> Void)] {
        return [
            ("testRenderingDocumentation", testRenderingDocumentation),
            ("testRenderingInfoDocumentation", testRenderingInfoDocumentation),
        ]
    }
// END OF GENERATED CODE
    
    func testRenderingDocumentation() {
        let render: RenderFunction = { (info: RenderingInfo) -> Rendering in
            return Rendering("foo")
        }
        let template = try! Template(string: "{{object}}")
        let data = ["object": Box(render)]
        let rendering = try! template.render(with: Box(data))
        XCTAssertEqual(rendering, "foo")
    }
    
    func testRenderingInfoDocumentation() {
        let render: RenderFunction = { (info: RenderingInfo) -> Rendering in
            switch info.tag.type {
            case .Variable:
                // Render a {{object}} variable tag
                return Rendering("variable")
                
            case .Section:
                // Render a {{#object}}...{{/object}} section tag.
                //
                // Extend the current context with ["value": "foo"], and proceed
                // with regular rendering of the inner content of the section.
                let context = info.context.extendedContext(by: Box(["value": "foo"]))
                return try info.tag.render(with: context)
            }
        }
        let data = ["object": Box(render)]
        
        // Renders "variable"
        let template1 = try! Template(string: "{{object}}")
        let rendering1 = try! template1.render(with: Box(data))
        XCTAssertEqual(rendering1, "variable")
        
        // Renders "value: foo"
        let template2 = try! Template(string: "{{#object}}value: {{value}}{{/object}}")
        let rendering2 = try! template2.render(with: Box(data))
        XCTAssertEqual(rendering2, "value: foo")
    }
}

