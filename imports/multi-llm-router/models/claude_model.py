"""
models/claude_model.py — Anthropic Claude Connector
=====================================================
Handles sending prompts to Anthropic's Claude models and returning responses.

Phase 2: Currently returns a PLACEHOLDER response.
Phase 4: Replace the placeholder with a real Anthropic API call.
"""

from config import ANTHROPIC_API_KEY


def query(prompt: str, model: str = "claude-opus-4-6") -> str:
    """
    Send a prompt to Claude and return the response.

    Args:
        prompt: The user's question or instruction
        model:  Which Claude model to use (default: claude-opus-4-6)

    Returns:
        The model's response as a string
    """

    # -----------------------------------------------
    # PHASE 2: Placeholder response (no real API call)
    # Remove this block in Phase 4 and replace with
    # the real Anthropic API call below.
    # -----------------------------------------------
    return f"[Claude Placeholder] I received your prompt: '{prompt[:60]}...'"

    # -----------------------------------------------
    # PHASE 4: Real API call (uncomment when ready)
    # -----------------------------------------------
    # if not ANTHROPIC_API_KEY:
    #     raise ValueError("ANTHROPIC_API_KEY is not set in your .env file!")
    #
    # import anthropic
    # client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)
    #
    # message = client.messages.create(
    #     model=model,
    #     max_tokens=1024,
    #     messages=[
    #         {"role": "user", "content": prompt}
    #     ]
    # )
    #
    # return message.content[0].text
