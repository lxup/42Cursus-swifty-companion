//
//  AsyncSvgImage.swift
//  42Cursus-swifty-companion
//
//  Created by Loup on 16/05/2025.
//
import Darwin
import Foundation
import UIKit
import SwiftUI

/// A view that asynchronously loads and displays an image in SVG format, similarly to SwiftUI's `AsyncImage`.
///
/// This view uses the `shared` [URLSession](https://developer.apple.com/documentation/foundation/urlsession)
/// instance to load an image from the specified URL, and then display it.
/// For example, you can display an SVG icon that's stored on a server:
///
///     AsyncSVGImage(url: URL(string: "https://example.com/icon.svg")) { image in
///         image.resizable()
///     } placeholder: {
///         ProgressView()
///     }
///     .frame(width: 50, height: 50)
///
/// For this example, `AsyncSVGImage` shows a ``ProgressView`` first, and then the
/// image with the `resizable` modifier applied.
public struct AsyncSVGImage<Content, Placeholder>: View where Content: View, Placeholder: View {
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: Placeholder

    @State private var uiImage: UIImage?

    /// Loads and displays a modifiable image from the specified URL using
    /// a custom placeholder until the image loads.
    ///
    /// Until the image loads, `AsyncSVGImage` displays the placeholder view that
    /// you specify. When the load operation completes successfully, `AsyncSVGImage`
    /// updates the view to show content that you specify, which you
    /// create using the loaded image. For example, you can show a `ProgressView`
    /// placeholder, followed by a loaded image with the `renderingMode` and the `aspectRatio` modifiers applied:
    ///
    ///     AsyncSVGImage(url: URL(string: "https://example.com/icon.svg")) { image in
    ///         image.resizable()
    ///             .renderingMode(.original)
    ///             .aspectRatio(contentMode: .fit)
    ///     } placeholder: {
    ///         ProgressView()
    ///     }
    ///
    /// - Parameters:
    ///   - url: The URL of the SVG to display.
    ///   - content: A closure that takes the loaded image as an input, and
    ///     returns the view to show. You can return the image directly, or
    ///     modify it as needed before returning it.
    ///   - placeholder: A closure that returns the view to show until the
    ///     load operation completes successfully.
    public init(url: URL?, @ViewBuilder content: @escaping (Image) -> Content, @ViewBuilder placeholder: @escaping () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder()
    }

    @MainActor public var body: some View {
        content(
            Image(uiImage: uiImage ?? UIImage())
        )
        .overlay {
            placeholder
                .opacity(uiImage == nil ? 1.0 : 0.0)
                .disabled(uiImage == nil)
        }
        .onAppear {
            loadImageIfPossible()
        }
    }

    private func loadImageIfPossible() {
        guard let url else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data,
                error == nil,
                let svg = SVG(data)
            else { return }

            let render = UIGraphicsImageRenderer(size: svg.size)
            uiImage = render.image { context in
                svg.draw(in: context.cgContext)
            }
        }.resume()
    }
}

// MARK: - Private CoreSVG Framework

/// Full credit for the `CoreSVG` private framework code  goes to Oliver Atkinson, for creating this [SVG.swift](https://gist.github.com/ollieatkinson/eb87a82fcb5500d5561fed8b0900a9f7) gist.
@objc
final fileprivate class CGSVGDocument: NSObject {}

fileprivate var CGSVGDocumentRetain: (@convention(c) (CGSVGDocument?) -> Unmanaged<CGSVGDocument>?) = load("CGSVGDocumentRetain")
fileprivate var CGSVGDocumentRelease: (@convention(c) (CGSVGDocument?) -> Void) = load("CGSVGDocumentRelease")
fileprivate var CGSVGDocumentCreateFromData: (@convention(c) (CFData?, CFDictionary?) -> Unmanaged<CGSVGDocument>?) = load("CGSVGDocumentCreateFromData")
fileprivate var CGContextDrawSVGDocument: (@convention(c) (CGContext?, CGSVGDocument?) -> Void) = load("CGContextDrawSVGDocument")
fileprivate var CGSVGDocumentGetCanvasSize: (@convention(c) (CGSVGDocument?) -> CGSize) = load("CGSVGDocumentGetCanvasSize")

fileprivate typealias ImageWithCGSVGDocument = @convention(c) (AnyObject, Selector, CGSVGDocument) -> UIImage
fileprivate var ImageWithCGSVGDocumentSEL: Selector = NSSelectorFromString("_imageWithCGSVGDocument:")

fileprivate let CoreSVG = dlopen("/System/Library/PrivateFrameworks/CoreSVG.framework/CoreSVG", RTLD_NOW)

fileprivate func load<T>(_ name: String) -> T {
    unsafeBitCast(dlsym(CoreSVG, name), to: T.self)
}

final fileprivate class SVG {
    deinit { CGSVGDocumentRelease(document) }

    let document: CGSVGDocument

    convenience init?(_ value: String) {
        guard let data = value.data(using: .utf8) else { return nil }
        self.init(data)
    }

    init?(_ data: Data) {
        guard let document = CGSVGDocumentCreateFromData(data as CFData, nil)?.takeUnretainedValue() else { return nil }
        guard CGSVGDocumentGetCanvasSize(document) != .zero else { return nil }
        self.document = document
    }

    var size: CGSize {
        CGSVGDocumentGetCanvasSize(document)
    }

    func image() -> UIImage? {
        let ImageWithCGSVGDocument = unsafeBitCast(UIImage.method(for: ImageWithCGSVGDocumentSEL), to: ImageWithCGSVGDocument.self)
        let image = ImageWithCGSVGDocument(UIImage.self, ImageWithCGSVGDocumentSEL, document)
        return image
    }

    func draw(in context: CGContext) {
        draw(in: context, size: size)
    }

    func draw(in context: CGContext, size target: CGSize) {
        var target = target

        let ratio = (
            x: target.width / size.width,
            y: target.height / size.height
        )

        let rect = (
            document: CGRect(origin: .zero, size: size), ()
        )

        let scale: (x: CGFloat, y: CGFloat)

        if target.width <= 0 {
            scale = (ratio.y, ratio.y)
            target.width = size.width * scale.x
        } else if target.height <= 0 {
            scale = (ratio.x, ratio.x)
            target.width = size.width * scale.y
        } else {
            let min = min(ratio.x, ratio.y)
            scale = (min, min)
            target.width = size.width * scale.x
            target.height = size.height * scale.y
        }

        let transform = (
            scale: CGAffineTransform(scaleX: scale.x, y: scale.y),
            aspect: CGAffineTransform(translationX: (target.width / scale.x - rect.document.width) / 2, y: (target.height / scale.y - rect.document.height) / 2)
        )

        context.translateBy(x: 0, y: target.height)
        context.scaleBy(x: 1, y: -1)
        context.concatenate(transform.scale)
        context.concatenate(transform.aspect)

        CGContextDrawSVGDocument(context, document)
    }
}
