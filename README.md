# HeiCHips 2025 LibreLane Workshop

This is the repository for the LibreLane workshop during HeiChips 2025.

You will learn how to use and configure LibreLane, debug your design, integrate macros, and implement a full chip.

- LibreLane repository: https://github.com/librelane/librelane
- LibreLane documentation: https://librelane.readthedocs.io

## Prerequisites

> [!NOTE]
> The HeiChips VM has Nix already pre-installed.

If you haven't installed Nix yet, please do so using LibreLane's documentation: [Nix-based Installation](https://librelane.readthedocs.io/en/latest/getting_started/common/nix_installation/index.html). 

Now you simply need to execute `nix-shell` at the root directory of this repository to enable all of the required tools. This has to be done each time you open a new shell.

The Nix flake of this repository provides the `dev` branch of LibreLane.

## Exercises

- [Exercise 1](exercise_1/README.md): Let's Implement a Counter
- [Exercise 2](exercise_2/README.md): All About Configuration Variables
- [Exercise 3](exercise_3/README.md): Controlling the Flow
- [Exercise 4](exercise_4/README.md): Using Macros
- [Exercise 5](exercise_5/README.md): LibreLane API
- [Bonus](bonus/README.md): Full Chip Design

### License

The code is licensed under Apache 2.0

Workshop: CC-BY-SA-4.0 Leo Moser
