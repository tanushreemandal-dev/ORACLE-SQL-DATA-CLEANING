# 🧹 Oracle SQL Data Cleaning — World Layoffs Dataset

> Transforming a raw, inconsistent layoffs dataset into a clean, analysis-ready table using pure Oracle SQL — duplicates removed, formats standardized, nulls resolved, and data types corrected.

![SQL](https://img.shields.io/badge/SQL-Oracle-red)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
![Type](https://img.shields.io/badge/Type-Data%20Cleaning-blue)

---

## 📌 Overview

This project takes a messy, real-world layoffs dataset and runs it through a full **Oracle SQL data cleaning pipeline** — the kind of work every data analyst faces before any meaningful analysis can happen. Rather than working with pre-cleaned data, this project starts from raw, inconsistent records and systematically fixes them using only SQL: no external scripts, no spreadsheets, no manual edits.

The project was inspired by Alex The Analyst's popular *Data Cleaning in MySQL* tutorial, but was independently rebuilt for **Oracle SQL** 

---

## 🗂️ Dataset

A real-world layoffs dataset containing company-level layoff events, including:

| Column | Description |
|---|---|
| `company` | Name of the company |
| `location` | City where layoffs occurred |
| `industry` | Company's industry sector |
| `total_laid_off` | Number of employees laid off |
| `percentage_laid_off` | Percentage of workforce laid off |
| `date` | Date of the layoff event |
| `stage` | Company funding stage |
| `country` | Country of operation |
| `funds_raised_millions` | Total funds raised by the company (in millions) |

The raw data contained duplicate records, inconsistent text formatting, non-standard NULL representations (literal `'NULL'` text strings), and dates stored as timestamps rather than clean date values — all addressed in this project.

---

## 🛠️ Tools & Environment

- **Database:** Oracle Database (via [FreeSQL](https://freesql.com), Oracle's free cloud SQL environment)
- **Language:** Oracle SQL
- **Editor:** VS Code (for version control and repo management)
- **Version Control:** Git & GitHub

---

## 🔧 Project Workflow

### 1. Initial Exploration
Inspected the raw table's row count, column structure, and data types using Oracle's system catalog view (`user_tab_columns`).

### 2. Created a Working Copy
Preserved the original raw data by creating a staging copy before any cleaning began — a critical safeguard against irreversible changes.

### 3. Identified & Removed Duplicate Records
Used `ROW_NUMBER()` partitioned across every meaningful column to flag true duplicate rows (not just partial matches), then removed the extras while keeping one copy of each.

### 4. Standardized Text Fields
Trimmed stray whitespace and consolidated inconsistent category labels (e.g. merging `Crypto`, `Cryptocurrency`, and similar variants into a single standardized value).

### 5. Fixed Data Types — Timestamp to Clean Date
The `date` column was stored as a `TIMESTAMP`. Converted it to a clean `DATE` type via a safe add-populate-drop-rename sequence, since Oracle doesn't allow a direct in-place type change on a column with existing data.

### 6. Handled NULL Values
Discovered that missing values weren't stored as true database NULLs, but as the **literal text string `'NULL'`** — a common data-quality trap from CSV exports. Queried for both cases explicitly, then populated missing `industry` values by cross-referencing other records for the same company.

### 7. Removed Unrecoverable Rows
Deleted records where both `total_laid_off` and `percentage_laid_off` were missing — with no reliable way to estimate or infer them, these rows carried no analytical value.

### 8. Final Cleanup
Dropped the helper `row_num` column used for duplicate detection, leaving a clean, analysis-ready table.

*Full query details for each step are available in [`data_cleaning.sql`](./data_cleaning.sql).*

---

## 🧠 Key Challenges & How They Were Solved

| Challenge | Solution |
|---|---|
| **MySQL tutorial syntax didn't translate directly to Oracle** | Rebuilt logic using Oracle-native syntax — e.g. `TO_DATE()` instead of `STR_TO_DATE()`, `MERGE` instead of MySQL's self-join `UPDATE`, and double-quoted `"date"` to safely reference a reserved keyword as a column name. |
| **`ROW_NUMBER()` alone can't drive a `DELETE`** | Oracle doesn't allow filtering directly on window function output within a `DELETE`. Solved by first materializing the row numbers into a real table (`layoffs_copy1`), then filtering and deleting from that. |
| **Literal `'NULL'` text values, not true NULLs** | Diagnosed via `ORA-01722` numeric conversion errors, then handled explicitly with `OR column = 'NULL'` conditions throughout, rather than relying on `IS NULL` alone. |
| **Timestamp-to-Date conversion with existing data** | Used a safe 4-step column swap (add new column → populate via `TO_DATE`/`SUBSTR` → drop old column → rename) instead of a risky in-place `ALTER ... MODIFY`. |

---

## ✅ Skills Demonstrated

- Advanced SQL: window functions (`ROW_NUMBER()`), CTEs, `MERGE` statements, subqueries
- Data quality diagnosis (detecting disguised NULLs, malformed values)
- Safe, reversible data transformation workflows (staging tables, backups before destructive operations)
- Oracle-specific syntax and system views (`user_tab_columns`, `ROWID`, reserved-word handling)
- Cross-dialect SQL translation (MySQL → Oracle)

---

## ▶️ How to Run

1. Load the raw dataset into an Oracle SQL environment (e.g. [FreeSQL](https://freesql.com), Oracle APEX, or any Oracle Database instance) as a table named `LAYOFFS`.
2. Run `data_cleaning.sql` from top to bottom in a SQL worksheet.
3. The final cleaned dataset will be available in the `layoffs_copy1` table.

---

## 📁 Repository Structure

```
oracle-sql-data-cleaning/
│
├── layoffs.csv          # Raw dataset used for this project
├── data_cleaning.sql    # Full SQL script: exploration → duplicates → standardization → nulls → final cleanup
└── README.md            # Project documentation
```

---

## 🤝 Connect

If you have feedback, questions, or just want to talk data — feel free to reach out or open an issue on this repo!

- 💼 LinkedIn: [Tanushree Mandal](https://linkedin.com/in/tanushree-mandal-aba24b286)
- 📧 Email: [tanushreemandal235@gmail.com](tanushreemandal235@gmail.com)