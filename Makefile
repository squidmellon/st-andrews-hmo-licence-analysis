.PHONY: help python-check

help:
	@echo "python-check  Compile Python scripts for syntax errors"
	@echo "R scripts require the original project data before execution."

python-check:
	python -m py_compile code/python/*.py
