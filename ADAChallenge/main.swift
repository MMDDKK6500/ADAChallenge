import Foundation

func printWait(_ message: String) {
    print(message)
    _ = readLine()
}

// Listas base
let enemyList: [String: Enemy] = [
    "Smile": Enemy(name: "Slime", level: 1, hp: 25, attack: 6),
    "Goblin": Enemy(name: "Goblin", level: 2, hp: 30, attack: 6),
    "Esqueleto": Enemy(name: "Esqueleto", level: 3, hp: 35, attack: 7),
    "Aranha": Enemy(name: "Aranha", level: 4, hp: 40, attack: 8),
    "Zumbi": Enemy(name: "Zumbi", level: 5, hp: 40, attack: 9),
    "Orc": Enemy(name: "Orc", level: 6, hp: 45, attack: 10),
    "Troll": Enemy(name: "Troll", level: 7, hp: 60, attack: 11)
]

let weaponList: [String: Weapon] = [
    "Espada de Madeira": Weapon(name: "Espada de Madeira", attack: 7, price: 0),
    "Espada de Ferro": Weapon(name: "Espada de Ferro", attack: 12, price: 50),
    "Espada de Aço": Weapon(name: "Espada de Aço", attack: 19, price: 85),
    "Excalibur": Weapon(name: "Excalibur", attack: 30, price: 200)
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
    printWait("Saudações, \(hero.name)! Sua jornada começa agora.\n\n")
} else {
    printWait("Prefere ficar anônimo, isso mesmo? Sem problemas! Sua jornada será tão misteriosa quanto você. Sua jornada começa agora.\nPressione Enter para continuar...")
}


// História do jogo
printWait("O povo de Swiftsville vem reclamando de monstros invadindo o vilarejo e causando caos.")

printWait("A coroa real ofereceu uma recompensa para quem conseguir eliminar esses monstros.")

printWait("Será que você tem o que é preciso para salvar Swiftsville e se tornar o herói do vilarejo?")

printWait("Boa sorte, \(hero.name)!")

// Explicação do jogo
print("Explicação do jogo\n")
printWait("Você irá explorar uma certa quantidade de salas, cada sala pode conter inimigos, tesouros ou uma loja.\nDerrote inimigos para ganhar experiência e ouro, compre armas na loja para aumentar seu poder de ataque.\nTente sobreviver e chegar até a última sala, e dependendo do seu equipamento você talvez terá uma chance contra o rei dos monstros!\n\nPressione Enter para começar sua aventura...")

printWait("Você entra na masmorra que foi vista sendo utilizada como esconderijo para os monstros...\n")


// Sala atual e total de salas
var currRoomNum = 0
var currRoom: Room
var totalRooms = Int.random(in: 10...15)
//var totalRooms = 0


// i hate this
print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

// Gamplay Loop
repeat {
    currRoomNum += 1
    print("Você entrou na \(currRoomNum)º Sala.")
    currRoom = Room(hero.level)

    if currRoom.hasEnemy, var enemyInRoom = currRoom.enemy {
        print("Um \(enemyInRoom.name) apareceu!\n")

        repeat {
            print("\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))")
            print("\(enemyInRoom.name) - Lv: \(enemyInRoom.level) - HP: \(enemyInRoom.hp)\n")
            print("O que você deseja fazer?\n1. Atacar\n2. Usar Poção")
            
            if let action = readLine() {
                switch action {
                case "1":
                    // Heroi ataca
                    let damage = hero.calcDmg()
                    enemyInRoom.hp -= damage
                    print("\nVocê atacou o \(enemyInRoom.name) com sua \(hero.weapon.name), causando \(damage) de dano!")
                    
                    // Se inimigo ainda estiver vivo, ele contra-ataca
                    if enemyInRoom.hp > 0 {
                        let enemyDamage = enemyInRoom.calcDmg()
                        hero.hurt(enemyDamage)
                        print("O \(enemyInRoom.name) contra-atacou, causando \(enemyDamage) de dano!")
                        _ = readLine()
                    } else {
                        print("\n")
                    }
                    
                case "2":
                    if !hero.potions.isEmpty {
                        print("\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))\n")
                        print("Suas poções:")
                        for (index, potion) in hero.potions.enumerated() {
                            print("\(index + 1). \(potion.name) - Cura: \(potion.healAmount) HP")
                        }
                        print("Qual poção você deseja usar? (Digite o número correspondente ou '0' para voltar)")
                        if let potionChoice = readLine(), let potionIndex = Int(potionChoice), potionIndex > 0, potionIndex <= hero.potions.count {
                            hero.usarPocao(potionIndex)
                        } else {
                            print("Escolha inválida de poção.\n")
                        }
                    } else {
                            printWait("Você não tem poções!")
                    }
                    
                default:
                    print("Ação inválida. Tente novamente.\n")
                }
            }
        } while enemyInRoom.hp > 0 && hero.hp > 0

        if hero.hp <= 0 {
            printWait("Você foi derrotado pelo \(enemyInRoom.name). Fim de jogo.")
            break
        }

        print("Você derrotou o \(enemyInRoom.name)!\n")
        printWait("Você ganhou \(enemyInRoom.level * 10) XP e \(enemyInRoom.level * 5) ouro.")
        hero.addMoedas(enemyInRoom.level * 15)
        hero.addXP(enemyInRoom.level * 10)
    
    // SHOP LOGIC
    } else if currRoom.hasShop, let shop = currRoom.shop {
        printWait("Você encontrou uma loja!")

        var shopping = true

        repeat {
            print("\n\n\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))")
            print("Você tem \(hero.ouro) ouro.")
            print("O que você deseja comprar?\n1. Poções\n2. Armas\n3. Sair da loja")
            
            if let shopChoice = readLine() {
                switch shopChoice {
                    
                case "1":
                    
                    print("\nVocê tem \(hero.ouro) ouro.\n")
                    print("Suas poções:")
                    for (index, potion) in hero.potions.enumerated() {
                        print("\(index + 1). \(potion.name) - Cura: \(potion.healAmount) HP")
                    }
                    
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
                    
                    print("Você tem \(hero.ouro) ouro.\n")
                    print("Armas disponíveis:")
                    // listar armas disponíveis
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
                    print("Você saiu da loja.\n")
                    break
                    
                default:
                    print("Escolha inválida. Tente novamente.\n")
                }
            }
        } while shopping
    } else if currRoom.hasTreasure, let currTreasure = currRoom.treasure {
        print("Você achou um tesouro!")
        printWait("Você adiquiriu \(currTreasure.moedas) moedas e \(currTreasure.xp) de XP!")
        hero.addMoedas(currTreasure.moedas)
        hero.addXP(currTreasure.xp)
    } else {
        print("A sala está vazia. Você segue em frente.\n")
    }

    print("Pressione Enter para continuar...\n")
    _ = readLine()
    
    // i hate this too
    print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")

} while currRoomNum < totalRooms && hero.hp > 0

