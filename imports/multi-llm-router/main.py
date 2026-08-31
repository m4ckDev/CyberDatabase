"""
main.py — Entry Point
======================
This is where the program starts.
Run this file to launch the AI router:

    python main.py

It shows a simple interactive loop where you can type prompts
and see which model the router picks and what response comes back.
"""

from config import check_keys   # Shows which API keys are loaded
from router import route         # The routing function
from logger import logger        # For logging start/stop events
import time                      # For measuring response time


def main():
    """
    Run an interactive prompt loop.
    Type your prompt, see the router's decision and response.
    Type 'quit' or 'exit' to stop.
    """

    print("=" * 55)
    print("   🤖 Multi-LLM Router — AI Command Center")
    print("   Phase 2: Running with placeholder responses")
    print("=" * 55)

    # Show which API keys are loaded
    check_keys()

    print("Type a prompt and press Enter. Type 'quit' to exit.\n")

    while True:
        # Get input from the user
        try:
            prompt = input("You: ").strip()
        except (KeyboardInterrupt, EOFError):
            # Handle Ctrl+C gracefully
            print("\n\nGoodbye!")
            break

        # Check for exit commands
        if prompt.lower() in ("quit", "exit", "q", "bye"):
            print("Goodbye!")
            break

        # Skip empty input
        if not prompt:
            print("Please enter a prompt.\n")
            continue

        # Measure response time
        start = time.time()

        # Send to router — this picks the model and gets the response
        response = route(prompt)

        duration_ms = int((time.time() - start) * 1000)

        # Display the response
        print(f"\nAI ({duration_ms}ms): {response}\n")
        print("-" * 55)


# This block makes sure main() only runs if you run this file directly
# (not if it's imported by another file)
if __name__ == "__main__":
    main()
