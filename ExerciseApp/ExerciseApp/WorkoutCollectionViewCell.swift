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
    
    func configure(with workout: WorkoutSession){
        typeLabel.text = workout.type
        distanceLabel.text = String(workout.getDistance())
        durationLabel.text = workout.getDuration()
        
    }
    
}
