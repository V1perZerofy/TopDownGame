# 🕹️ TopDown Game Design Document

## 🎯 Vision
Create a modular, clean, keyboard-controlled 2D top-down game using Lua and LÖVE (Love2D). The game features sprite-based characters, tile-based maps, and systems like movement, combat, and interaction. The codebase will be readable, extensible, and minimalistic — suitable for rapid prototyping and learning real game architecture.

---

## 🔍 Core Features

### ✅ 1. Player System
- Sprite-based visual (static or animated)
- Freeform top-down movement (not tile-by-tile)
- Keyboard input (WASD or arrow keys)
- Collision with map tiles
- Later: health, damage, interaction prompts

### ✅ 2. Tile-Based World
- Map defined as a 2D array (e.g., `map[y][x]`)
- Tiles loaded from a tileset image
- Map layers (optional): ground, objects, overlay
- Solid tiles (collision) and walkable tiles
- Support for multiple maps / rooms

### ✅ 3. Camera
- Follows player smoothly or hard-locked
- Clamped to map boundaries
- Optional screen shake or effects

### ✅ 4. Sprites & Asset Management
- All visual elements loaded at startup
- Spritesheets for tiles, player, and entities
- Uses `Quad` objects to select parts of tileset
- Optional support for animation frames

### ✅ 5. Entity System (future)
- All dynamic objects (player, enemies, NPCs) treated as entities
- Properties: position, sprite, collision, behavior
- Extensible system with tags (e.g., "enemy", "talkable")

### ✅ 6. Combat (future)
- Basic melee attack or projectile
- Hitbox checks, damage values
- Enemy reaction logic
- Visual and audio feedback

### ✅ 7. User Interface
- Health bar, optional inventory/hotbar
- Pause screen
- Game over screen and restart

---

## 🎮 Controls

| Key       | Action           |
|-----------|------------------|
| W / ↑     | Move up          |
| A / ←     | Move left        |
| S / ↓     | Move down        |
| D / →     | Move right       |
| SPACE     | Action / Attack (later) |
| ESC       | Pause menu (later)     |

---

## 📦 Assets

### 🎨 Graphics
- `tiles.png`: 32x32 or 16x16 tileset
- `player.png`: animated or static
- `enemies.png`: placeholder enemies
- All assets stored in `assets/sprites/` and `assets/tiles/`

### 🔊 Audio (optional later)
- Placeholder SFX for movement, combat, etc.
- Stored in `assets/sfx/`

---

## 🗺 Map Format

- Static Lua tables for initial maps
- Format:
```lua
map = {
  { 1, 1, 1, 1 },
  { 1, 0, 0, 1 },
  { 1, 0, 0, 1 },
  { 1, 1, 1, 1 }
}
