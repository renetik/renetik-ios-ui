extension UIView {

    @discardableResult
    @objc open func onClick(_ block: @escaping Func) -> Self {
        // We need this to cancel click when scrolling
        // but in xcode preview not working with noUpAfterChanged:true
        onTouch({ isDown in if !isDown { block() } },
            noUpAfterChanged: !CSEnvironment.isPreview && !CSEnvironment.isMac)
        return self
    }

    @discardableResult
    @objc open func onTap(_ block: @escaping Func) -> Self {
        interaction(enabled: true)
        addTapRecognizer(numberOfTouches: 1, numberOfTaps: 1) { block() }
        return self
    }

    @discardableResult
    @objc open func aspectFit() -> Self { contentMode = .scaleAspectFit; return self }

    @discardableResult
    @objc open func aspectFill() -> Self { contentMode = .scaleAspectFill; return self }
}

public extension UIView {

    @discardableResult
    func onLongPress(_ block: @escaping Func) -> Self {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer { _ in block() })
        return self
    }

    @discardableResult
    @objc func onTouch(_ block: @escaping ArgFunc<Bool>, noUpAfterChanged: Bool = false) -> Self {
        interaction(enabled: true)
        var ignoreUp = false
        let recognizer = UILongPressGestureRecognizer { recognizer in
            if recognizer.state == .began {
                block(true)
                ignoreUp = false
            }
            else if recognizer.state == .changed {
                if noUpAfterChanged { ignoreUp = true }
            }
            else if recognizer.state == .ended || recognizer.state == .cancelled {
                if !ignoreUp { block(false) }
            }
            logInfo(recognizer.state)
        }
        recognizer.minimumPressDuration = 0
        recognizer.delegate = recognizer.associated("delegate") { RecognizeSimultaneouslyWithAnyDelegate() }
        addGestureRecognizer(recognizer)
        return self
    }

    class RecognizeSimultaneouslyWithAnyDelegate: NSObject, UIGestureRecognizerDelegate {
        public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith
            otherGestureRecognizer: UIGestureRecognizer) -> Bool { true }
    }

    @discardableResult
    @objc func onTouchUp(_ block: @escaping Func) -> Self {
        onTouch { isDown in if !isDown { block() } }
    }

    @discardableResult
    @objc func onTouchDown(_ block: @escaping Func) -> Self {
        onTouch { isDown in if isDown { block() } }
    }

    @discardableResult
    func addTouchEffect(color: UIColor, fade: Bool = true,
        fadeDuration: TimeInterval = .defaultAnimation) -> Self {
        var originalBackground: UIColor!
        onTouch { [unowned self] isDown in
            if isDown {
                if backgroundColor.isNil { backgroundColor = .clear }
                originalBackground = backgroundColor
            }
            fade.isTrue { background(fadeTo: isDown ? color : originalBackground) }
                .elseDo { background(color: isDown ? color : originalBackground) }
        }
        return self
    }
}
