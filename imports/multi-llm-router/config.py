"""
config.py — Configuration Loader
=================================
This file reads your API keys and settings from the .env file
and makes them available to the rest of the project.

Think of this as the "settings panel" of the app.
"""

import os
from dotenv import load_dotenv  # This reads your .env file into memory

# Load the .env file — must be called before reading any env variables
load_dotenv()


# -----------------------------------------------
# API Keys — loaded from .env (never hardcoded!)
# -----------------------------------------------
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
GROK_API_KEY = os.getenv("GROK_API_KEY")

# -----------------------------------------------
# Ollama (local model, no key needed)
# -----------------------------------------------
OLLAMA_BASE_URL = os.getenv("OLLAMA_BASE_URL", "http://localhost:11434")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "llama3")

# -----------------------------------------------
# Router defaults
# -----------------------------------------------
# Which model to use if the router can't decide
DEFAULT_MODEL = os.getenv("DEFAULT_MODEL", "openai")

# -----------------------------------------------
# Logging settings
# -----------------------------------------------
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
LOG_TO_FILE = os.getenv("LOG_TO_FILE", "true").lower() == "true"
LOG_FILE_PATH = "logs/router.log"


def check_keys():
    """
    Prints a quick summary of which API keys are loaded.
    Useful for debugging — run this at startup.
    """
    print("\n=== API Key Status ===")
    print(f"  OpenAI:     {'✅ loaded' if OPENAI_API_KEY else '❌ missing'}")
    print(f"  Anthropic:  {'✅ loaded' if ANTHROPIC_API_KEY else '❌ missing'}")
    print(f"  Gemini:     {'✅ loaded' if GEMINI_API_KEY else '❌ missing'}")
    print(f"  Grok:       {'✅ loaded' if GROK_API_KEY else '❌ missing'}")
    print(f"  Ollama URL: {OLLAMA_BASE_URL}")
    print(f"  Default:    {DEFAULT_MODEL}")
    print("======================\n")


# Run check_keys() if this file is run directly (not imported)
if __name__ == "__main__":
    check_keys()
