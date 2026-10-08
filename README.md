# Robot Framework Automation Challenge

This project implements the three requested tests using Robot Framework and SeleniumLibrary.

## Requirements

- Python 3.10+
- Google Chrome
- ChromeDriver compatible with the installed Chrome version
- Robot Framework

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

## Run all tests

From the project root:

```bash
robot --outputdir results tests
```

The generated `results/log.html` is the execution report requested by the challenge.

## Run by test

```bash
robot --outputdir results -t "Upload a CSV file and validate the result" tests
robot --outputdir results -t "Download a file and validate it locally" tests
robot --outputdir results -t "Compare two JSON files" tests
```

