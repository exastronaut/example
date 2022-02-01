import UIKit

enum Accessories: String {
    case toning = "тонировка"
    case alarm = "сингнализация"
    case sportWheels = "спортивные диски"
    case medkit = "аптечка"
    case fireExtinguisher = "огнетушитель"
}

protocol CarProtocol {
    var model: String { get }
    var color: UIColor { get }
    var buildDate: (month: Int, year: Int) { get }
    var price: Double { get set }
    var accessories: [Accessories] { get set }
    var isServiced: Bool { get set }
}

protocol DealershipProtocol {
    var name: String { get }
    var showroomCapacity: Int { get }
    var stockCars: [CarProtocol] { get set }
    var showroomCars: [CarProtocol] { get set }
    var cars: [CarProtocol] { get set }

    func offerAccesories(_ : [Accessories])
    func presaleService(_ : inout CarProtocol)
    func addToShowroom(_ : inout CarProtocol)
    func sellCar(_ : inout CarProtocol)
    func orderCar()
}

protocol OrderCar {
    func orderCar()
}

class Generator {
    static func get() -> (color: UIColor, month: Int, year: Int) {
        let color: UIColor = [.orange, .blue, .brown, .darkGray, .red, .yellow, .white, .black].randomElement()!
        let month = Int.random(in: 1...12)
        let year = Int.random(in: 2019...2022)
        return (color, month, year)
    }
}

struct Car: CarProtocol {
    var model: String
    var color: UIColor
    var buildDate: (month: Int, year: Int)
    var price: Double
    var accessories: [Accessories] = []
    var isServiced: Bool = false
}

class Dealership: DealershipProtocol {
    var name: String
    var showroomCapacity: Int
    var stockCars: [CarProtocol] = []
    var showroomCars: [CarProtocol] = []
    var cars: [CarProtocol] {
        get {
            stockCars + showroomCars
        }
        set {
            stockCars = newValue
        }
    }

    init(nameDealer: String, capacity: Int) {
        name = nameDealer
        showroomCapacity = capacity
    }

    func offerAccesories(_ accessories: [Accessories]) {
        print("Предлагаем дополнительно приобрести:")
        accessories.forEach { item in
            print(item.rawValue)
        }
    }

    func presaleService(_ car: inout CarProtocol) {
        print("\(car.model) отправлена на предпродажную подготовку")
        car.isServiced = true
    }

    func addToShowroom(_ car: inout CarProtocol) {
        if showroomCars.count < showroomCapacity {
            stockCars.removeAll { $0.model == car.model }
            presaleService(&car)
            showroomCars.append(car)
            print("\(car.model) в шоуруме и готова к продаже")
        } else {
            print("Шоурум заполнен!")
        }
    }

    func sellCar(_ car: inout CarProtocol) {
        car.accessories
        if car.isServiced {
            if car.accessories.isEmpty {
                offerAccesories([.toning, .alarm, .sportWheels])
                car.accessories = [.toning, .alarm, .sportWheels]
                car.price += 200_000
            }
            print("\(car.model) продана за \(car.price) руб.")
            showroomCars.removeAll(where: { $0.model == car.model })
        } else {
            print("\(car.model) не готова к продаже!")
        }
    }
}

var dealerBMW = Dealership(nameDealer: "BMW", capacity: 5)

var bmw3 = Car(model: "x6", color: .red, buildDate: (6, 2020), price: 6_000_000.0)

extension Dealership: OrderCar {
    func orderCar() {
        print("Отправка запроса заводу на новый автомобиль...")
        let name = ["m5", "x6", "x5", "m3"].randomElement()!
        var price = 0.0
        switch name {
        case "x5", "x6":
            price = 6_000_000.0
        case "m3":
            price = 3_000_000.0
        case "m5":
            price = 4_000_000.0
        default:
            break
        }
        let newCar = Car(model: name, color: Generator.get().color, buildDate: (Generator.get().year, Generator.get().year), price: price)
        print("\(newCar.model) добавлена на парковку склада")
        stockCars.append(newCar)
    }
}

dealerBMW.orderCar()

