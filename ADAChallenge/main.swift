import Foundation

func printWaitClear(_ message: String) {
    print(message)
    _ = readLine()
    print("\u{001B}[2J")
}

// Listas base
let enemyList: [String: Enemy] = [
    "Goblin": Enemy(name: "Goblin", level: 1, hp: 25, attack: 5),
    "Esqueleto": Enemy(name: "Esqueleto", level: 2, hp: 35, attack: 7),
    "Orc": Enemy(name: "Orc", level: 5, hp: 50, attack: 10),
    "Zumbi": Enemy(name: "Zumbi", level: 6, hp: 60, attack: 15),
    "Troll": Enemy(name: "Troll", level: 7, hp: 80, attack: 20),
    "Dragão": Enemy(name: "Dragão", level: 10, hp: 100, attack: 25)
]

let weaponList: [String: Weapon] = [
    "Espada de Madeira": Weapon(name: "Espada de Madeira", attack: 7, price: 0),
    "Espada de Ferro": Weapon(name: "Espada de Ferro", attack: 15, price: 50),
    "Espada de Aço": Weapon(name: "Espada de Aço", attack: 30, price: 90),
    "Excalibur": Weapon(name: "Excalibur", attack: 50, price: 300)
]

let potionList: [String: Potion] = [
    "Poção Pequena": Potion(name: "Poção Pequena", price: 10, healAmount: 10),
    "Poção Média": Potion(name: "Poção Média", price: 25, healAmount: 20),
    "Poção Grande": Potion(name: "Poção Grande", price: 50, healAmount: 50)
]

// variavel do heroi
var hero = BaseHero(hp: 30, maxHp: 30, weapon: weaponList["Espada de Madeira"]!, level: 1, xp: 0, ouro: 50, potions: [potionList["Poção Pequena"]!])

// introdução do jogo
print("Bem-vindo aventureiro, como devo lhe chamar?")
if let inputName = readLine(), !inputName.isEmpty {
    hero.name = inputName
    printWaitClear("Saudações, \(hero.name)! Sua jornada começa agora.\n\n")
} else {
    printWaitClear("Prefere ficar anônimo, isso mesmo? Sem problemas! Sua jornada será tão misteriosa quanto você. Sua jornada começa agora.\nPressione Enter para continuar...")
}


// História do jogo
printWaitClear("O povo de Swiftsville vem reclamando de monstros invadindo o vilarejo e causando caos.")

printWaitClear("A coroa real ofereceu uma recompensa para quem conseguir eliminar esses monstros.")

printWaitClear("Será que você tem o que é preciso para salvar Swiftsville e se tornar o herói do vilarejo?")

printWaitClear("Boa sorte, \(hero.name)!")

// Explicação do jogo
print("Explicação do jogo\n")
printWaitClear("Você irá explorar uma certa quantidade de salas, cada sala pode conter inimigos, tesouros ou uma loja.\nDerrote inimigos para ganhar experiência e ouro, compre armas na loja para aumentar seu poder de ataque.\nTente sobreviver e chegar até a última sala, e dependendo do seu equipamento você talvez terá uma chance contra o rei dos monstros!\n\nPressione Enter para começar sua aventura...")

printWaitClear("Você entra na masmorra que foi vista sendo utilizada como esconderijo para os monstros...\n")


// Sala atual e total de salas
var currRoomNum = 0
var currRoom: Room
var totalRooms = Int.random(in: 10...20)


