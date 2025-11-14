import Foundation

// Listas base de inimigos e armas
let enemyList: [String: Enemy] = [
    "Goblin": Enemy(name: "Goblin", level: 1, hp: 30, attack: 5),
    "Esqueleto": Enemy(name: "Esqueleto", level: 2, hp: 40, attack: 8),
    "Orc": Enemy(name: "Orc", level: 5, hp: 50, attack: 10),
    "Zumbi": Enemy(name: "Zumbi", level: 6, hp: 60, attack: 15),
    "Troll": Enemy(name: "Troll", level: 7, hp: 80, attack: 20),
    "Dragão": Enemy(name: "Dragão", level: 10, hp: 150, attack: 25)
]

let weaponList: [String: Weapon] = [
    "Espada de Madeira": Weapon(name: "Espada de Madeira", attack: 10, price: 0),
    "Espada de Ferro": Weapon(name: "Espada de Ferro", attack: 20, price: 50),
    "Espada de Aço": Weapon(name: "Espada de Aço", attack: 35, price: 100),
    "Excalibur": Weapon(name: "Excalibur", attack: 50, price: 500)
]

// variavel do heroi
var hero = BaseHero(hp: 50, maxHp: 50, weapon: weaponList["Espada de Madeira"]!, level: 1, xp: 0, ouro: 50, potions: [])

// introdução do jogo
print("Bem-vindo aventureiro, como devo lhe chamar?")
if let inputName = readLine(), !inputName.isEmpty {
    hero.name = inputName
    print("Saudações, \(hero.name)! Sua jornada começa agora.\n\n")
} else {
    print("Prefere ficar anônimo, isso mesmo? Sem problemas! Sua jornada será tão misteriosa quanto você. Sua jornada começa agora.")
}


// História do jogo
print("O povo de Swiftsville vem reclamando de monstros invadindo o vilarejo e causando caos.\nPressione Enter para continuar...")
_ = readLine()

print("A coroa real ofereceu uma recompensa para quem conseguir eliminar esses monstros.")
_ = readLine()

print("Será que você tem o que é preciso para salvar Swiftsville e se tornar o herói do vilarejo?")
_ = readLine()

print("Boa sorte, \(hero.name)!\n")
_ = readLine()
print("\u{001B}[2J")


// Explicação do jogo
print("Explicação do jogo\n")
print("Você irá explorar uma certa quantidade de salas, cada sala pode conter inimigos, tesouros ou uma loja.\nDerrote inimigos para ganhar experiência e ouro, compre armas na loja para aumentar seu poder de ataque.\nTente sobreviver e chegar até a última sala, e dependendo do seu equipamento você talvez terá uma chance contra o rei dos monstros!\n\nPressione Enter para começar sua aventura...")
_ = readLine()
print("\u{001B}[2J")

print("Você entra na masmorra que foi vista sendo utilizada como esconderijo para os monstros...\n")
_ = readLine()
print("\u{001B}[2J")


// Sala atual e total de salas
var currRoomNum = 0
var currRoom: Room
var totalRooms = Int.random(in: 10...20)


// Gamplay Loop
repeat {
    print("\u{001B}[2J")
    currRoomNum += 1
    print("Você entrou na sala \(currRoomNum).\n")
    currRoom = Room(currRoom: currRoomNum, totalRooms: totalRooms)

    if currRoom.hasEnemy, var enemyInRoom = currRoom.enemy {
        print("Um \(enemyInRoom.name) apareceu!\n")
        _ = readLine()

        repeat {
            print("\u{001B}[2J")
            print("\(hero.name) - HP: \(hero.hp)/\(hero.maxHp) | Arma: \(hero.weapon.name) (Ataque: \(hero.weapon.attack))\n")
            print("\(enemyInRoom.name) - HP: \(enemyInRoom.hp)\n")
            print("O que você deseja fazer?\n1. Atacar\n2. Usar Poção\n")
            
            if let action = readLine() {
                switch action {
                case "1":
                    // Hero attacks
                    enemyInRoom.hp -= hero.weapon.attack
                    print("Você atacou o \(enemyInRoom.name) com sua \(hero.weapon.name), causando \(hero.weapon.attack) de dano!\n")
                    _ = readLine()
                    if enemyInRoom.hp > 0 {
                        // Enemy attacks back
                        hero.hp -= enemyInRoom.attack
                        print("O \(enemyInRoom.name) contra-atacou, causando \(enemyInRoom.attack) de dano!\n")
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
                            print("Você não tem poções!\n")
                    }
                    
                default:
                    print("Ação inválida. Tente novamente.\n")
                }
            }
        } while enemyInRoom.hp > 0 && hero.hp > 0

        if hero.hp <= 0 {
            print("Você foi derrotado pelo \(enemyInRoom.name). Fim de jogo.\n")
            break
        }

        print("Você derrotou o \(enemyInRoom.name)!\n")
        hero.xp += enemyInRoom.level * 10
        hero.ouro += enemyInRoom.level * 5
        print("Você ganhou \(enemyInRoom.level * 10) XP e \(enemyInRoom.level * 5) ouro.\n")
    }

    print("Pressione Enter para continuar...")
    _ = readLine()
    print("\u{001B}[2J")

} while currRoomNum < 10 && hero.hp > 0