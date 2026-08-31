"""
router.py — The AI Router
==========================
This is the brain of the project.

It looks at the user's prompt and decides which AI model
is best suited to answer it, then calls that model.

Routing logic (Phase 2 — keyword-based):
- Coding / programming questions  → OpenAI
- Writing / long-form reasoning   → Claude
- Research / factual questions    → Gemini
- Private / offline tasks         → Ollama
- Unknown / default               → OpenAI

Future phases will improve this with scoring, embeddings,
or even asking an AI to classify the task.
"""

from config import DEFAULT_MODEL
from logger import log_routing_decision

# Import all model connectors
from models import openai_model, claude_model, gemini_model, ollama_model


# -----------------------------------------------
# Keyword lists for each routing category
# Add more keywords as you discover patterns
# -----------------------------------------------
CODING_KEYWORDS = [
    "code", "python", "javascript", "function", "bug", "error",
    "script", "programming", "debug", "class", "loop", "algorithm",
    "linux", "bash", "powershell", "terminal", "git", "docker",
]

WRITING_KEYWORDS = [
    "write", "essay", "article", "summarize", "explain", "story",
    "describe", "letter", "email", "report", "blog", "draft",
    "rewrite", "paraphrase", "creative", "poem",
]

RESEARCH_KEYWORDS = [
    "research", "what is", "who is", "when did", "why does",
    "how does", "history", "compare", "difference between",
    "facts about", "latest", "current", "news", "search",
]

PRIVATE_KEYWORDS = [
    "private", "offline", "local", "confidential", "sensitive",
    "no internet", "secure", "internal",
]


def classify_prompt(prompt: str) -> tuple[str, str]:
    """
    Look at the prompt and return (model_name, reason).

    Args:
        prompt: The user's input text

    Returns:
        A tuple of (model_name, reason_for_choice)
    """

    prompt_lower = prompt.lower()  # Make comparison case-insensitive

    # Check for private/local tasks first (highest priority)
    for keyword in PRIVATE_KEYWORDS:
        if keyword in prompt_lower:
            return "ollama", f"keyword match: '{keyword}' → private/local task"

    # Check for coding tasks
    for keyword in CODING_KEYWORDS:
        if keyword in prompt_lower:
            return "openai", f"keyword match: '{keyword}' → coding task"

    # Check for writing tasks
    for keyword in WRITING_KEYWORDS:
        if keyword in prompt_lower:
            return "claude", f"keyword match: '{keyword}' → writing/reasoning task"

    # Check for research tasks
    for keyword in RESEARCH_KEYWORDS:
        if keyword in prompt_lower:
            return "gemini", f"keyword match: '{keyword}' → research task"

    # Default fallback
    return DEFAULT_MODEL, "no keyword match → using default model"


def route(prompt: str) -> str:
    """
    Main routing function.
    Takes the user's prompt, picks the best model, and returns the response.

    Args:
        prompt: The user's input text

    Returns:
        The AI model's response as a string
    """

    # Step 1: Decide which model to use
    chosen_model, reason = classify_prompt(prompt)

    # Step 2: Log the routing decision
    log_routing_decision(prompt, chosen_model, reason)

    # Step 3: Call the correct model
    if chosen_model == "openai":
        return openai_model.query(prompt)

    elif chosen_model == "claude":
        return claude_model.query(prompt)

    elif chosen_model == "gemini":
        return gemini_model.query(prompt)

    elif chosen_model == "ollama":
        return ollama_model.query(prompt)

    else:
        # Safety net — should never reach here
        return openai_model.query(prompt)
