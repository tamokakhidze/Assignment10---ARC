//შექმენით ციკლური რეფერენცები და გაწყვიტეთ
//აუცილებელია ქლოჟერების გამოყენება
//აუცილებელია value და რეფერენს ტიების გამოყენება (კლასები, სტრუქტურები, ენამები და პროტოკოლები)
//აუცილებელია გამოიყენოთ strong, weak &unowned რეფერენსები ერთხელ მაინც
//დაიჭირეთ self ქლოჟერებში
//გატესტეთ მიღებული შედეგები ინსტანსების შექმნით და დაპრინტვით


class Person {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    var camera: Camera?
    
    deinit {
        print("ობიექტი \(name) დეინიციალიზდა\n")
    }
}

class Camera {
    let cameraName: String
    
    init(cameraName: String) {
        self.cameraName = cameraName
    }
    
    var owner: Person?
    
    deinit {
        print("ობიექტი \(cameraName) დეინიციალიზდა")
    }
}

//შექმენით ციკლური რეფერენცები და გაწყვიტეთ
//------------------------------------------
//strong რეფერენსების მაგალითი:

var person1: Person?
var camera1: Camera?

person1 = Person(name: "leo")
camera1 = Camera(cameraName: "Minolta")

//strong reference ციკლი
person1!.camera = camera1
camera1!.owner = person1

person1?.camera = nil
camera1?.owner = nil
person1 = nil //პირდაპირ ობიექტების განილებით არ დეინიციალიზდა, ჯერ მათი ფროფერთების განილება გახდა საჭირო და მერე თვითონ ობიექტების
camera1 = nil
//------------------------------------------


//მაგალითი weak რეფერენსით

class Racer {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    var car: Car?
    
    deinit {
        print("ობიექტი \(name) დეინიციალიზდა")
    }
}

class Car {
    let carName: String
    
    init(carName: String) {
        self.carName = carName
    }
    
    weak var owner: Racer? //owner-ზე რეფერენსი იქნება weak
    
    deinit {
        print("ობიექტი \(carName) დეინიციალიზდა\n")
    }
}


var racer1: Racer?
var car1: Car?

racer1 = Racer(name: "seb")
car1 = Car(carName: "rb-18")

racer1!.car = car1 //strong რეფერენსი
car1!.owner = racer1 //weak რეფერენსი

racer1 = nil //ობიექტი seb დეინიციალიზდა
car1 = nil //ობიექტი rb-18 დეინიციალიზდა



//მაგალითი სტრაქტით და ენამით

enum Block {
    case floor1, floor2, floor3
}
//class Apartment {
//    var number: Int
//    
//    init(number: Int) {
//        self.number = number
//    }
//    
//    var floorNumber: Block?
//    weak var buyer: Buyer?
//    
//}


struct Apartment {
    var number: Int
    var floorNumber: Block?
    var buyer: Buyer?
}

class Buyer {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    var apartment: Apartment?
    
    deinit {
        print("ობიექტი \(name) დეინიციალიზდა\n")
    }
}


var apartment1: Apartment?
var buyer: Buyer?
buyer = Buyer(name: "tt")


apartment1 = Apartment(number: 10)

apartment1!.floorNumber = Block.floor1
apartment1!.buyer = buyer
buyer!.apartment = apartment1

//roca structma miutita classze, aqac strong reference sheiqmna da sanam apartmentis buyer ar ganilda, buyer ar deinicializda
apartment1!.buyer = nil
//apartment1!.floorNumber = nil //structis enumze mimtiteblis(?) ganileba araa sachiro aq reference ar iqmeneba
//apartment1 = nil //magram tviton apartmentis ganileba ar gaxda sachiro

buyer!.apartment = nil //es sachiro gaxda tu struct apartments viyenebt, lets try to make it weak. update: 'weak' may only be applied to class and class-bound protocol types, not 'Apartment'. mere apartmentis classhi buyer weak ro gaxda imushava obvi.
buyer = nil

//------------------
//ობიექტი tt დეინიციალიზდა
//ობიექტი seb დეინიციალიზდა
//ობიექტი rb-18 დეინიციალიზდა
//ობიექტი Minolta დეინიციალიზდა
//ობიექტი leo დეინიციალიზდა
//deiniti bottom to top mimdinareobs(???)



//მაგალითი unowned რეფერენსით
//დაძღვევა მფლობელის გარეშე ვერ იარსებებს;


enum InsuranceCoverage {
    case halfCoverage, fullCoverage
}

