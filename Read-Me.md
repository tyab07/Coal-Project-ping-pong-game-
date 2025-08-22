# Ping Pong Game — 8086 Assembly (Text‑Mode)

A classic two‑player **Ping Pong** (Pong) game written in 16‑bit x86 assembly for DOS text mode. It draws directly to video memory (segment `0xB800`) and uses BIOS interrupts for keyboard and text rendering. Designed/tested with EMU8086/DOSBox.

> **Authors:** M. Tayyab (23F‑3058) & M. Ali (23F‑3016)

---

## 🎮 Features

* Two paddles in 80×25 text mode using VGA text buffer (`0xB800`).
* Ball movement: straight/diagonal up/diagonal down in both directions.
* Collision detection with paddles and left/right walls.
* On‑screen live score and a bordered playfield.
* Intro screen and step‑by‑step game menu/instructions.
* Background style toggle with key `c` (cycles blue → cyan → green → default).
* **Game Over** screen with winner banner and final scores.

---

## ⌨️ Controls

* **Player 1 (Left):**

  * `w` — move up
  * `s` — move down
* **Player 2 (Right):**

  * `o` — move up
  * `k` — move down
* **Background theme:** `c`
* **Exit:** `Esc`

> The welcome/menu screens appear first. After pressing Enter, the game starts.

---

## 🧱 Playfield & Scoring

* A vertical border is rendered on both sides; the ball bounces off paddles and goes out on the extreme left/right edges.
* **Scoring:**

  * If the ball crosses the **right** edge → **Player 1** gains a point.
  * If the ball crosses the **left** edge → **Player 2** gains a point.
* **Winning score:** currently **3** points (see *Known Mismatch* below).

> **Known mismatch:** The on‑screen menu text says *“score 6 points”*, but the logic checks for `3`. See **Customization → Change winning score** to make them consistent.

---

## 🛠️ Build & Run

You can assemble and run the program with EMU8086 directly, or produce a `.COM/.EXE` via MASM/TASM and run it in DOSBox.

### Option A — EMU8086 (easiest)

1. Open the source file in EMU8086.
2. Click **Assemble** ▶ **Run**.

### Option B — MASM + DOSBox

```dos
REM Inside DOSBox
MOUNT C path\to\project
C:
MASM PINGPONG.ASM;
LINK PINGPONG.OBJ;
PINGPONG.EXE
```

### Option C — TASM + DOSBox

```dos
REM Inside DOSBox
MOUNT C path\to\project
C:
TASM /M2 PINGPONG.ASM
TLINK PINGPONG.OBJ
PINGPONG.EXE
```

> The source uses MASM/TASM style syntax (labels, directives like `db`, `dw`, `dd`). If using NASM, you’ll need minor adaptations (syntax and segment setup).

---

## 📁 File Layout (key labels & routines)

The single assembly source contains **data**, **utility subroutines**, and **game logic**. Here are the most important labels you’ll see:

### Data / Strings

* `lengthPl` — paddle length (default `5`).
* `score1`, `score2` — word counters for P1/P2.
* `win` — winner flag (1 → P1, 0 → P2).
* `background_n`, `change_key` — background theme state.
* Title & UI strings: `gameName`, `creater`, `studentName`, `menu`, `players`, `menu1..menu5`, `player1`, `player2`, `gameOver`, `press`, `score`, `scoreP1`, `scoreP2`.

### Screen / Utility

* `clrscr` — clear screen (fills `0xB800` with `0x0720`).
* `border` — draws left/right vertical borders.
* `printscore_onscreen` — draws current scores to fixed offsets.
* `printNum` — prints a decimal number at a given video offset.
* `delay` — crude busy‑wait to slow movement.
* `printb`, `clearprintb`, `change_background` — background patterns & cycles.

### Game Flow

* `start` — program entry. Clears screen → `intro` → `gameMenu` → `game`.
* `intro` — shows the game title/credits.
* `gameMenu` — shows instructions & waits for Enter.
* `game` — sets up paddles/ball and enters ball movement.
* `gameOverr` — final screen, prints winner & scores, then exits.

### Input & Movement

* `inputP1` — polls keyboard, routes to movement/background/exit.
* `movePlayer1Up/Down`, `movePlayer2Up/Down` — paddle movement.
* Ball movement families (jump between each other upon collisions):

  * `ballMovementStraight1/2`
  * `ballMovementDiagonallyUpP1/P2`
  * `ballMovementDiagonallyDownP1/P2`
* Per‑step movement helpers that also draw/erase:

  * `moveBallStraightPLayer1/2`
  * `moveBallDiagonallyUp/DownPlayer1/2`

### Collision & Scoring

* `checkPlayer1HitsBall`, `checkPlayer2HitsBall` — detect paddle hits and redirect ball path (up/straight/down depending on impact row).
* `leftCollisionCheck`, `rightCollisionCheck` — detect ball crossing extreme columns and award points. On reaching the winning score, set `win` and jump to `gameOverr`.
* `BallresetPlayer1/2` — reposition ball after a point and resume movement.

---

## 🖥️ How the Rendering Works

* **Video memory:** text buffer at segment `0xB800`. Each screen cell = **2 bytes** (`[char][attr]`).
* **Offsets:** 80 columns × 25 rows → 160 bytes per row. The code uses expressions like `add di, 160` to move down one row.
* **Colors:** attribute high byte (e.g., `0x47` for gray on red, `0x0F` bright white). Paddles/ball/border use different attributes for visibility.
* **BIOS:**

  * `int 10h, ah=13h` — print strings at coordinates.
  * `int 16h` — keyboard (non‑blocking check `ah=1`, read `ah=0`).
  * `int 21h` — miscellaneous DOS services (e.g., wait for key, program exit).

---

## 🧩 Customization

### Change paddle length

Update the `lengthPl` word near the top:

```asm
lengthPl: dw 5 ; try 4..8
```



### Adjust ball speed

Tweak the busy‑wait count in `delay`:

```asm
mov dword[counter], 100000 ; lower = faster, higher = slower
```

### Colors / themes

Search for attribute constants like `0x4700`, `0x0F09`, `0x74B2` and adjust foreground/background to taste.

---

## 🐞 Known Issues & Notes

* **Win condition mismatch:** menu says 6; logic uses 3 (see *Customization*).
* **Frame pacing:** uses a simple busy‑wait; speed depends on emulator/host CPU. Consider replacing with a BIOS timer tick loop for stable speed.
* **Hard‑coded positions:** score text offsets (`20`, `120`) assume 80×25. Changing resolution or font likely breaks alignment.
* **Minimal bounds checks:** paddle movement clamps but some edge cases may leave artifacts until the next draw.

---

## ✅ Tested With

* **EMU8086** (Windows)
* **DOSBox** 0.74+ running MASM/TASM‑built `.EXE`

---


Reference them in this README after you commit.

---

## 📜 License



```
MIT License — Copyright (c) 2025 M. Tayyab & M. Ali
```

---

## 🙌 Acknowledgements

* Course instructors/classmates for feedback.
* References on VGA text mode and BIOS interrupts.

---

## 🚀 Quick Start (TL;DR)

1. Open in EMU8086 → Assemble → Run.
2. Or build with MASM/TASM in DOSBox and run `PINGPONG.EXE`.
3. Controls: `w/s` (P1), `o/k` (P2), `c` theme, `Esc` quit.
4. First to **3** (or your chosen value) wins. Have fun!
