//Estruturas e classes base do jogo
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

    func calcDmg() -> Int {
        let _chance = Int.random(in: 1...10)
        if _chance == 10 {
            print("Ataque crítico!")
            return weapon.attack * 2 // Critical hit
        }  else if _chance <= 2 {
            print("Ataque falhou!")
            return 0 // Miss
        } else {
            return weapon.attack + (Bool.random() ? -1 : 1) // Normal hit
        }
    }

    func levelUp() {
        level += 1
        maxHp += 10
        hp = maxHp
        printWaitClear("Parabéns! Você subiu para o nível \(level)!\nSeu HP máximo aumentou para \(maxHp).\n")
    }

}

struct Potion {
    var name: String
    var price: Int
    var healAmount: Int
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

    func calcDmg() -> Int {
        let _chance = Int.random(in: 1...10)
        if _chance == 10 {
            print("Ataque crítico!")
            return attack * 2 // Critical hit
        }  else if _chance <= 2 {
            print("Ataque falhou!")
            return 0 // Miss
        } else {
            return attack + (Bool.random() ? -1 : 1) // Normal hit
        }
    }
}

class Shop {
    var potions: [Potion] = potionList.map { $0.value }
    var weapons: [Weapon] = weaponList.map { $0.value }

    func buyPotion(potion: Potion, hero: inout BaseHero) {
        if hero.ouro < potion.price {
            printWaitClear("Você não tem ouro suficiente para comprar a \(potion.name).\n")
            return
        }
        potions.removeAll { $0.name == potion.name }
        hero.potions.append(potion)
        hero.ouro -= potion.price
    }

    func buyWeapon(weapon: Weapon, hero: inout BaseHero) {
        if hero.ouro < weapon.price {
            printWaitClear("Você não tem ouro suficiente para comprar a \(weapon.name).\n")
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

        let _chance = Int.random(in: 1...100)

        self.doors = Int.random(in: 1...3)

        // Chance de cada coisa ser gerada
        if _chance <= 60 {
            self.hasEnemy = true
            self.hasShop = false
        } else if _chance <= 80 {
            self.hasEnemy = false
            self.hasShop = true
        } else {
            self.hasEnemy = false
            self.hasShop = false
        }

        if self.hasEnemy {
            // Gerar inimigo baseado na sala
            // Usa o enemyList do main.swift
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