# Getting started with Embedded Swift

Possible directions to explore to start using Embedded Swift

## Introduction

Embedded Swift is a way to write code for embedded systems using the Swift programming language. Depending on the use case, there are different ways of using it, different ways of integrating with existing ecosystems, and different setups for different hardware devices. This guide will help you explore various paths to get started with embedded development using Swift.

Before diving into Embedded Swift development, you should have:

- Basic knowledge of the Swift programming language
- A Swift toolchain installed on your development host
- A target embedded platform in mind (e.g. a Raspberry Pi Pico)
  - this can also be a simulated hardware platform (e.g. in QEMU), or even a full desktop OS environment in case you're not interested in controlling low-level hardware or custom electronic peripherals
  
> Note: Embedded Swift is experimental. Public releases of Swift do not support Embedded Swift, yet. See [Install Embedded Swift](InstallEmbeddedSwift.md) for details.

## Guided Tutorials

To help you get started with Embedded Swift, we've prepared several step-by-step guides that cover different platforms and use cases:

- [Try out Embedded Swift on macOS](../GuidedExamples/macOSGuide.md) - Try out Embedded Swift on your development machine
- [Raspberry Pi Pico Blink (Pico SDK)](../GuidedExamples/PicoGuide.md) - Build and run Swift code on a Raspberry Pi Pico
- [Baremetal Setup for STM32 with Embedded Swift](../GuidedExamples/STM32BaremetalGuide.md) - Set up a baremetal Swift project for STM32 microcontrollers

These guides provide a practical introduction to Embedded Swift development with specific hardware targets, showing you how to build, upload, and run your first Swift programs on embedded systems.

## Other Resources

For a deeper understanding of Embedded Swift concepts and philosophy, check out these resources:

- [Introduction to Embedded Swift](Introduction.md) - Learn about the core concepts and philosophy of Embedded Swift
- [Language subset](LanguageSubset.md) - Understand which Swift language features are available in Embedded Swift
- [Install Embedded Swift](InstallEmbeddedSwift.md) - Detailed instructions for installing the required toolchain

For developers coming from embedded C/C++ backgrounds or those integrating Swift into existing projects:

- [Basics of using Embedded Swift](../UsingEmbeddedSwift/Basics.md) - Essential knowledge for using Embedded Swift effectively
- [Conditionalizing compilation for Embedded Swift](../UsingEmbeddedSwift/ConditionalCompilation.md) - How to share code between Embedded Swift and standard Swift
- [Libraries and modules in Embedded Swift](../UsingEmbeddedSwift/Libraries.md) - Understanding how libraries work in Embedded Swift
