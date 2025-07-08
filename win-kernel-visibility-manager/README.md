# Windows Kernel Visibility Manager

## Overview
The Windows Kernel Visibility Manager is a kernel-mode driver that provides a user-space interface for managing low-level system visibility. It allows user-mode applications to filter process enumeration results based on specified process IDs (PIDs).

## Project Structure
```
win-kernel-visibility-manager
├── driver
│   ├── Driver.c
│   ├── Driver.h
│   ├── VisibilityManager.c
│   ├── VisibilityManager.h
│   ├── inf
│   │   └── VisibilityManager.inf
│   └── Makefile
├── user_app
│   ├── main.c
│   ├── VisibilityManagerUser.h
│   └── Makefile
└── README.md
```

## Driver Components
- **Driver.c**: Main entry point for the kernel-mode driver. Handles initialization, cleanup, and device creation.
- **Driver.h**: Header file for driver functions and structures.
- **VisibilityManager.c**: Implements core functionality for filtering process enumeration results.
- **VisibilityManager.h**: Header file for visibility management functions and structures.
- **VisibilityManager.inf**: Installation information file for the driver.
- **Makefile**: Build instructions for the kernel-mode driver.

## User Application Components
- **main.c**: Entry point for the user-mode application. Communicates with the kernel-mode driver to filter processes.
- **VisibilityManagerUser.h**: Header file for user-mode application functions and structures.
- **Makefile**: Build instructions for the user-mode application.

## Setup Instructions
1. **Build the Driver**: Navigate to the `driver` directory and run the Makefile to compile the kernel-mode driver.
2. **Install the Driver**: Use the `VisibilityManager.inf` file to install the driver on your Windows system.
3. **Build the User Application**: Navigate to the `user_app` directory and run the Makefile to compile the user-mode application.

## Usage Guidelines
- After installing the driver, run the user-mode application to filter process enumeration based on specified PIDs.
- Ensure you have the necessary permissions to interact with kernel-mode drivers.

## Functionality
The kernel-mode driver provides a mechanism to filter process information, enhancing system visibility management for user-mode applications. This can be particularly useful for security and monitoring applications that require control over which processes are visible to the system.