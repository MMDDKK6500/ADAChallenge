struct Potion {
    var name: String
    var price: Int
    var healAmount: Int
}

//Estruturas base do jogo
class BaseHero {
    var name: String = "Anônimo"
    var hp: Int
    var maxHp: Int
    var weapon: Weapon
    var level: Int
    var xp: Int
    var ouro: Int
    var potions: [Potion]

    init(hp: Int, maxHp: Int, weapon: Weapon, level: Int, xp: Int, ouro: Int, potions: [Potion]) {
        self.hp = hp
        self.maxHp = maxHp
        self.weapon = weapon
        self.level = level
        self.xp = xp
        self.ouro = ouro
        self.potions = potions
    }
}

struct Weapon {
    var name: String
    var attack: Int
    var price: Int
}

struct Enemy {
    var name: String
    var level: Int
    var hp: Int
    var attack: Int
}

class Shop {
    var potions: [Potion]
    var weapons: [Weapon]

    init() {
        potions = [
            Potion(name: "Poção Pequena", price: 10, healAmount: 20),
            Potion(name: "Poção Média", price: 25, healAmount: 50),
            Potion(name: "Poção Grande", price: 50, healAmount: 100)
        ]
        weapons = [
            Weapon(name: "Espada de Madeira", attack: 10, price: 0),
            Weapon(name: "Espada de Ferro", attack: 20, price: 50),
            Weapon(name: "Espada de Aço", attack: 35, price: 100),
            Weapon(name: "Excalibur", attack: 50, price: 500)
        ]
    }

    func buyPotion(potion: Potion, hero: inout BaseHero) {
        if hero.ouro < potion.price {
            print("Você não tem ouro suficiente para comprar a \(potion.name).\n")
            return
        }
        potions.removeAll { $0.name == potion.name }
        hero.potions.append(potion)
        hero.ouro -= potion.price
    }

    func buyWeapon(weapon: Weapon, hero: inout BaseHero) {
        if hero.ouro < weapon.price {
            print("Você não tem ouro suficiente para comprar a \(weapon.name).\n")
            return
        }
        weapons.removeAll { $0.name == weapon.name }
        hero.ouro -= weapon.price
        hero.weapon = weapon
    }
}

struct Room {
    var doors: Int
    var hasEnemy: Bool
    var hasShop: Bool
    var enemy: Enemy? = nil
    var shop: Shop? = nil

    init(currRoom: Int, totalRooms: Int) {
        self.doors = Int.random(in: 1...3)

        self.hasEnemy = Bool.random()
        self.hasShop = !self.hasEnemy && Bool.random() && currRoom != totalRooms

        if self.hasEnemy {
            let enemyNames = Array(enemyList.keys)
            let isLaterRoom = currRoom > totalRooms / 2
            let filteredEnemyNames = isLaterRoom ? enemyNames.filter { enemyList[$0]!.level >= 5 } : enemyNames.filter { enemyList[$0]!.level < 5 }
            let enemyNamesToChooseFrom = filteredEnemyNames.isEmpty ? enemyNames : filteredEnemyNames
            let randomEnemyName = enemyNamesToChooseFrom.randomElement()!
            self.enemy = enemyList[randomEnemyName]
        } else if self.hasShop {
            self.shop = Shop()
        }
    }
}

// Se der tempo de fazer isso depois
/*
struct doorOptions {
    var left: Bool
    var right: Bool
    var forward: Bool
}
*/