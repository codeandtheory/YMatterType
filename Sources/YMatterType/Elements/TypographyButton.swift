//
//  TypographyButton.swift
//  YMatterType
//
//  Created by Mark Pospesel on 9/27/21.
//  Copyright © 2021 Y Media Labs. All rights reserved.
//

import UIKit

/// Button that supports `Typography`.
/// You can optionally set `maximumPointSize` or `maximumScaleFactor` to set a cap on Dynamic Type scaling.
open class TypographyButton: UIButton {
    /// The current typographical layout
    public private(set) var layout: TypographyLayout!

    /// Typography to be used for this buttons's title label
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

    /// Initializes a button using the specified `Typography`
    /// - Parameter typography: the font information to use
    required public init(typography: Typography) {
        self.typography = typography
        super.init(frame: .zero)
        build()
    }

    /// Initializes a button using the default Typography `Typography.systemButton`
    required public init?(coder: NSCoder) {
        self.typography = Typography.systemButton
        super.init(coder: coder)
        build()
    }

    private enum TextSetMode {
        case text
        case attributedText
    }

    private var textSetMode: TextSetMode = .text

    /// :nodoc:
    override public func setTitle(_ title: String?, for state: UIControl.State) {
        // When text is set, we may need to re-style it as attributedText
        // with the correct paragraph style to achieve the desired line height.
        textSetMode = .text
        styleText(title, for: state)
    }

    /// :nodoc:
    override public func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        // When text is set, we may need to re-style it as attributedText
        // with the correct paragraph style to achieve the desired line height.
        textSetMode = .attributedText
        styleAttributedText(title, for: state)
    }

    /// Gets or sets the text alignment of the button's title label.
    /// Default value = `.natural`
    public var textAlignment: NSTextAlignment = .natural {
        didSet {
            if textAlignment != oldValue {
                // Text alignment can be part of our paragraph style, so we may need to
                // re-style when changed
                restyleText()
            }
        }
    }

    /// Gets or sets the line break mode of the button's title label.
    /// Default value = `.byTruncatingTail`
    public var lineBreakMode: NSLineBreakMode = .byTruncatingTail {
        didSet {
            if lineBreakMode != oldValue {
                // Line break mode can be part of our paragraph style, so we may need to
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
        titleLabel?.font = layout.font
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

    /// :nodoc:
    override open var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else { return }
            buttonStateDidChange()
        }
    }

    /// :nodoc:
    override open var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }
            buttonStateDidChange()
        }
    }

    /// :nodoc:
    override open var isSelected: Bool {
        didSet {
            guard isSelected != oldValue else { return }
            buttonStateDidChange()
        }
    }

    /// :nodoc:
    override open var currentTitle: String? {
        if let title = super.currentTitle { return title }

        // Unlike UILabel, UITextField, and UITextView, when you set an attributed string to
        // UIButton, the plain version returns nil. Because we always use attributed strings
        // to render text properly, without this the following situation is possible:
        //     setTitle("Press Me", for: .normal)
        //     currentTitle == nil! // because internally we call super.setAttributedTitle(:, for:)
        return currentAttributedTitle?.string
    }

    // Marked as `internal` for unit test access only
    internal func buttonStateDidChange() {
        // This should be a no-op, but it's needed to force the attributed title
        // to redraw itself when button state changes
        setTitleColor(currentTitleColor, for: state)
        adjustFonts()
    }
}

private extension TypographyButton {
    func build() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
        configure()
        adjustFonts()
        adjustColors()
        adjustBreakpoint()
    }

    func configure() {
        setTitleColor(.label, for: .normal)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }

    @objc func contentSizeDidChange() {
        adjustFonts()
    }

    func restyleText() {
        styleAttributedText(currentAttributedTitle, for: state)
    }

    func styleText(_ newValue: String!, for state: UIControl.State) {
        defer { invalidateIntrinsicContentSize() }
        guard let layout = layout,
              let newValue = newValue else {
            // We don't need to use attributed text
            super.setAttributedTitle(nil, for: state)
            super.setTitle(newValue, for: state)
            return
        }

        // Set attributed text to match typography
        let attributedText = layout.styleText(newValue, lineMode: lineMode)
        super.setAttributedTitle(attributedText, for: state)
    }

    func styleAttributedText(_ newValue: NSAttributedString?, for state: UIControl.State) {
        defer { invalidateIntrinsicContentSize() }
        guard let layout = layout,
              let newValue = newValue else {
            // We don't need any additional styling
            super.setAttributedTitle(newValue, for: state)
            return
        }

        // Modify attributed text to match typography
        super.setAttributedTitle(
            layout.styleAttributedText(newValue, lineMode: lineMode),
            for: state
        )
    }

    /// Line mode (single or multi)
    var lineMode: Typography.LineMode {
        .multi(alignment: textAlignment, lineBreakMode: lineBreakMode)
    }
}
