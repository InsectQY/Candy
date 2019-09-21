//
//  KingfisherExtension.swift
//

import UIKit
import Kingfisher

public extension UIImageView {

    func qy_setImage(_ URLString: String?,
                     placeholder: UIImage? = nil,
                     options: KingfisherOptionsInfo? = nil,
                     progressBlock: DownloadProgressBlock? = nil,
                     completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        kf.setImage(with: URL(string: URLString ?? ""), placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
}

public extension UIButton {

    func qy_setBackgroundImage(_ URLString: String?,
                               for state: UIControl.State,
                               placeholder: UIImage? = nil,
                               options: KingfisherOptionsInfo? = nil,
                               progressBlock: DownloadProgressBlock? = nil,
                               completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        kf.setBackgroundImage(with: URL(string: URLString ?? ""), for: state, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }

    func qy_setImage(_ URLString: String?,
                     for state: UIControl.State,
                     placeholder: UIImage? = nil,
                     options: KingfisherOptionsInfo? = nil,
                     progressBlock: DownloadProgressBlock? = nil,
                     completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) {
        kf.setImage(with: URL(string: URLString ?? ""), for: state, placeholder: placeholder, options: options, progressBlock: progressBlock, completionHandler: completionHandler)
    }
}
