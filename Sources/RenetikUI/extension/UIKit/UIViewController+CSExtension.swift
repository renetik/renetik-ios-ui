//
//  UIViewController+CSExtension.swift
//  Renetik
//
//  Created by Rene Dohan on 2/19/19.
//

import UIKit

public extension UIViewController {

    var window: UIWindow? {
//        get { weakAssociated("window") }
//        set { weakAssociate("window", newValue) }
        view.window
    }

    var screen: CSScreen {
        view.screen
    }

    var navigation: UINavigationController? {
        controllerInNavigation?.parent as? UINavigationController
    }

    func push() -> Self {
        navigation?.push(self)
        return self
    }

    @discardableResult
    func pushAsLast() -> Self {
        navigation?.pushAsLast(self)
        return self
    }

    @discardableResult
    func push(key: String) -> Self {
        navigation?.push(key, self)
        return self
    }

    @discardableResult
    func pushMain() -> Self {
        push(key: "mainController")
        return self
    }

    @discardableResult
    func pushFromTop() -> Self {
        navigation?.push(fromTop: self)
        return self
    }

    @discardableResult
    func present(from element: CSDisplayElement) -> Self {
        element.view.notNil { present(from: $0) }
        element.item.notNil { present(from: $0) }
        return self
    }

    @discardableResult
    func present(from view: UIView) -> Self {
        modalPresentationStyle = .popover
        popoverPresentationController?.sourceView = view.superview
        popoverPresentationController?.sourceRect = view.frame
        present()
        return self
    }

    @discardableResult
    func present(from item: UIBarButtonItem) -> Self {
        modalPresentationStyle = .popover
        popoverPresentationController?.barButtonItem = item
        present()
        return self
    }

    @discardableResult
    func present() -> Self {
        navigation?.last!.present(self, animated: true, completion: nil)
        return self
    }

    var isDarkMode: Bool {
        if #available(iOS 12, *) { return traitCollection.isDarkMode }
        else { return false }
    }

    var controllerInNavigation: UIViewController? {
        var controller: UIViewController? = self
        while controller.notNil && !(controller!.parent is UINavigationController) {
            controller = controller!.parent
        }
        return controller
    }

    var isLastInNavigation: Bool { navigation?.last == self }

    @discardableResult
    func backButtonWithoutPreviousTitle() -> Self {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        return self
    }

    @discardableResult
    func backButtonTitle(_ title: String?) -> Self {
        navigationItem.backBarButtonItem?.title = title; return self
    }

    @discardableResult
    func present(_ modalViewController: UIViewController) -> Self {
        present(modalViewController, animated: true); return self
    }

    @discardableResult
    func dismiss() -> Self { dismiss(animated: true); return self }

    @discardableResult
    func updateLayout() -> Self { view.setNeedsLayout(); return self }
}
