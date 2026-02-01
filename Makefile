.PHONY: build lint docs clean install help update-icons

# Default target
build: lint docs

# Install dependencies
install:
	pip install -r requirements.txt
	npm install

# Linting target - runs all linters
lint: 
	@echo "Running markdownlint with autofix..."
	npx markdownlint-cli2 --fix --config .markdownlint-cli2.jsonc docs/**/*.md
	@echo "Checking for broken links..."
	npx markdown-link-check -q -c .markdown-link-check.json docs/**/*.md || true
	@echo "Running Vale linting..."
	@command -v vale >/dev/null 2>&1 && vale docs/ || echo "Vale not installed, skipping prose linting"

# Docs target - starts local MkDocs server
docs:
	@echo "Starting MkDocs server at http://127.0.0.1:8000"
	mkdocs serve

# Update icon lists from Material theme (run after upgrading mkdocs-material)
update-icons:
	@echo "Regenerating icon lists from Material for MkDocs theme..."
	python3 .github/scripts/generate-icon-lists.py
	@echo "Icon lists updated in .github/icon-lists.json"

# Clean build artifacts
clean:
	rm -rf site/

# Help target
help:
	@echo "Calculinux Docs Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make build        (default) - Run lint and then start docs server"
	@echo "  make lint                   - Run all linting tools (markdownlint, link-check, vale)"
	@echo "  make docs                   - Start local MkDocs server"
	@echo "  make install                - Install Python and Node dependencies"
	@echo "  make update-icons           - Regenerate icon lists from Material theme"
	@echo "  make clean                  - Remove build artifacts"
	@echo "  make help                   - Show this help message"
	@echo ""
	@echo "Icon Validation:"
	@echo "  The linter validates against 14,000+ icons from Material for MkDocs."
	@echo "  Run 'make update-icons' after upgrading mkdocs-material to get new icons."
