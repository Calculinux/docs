.PHONY: build lint docs clean install help

# Default target
build: lint docs

# Install dependencies
install:
	pip install -r requirements.txt
	npm install

# Linting target - runs all linters
lint: 
	@echo "Running markdownlint with autofix..."
	npx markdownlint-cli2 --fix docs/**/*.md
	@echo "Checking for broken links..."
	npx markdown-link-check -q docs/**/*.md || true
	@echo "Running Vale linting..."
	vale docs/

# Docs target - starts local MkDocs server
docs:
	@echo "Starting MkDocs server at http://127.0.0.1:8000"
	mkdocs serve

# Clean build artifacts
clean:
	rm -rf site/

# Help target
help:
	@echo "Calculinux Docs Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make build   (default) - Run lint and then start docs server"
	@echo "  make lint              - Run all linting tools (markdownlint, link-check, vale)"
	@echo "  make docs              - Start local MkDocs server"
	@echo "  make install           - Install Python and Node dependencies"
	@echo "  make clean             - Remove build artifacts"
	@echo "  make help              - Show this help message"
