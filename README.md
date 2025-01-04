# Asfallen KDA System

## Overview
Asfallen KDA is a simple Kill-Death-Assist (KDA) tracking system for the **RedM** framework. This system is designed for servers using the `vorp_core` framework and integrates seamlessly with `oxmysql` for database management. It provides real-time updates of player stats such as kills, deaths, and KDA ratio on a customizable UI.

## Features
- Tracks kills, deaths, and calculates KDA ratio.
- Synchronizes stats with a MySQL database for persistence.
- Dynamic and visually appealing UI with real-time updates.
- Integrates with the `vorp_core` framework.
- Fully customizable UI with HTML, CSS, and JavaScript.

## Requirements
- **RedM** (Cerulean)
- **MySQL Server**
- [oxmysql](https://github.com/overextended/oxmysql)
- [vorp_core](https://github.com/VORPCore/VORP-Core)

## Installation
1. **Download & Extract**: Place the `asfallen-kda` folder into your server's `resources` directory.
2. **Database Setup**:
   - Import the `kda.sql` file into your MySQL database to create the required table.
3. **Configuration**:
   - Ensure `fxmanifest.lua` includes all dependencies and files.
   - Modify server configurations to point to the correct database if necessary.
4. **Add to Server.cfg**:
   ```plaintext
   ensure asfallen-kda
