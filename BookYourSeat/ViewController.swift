//
//  ViewController.swift
//  BookYourSeat
//
//  Created by Georgekutty on 10/01/19.
//  Copyright © 2019 Georgekutty. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet weak var txtCount: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard (UserDefaults.standard.string(forKey: "dataBaseCreated") != nil) else {
            UserDefaults.standard.set("Yes", forKey: "dataBaseCreated")
            DataManagement.createData(data: staticData.seatDetails)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtCount.text = ""
    }
    
    @IBAction func chooseSeat(_ sender: Any) {
        let count:Int = Int(txtCount.text ?? "0") ?? 0
        if count < 7 && count > 0   {
            let seatsVies:SeatArrangement = SeatArrangement(nibName: "SeatArrangement", bundle: nil) as SeatArrangement
            seatsVies.selected_seat_limit = count
            self.present(seatsVies, animated: true, completion: nil)
        }
      self.dispAlert(alertStr :"Please eneter numer of Seats in between 1-8" , alertTitle : "Alert!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

