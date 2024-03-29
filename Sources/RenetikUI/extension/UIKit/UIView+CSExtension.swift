public extension UIView {

    @discardableResult
    func background(_ color: UIColor?) -> Self { invoke { backgroundColor = color } }

    @discardableResult
    func background(_ color: UIColor, opacity: CGFloat) -> Self {
        background(color.add(alpha: opacity))
    }

    @discardableResult
    func background(color: UIColor?, opacity: CGFloat = 1) -> Self {
        background(color?.add(alpha: opacity))
    }

    @discardableResult
    func interaction(enabled: Bool) -> Self { isUserInteractionEnabled = enabled; return self }

    @discardableResult
    func tint(color: UIColor) -> Self { tintColor = color; return self }

    @discardableResult
    func rotate(angle: CGFloat) -> Self { transform = CGAffineTransform(rotationAngle: angle); return self }

    @discardableResult
    func content(mode: UIView.ContentMode) -> Self { contentMode = mode; return self }

    @discardableResult
    func clipsToBounds(_ value: Bool = true) -> Self { clipsToBounds = value; return self }

    @discardableResult
    func asCircular() -> Self {
        aspectFill()
        layer.cornerRadius = width / 2
        layer.masksToBounds = true
        clipsToBounds = true
        return self
    }

    @discardableResult
    func roundedCorners(width: Int = 5) -> Self {
        layer.cornerRadius = CGFloat(width)
        layer.masksToBounds = true
        clipsToBounds = true
        return self
    }

    @discardableResult
    func clipToBounds() -> Self { clipsToBounds = true; return self }

    @discardableResult
    func border(width: CGFloat = 1, color: UIColor = .darkGray, radius: CGFloat = 3) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.cornerRadius = radius
        layer.masksToBounds = true
        clipsToBounds = true
        return self
    }

    func clone() -> Self {
        try! NSKeyedUnarchiver.unarchivedObject(ofClass: Self.self,
            from: try! NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false))!
        //        NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! Self
    }

    var firstResponder: UIView? {
        for view in subviews {
            if view.isFirstResponder { return view }
            let childFirstResponder = view.firstResponder
            if childFirstResponder.notNil { return childFirstResponder }
        }
        return nil
    }

    @discardableResult
    func background(fadeTo color: UIColor?, duration: TimeInterval = .defaultAnimation) -> Self {
        if backgroundColor == color { return self }
        if let color = color {
            CATransaction.flush()
            CATransaction.begin()
            let animationKey = "background(fadeTo color"
            let keyPath = "backgroundColor"
            var fromValue: CGColor? = backgroundColor?.cgColor
            if layer.animation(forKey: animationKey) != nil {
                fromValue = (layer.presentation()?.value(forKeyPath: keyPath) as! CGColor)
                layer.removeAnimation(forKey: animationKey)
            }
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = fromValue
            animation.toValue = color.cgColor
            animation.duration = duration
            layer.add(animation, forKey: animationKey)
            CATransaction.commit()
        }
        backgroundColor = color
        return self
    }

    @discardableResult
    func fadeToggle() -> Self { (isVisible && alpha == 1).then { fadeOut() }.elseDo { fadeIn() }; return self }

    @discardableResult
    func fadeTo(visible: Bool) -> Self { visible.isTrue { fadeIn() }.elseDo { fadeOut() }; return self }

    func fadeIn(duration: TimeInterval = .defaultAnimation, onDone: Func? = nil) {
        if isVisible && alpha == 1 { onDone?(); return }
        show()
        UIView.animate(withDuration: duration, delay: 0,
            options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState],
            animations: { [unowned self] in alpha = 1 },
            completion: { _ in onDone?() })
    }

    func fadeOut(duration: TimeInterval = .defaultAnimation, onDone: Func? = nil) {
        if isHidden || alpha == 0 { onDone?(); return }
        UIView.animate(withDuration: duration, delay: 0,
            options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState],
            animations: { [unowned self] in alpha = 0 },
            completion: { [unowned self] isFinished in if isFinished { alpha = 1; hide() }; onDone?() })
    }

    @discardableResult
    func background4(dashed color: UIColor, stroke: NSNumber, gap: NSNumber) -> Self {
        clipsToBounds()
        let shapeLayer = CAShapeLayer()

        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [stroke, gap]

        let path = CGMutablePath()
        let point1 = CGPoint(x: frame.minX, y: bounds.midY)
        let point2 = CGPoint(x: frame.maxX, y: bounds.midY)
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
        return self
    }

    func data(_ value: Any) -> Self {
        associatedDictionary["UIView+CSExtension.model"] = value
        return self
    }

    func data() -> Any? { associatedDictionary["UIView+CSExtension.model"] }

    func addTapRecognizer(numberOfTouches: Int, numberOfTaps: Int, handler: @escaping Func) {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTouchesRequired = numberOfTouches
        recognizer.numberOfTapsRequired = numberOfTaps
        recognizer.add(action: { _ in handler() })
        addGestureRecognizer(recognizer)
    }

    @objc var isEmpty: Bool { subviews.isEmpty }

    var controller: UIViewController? {
        var responder: UIResponder? = self.next
        while responder != nil {
            if let controller = responder as? UIViewController { return controller }
            responder = responder?.next
        }
        return nil
    }

    var navigation: UINavigationController? { controller?.navigation }
}
