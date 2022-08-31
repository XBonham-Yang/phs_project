# cleaning names - age_sex demographics
hospital_admissions_by_hb_agesex_2022_03_02_cleaned <- hospital_admissions_by_hb_agesex_2022_03_02_covid %>% 
  clean_names() %>%
  mutate(week_ending_amended = as.Date(ymd(week_ending)), .after = week_ending) %>% 
  mutate(month_of_admission = month(week_ending_amended, label = T), .before = hb) %>% 
  mutate(year_of_admission = year(week_ending_amended), .before = hb) %>% 
  mutate(month_year = make_datetime(year_of_admission, month_of_admission), .before = hb) %>%
  mutate(age_group_fct = factor(age_group, levels = c("Under 5", "5 - 14", "15 - 44", "45 - 64", "65 - 74", "75 - 84", "85 and over", "All ages")), .after = age_group) %>% 
  select(week_ending, week_ending_amended, month_of_admission, year_of_admission, month_year, hb, age_group, age_group_fct, sex, admission_type, number_admissions, average20182019, percent_variation) # removing columns that are not required

hospital_admissions_by_hb_agesex_2022_03_02_cleaned

write_csv(hospital_admissions_by_hb_agesex_2022_03_02_cleaned, "clean_data/hospital_admissions_by_hb_agesex_2022_03_02_cleaned.csv")

