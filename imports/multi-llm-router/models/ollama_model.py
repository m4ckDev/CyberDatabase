"""
models/ollama_model.py — Local Ollama Connector
================================================
Handles sending prompts to a locally running Ollama instance.
Ollama lets you run open-source LLMs (like Llama 3, Mistral) on your own machine.
No API key needed — it runs 100% offline.

Phase 2: Currently returns a PLACEHOLDER response.
Phase 6: Replace the placeholder with a real Ollama API call.

To use Ollama:
1. Install from https://ollama.com
2. Run: ollama pull llama3
3. Start the server: ollama serve
"""

from config import OLLAMA_BASE_URL, OLLAMA_MODEL


def query(prompt: str, model: str = None) -> str:
    """
    Send a prompt to a local Ollama model and return the response.

    Args:
        prompt: The user's question or instruction
        model:  Which Ollama model to use (defaults to OLLAMA_MODEL in .env)

    Returns:
        The model's response as a string
    """

    # Use the model from .env if none is specified
    model = model or OLLAMA_MODEL

    # -----------------------------------------------
    # PHASE 2: Placeholder response (no real API call)
    # Remove this block in Phase 6 and replace with
    # the real Ollama API call below.
    # -----------------------------------------------
    return f"[Ollama Placeholder] Local model '{model}' received: '{prompt[:60]}...'"

    # -----------------------------------------------
    # PHASE 6: Real API call (uncomment when ready)
    # Make sure Ollama is running locally first!
    # -----------------------------------------------
    # import requests
    #
    # url = f"{OLLAMA_BASE_URL}/api/generate"
    #
    # payload = {
    #     "model": model,
    #     "prompt": prompt,
    #     "stream": False  # Get the full response at once (not streamed)
    # }
    #
    # try:
    #     response = requests.post(url, json=payload, timeout=60)
    #     response.raise_for_status()
    #     return response.json().get("response", "No response received.")
    # except requests.exceptions.ConnectionError:
    #     return "Error: Ollama is not running. Start it with: ollama serve"
    # except Exception as e:
    #     return f"Error calling Ollama: {str(e)}"
