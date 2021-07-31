//
//  WorkoutCollectionViewCell.swift
//  ExerciseApp
//
//  Created by Christian Hilton on 7/31/21.
//

import UIKit

class WorkoutCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    
    // remove
    func configure(with name: String){
        typeLabel.text = name
    }
    
    func configure(with workout: WorkoutSession){
        typeLabel.text = workout.type
        distanceLabel.text = String(workout.distance)
        durationLabel.text = String(workout.duration)
        
    }
    
    //
    
}
