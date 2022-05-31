//
//  TypographyTextView.swift
//  YMatterType
//
//  Created by Mark Pospesel on 12/17/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

/// A text view that supports `Typography`.
///
/// You can optionally set `maximumPointSize` or `maximumScaleFactor` to set a cap on Dynamic Type scaling.
/// - Note: By default UITextView has no intrinsic height (because content can scroll).
/// If you are looking to essentially have an interactive label with link support,
/// you need to set `isScrollEnabled = false` and `isEditable = false`.
open class TypographyTextView: UITextView {
    /// The current typographical layout
    public private(set) var layout: TypographyLayout!

    /// Typography to be used for this text view's text
    public var typography: Typography {
        didSet {
            adjustFonts()
        }
    }

    /// (Optional) maximum point size when scaling the font.
    ///
    /// Value should be greater than Typography.fontSize.
    /// `nil` means no maximum for scaling.
    /// Has no effect for fixed Typography.
    ///
    /// If you wish to set a specific maximum scale factor instead of a fixed maximum point size,
    /// set `maximumScaleFactor` instead.
    /// `maximumScaleFactor` will be used if both properties are non-nil.
    public var maximumPointSize: CGFloat? {
        didSet {
            if !typography.isFixed && maximumPointSize != oldValue {
                adjustFonts()
            }
        }
    }

    /// (Optional) maximum scale factor to use when scaling the font.
    ///
    /// Value should be greater than 1.
    /// `nil` means no maximum scale factor.
    /// Has no effect for fixed Typography.
    ///
    /// If you wish to set a specific maximum point size instead of a scale factor, set `maximumPointSize` instead.
    /// Takes precedence over `maximumPointSize` if both properties are non-nil.
    public var maximumScaleFactor: CGFloat? {
        didSet {
            if !typography.isFixed && maximumScaleFactor != oldValue {
                adjustFonts()
            }
        }
    }

    /// Initializes a text view using the specified `Typography`
    /// - Parameter typography: the font information to use
    required public init(typography: Typography) {
        self.typography = typography
        super.init(frame: .zero, textContainer: nil)
        build()
    }

    /// :nodoc:
    required public init?(coder: NSCoder) { nil }

    private enum TextSetMode {
        case text
        case attributedText
    }

    private var textSetMode: TextSetMode = .text

    /// :nodoc:
    override public var text: String! {
        get { super.text }
        set {
            // When text is set, we may need to re-style it as attributedText
            // with the correct paragraph style to achieve the desired line height.
            textSetMode = .text
            styleText(newValue)
        }
    }

    /// :nodoc:
    override public var attributedText: NSAttributedString? {
        get { super.attributedText }
        set {
            // When text is set, we may need to re-style it as attributedText
            // with the correct paragraph style to achieve the desired line height.
            textSetMode = .attributedText
            styleAttributedText(newValue)
        }
    }

    /// :nodoc:
    override public var textAlignment: NSTextAlignment {
        didSet {
            if textAlignment != oldValue {
                // Text alignment can be part of our paragraph style, so we may need to
                // re-style when changed
                restyleText()
            }
        }
    }

    /// :nodoc:
    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentFontAppearance(comparedTo: previousTraitCollection) {
            adjustFonts()
        }

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            adjustColors()
        }

        if traitCollection.hasDifferentBreakpoint(comparedTo: previousTraitCollection) {
            adjustBreakpoint()
        }
    }

    /// Call this if you've made a change that would require text to be re-styled. (Normally this is not necessary).
    /// Override this if you need to do something additional when preferred content size
    /// or legibility weight has changed
    open func adjustFonts() {
        layout = typography.generateLayout(
            maximumScaleFactor: maximumScaleFactor,
            maximumPointSize: maximumPointSize,
            compatibleWith: traitCollection
        )
        font = layout.font
        restyleText()
    }

    /// Override this if you have colors that will not automatically adjust to
    /// Light / Dark mode, etc. This can be the case for CGColor or
    /// non-template images (or backgroundImages).
    open func adjustColors() {
        // override to handle any color changes
    }

    /// Override this if you have typography that might change at different breakpoints.
    /// You should check `.window?.bounds.size` for potential changes.
    open func adjustBreakpoint() {
        // override to handle any changes based on breakpoint
    }
}

private extension TypographyTextView {
    func build() {
        configure()
        adjustFonts()
        adjustColors()
        adjustBreakpoint()
    }

    func configure() {
        adjustsFontForContentSizeCategory = true
        textContainerInset = .zero // Typography should provide sufficient insets
    }

    func restyleText() {
        if textSetMode == .text {
            styleText(text)
        } else {
            styleAttributedText(attributedText)
        }
    }

    func styleText(_ newValue: String!) {
        defer { invalidateIntrinsicContentSize() }
        guard let layout = layout,
              let newValue = newValue else {
            // We don't need to use attributed text
            super.attributedText = nil
            super.text = newValue
            return
        }

        // Set attributed text to match typography
        super.attributedText = layout.styleText(newValue, lineMode: lineMode)
    }

    func styleAttributedText(_ newValue: NSAttributedString?) {
        defer { invalidateIntrinsicContentSize() }
        guard let layout = layout,
              let newValue = newValue else {
            // We don't need any additional styling
            super.attributedText = newValue
            return
        }

        // Modify attributed text to match typography
        super.attributedText = layout.styleAttributedText(newValue, lineMode: lineMode)
    }

    /// Line mode (single or multi)
    var lineMode: Typography.LineMode {
        .multi(alignment: textAlignment, lineBreakMode: nil)
    }
}
