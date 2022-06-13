open class CSWindowSceneDelegate: UIResponder, UIWindowSceneDelegate {
    public var orientationChange: CSEvent<Void> {
        associated("orientationChange") { event() }
    }

    @discardableResult
    public func onOrientationChange(function: @escaping Func) -> CSRegistration {
        orientationChange.listen(function: function)
    }

    open func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        orientationChange.fire()
    }
}
