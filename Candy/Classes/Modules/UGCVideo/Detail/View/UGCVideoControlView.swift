//
//  UGCVideoControlView.swift
//  Candy
//
//  Created by Insect on 2019/5/28.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit
import ZFPlayer

class UGCVideoControlView: View {

    weak var player: ZFPlayerController?

    var coverImageURL: String? {
        didSet {
            player?.currentPlayerManager.view.coverImageView.qy_setImage(coverImageURL)
        }
    }

    // MARK: - Lazyload
    private lazy var sliderView: ZFSliderView = {

        let sliderView = ZFSliderView()
        sliderView.maximumTrackTintColor = .white
        sliderView.minimumTrackTintColor = .white
        sliderView.sliderHeight = 2
        sliderView.isHideSliderBlock = false
        return sliderView
    }()

    private lazy var activity: ZFLoadingView = {
        let activity = ZFLoadingView()
        activity.lineWidth = 0.8
        activity.duration = 1
        activity.hidesWhenStopped = true
        return activity
    }()

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func makeUI() {
        super.makeUI()
        addSubview(activity)
        addSubview(sliderView)
        resetControlView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        activity.center = center
        activity.size = CGSize(width: 44,
                               height: 44)
        sliderView.frame = CGRect(x: 0,
                                  y: height - 2,
                                  width: width,
                                  height: 2)
    }

    func resetControlView() {
        sliderView.value = 0
        sliderView.bufferValue = 0
    }
}

extension UGCVideoControlView: ZFPlayerMediaControl {

    func videoPlayer(_ videoPlayer: ZFPlayerController, currentTime: TimeInterval, totalTime: TimeInterval) {
        sliderView.value = videoPlayer.progress
    }

    func videoPlayer(_ videoPlayer: ZFPlayerController, bufferTime: TimeInterval) {
        sliderView.bufferValue = videoPlayer.bufferProgress
    }

    func videoPlayer(_ videoPlayer: ZFPlayerController, loadStateChanged state: ZFPlayerLoadState) {
        if state == .stalled {
            activity.startAnimating()
        } else {
            activity.stopAnimating()
        }
    }
}
