//
//  WorkoutsCollectionViewController.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/31/21.
//

import UIKit

class WorkoutsCollectionViewController: UICollectionViewController {
    
    var dataSource: [WorkoutSession] = [WorkoutSession(), WorkoutSession()]
    var delegate: MainViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let nameCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? WorkoutCollectionViewCell {
            nameCell.configure(with: dataSource[indexPath.row])
            cell = nameCell
        }
        return cell
    }
    
    // Unused, clicking cell to view more
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func reload() {
        dataSource = delegate?.getWorkoutData() ?? []
        collectionView.reloadData()
    }
}
