//
//  ShowDetailsViewController.swift
//  LibX
//
//  Created by Lisa Fabien on 11/26/20.
//

import UIKit
import AlamofireImage
import JJFloatingActionButton

class ShowDetailsViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundImageTGR: UITapGestureRecognizer!
    
    var show : [String:Any]!
    var showAddButton : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDesign()
        
        //Floating action button
        if showAddButton {
            let actionButton = JJFloatingActionButton()

            actionButton.addItem(title: "Add Button", image: UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)) { item in
                self.performSegue(withIdentifier: "addSegue", sender: self)
            }
            actionButton.buttonColor = UIColor.systemTeal
            actionButton.display(inViewController: self)
            bottomConstraint.constant = 80
        } else {
            bottomConstraint.constant = 40
        }
    }
    
    func setDesign() {
        let title = show["name"] as? String ?? "N/A"
        let synopsis = show["overview"] as? String ?? "N/A"
        showTitleLabel.text = title
        synopsisLabel.text = synopsis
        
        //Movie poster
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        if let posterPath = show["poster_path"] as? String {
            let posterUrl = URL(string: baseUrl + posterPath)
            posterImage.af_setImage(withURL: posterUrl!)
            //Shadow
            posterImage.layer.masksToBounds = false
            posterImage.layer.shadowColor = UIColor.black.cgColor
            posterImage.layer.shadowOffset = .zero
            posterImage.layer.shadowOpacity = 0.7
            posterImage.layer.shadowRadius = 10
            posterImage.layer.shadowPath = UIBezierPath(rect: posterImage.bounds).cgPath
        }
        
        //Backdrop image
        if let backdropPath = show["backdrop_path"] as? String {
            let backdropUrl = URL(string: "https://image.tmdb.org/t/p/w780" + backdropPath)
            backgroundImage.af_setImage(withURL: backdropUrl!)
        }
    }

    @IBAction func didTapBackgroundImage(_ sender: Any) {
        performSegue(withIdentifier: "previewSegue", sender: backgroundImageTGR)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? NSObject == backgroundImageTGR {
            let previewViewController = segue.destination as! PreviewViewController
            previewViewController.item = show
            previewViewController.type = "show"
        } else {
            let addViewController = segue.destination as! AddViewController
            //Lets view controller know what item to add to list
            addViewController.item = show
            addViewController.type = "show"
        }
    }
    

}
