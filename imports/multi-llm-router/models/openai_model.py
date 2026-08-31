"""
models/openai_model.py — OpenAI / ChatGPT Connector
=====================================================
Handles sending prompts to OpenAI's GPT models and returning responses.

Phase 2: Currently returns a PLACEHOLDER response.
Phase 3: Replace the placeholder with a real OpenAI API call.
"""

from config import OPENAI_API_KEY


def query(prompt: str, model: str = "gpt-4o") -> str:
    """
    Send a prompt to OpenAI and return the response.

    Args:
        prompt: The user's question or instruction
        model:  Which GPT model to use (default: gpt-4o)

    Returns:
        The model's response as a string
    """

    # -----------------------------------------------
    # PHASE 2: Placeholder response (no real API call)
    # Remove this block in Phase 3 and replace with
    # the real OpenAI API call below.
    # -----------------------------------------------
    return f"[OpenAI Placeholder] I received your prompt: '{prompt[:60]}...'"

    # -----------------------------------------------
    # PHASE 3: Real API call (uncomment when ready)
    # -----------------------------------------------
    # if not OPENAI_API_KEY:
    #     raise ValueError("OPENAI_API_KEY is not set in your .env file!")
    #
    # from openai import OpenAI
    # client = OpenAI(api_key=OPENAI_API_KEY)
    #
    # response = client.chat.completions.create(
    #     model=model,
    #     messages=[
    #         {"role": "user", "content": prompt}
    #     ]
    # )
    #
    # return response.choices[0].message.content
