//
//  EpisodeListViewController.swift
//  QYNews
//
//  Created by Insect on 2019/1/10.
//  Copyright © 2019 Insect. All rights reserved.
//

import UIKit

class EpisodeListViewController: CollectionViewController {

    fileprivate var item: EpisodePage?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - init
    init(page: EpisodePage) {
        item = page
        super.init(collectionViewLayout: EpisodeListFlowLayout())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func makeUI() {
        super.makeUI()
        
        collectionView.register(cellType: EpisodeCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
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

        let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                      cellType: EpisodeCell.self)
        cell.item = "\(item!.start + indexPath.item + 1)"
        cell.isSel = indexPath.item == item!.selIndex - item!.start
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
            vc.item?.selIndex = (item.start...item.end).contains(result) ? result : -1
            vc.collectionView.reloadData()
        }
    }
}