class Insurance {
    var type: InsuranceCoverage
    unowned let owner: Patient
    init(type: InsuranceCoverage, owner: Patient) {
        self.type = type
        self.owner = owner
    }
    
    deinit {
        print("დაზღვევა დეინიციალიზდა")
    }
}

class Patient {
    let name: String
    
    init(name: String) {
        self.name = name
    }
    var insurance: Insurance?
    
    deinit {
        print("\nობიექტი \(name) დეინიციალიზდა\n")
    }
}

var patient1: Patient?
patient1 = Patient(name: "nana")
patient1!.insurance = Insurance(type: InsuranceCoverage.fullCoverage, owner: patient1!)
patient1 = nil


//მაგალითები ქლოჟერებით
//--------------------

//Reference to property 'name' in closure requires explicit use of 'self' to make capture semantics explicit. self შეგვიძლია capture ლისტში დავამატოთ

class Folder {
    var name: String
    var files: [String]?
    
    
    lazy var filesCount: () -> String = { [unowned self] in //ამ capture ლისტის გარეშე strong რეფერენსები იქმნება იმიტორო ქლოჟერიც კლასის მსგავსად რეფერენს ტიპია
        if let files = (self.files) {
            return "ფოლდერში '\(name)' არის \(files.count) ფაილი"
        }
        else {
            return "ფოლდერი \(name) ცარიელია"
        }
        
    }
    
    init(name: String, files: [String]? = nil) {
        self.name = name
        self.files = files
    }
    
    deinit {
        print("ფოლდერი \(name) დეინიციალიზდა\n")
    }

}
var folder: Folder? = Folder(name: "Photos")

print(folder!.filesCount())

folder?.files? += ["photo1"]
folder!.files = folder!.files ?? ["photo1"]
print(folder!.filesCount())

folder = nil //არ დეინიციალიზდა სანამ [unowned self] ქლოჟერების capture ლისტი არ გავუწერე


//ბეევრი რეფერენსი

class SpotifyUser {
    
    
    var username: String
    var likedSongs: [String]?
    weak var follower: SpotifyUser?
    weak var followingArtist: Artist?
    
    init(username: String) {
        self.username = username
    }
    
    lazy var likedSongsCount: () -> String = { [unowned self] in
        if let likedSongs = (self.likedSongs) {
            return "იუზერს \(username) აქვს მოწონებული \(likedSongs.count) სიმღერა"
        }
        else {
            return "იუზერს \(username) არ აქვს მოწონებული სიმღერები"
        }
        
    }
    
    weak var subscription: Subscription?
    weak var playlists: Playlists?
    
    deinit {
        print("იუზერი \(username) დეინიციალიზდა")
    }

    
}

class Artist {
    var name: String
    weak var follower: SpotifyUser?
    
    init(name: String) {
        self.name = name
    }
    
    
}

enum SubscriptionType {
    case freemium, premium
}

class Subscription {
    var subscriptionType: SubscriptionType
    unowned var user: SpotifyUser?
    
    init(subscriptionType: SubscriptionType) {
        self.subscriptionType = subscriptionType
    }
}


class Playlists {
    
    var name: String
    
    unowned var user: SpotifyUser? //იუზერის გარეშე ვერც ფლეილისტები იარსებებს და ვერც საბსქრიფშენი

    init(name: String) {
        self.name = name
    }
    
}

class Podcast {
    var name: String
    
    weak var followers: SpotifyUser?
    
    init(name: String){
        self.name = name
    }
    
    deinit {
        print("პოდკასტი \(name) დეინიციალიზდა")
    }
    
}

var user1: SpotifyUser? = SpotifyUser(username: "user1254678987654567898765435678123")
var user2: SpotifyUser? = SpotifyUser(username: "user9999999999999999999999")
user1!.likedSongs = ["gg"]
var podcast1: Podcast? = Podcast(name: "Podcast113")
podcast1!.followers = user1

print(user1!.likedSongsCount())
print(user2!.likedSongsCount())

var playlists = Playlists(name: "q")
var subscription = Subscription(subscriptionType: SubscriptionType.premium)
var artist1 = Artist(name: "rhcp")

playlists.user = user1
subscription.user = user1
artist1.follower = user1

user1!.playlists = playlists
user1!.subscription = subscription
user1!.followingArtist = artist1
user1!.follower = user2
user2!.follower = user1 //weak ro ar iyos ar deinicializdeba


user1 = nil
user2 = nil

