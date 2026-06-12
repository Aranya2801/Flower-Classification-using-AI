# ═══════════════════════════════════════════════════════════════════════════════
# FlowerAI — Makefile
# Common development, testing, and deployment commands.
# Usage: make <target>
# ═══════════════════════════════════════════════════════════════════════════════

.PHONY: help install install-dev setup-env dev api frontend test lint format clean docker-up docker-down train docs

PYTHON := python3
PIP    := pip
NPM    := npm

# Colour output
CYAN  := \033[0;36m
GREEN := \033[0;32m
RESET := \033[0m

help:  ## Show all available commands
	@echo ""
	@echo "$(CYAN)🌸 FlowerAI — Development Commands$(RESET)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-28s$(RESET) %s\n", $$1, $$2}'
	@echo ""

# ── Setup ─────────────────────────────────────────────────────────────────────

install:  ## Install all Python dependencies
	$(PIP) install -r requirements.txt

install-dev:  ## Install dev dependencies + pre-commit hooks
	$(PIP) install -r requirements.txt
	$(PIP) install pre-commit
	pre-commit install
	@echo "$(GREEN)✅ Dev dependencies installed$(RESET)"

setup-env:  ## Create .env from .env.example
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(GREEN)✅ .env created from .env.example — fill in your API keys$(RESET)"; \
	else \
		echo "⚠️  .env already exists — skipping"; \
	fi

setup-conda:  ## Create conda environment
	conda env create -f environment.yml
	@echo "$(GREEN)✅ Run: conda activate flower-ai$(RESET)"

init-db:  ## Initialise databases (run migrations)
	$(PYTHON) scripts/init_db.py
	@echo "$(GREEN)✅ Databases initialised$(RESET)"

download-data:  ## Download all datasets
	$(PYTHON) scripts/dataset_download.py --all

download-models:  ## Download pretrained model weights
	$(PYTHON) scripts/download_models.py

# ── Development Servers ──────────────────────────────────────────────────────

dev: api-dev frontend-dev  ## Start API + frontend in development mode (parallel)

api-dev:  ## Start FastAPI dev server with hot-reload
	uvicorn src.api.main:app \
		--host 0.0.0.0 \
		--port 8000 \
		--reload \
		--log-level debug

api-prod:  ## Start FastAPI production server
	uvicorn src.api.main:app \
		--host 0.0.0.0 \
		--port 8000 \
		--workers 4 \
		--loop uvloop \
		--access-log

frontend-dev:  ## Start Next.js frontend dev server
	cd frontend && $(NPM) run dev

frontend-build:  ## Build Next.js frontend for production
	cd frontend && $(NPM) run build

# ── Testing ───────────────────────────────────────────────────────────────────

test:  ## Run full test suite with coverage
	pytest tests/ -v \
		--cov=src \
		--cov-report=html:htmlcov \
		--cov-report=term-missing \
		--cov-report=xml:coverage.xml \
		--tb=short \
		-q

test-unit:  ## Run unit tests only
	pytest tests/unit/ -v --tb=short

test-integration:  ## Run integration tests only
	pytest tests/integration/ -v --tb=short

test-e2e:  ## Run end-to-end tests
	pytest tests/e2e/ -v

test-watch:  ## Run tests in watch mode
	pytest-watch tests/unit/ -- -v

coverage:  ## Open coverage report in browser
	open htmlcov/index.html || xdg-open htmlcov/index.html

# ── Code Quality ──────────────────────────────────────────────────────────────

lint:  ## Run all linters (ruff + mypy + bandit)
	ruff check src/ tests/ configs/ --fix
	mypy src/ --ignore-missing-imports --no-strict-optional
	bandit -r src/ -ll

format:  ## Auto-format all code
	black src/ tests/ configs/ scripts/
	isort src/ tests/ configs/ scripts/
	ruff check src/ --fix

pre-commit:  ## Run pre-commit hooks on all files
	pre-commit run --all-files

# ── Docker ───────────────────────────────────────────────────────────────────

docker-build:  ## Build all Docker images
	docker-compose build

docker-up:  ## Start all services with Docker Compose
	docker-compose up -d
	@echo "$(GREEN)✅ Services starting...$(RESET)"
	@echo "  API:      http://localhost:8000/docs"
	@echo "  Frontend: http://localhost:3000"
	@echo "  MLflow:   http://localhost:5000"
	@echo "  Grafana:  http://localhost:3001"

docker-down:  ## Stop all Docker services
	docker-compose down

docker-logs:  ## Follow Docker Compose logs
	docker-compose logs -f

docker-restart-api:  ## Restart only the API container
	docker-compose restart api

docker-clean:  ## Remove all containers, images, and volumes
	docker-compose down -v --rmi all

# ── Training ─────────────────────────────────────────────────────────────────

train-efficientnet:  ## Train EfficientNet-B7 model
	$(PYTHON) src/training/train.py \
		--model efficientnet_b7 \
		--data-dir data/processed/oxford102_organised \
		--epochs 100 \
		--batch-size 32 \
		--experiment flower-clf-efficientnet

train-vit:  ## Train ViT-L/16 model
	$(PYTHON) src/training/train.py \
		--model vit_large_16 \
		--data-dir data/processed/oxford102_organised \
		--epochs 100 \
		--batch-size 16 \
		--lr 5e-5 \
		--experiment flower-clf-vit

train-ensemble:  ## Train all models for ensemble
	$(MAKE) train-efficientnet &
	$(MAKE) train-vit &
	wait
	@echo "$(GREEN)✅ Ensemble training complete$(RESET)"

train-mbin:  ## Train full MBIN multi-modal model
	$(PYTHON) src/training/train_mbin.py \
		--config configs/mbin_full.yaml \
		--multi-modal

# ── MLOps ────────────────────────────────────────────────────────────────────

mlflow:  ## Start MLflow tracking server
	mlflow server \
		--host 0.0.0.0 \
		--port 5000 \
		--backend-store-uri sqlite:///mlruns/mlflow.db \
		--default-artifact-root ./mlruns/artifacts

dvc-pull:  ## Pull data with DVC
	dvc pull

dvc-push:  ## Push data with DVC
	dvc push

wandb-sweep:  ## Launch W&B hyperparameter sweep
	wandb sweep configs/sweep.yaml

# ── Deployment ────────────────────────────────────────────────────────────────

deploy-staging:  ## Deploy to staging Kubernetes
	kubectl set image deployment/flowerai-api \
		api=ghcr.io/your-username/flower-ai:latest \
		-n flowerai-staging
	kubectl rollout status deployment/flowerai-api -n flowerai-staging

deploy-prod:  ## Deploy to production Kubernetes (requires approval)
	@read -p "⚠️  Deploy to PRODUCTION? [y/N] " confirm; \
	if [ "$$confirm" = "y" ]; then \
		kubectl set image deployment/flowerai-api \
			api=ghcr.io/your-username/flower-ai:$(VERSION) \
			-n flowerai; \
		kubectl rollout status deployment/flowerai-api -n flowerai; \
	fi

terraform-plan:  ## Preview Terraform infrastructure changes
	cd infrastructure/terraform/aws && terraform plan

terraform-apply:  ## Apply Terraform infrastructure changes
	cd infrastructure/terraform/aws && terraform apply

# ── Documentation ─────────────────────────────────────────────────────────────

docs-serve:  ## Serve documentation locally
	mkdocs serve -a localhost:8080

docs-build:  ## Build documentation
	mkdocs build

# ── Utilities ─────────────────────────────────────────────────────────────────

clean:  ## Remove cache, build artefacts, and temp files
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	rm -rf htmlcov/ coverage.xml .coverage dist/ build/
	@echo "$(GREEN)✅ Cleaned$(RESET)"

health:  ## Check API health
	curl -s http://localhost:8000/health | python3 -m json.tool

demo-classify:  ## Demo: classify a test image
	curl -s -X POST "http://localhost:8000/api/v1/predict" \
		-H "Authorization: Bearer $$(curl -s -X POST http://localhost:8000/api/v1/auth/login \
			-d 'username=demo@flowerai.com&password=Demo@FlowerAI123' | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')" \
		-F "image=@tests/fixtures/rose.jpg" \
		-F "models=all" | python3 -m json.tool

info:  ## Show environment information
	@echo "$(CYAN)FlowerAI Environment$(RESET)"
	@echo "  Python:  $$($(PYTHON) --version)"
	@echo "  pip:     $$($(PIP) --version)"
	@echo "  Node:    $$(node --version 2>/dev/null || echo 'not found')"
	@echo "  Docker:  $$(docker --version 2>/dev/null || echo 'not found')"
	@echo "  kubectl: $$(kubectl version --client --short 2>/dev/null || echo 'not found')"
	@echo "  Torch:   $$($(PYTHON) -c 'import torch; print(torch.__version__)' 2>/dev/null || echo 'not installed')"
	@echo "  CUDA:    $$($(PYTHON) -c 'import torch; print(torch.cuda.is_available())' 2>/dev/null || echo 'unknown')"
