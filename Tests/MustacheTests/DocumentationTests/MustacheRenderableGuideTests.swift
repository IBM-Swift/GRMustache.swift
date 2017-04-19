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
import Foundation

class MustacheRenderableGuideTests: XCTestCase {

// GENERATED: allTests required for Swift 3.0
    static var allTests : [(String, (MustacheRenderableGuideTests) -> () throws -> Void)] {
        return [
            ("testExample1", testExample1),
            ("testExample6", testExample6),
            ("testExample7", testExample7),
            ("testExample8", testExample8),
        ]
    }
// END OF GENERATED CODE

    func testExample1() {
        let render = { (info: RenderingInfo) -> Rendering in
            switch info.tag.type {
            case .Variable:
                return Rendering("I'm rendering a {{ variable }} tag.")
            case .Section:
                return Rendering("I'm rendering a {{# section }}...{{/ }} tag.")
            }
        }

        var rendering = try! Template(string: "{{.}}").render(with: Box(render))
        XCTAssertEqual(rendering, "I&apos;m rendering a {{ variable }} tag.")

        rendering = try! Template(string: "{{#.}}{{/}}").render(with: Box(render))
        XCTAssertEqual(rendering, "I&apos;m rendering a {{# section }}...{{/ }} tag.")
    }

    func textExample2() {
        let render = { (info: RenderingInfo) -> Rendering in
            return Rendering("Arthur & Cie")
        }

        let rendering = try! Template(string: "{{.}}|{{{.}}}").render(with: Box(render))
        XCTAssertEqual(rendering, "Arthur &amp; Cie|Arthur & Cie")
    }

    func textExample3() {
        let render = { (info: RenderingInfo) -> Rendering in
            let rendering = try! info.tag.render(with: info.context)
            return Rendering("<strong>\(rendering.string)</strong>", rendering.contentType)
        }

        let box = Box([
            "strong": Box(render),
            "name": Box("Arthur")])
        let rendering = try! Template(string: "{{#strong}}{{name}}{{/strong}}").render(with: box)
        XCTAssertEqual(rendering, "<strong>Arthur</strong>")
    }

    func textExample4() {
        let render = { (info: RenderingInfo) -> Rendering in
            let rendering = try! info.tag.render(with: info.context)
            return Rendering(rendering.string + rendering.string, rendering.contentType)
        }
        let box = Box(["twice": Box(render)])
        let rendering = try! Template(string: "{{#twice}}Success{{/twice}}").render(with: box)
        XCTAssertEqual(rendering, "SuccessSuccess")
    }

    func textExample5() {
        let render = { (info: RenderingInfo) -> Rendering in
            let template = try! Template(string: "<a href=\"{{url}}\">\(info.tag.innerTemplateString)</a>")
            return try template.render(with: info.context)
        }
        let box = Box([
            "link": Box(render),
            "name": Box("Arthur"),
            "url": Box("/people/123")])
        let rendering = try! Template(string: "{{# link }}{{ name }}{{/ link }}").render(with: box)
        XCTAssertEqual(rendering, "<a href=\"/people/123\">Arthur</a>")
    }

    func testExample6() {
        let repository = TemplateRepository(templates: [
            "movieLink": "<a href=\"{{url}}\">{{title}}</a>",
            "personLink": "<a href=\"{{url}}\">{{name}}</a>"])
        let link1 = Box(try! repository.template(named: "movieLink"))
        let item1 = Box([
            "title": Box("Citizen Kane"),
            "url": Box("/movies/321"),
            "link": link1])
        let link2 = Box(try! repository.template(named: "personLink"))
        let item2 = Box([
            "name": Box("Orson Welles"),
            "url": Box("/people/123"),
            "link": link2])
        let box = Box(["items": Box([item1, item2])])
        let rendering = try! Template(string: "{{#items}}{{link}}{{/items}}").render(with: box)
        XCTAssertEqual(rendering, "<a href=\"/movies/321\">Citizen Kane</a><a href=\"/people/123\">Orson Welles</a>")
    }

    func testExample7() {
        struct Person : MustacheBoxable {
            let firstName: String
            let lastName: String
            var mustacheBox: MustacheBox {
                let keyedSubscript = { (key: String) -> MustacheBox in
                    switch key {
                    case "firstName":
                        return Box(self.firstName)
                    case "lastName":
                        return Box(self.lastName)
                    default:
                        return Box()
                    }
                }
                let render = { (info: RenderingInfo) -> Rendering in
                    let testBundle = FoundationAdapter.getBundle(for: MustacheRenderableGuideTests.self)
                    let template = try! Template(named: "Person", bundle: testBundle)
                    let context = info.context.extendedContext(by: Box(self))
                    return try template.render(with: context)
                }
                return MustacheBox(
                    value: self,
                    keyedSubscript: keyedSubscript,
                    render: render)
            }
        }

        struct Movie : MustacheBoxable {
            let title: String
            let director: Person
            var mustacheBox: MustacheBox {
                let keyedSubscript = { (key: String) -> MustacheBox in
                    switch key {
                    case "title":
                        return Box(self.title)
                    case "director":
                        return Box(self.director)
                    default:
                        return Box()
                    }
                }
                let render = { (info: RenderingInfo) -> Rendering in
                    let testBundle = FoundationAdapter.getBundle(for: MustacheRenderableGuideTests.self)
                    let template = try! Template(named: "Movie", bundle: testBundle)
                    let context = info.context.extendedContext(by: Box(self))
                    return try template.render(with: context)
                }
                return MustacheBox(
                    value: self,
                    keyedSubscript: keyedSubscript,
                    render: render)
            }
        }

        let director = Person(firstName: "Orson", lastName: "Welles")
        let movie = Movie(title:"Citizen Kane", director: director)

        let template = try! Template(string: "{{ movie }}")
        let rendering = try! template.render(with: Box(["movie": Box(movie)]))
        XCTAssertEqual(rendering, "Citizen Kane by Orson Welles")
    }

    func testExample8() {
        let listFilter = { (box: MustacheBox, info: RenderingInfo) -> Rendering in
            guard let items = box.arrayValue else {
                return Rendering("")
            }

            var buffer = "<ul>"
            for item in items {
                let itemContext = info.context.extendedContext(by: item)
                let itemRendering = try! info.tag.render(with: itemContext)
                buffer += "<li>\(itemRendering.string)</li>"
            }
            buffer += "</ul>"
            return Rendering(buffer, .HTML)
        }

        let template = try! Template(string: "{{#list(nav)}}<a href=\"{{url}}\">{{title}}</a>{{/}}")
        template.baseContext = template.baseContext.extendedContext(by: Box(["list": Box(Filter(listFilter))]))

        let item1 = Box([
            "url": "http://mustache.github.io",
            "title": "Mustache"])
        let item2 = Box([
            "url": "http://github.com/groue/GRMustache.swift",
            "title": "GRMustache.swift"])
        let box = Box(["nav": Box([item1, item2])])

        let rendering = try! template.render(with: box)
        XCTAssertEqual(rendering, "<ul><li><a href=\"http://mustache.github.io\">Mustache</a></li><li><a href=\"http://github.com/groue/GRMustache.swift\">GRMustache.swift</a></li></ul>")
    }
}
