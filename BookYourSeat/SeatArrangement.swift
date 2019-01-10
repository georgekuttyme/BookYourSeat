//
//  SeatArrangement.swift
//  BookYourSeat
//
//  Created by George on 1/10/19.
//  Copyright © 2019 Georgekutty. All rights reserved.
//

import UIKit

class SeatArrangement: UIViewController,SeatSelectorDelegate {
    
    var selected_seat_limit:Int = 0
    var selectedSeats:[String] = []
    
    @IBOutlet weak var lblCost: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retriveDataFromDB()

    }
    
    func retriveDataFromDB() {
        let seatDetails:[[String:String]] = DataManagement.retrieveData() as! [[String : String]]
        let seats = SeatSelector()
        seats.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 500)
        seats.selected_seat_limit = selected_seat_limit
        seats.spcaePerRow = 10
        seats.setSeatMap(seatDetails)
        seats.seatSelectorDelegate = self
        self.view.addSubview(seats)
    }
    
    
    func seatSelected(_ seat: Seat) {
        //print("Seat at row: \(seat.row) and column: \(seat.column)\n")
    }
    
    func getSelectedSeats(_ seats: NSMutableArray) {
        var total:Float = 0.0;
         selectedSeats = []
        for i in 0..<seats.count {
            let seat:Seat  = seats.object(at: i) as! Seat
            print("Seat at row: \(seat.row) and column: \(seat.column)\n")
            total += seat.price
            selectedSeats.append(seat.id)
        }
         self.lblCost.text = "Total Price : "+String(total)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {

        if selectedSeats.count > 0 {
            for id in selectedSeats {
                DataManagement.updateData(seatStatus: "S", id: id)
            }
            self.dispAlert(alertStr :"Your Seat Suceessfully Booked. Thank you." , alertTitle : "success")
        }
        else
        {
            self.dispAlert(alertStr :"Please select your Seat" , alertTitle : "Alert!")
        }        
    }
    
}
