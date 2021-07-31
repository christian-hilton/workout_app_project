//
//  WorkoutListViewController.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/30/21.
//

import Foundation
import UIKit

class WorkoutListViewController: UICollectionViewController {
    
    var workouts: [WorkoutSession]?
    
//    init(){
//
//    }
    
    

    
    
}

//extension WorkoutListViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return workouts?.count ?? 0
//    }
//
//
//
//    func tableView(_ tableView: UITableView,
//                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // Ask for a cell of the appropriate type.
//        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyleCell", for: indexPath)
//
//        // Configure the cell’s contents with the row and section number.
//        // The Basic cell style guarantees a label view is present in textLabel.
//        let data = currentWorkout?.getData()
//        let curData = data?[indexPath.row] ?? ("", 0.0)
//        cell.textLabel!.text = "\(curData.0) \(curData.1)"
//        return cell
//    }
//}

extension WorkoutListViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return workouts?.count ?? 0
    }
    
    override func collectionView(
      _ collectionView: UICollectionView,
      numberOfItemsInSection section: Int
    ) -> Int {
      return workouts?.count ?? 0 //TODO
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return nil
//    }
}

