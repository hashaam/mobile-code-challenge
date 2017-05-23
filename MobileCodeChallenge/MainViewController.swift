//
//  MainViewController.swift
//  MobileCodeChallenge
//
//  Created by Hashaam Siddiq on 5/23/17.
//  Copyright © 2017 Hashaam Siddiq. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, CoreDataStackProviding, ReachManagerProviding {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coreDataStack: CoreDataStack!
    var reachManager: ReachabilityManager!
    
    var profiles: [Profile]? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // display not reachable alert view
        displayNotReachableAlertView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // get data
        getData()
        
    }
    
    func displayNotReachableAlertView() {
        
        let reachable = reachManager.isReachable()
        
        if !reachable { UIApplication.shared.keyWindow?.showAlertView() }
        
    }
    
    func getData() {
        
        // load data
        loadData()
        
        // download data only if profile data is not in core data
        let profileCount = profiles?.count ?? 0
        if profileCount > 0 {
            return
        }
        
        let pp = ParseProfile(coreDataStack: coreDataStack, reachManager: reachManager) { [weak self] (result: JSONParseResult) in
            
            guard let strongSelf = self else { return }
            
            switch result {
            case .success:
                strongSelf.loadData()
                
            case .failure(let error):
                strongSelf.handleError(error: error)
            }
            
        }
        pp.fetch()
        
    }
    
    func loadData() {
        
        profiles = Profile.get(context: coreDataStack.viewContext)
        
    }
    
    func updateView() {
        
        collectionView.reloadData()
        
    }
    
    func handleError(error: Error?) {
        
        // TODO: Show alert view here to retry
        
    }
    
    func configure(cell: ProfileCollectionCell, atIndex index: Int) {
        
        guard let p = profiles?[index] else { return }
        
        cell.delegate = self
        
        let pi = ParseImage(coreDataStack: coreDataStack, reachManager: reachManager, imageView: cell.cellImageView, object: p, completionHandler: nil)
        pi.process()
        
        cell.imageOperationKey = pi.operationKey
        
        if p.isFavorite {
            cell.favoriteImageView.alpha = 1.0
        } else {
            cell.favoriteImageView.alpha = 0.0
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Detail" {
            
            guard let vc = segue.destination as? DetailViewController else { return }
            guard let ip = collectionView.indexPathsForSelectedItems?.last else { return }
            guard let profile = profiles?[ip.row] else { return }
            
            vc.coreDataStack = coreDataStack
            vc.reachManager = reachManager
            vc.profile = profile
            
        }
        
    }

}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Profile Collection Cell", for: indexPath) as! ProfileCollectionCell
        configure(cell: cell, atIndex: indexPath.row)
        return cell
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "Show Detail", sender: nil)
        
    }
    
}

extension MainViewController: CellViewModelDelegate {
    
    func cancelOperation(forKey: OperationKey) {
        
        reachManager.cancelOperation(withKey: forKey)
        
    }
    
}