// Gamplay Loop
repeat {
    print("\u{001B}[2J")
    currRoomNum += 1
    print("Você entrou na \(currRoomNum)º Sala.\n")
    currRoom = Room(currRoom: currRoomNum, totalRooms: totalRooms)

    if currRoom.hasEnemy, var enemyInRoom = currRoom.enemy {
        print("Um \(enemyInRoom.name) apareceu!\n")
        _ = readLine()

        repeat {
            print("\u{001B}[2J")
            print("\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))\n")
            print("\(enemyInRoom.name) - Lv: \(enemyInRoom.level) - HP: \(enemyInRoom.hp)\n")
            print("O que você deseja fazer?\n1. Atacar\n2. Usar Poção\n")
            
            if let action = readLine() {
                switch action {
                case "1":
                    print("\u{001B}[2J") // clear screen
                    // Heroi ataca
                    let damage = hero.calcDmg()
                    enemyInRoom.hp -= damage
                    print("Você atacou o \(enemyInRoom.name) com sua \(hero.weapon.name), causando \(damage) de dano!\n")
                    _ = readLine()
                    if enemyInRoom.hp > 0 {
                        // Inimigo contra-ataca
                        let enemyDamage = enemyInRoom.calcDmg()
                        hero.hp -= enemyDamage
                        print("O \(enemyInRoom.name) contra-atacou, causando \(enemyDamage) de dano!\n")
                        _ = readLine()
                    }
                    
                case "2":
                    if !hero.potions.isEmpty {
                            print("Suas poções:")
                            for (index, potion) in hero.potions.enumerated() {
                                print("\(index + 1). \(potion.name) - Cura: \(potion.healAmount) HP")
                            }
                            print("Qual poção você deseja usar? (Digite o número correspondente)")
                            if let potionChoice = readLine(), let potionIndex = Int(potionChoice), potionIndex > 0, potionIndex <= hero.potions.count {
                                let potion = hero.potions[potionIndex - 1]
                                hero.hp += potion.healAmount
                                if hero.hp > hero.maxHp {
                                    hero.hp = hero.maxHp
                                }
                                hero.potions.remove(at: potionIndex - 1)
                                print("Você usou uma \(potion.name) e recuperou \(potion.healAmount) de HP!\n")
                            } else {
                                print("Escolha inválida de poção.\n")
                            }
                        } else {
                            printWaitClear("Você não tem poções!\n")
                    }
                    
                default:
                    print("Ação inválida. Tente novamente.\n")
                }
            }
        } while enemyInRoom.hp > 0 && hero.hp > 0

        if hero.hp <= 0 {
            printWaitClear("Você foi derrotado pelo \(enemyInRoom.name). Fim de jogo.\n")
            break
        }

        print("Você derrotou o \(enemyInRoom.name)!\n")
        hero.xp += enemyInRoom.level * 5
        hero.ouro += enemyInRoom.level * 10
        printWaitClear("Você ganhou \(enemyInRoom.level * 10) XP e \(enemyInRoom.level * 5) ouro.\n")
        if hero.xp >= hero.level * 20 {
            hero.levelUp()
        }
    } else if currRoom.hasShop, let shop = currRoom.shop {
        printWaitClear("Você encontrou uma loja!\n")

        var shopping = true

        repeat {
            print("Você tem \(hero.ouro) ouro.\n")
            print("O que você deseja comprar?\n1. Poções\n2. Armas\n3. Sair da loja\n")
            if let shopChoice = readLine() {
                print("\u{001B}[2J")
                switch shopChoice {
                case "1":
                    print("Poções disponíveis:")
                    for (index, potion) in shop.potions.enumerated() {
                        print("\(index + 1). \(potion.name) - Preço: \(potion.price) ouro - Cura: \(potion.healAmount) HP")
                    }
                    print("Digite o número da poção que deseja comprar ou '0' para voltar:")
                    if let potionChoice = readLine(), let potionIndex = Int(potionChoice), potionIndex > 0, potionIndex <= shop.potions.count {
                        let potion = shop.potions[potionIndex - 1]
                        shop.buyPotion(potion: potion, hero: &hero)
                    }
                    
                case "2":
                    print("Armas disponíveis:")
                    for (index, weapon) in shop.weapons.enumerated() {
                        print("\(index + 1). \(weapon.name) - Preço: \(weapon.price) ouro - Ataque: \(weapon.attack)")
                    }
                    print("Digite o número da arma que deseja comprar ou '0' para voltar:")
                    if let weaponChoice = readLine(), let weaponIndex = Int(weaponChoice), weaponIndex > 0, weaponIndex <= shop.weapons.count {
                        let weapon = shop.weapons[weaponIndex - 1]
                        shop.buyWeapon(weapon: weapon, hero: &hero)
                    }
                    
                case "3":
                    shopping = false
                    printWaitClear("Você saiu da loja.\n")
                    
                default:
                    print("Escolha inválida. Tente novamente.\n")
                }
            }
        } while shopping
    } else {
        print("A sala está vazia. Você segue em frente.\n")
    }

    print("Pressione Enter para continuar...")
    _ = readLine()
    print("\u{001B}[2J")

} while currRoomNum < 10 && hero.hp > 0
