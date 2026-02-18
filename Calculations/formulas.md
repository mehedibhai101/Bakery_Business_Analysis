# 📠 Excel Formulas: Bakery Business Analysis

This documentation details the Excel table formulas used to transform raw transaction logs into a comprehensive business intelligence dataset. These formulas handle data enrichment, financial calculations, and demographic segmentation.

---

## 📋 Data Enrichment & Lookups

These formulas pull product-specific information from secondary reference tables using modern Excel lookup functions.

* **Buyer Name**: Combines first and last names into a single string.

  * **Formula**: `=TEXTJOIN(" ", TRUE, Table1[@[Buyer First Name]:[Buyer Last Name]])`

* **Biscuit Brand**: Retrieves the brand name based on the unique product code.

  * **Formula**: `=XLOOKUP([@[Product Code]], Product_Code, Biscuit_Brand)`

* **Unit Cost**: Retrieves the manufacturing/wholesale cost per unit.

  * **Formula**: `=XLOOKUP([@[Product Code]], Product_Code, Cost)`

* **Unit Price**: Retrieves the retail selling price per unit.

  * **Formula**: `=XLOOKUP([@[Product Code]], Product_Code, Unit_Price)`

---

## 💰 Financial Performance

Standardized accounting formulas used to calculate margins and total returns per transaction.

* **COGS (Cost of Goods Sold)**: The total internal cost for the quantity sold.

  * **Formula**: `=[@[Unit Cost]] * [@[Quantity Purchased]]`

* **Revenue**: Total gross income from the sale.

  * **Formula**: `=[@[Quantity Purchased]] * [@[Unit Price]]`

* **Profit**: The net gain after deducting COGS from Revenue.

  * **Formula**: `=[@Revenue] - [@COGS]`

* **Profit%**: The markup percentage relative to the cost.

  * **Formula**: `=[@Profit] / [@COGS]`

---

## 👥 Customer & Market Segmentation

Categorical logic used to group customers and products for pivot table analysis.

* **Buyer Age**: Calculates the age of the customer at the specific time of purchase.

  * **Formula**: `=DATEDIF([@[Buyer Date of Birth]], [@[Transaction Date]], "Y")`

* **Age Group**: Groups ages into 15-year buckets (e.g., 15-29, 30-44) for demographic trends.

  * **Formula**: `=FLOOR([@[Buyer Age]], 15) & " - " & FLOOR([@[Buyer Age]], 15) + 14`

* **Price Group**: Categorizes items based on their retail value.

  * **Formula**: `=IF([@[Unit Price]] <= 10, "Low-Priced", "High-Priced")`

* **Region**: Maps specific cities to broad geographical sales territories.

  * **Formula**:
  
  ```excel
  =IFS(
    OR([@[Buyer Location]]="New York", [@[Buyer Location]]="Philadelphia"), "East",
    OR([@[Buyer Location]]="Los Angeles", [@[Buyer Location]]="San Diego", [@[Buyer Location]]="San Jose", [@[Buyer Location]]="Phoenix"), "West",
    [@[Buyer Location]]="Chicago", "North",
    OR([@[Buyer Location]]="Houston", [@[Buyer Location]]="San Antonio", [@[Buyer Location]]="Dallas"), "South",
    TRUE, "Unknown"
  )
  ```

---

## 🧠 Explanation of Logic & Best Practices

* **Modern Lookups (`XLOOKUP`)**: Unlike the older `VLOOKUP`, `XLOOKUP` is used here because it is more robust—it doesn't require the product code to be the first column in the reference array and won't break if new columns are inserted into the source data.

* **Dynamic Age Calculation**: Using undocumented `DATEDIF` function with the "Y" parameter ensures we get the completed years of age. By comparing the `Date of Birth` to the `Transaction Date` (rather than the current date), the data remains historically accurate even if the file is opened years later.

* **Mathematical Binning (`FLOOR`)**: The `Age Group` formula uses the `FLOOR` function to create mathematical boundaries. By rounding the age down to the nearest multiple of 15 and then concatenating a string, it automatically creates uniform buckets like "30 - 44" without requiring a long, complex `IFS` statement.

* **Revenue Recognition**: Note that `COGS` and `Revenue` are calculated at the row level. This is a best practice for Excel Data Models, as it allows for simple summation in Pivot Tables while maintaining the ability to drill down into specific transaction variances.


### 📌 The rest of the calculations were performed using the dynamic features of Pivot Tables.
