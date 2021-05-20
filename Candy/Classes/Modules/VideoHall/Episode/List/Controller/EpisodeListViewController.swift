//
//  EpisodeListViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class EpisodeListViewController: VMCollectionViewController<RefreshViewModel> {

    fileprivate var item: EpisodePage?
    fileprivate var selIndex: Int = -1

    // MARK: - init
    init(page: EpisodePage, selIndex: Int) {
        item = page
        self.selIndex = selIndex
        super.init(collectionViewLayout: EpisodeListFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()

        collectionView.register(R.nib.episodeCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 20,
                                                   left: 8,
                                                   bottom: 20,
                                                   right: 8)
        collectionView.reloadData()
    }

    override func bindViewModel() {
        super.bindViewModel()

        NotificationCenter.default.rx
        .notification(Notification.clickEpisode)
        .asDriverOnErrorJustComplete()
        .map { $0.object as? Int }
        .filterNil()
        .drive(rx.selIndex)
        .disposed(by: rx.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource
extension EpisodeListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let item = item else { return 0 }
        return item.end - item.start
    }

    //  swiftlint:disable force_unwrapping
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.episodeCell.identifier,
                                                      for: indexPath,
                                                      cellType: EpisodeCell.self)
        cell.item = "\(item!.start + indexPath.item + 1)"
        cell.isSel = indexPath.item == selIndex - item!.start
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension EpisodeListViewController: UICollectionViewDelegate {

    //  swiftlint:disable force_unwrapping
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default
        .post(name: Notification.clickEpisode,
              object: item!.start + indexPath.item)
    }
}

extension Reactive where Base: EpisodeListViewController {

    var selIndex: Binder<Int> {

        return Binder(base) { vc, result in

            guard let item = vc.item else { return }
            // 点击的是其他页面(当前页面全部取消选中)
            vc.selIndex = (item.start...item.end).contains(result) ? result : -1
            vc.collectionView.reloadData()
        }
    }
}
