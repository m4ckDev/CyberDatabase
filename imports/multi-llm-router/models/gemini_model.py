"""
models/gemini_model.py — Google Gemini Connector
=================================================
Handles sending prompts to Google's Gemini models and returning responses.

Phase 2: Currently returns a PLACEHOLDER response.
Phase 5: Replace the placeholder with a real Gemini API call.
"""

from config import GEMINI_API_KEY


def query(prompt: str, model: str = "gemini-1.5-pro") -> str:
    """
    Send a prompt to Google Gemini and return the response.

    Args:
        prompt: The user's question or instruction
        model:  Which Gemini model to use (default: gemini-1.5-pro)

    Returns:
        The model's response as a string
    """

    # -----------------------------------------------
    # PHASE 2: Placeholder response (no real API call)
    # Remove this block in Phase 5 and replace with
    # the real Gemini API call below.
    # -----------------------------------------------
    return f"[Gemini Placeholder] I received your prompt: '{prompt[:60]}...'"

    # -----------------------------------------------
    # PHASE 5: Real API call (uncomment when ready)
    # -----------------------------------------------
    # if not GEMINI_API_KEY:
    #     raise ValueError("GEMINI_API_KEY is not set in your .env file!")
    #
    # import google.generativeai as genai
    # genai.configure(api_key=GEMINI_API_KEY)
    #
    # model_instance = genai.GenerativeModel(model)
    # response = model_instance.generate_content(prompt)
    #
    # return response.text