if hero.hp > 0 {
    // Chefe final

    print("Você observa a proxima sala pela porta, você vê um grande dragão, esperando pela sua chegada.")
    print("Ao seu lado, você vê uma loja de itens, gostaria de entrar antes de enfrentar o dragão?")
    print("1. Ir para a loja\n2. Ir para o dragão")

    //Loja do chefe final
    if let shopChoice = readLine() {
        switch (shopChoice) {
        case "1":
            var shopping = true
            let shop = Shop()

            repeat {
                print("\n\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))")
                print("Você tem \(hero.ouro) ouro.")
                print("O que você deseja comprar?\n1. Poções\n2. Armas\n3. Sair da loja")
                if let shopChoice = readLine() {
                    switch shopChoice {
                    case "1":
                        print("\nVocê tem \(hero.ouro) ouro.\n")
                        print("Suas poções:")
                        for (index, potion) in hero.potions.enumerated() {
                            print("\(index + 1). \(potion.name) - Cura: \(potion.healAmount) HP")
                        }
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
                        print("Você tem \(hero.ouro) ouro.\n")
                        print("Armas disponíveis:")
                        // listar armas disponíveis
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
                        printWait("Você saiu da loja, é melhor ter se preparado para o que há por vir...\n")
                        break
                        
                    default:
                        print("Escolha inválida. Tente novamente.\n")
                    }
                }
            } while shopping
            break
        default:
            break
        }
    }

    // var do chefe final
    var boss = Enemy(name: "Dragão, Rei dos Monstros", level: 10, hp: 80, attack: 12)

    printWait("Você entra na sala e se aproxima do dragão\nO momento a partir de agorá irá ditar se você será o heroi do vilarejo, ou apenas uma das tentativas inúteis de impedir os monstros")

    repeat {
        print("\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))")
        print("\(boss.name) - Lv: \(boss.level) - HP: \(boss.hp)\n")
        print("O que você deseja fazer?\n1. Atacar\n2. Usar Poção")
        
        if let action = readLine() {
            switch action {
            case "1":
                // Heroi ataca
                let damage = hero.calcDmg()
                boss.hp -= damage
                print("\nVocê atacou o \(boss.name) com sua \(hero.weapon.name), causando \(damage) de dano!")
                
                // Se inimigo ainda estiver vivo, ele contra-ataca
                if boss.hp > 0 {
                    let enemyDamage = boss.calcDmg()
                    hero.hurt(enemyDamage)
                    print("O \(boss.name) contra-atacou, causando \(enemyDamage) de dano!")
                    _ = readLine()
                } else {
                    print("\n")
                }
                
            case "2":
                if !hero.potions.isEmpty {
                    print("\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))\n")
                    print("Suas poções:")
                    for (index, potion) in hero.potions.enumerated() {
                        print("\(index + 1). \(potion.name) - Cura: \(potion.healAmount) HP")
                    }
                    print("Qual poção você deseja usar? (Digite o número correspondente ou '0' para voltar)")
                    if let potionChoice = readLine(), let potionIndex = Int(potionChoice), potionIndex > 0, potionIndex <= hero.potions.count {
                        hero.usarPocao(potionIndex)
                    } else {
                        print("Escolha inválida de poção.\n")
                    }
                } else {
                        printWait("Você não tem poções!")
                }
                
            default:
                print("Ação inválida. Tente novamente.\n")
            }
        }
    } while boss.hp > 0 && hero.hp > 0

    if hero.hp <= 0 {
        printWait("Você foi derrotado pelo \(boss.name) e apenas será lembrado como um fracassado que não conseguiu salvar o vilarejo. Fim de jogo.")
    }

    print("Você derrotou o rei dos monstros, parabens!\nVocê será sempre lembrado como o heroi do vilarejo")
    print("Stats finais:")
    printWait("\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))\n")

}
