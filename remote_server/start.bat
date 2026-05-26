@echo off
cd /d "%~dp0"
title Vault-17 Remote Server
echo =============================================================
echo ⚡ PIGGYVAULT REMOTE PC SERVER RUNNING ON PORT 8080 ⚡
echo =============================================================
node server.js
pause
