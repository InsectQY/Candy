//
//  UIViewControllerExt.swift
//  ExtensionX
//
//  Created by GorXion on 2018/5/2.
//

public extension UIViewController {

    func disablesAdjustScrollViewInsets(_ scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    func alert(title: String?,
               message: String?,
               preferredStyle: UIAlertController.Style = .alert,
               cancelTitle: String?,
               otherTitles: [String],
               completionHandler: @escaping (Int) -> Void) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        if let title = cancelTitle {
            alert.addAction(UIAlertAction(title: title, style: .cancel, handler: { (action) in
                completionHandler(0)
            }))
        }

        if !otherTitles.isEmpty {
            otherTitles.enumerated().forEach { (index, title) in
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action) in
                    completionHandler(index + 1)
                }))
            }
        }

        present(alert, animated: true, completion: nil)
    }

    func goBack(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard presentingViewController != nil else {
            navigationController?.popViewController(animated: animated)
            return
        }
        if let nav = navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
            return
        }
        dismiss(animated: animated, completion: completion)
    }
}
