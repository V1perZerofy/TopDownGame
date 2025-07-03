# Whispers of the Hollow

A modular, clean, keyboard-controlled 2D top-down game built with Lua and LÖVE (Love2D).  
Explore a mysterious island, traverse hand-crafted tile-based maps, and uncover the secrets hidden within the Hollow.

---

## 🕹️ Features

- **Tile-Based World**: Multiple interconnected rooms built with Tiled, fully navigable with smooth top-down movement.
- **Sprite-Based Player**: Animated character with WASD/arrow-key movement and idle/walk animations.
- **Collision Physics**: Accurate solid tile/object collisions using Box2D via the [STI](https://github.com/karai17/Simple-Tiled-Implementation) library.
- **Map Transitions**: Walk into special zones to seamlessly change maps, with configurable spawn points.
- **Extensible Architecture**: Minimal, readable codebase designed for learning, prototyping, and further expansion.

---

## 🎮 Controls

| Key       | Action                        |
|-----------|------------------------------|
| W / ↑     | Move up                      |
| A / ←     | Move left                    |
| S / ↓     | Move down                    |
| D / →     | Move right                   |
| E         | Interact / Enter doors       |
| ESC       | Quit game                    |

---

## 🚀 Getting Started

### Requirements

- [LÖVE 11.0+](https://love2d.org/) installed on your system.

### Running the Game

1. **Clone this repository**
    ```bash
    git clone https://github.com/V1perZerofy/TopDownGame.git
    cd TopDownGame
    ```

2. **Run with LÖVE**
    ```bash
    love .
    ```

---

## 🗺️ Asset Structure

- `assets/maps/` – Tiled `.lua` and `.tmx` maps
- `assets/tiles/` – Tileset images
- `assets/sprites/` – Player and entity sprites
- `assets/tiled/` – Tiled Config Files

---

## 📖 Narrative

See [`docs/story.md`](docs/story.md) for the game's story, themes, and world-building.

---

## 📝 Design

See [`docs/design.md`](docs/design.md) for system architecture, technical breakdowns, and planned features.

---

## 🛠️ Technologies & Credits

- **Lua** & **LÖVE**: Game engine and scripting
- **Tiled**: Map editor
- **STI**: Simple Tiled Implementation (map loader)
- **Box2D**: Physics & collision (via LÖVE)
- Player and enemy sprites: Placeholder art by contributors or public domain

---

## 💡 Extending & Contributing

- The core code is modular and commented for easy extension (entities, UI, dialogue, combat, and more).
- Pull requests and suggestions are welcome!

---

Made with ♥ for learning.
