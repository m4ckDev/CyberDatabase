# multi-llm-router

An AI command center that intelligently routes prompts to the best available LLM — OpenAI, Claude, Gemini, Grok, or a local Ollama model.

---

## What It Does

```
User Prompt → AI Router → Selects Best LLM → Gets Response → Logs Result
```

Instead of always using one AI model, this router analyses your prompt and picks the best tool for the job:

| Task Type | Model Used |
|---|---|
| Coding / debugging | OpenAI (GPT-4o) |
| Writing / reasoning | Claude |
| Research / facts | Gemini |
| Private / offline | Ollama (local) |

---

## Project Status

| Phase | Status | Description |
|---|---|---|
| 1 | ✅ Done | GitHub setup, project structure |
| 2 | ✅ Done | Placeholder router (no real API calls) |
| 3 | ⬜ Next | Connect OpenAI |
| 4 | ⬜ | Connect Claude |
| 5 | ⬜ | Connect Gemini / Grok |
| 6 | ⬜ | Connect Ollama (local) |
| 7 | ⬜ | Logging system |
| 8 | ⬜ | Model comparison mode |
| 9 | ⬜ | n8n automation |
| 10 | ⬜ | Web dashboard |

---

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/YOUR-USERNAME/multi-llm-router.git
cd multi-llm-router
```

### 2. Create a virtual environment (recommended)

```bash
python -m venv venv

# Windows
venv\Scripts\activate

# Mac/Linux
source venv/bin/activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Set up your API keys

```bash
# Copy the example file
cp .env.example .env

# Open .env and fill in your real API keys
# NEVER commit the .env file to GitHub!
```

### 5. Run the router

```bash
python main.py
```

---

## Project Structure

```
multi-llm-router/
├── main.py              # Entry point — run this to start
├── router.py            # Routing logic — picks the best model
├── config.py            # Loads settings from .env
├── logger.py            # Logs all prompts and responses
├── models/
│   ├── openai_model.py  # OpenAI connector
│   ├── claude_model.py  # Claude connector
│   ├── gemini_model.py  # Gemini connector
│   └── ollama_model.py  # Local Ollama connector
├── prompts/             # Reusable prompt templates
├── logs/                # Auto-generated log files
├── tests/               # Unit tests
├── docs/                # Documentation
├── requirements.txt     # Python dependencies
├── .env.example         # API key template (safe to commit)
└── .gitignore           # Prevents secrets from being uploaded
```

---

## Security

- API keys are stored in `.env` (never committed to GitHub)
- `.env` is listed in `.gitignore`
- Only `.env.example` (with empty placeholder values) is committed
- Log files avoid storing sensitive prompt content in full

---

## License

MIT License — see [LICENSE](LICENSE) for details.
