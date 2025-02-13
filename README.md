# Appointment-Predictor

![calendar](https://github.com/user-attachments/assets/133158be-1ff3-4326-95e6-4c45e8c964eb)

This Statistical Analysis System(SAS) project provides valuable insights into patient behavior, which could help improve strategies for boosting appointment attendance. The dataset includes details like scheduled and appointment days, and whether the patient received an SMS reminder.
Key Steps:

    Data Import:
        The data is loaded using PROC IMPORT from a CSV file, creating a dataset called EDA_PROJECT.

    Data Wrangling:
        The dataset is explored using PROC CONTENTS to understand its structure.
        Missing values are identified using PROC MEANS.

    Data Cleaning:
        The "No-Show" variable is renamed to "Show" and recoded (1 for Yes, 0 for No).
        Dates are extracted from datetime variables (scheduledday and appointmentday), and a new variable day_diff calculates the difference in days between scheduling and appointment.

    Exploratory Data Analysis (EDA):
        The distribution of the "Show" variable is analyzed and visualized with bar charts.
        Relationships between attendance and other factors (like gender and SMS received) are explored using stacked bar charts.

    Appointment Timeliness Analysis:
        The dataset is categorized based on the difference between scheduling and appointment days, such as "Same Day" or "Few Days".
        A two-way bar plot is used to show how timing affects attendance.

    Weekday Analysis:
        The project identifies which weekdays most missed appointments occur, then visualizes these trends with a bar chart.

Key Outputs:

    Frequency distributions and bar plots highlight the relationship between attendance, appointment timing, and factors like gender and SMS reminders.
    The project also uncovers trends in missed appointments by weekday.

This analysis provides valuable insights into patient behavior, which could help improve strategies for boosting appointment attendance.
