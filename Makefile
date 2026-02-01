.PHONY: build lint docs clean install install-vale vale-sync validate-workflows help update-icons

# Default target
build: lint docs

# Install dependencies
install:
	pip install -r requirements.txt
	npm install
	@$(MAKE) install-vale
	@$(MAKE) vale-sync

# Install Vale
install-vale:
	@echo "Checking for Vale..."
	@if command -v vale >/dev/null 2>&1; then \
		echo "Vale is already installed: $$(vale --version)"; \
	else \
		echo "Installing Vale..."; \
		mkdir -p "$$HOME/.local/bin"; \
		VALE_VERSION=$$(curl -s https://api.github.com/repos/errata-ai/vale/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/'); \
		echo "Latest Vale version: $$VALE_VERSION"; \
		curl -L "https://github.com/errata-ai/vale/releases/download/v$$VALE_VERSION/vale_$${VALE_VERSION}_Linux_64-bit.tar.gz" -o /tmp/vale.tar.gz; \
		tar -xzf /tmp/vale.tar.gz -C "$$HOME/.local/bin/" vale; \
		chmod +x "$$HOME/.local/bin/vale"; \
		rm /tmp/vale.tar.gz; \
		echo "Vale installed to $$HOME/.local/bin/vale"; \
		echo ""; \
		echo "⚠️  IMPORTANT: Add $$HOME/.local/bin to your PATH:"; \
		echo "  export PATH=\"\$$HOME/.local/bin:\$$PATH\""; \
		echo ""; \
		echo "Or add this line to your ~/.bashrc or ~/.zshrc:"; \
		echo "  export PATH=\"\$$HOME/.local/bin:\$$PATH\""; \
	fi

# Sync Vale styles/packages
vale-sync:
	@echo "Syncing Vale styles and packages..."
	@if command -v vale >/dev/null 2>&1; then \
		vale sync; \
	elif [ -x "$$HOME/.local/bin/vale" ]; then \
		"$$HOME/.local/bin/vale" sync; \
	else \
		echo "ERROR: Vale is not installed. Run 'make install-vale' first."; \
		exit 1; \
	fi

# Linting target - runs all linters
lint: 
	@echo "Running markdownlint with autofix..."
	npx markdownlint-cli2 --fix --config .markdownlint-cli2.jsonc docs/**/*.md
	@echo "Checking for broken links..."
	npx markdown-link-check -q -c .markdown-link-check.json docs/**/*.md || true
	@echo "Running Vale linting..."
	@if command -v vale >/dev/null 2>&1; then \
		vale docs/; \
	elif [ -x "$$HOME/.local/bin/vale" ]; then \
		"$$HOME/.local/bin/vale" docs/; \
	else \
		echo "ERROR: Vale is not installed. Run 'make install-vale' to install it."; \
		exit 1; \
	fi

# Docs target - starts local MkDocs server
docs:
	@echo "Starting MkDocs server at http://127.0.0.1:8000"
	mkdocs serve

# Update icon lists from Material theme (run after upgrading mkdocs-material)
update-icons:
	@echo "Regenerating icon lists from Material for MkDocs theme..."
	python3 .github/scripts/generate-icon-lists.py
	@echo "Icon lists updated in .github/icon-lists.json"

# Validate GitHub Actions workflows
validate-workflows:
	@echo "Validating GitHub Actions workflows..."
	@if command -v action-validator >/dev/null 2>&1; then \
		for file in .github/workflows/*.yml; do \
			echo "Checking $$file..."; \
			action-validator "$$file" || exit 1; \
		done; \
		echo "✅ All workflows are valid"; \
	else \
		echo "⚠️  action-validator not installed. Install with:"; \
		echo "  npm install -g @action-validator/cli"; \
		exit 1; \
	fi

# Clean build artifacts
clean:
	rm -rf site/

# Help target
help:
	@echo "Calculinux Docs Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make build              (default) - Run lint and then start docs server"
	@echo "  make lint                         - Run all linting tools (markdownlint, link-check, vale)"
	@echo "  make docs                         - Start local MkDocs server"
	@echo "  make install                      - Install Python, Node, Vale, and sync Vale styles"
	@echo "  make install-vale                 - Install Vale prose linter only"
	@echo "  make vale-sync                    - Sync Vale styles and packages from .vale.ini"
	@echo "  make validate-workflows           - Validate GitHub Actions workflow YAML files"
	@echo "  make update-icons                 - Regenerate icon lists from Material theme"
	@echo "  make clean                        - Remove build artifacts"
	@echo "  make help                         - Show this help message"
	@echo ""
	@echo "Vale Setup:"
	@echo "  Vale requires style packages to be synced after installation."
	@echo "  Run 'make vale-sync' if you update .vale.ini or add new styles."
	@echo ""
	@echo "Workflow Validation:"
	@echo "  Validates GitHub Actions workflow YAML syntax using action-validator."
	@echo "  Requires: npm install -g @action-validator/cli"
	@echo ""
	@echo "Icon Validation:"
	@echo "  The linter validates against 14,000+ icons from Material for MkDocs."
	@echo "  Run 'make update-icons' after upgrading mkdocs-material to get new icons."
