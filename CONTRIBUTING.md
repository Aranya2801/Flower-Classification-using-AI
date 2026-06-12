# Contributing to FlowerAI 🌸

Thank you for your interest in contributing! FlowerAI welcomes contributions of all kinds — bug fixes, new features, documentation improvements, and research contributions.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Adding New Models](#adding-new-models)
- [Documentation](#documentation)

---

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you agree to uphold this standard.

---

## Getting Started

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR-USERNAME/flower-ai.git
cd flower-ai

# 3. Set up the development environment
make install-dev
make setup-env

# 4. Create a feature branch
git checkout -b feature/your-feature-name
# or for bug fixes:
git checkout -b fix/issue-description
```

---

## Development Workflow

```bash
# Run tests before making changes (establish baseline)
make test

# Make your changes...

# Format and lint
make format
make lint

# Run tests again
make test

# Commit with a descriptive message
git commit -m "feat(inference): add TensorRT optimisation for EfficientNet"
```

### Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `refactor` | Code refactoring |
| `perf` | Performance improvement |
| `test` | Adding/fixing tests |
| `chore` | Build, CI, dependencies |
| `research` | Research experiments, paper updates |

**Examples:**
```
feat(rag): add streaming response for chatbot endpoint
fix(inference): correct ensemble weight normalisation
docs(research): update MBIN ablation study results
perf(api): reduce predict endpoint latency by 40% with batched inference
```

---

## Pull Request Process

1. **Open an issue first** for significant changes to discuss the approach
2. Ensure all tests pass: `make test`
3. Ensure code is formatted: `make format`
4. Update documentation if needed
5. Add your change to `CHANGELOG.md` under `[Unreleased]`
6. Fill in the pull request template completely
7. Request review from at least one maintainer

### PR Checklist

- [ ] Tests pass (`make test`)
- [ ] No linting errors (`make lint`)
- [ ] Code is formatted (`make format`)
- [ ] Added tests for new functionality
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] Self-reviewed the diff

---

## Coding Standards

### Python

- **Formatter**: `black` (line length 100)
- **Linter**: `ruff`
- **Type hints**: Required for all public functions
- **Docstrings**: Google-style for public APIs

```python
def predict_species(
    image: Image.Image,
    models: list[str] | None = None,
    confidence_threshold: float = 0.5,
) -> PredictionResult:
    """
    Classify a flower image using the ensemble model.

    Args:
        image: PIL Image in RGB mode.
        models: Model names to include. None uses all loaded models.
        confidence_threshold: Minimum confidence to report a prediction.

    Returns:
        PredictionResult with species name, confidence, and top-5 predictions.

    Raises:
        ValueError: If no models are loaded or image is invalid.
    """
```

### TypeScript / React

- **Formatter**: `prettier`
- **Linter**: `eslint` with Next.js config
- **Components**: Functional with hooks; no class components
- **Props**: Always typed with TypeScript interfaces

---

## Testing Requirements

All PRs must include tests. Coverage must not decrease.

```bash
# Run full test suite
make test

# Unit tests only (fast, no external deps)
make test-unit

# Integration tests (requires running services)
make test-integration
```

### Test Structure

```
tests/
├── unit/           # Pure unit tests — no I/O, fast
├── integration/    # API endpoint tests with TestClient
└── e2e/            # Full stack tests (Playwright)
```

### Writing Good Tests

```python
class TestMyFeature:
    @pytest.mark.asyncio
    async def test_feature_does_expected_thing(self):
        # Arrange
        engine = MyEngine(config=test_config)

        # Act
        result = await engine.do_thing(input_data)

        # Assert
        assert result.status == "success"
        assert result.value > 0
```

---

## Adding New Models

To add a new vision model to the ensemble:

1. Add the model to `src/models/architectures/`
2. Register it in `src/inference/engine.py` (`model_configs` dict)
3. Add ensemble weight to `configs/settings.py`
4. Add a test to `tests/unit/test_all.py`
5. Update the README model table

```python
# In engine.py — add to model_configs:
"your_model_name": ("timm_model_string", input_size),
```

---

## Documentation

Documentation lives in `docs/`. Update relevant docs when changing functionality.

For new API endpoints, the docstring in the router function automatically populates the Swagger UI — keep it detailed.

---

## Research Contributions

We welcome research contributions! If you have:

- New model architectures
- Novel training techniques
- Benchmark improvements
- Dataset contributions

Please open a **Research Proposal** issue using the template, include preliminary results, and we'll work with you to integrate it.

---

## Questions?

Open a [GitHub Discussion](https://github.com/your-username/flower-ai/discussions) or file an issue with the `question` label.

Thank you for making FlowerAI better! 🌸
