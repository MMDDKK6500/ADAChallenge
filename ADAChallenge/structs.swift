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
        let _chance = Int.random(in: 1...20)
        if _chance == 20 {
            print("Ataque crítico!")
            return weapon.attack * 2 // Critical hit
            
        }  else if _chance == 1 {
            print("Ataque falhou!")
            return 0 // Miss
            
        } else {
            return weapon.attack + (Bool.random() ? -1 : 1) // Normal hit
        }
    }
    
    func setMaxHP(_ maxHP: Int) {
        self.maxHp = maxHP
        setHP((maxHP / 2) + hp - 5)
    }
    
    func addHP(_ hp: Int) {
        self.hp += hp
        if self.hp > self.maxHp {
            self.setHP(self.maxHp)
        }
    }
    
    func setHP(_ hp: Int) {
        self.hp = hp
    }
    
    func addXP(_ xp: Int) {
        self.xp += xp
        if self.xp >= self.level * 15 {
            self.levelUp()
        }
    }
    
    func addMoedas(_ moedas: Int) {
        self.ouro += moedas
    }
    
    func usarPocao(_ potionIndex: Int) {
        let potion = self.potions[potionIndex - 1]
        self.addHP(potion.healAmount)
        self.potions.remove(at: potionIndex - 1)
        printWait("Você usou uma \(potion.name) e recuperou \(potion.healAmount) de HP!\n")
    }
    
    func hurt(_ amount: Int) {
        self.hp -= amount
    }
    
    func levelUp() {
        level += 1
        setMaxHP(maxHp + 10)
        printWait("Parabéns! Você subiu para o nível \(level)!\nSeu HP máximo aumentou para \(maxHp).\n")
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
        let _chance = Int.random(in: 1...20)
        if _chance == 20 {
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
            printWait("Você não tem ouro suficiente para comprar a \(potion.name).\n")
            return
        }
        
        potions.removeAll { $0.name == potion.name }
        hero.potions.append(potion)
        hero.ouro -= potion.price
        printWait("Você comprou a poção de \(potion.name)")
    }

    func buyWeapon(weapon: Weapon, hero: inout BaseHero) {
        if hero.ouro < weapon.price {
            printWait("Você não tem ouro suficiente para comprar a \(weapon.name).\n")
            return
        }
        
        weapons.removeAll { $0.name == weapon.name }
        hero.ouro -= weapon.price
        hero.weapon = weapon
        printWait("Você comprou a \(weapon.name)")
    }
}

struct Room {
    var hasEnemy: Bool
    var hasShop: Bool
    var hasTreasure: Bool
    var enemy: Enemy? = nil
    var shop: Shop? = nil
    var treasure: Treasure? = nil

    init(_ heroLevel: Int) {

        let _chance = Int.random(in: 1...100)

        // Chance de cada coisa ser gerada
        if _chance <= 60 {
            self.hasEnemy = true
            self.hasTreasure = false
            self.hasShop = false
        } else if _chance <= 95 {
            self.hasEnemy = false
            self.hasTreasure = false
            self.hasShop = true
        } else {
            self.hasEnemy = false
            self.hasShop = false
            self.hasTreasure = true
        }

        if self.hasEnemy {
            // Gerar inimigo baseado na sala
            // Usa o enemyList do main.swift
            let enemyNames = Array(enemyList.keys)
            let filteredEnemyNames = enemyNames.filter { enemyList[$0]!.level == heroLevel + 1 || enemyList[$0]!.level == heroLevel - 1 || enemyList[$0]!.level == heroLevel }
            let enemyNamesToChooseFrom = filteredEnemyNames.isEmpty ? enemyNames : filteredEnemyNames
            let randomEnemyName = enemyNamesToChooseFrom.randomElement()!
            self.enemy = enemyList[randomEnemyName]
            
        } else if self.hasShop {
            
            self.shop = Shop()
            
        } else {
            
            self.treasure = Treasure()
            
        }
    }
}

struct Treasure {
    var xp: Int
    var moedas: Int
    
    init () {
        self.xp = Int.random(in: 10...20)
        self.moedas = Int.random(in: 20...50)
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
