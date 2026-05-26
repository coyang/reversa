# Translate the source code to English

Many files / places in the source code are not in English , I can't clear
understand the code/documentation.

Core Objective Unify the project's language by translating all non-English text
(such as code comments, documentation, and readable strings) into English to
improve overall comprehension.

Execution Steps

- Scan & Iterate : Automatically list and loop through every file in the project
  directory.
- Translate & Overwrite : For each file, identify any content not written in
  English, translate it to English, and save the updated content back to the
  original file.
- Atomic Commits : After translating a file (or related module), automatically
create a git commit specifically for that change, including a descriptive commit
message (e.g., chore: translate comments in utils.js to English ). Critical
Constraint

- Maintain Executability (No Breaking Changes) : The translation process must
  strictly preserve the code's logic. It must accurately distinguish between
  safe-to-translate text (like comments or docstrings) and logic-dependent text
  (like variable names, API endpoints, or exact string matches required by the
  code). The application must remain 100% runnable after the translation.

Don't use any script to translate the code, just use LLM Agent read the code and
translate it to English, then write to the original file.