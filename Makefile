SHELL := /bin/bash

default: help

format:
	gdformat .

find-format-error:
	find . -name "*.gd" -not -path "./addons/*" -exec sh -c 'echo "Formatting {}" && gdformat {}' \;

install-pre-commit:
	pre-commit clean
	pre-commit install

install-venv-help:
	@echo 'Run the following commands to install the virtual environment:'
	@echo 'python3 -m venv .venv'
	@echo 'source .venv/bin/activate'
	@echo 'pip install -r requirements.txt'

lint:
	gdlint .

tests-github-actions:
	godot --headless -s addons/gut/gut_cmdln.gd -gconfig=.gutconfig.github-actions.json

tests:
	godot --headless -s addons/gut/gut_cmdln.gd -gconfig=.gutconfig.default.json

# Run a specific test file (path should be relative to repo root)
# Example: make test TEST_FILE=src/services/items/__tests__/items_service_test.gd
test:
	godot --headless -s addons/gut/gut_cmdln.gd -gconfig=.gutconfig.default.json -gtest=res://$(TEST_FILE) -gexit -gdir=

clean-unused-assets:
	@python3 scripts/find_unused_assets.py --fix --no-interactive

help:
	@echo "> format               |----------------------------------|  Apply gdformat to all files"
	@echo "> install-pre-commit   |----------------------------------|  Install pre-commit hooks"
	@echo "> install-venv-help    |----------------------------------|  Show help to install virtual environment"
	@echo "> lint                 |----------------------------------|  Run gdlint on all files"
	@echo "> tests-github-actions |----------------------------------|  Run all tests (for github actions)"
	@echo "> tests                |----------------------------------|  Run all tests"
	@echo "> test                 |----------------------------------|  Run a test file (suffix with the test script location)"
	@echo "> clean-unused-assets  |----------------------------------|  Find and delete unused assets"