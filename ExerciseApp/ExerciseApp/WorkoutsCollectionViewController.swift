//
//  WorkoutsCollectionViewController.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/31/21.
//

import UIKit

class WorkoutsCollectionViewController: UICollectionViewController {
    
    let dataSource: [WorkoutSession] = [WorkoutSession(), WorkoutSession()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(dataSource.count)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("hello")
    }
    
    
    
}
