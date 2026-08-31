"""
logger.py — Activity Logger
============================
Logs every prompt sent and every response received.
Saves logs to a file in the /logs folder and prints to the terminal.

Important security note: Do NOT log sensitive personal data.
Only log what's needed for debugging and tracking usage.
"""

import os
import logging
from datetime import datetime
from config import LOG_LEVEL, LOG_TO_FILE, LOG_FILE_PATH

# Create the logs folder if it doesn't exist yet
os.makedirs("logs", exist_ok=True)

# Map the string log level (e.g. "INFO") to the logging module's constant
level = getattr(logging, LOG_LEVEL.upper(), logging.INFO)

# Build a list of "handlers" — where logs will be sent
handlers = [logging.StreamHandler()]  # Always print to the terminal

if LOG_TO_FILE:
    # Also write logs to a file
    handlers.append(logging.FileHandler(LOG_FILE_PATH, encoding="utf-8"))

# Configure the global logger
logging.basicConfig(
    level=level,
    format="%(asctime)s | %(levelname)s | %(message)s",  # e.g. 2024-01-01 12:00:00 | INFO | ...
    datefmt="%Y-%m-%d %H:%M:%S",
    handlers=handlers,
)

# Create a named logger for this project
logger = logging.getLogger("multi-llm-router")


def log_request(model: str, prompt: str):
    """
    Log when a prompt is sent to a model.
    Only logs the first 100 chars of the prompt to avoid storing sensitive data.
    """
    preview = prompt[:100] + "..." if len(prompt) > 100 else prompt
    logger.info(f"REQUEST → model={model} | prompt_preview=\"{preview}\"")


def log_response(model: str, response: str, duration_ms: int = 0):
    """
    Log the response received from a model.
    """
    preview = response[:100] + "..." if len(response) > 100 else response
    logger.info(f"RESPONSE ← model={model} | duration={duration_ms}ms | preview=\"{preview}\"")


def log_error(model: str, error: str):
    """
    Log when a model call fails.
    """
    logger.error(f"ERROR ✗ model={model} | error={error}")


def log_routing_decision(prompt: str, chosen_model: str, reason: str):
    """
    Log why the router chose a particular model.
    """
    logger.info(f"ROUTER → chose={chosen_model} | reason={reason}")
