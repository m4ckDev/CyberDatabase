@echo off
title multi-llm-router GitHub Setup
echo.
echo  ============================================
echo   multi-llm-router — GitHub Setup
echo  ============================================
echo.
echo  This will create your GitHub repo and push
echo  all your starter files in one go.
echo.
cd /d "%~dp0"
python setup_github.py
pause
