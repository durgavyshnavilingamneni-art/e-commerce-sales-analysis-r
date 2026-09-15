
# E-COMMERCE SALES & PROFITABILITY ANALYSIS USING R


# 1. Load Packages
library(tidyverse)
library(lubridate)

setwd("C:/Users/user/Desktop/E commerce-R")
# 2. Import Dataset
data <- read.csv(file.choose())


# 3. Understand the Dataset
head(data)
dim(data)
names(data)
str(data)
summary(data)


# 4. Data Cleaning

# Missing values
colSums(is.na(data))

# Duplicate rows
sum(duplicated(data))

# Convert Order Date
data$Order.Date <- as.Date(data$Order.Date)

class(data$Order.Date)


# 5. Basic Statistics

summary(data$Sales)
summary(data$Profit)
summary(data$Quantity)
summary(data$Discount)


# 6. Category-wise Sales Analysis

p1 <- ggplot(category_sales,
       aes(x = reorder(Category, Total_Sales),
           y = Total_Sales)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Total Sales by Category",
    x = "Category",
    y = "Total Sales"
  )

p1

ggsave(
  "visualizations/category_sales.png",
  plot = p1,
  width = 8,
  height = 6
)
# Category Sales Visualization
ggplot(category_sales,
       aes(x = reorder(Category, Total_Sales),
           y = Total_Sales)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Total Sales by Category",
    x = "Category",
    y = "Total Sales"
  )


# 7. Region-wise Sales Analysis

region_sales <- data %>%
  group_by(Region) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit)
  ) %>%
  arrange(desc(Total_Sales))

region_sales


# 8. Monthly Sales Trend

data$Month <- format(data$Order.Date, "%Y-%m")

monthly_sales <- data %>%
  group_by(Month) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit)
  ) %>%
  arrange(Month)

monthly_sales


ggplot(monthly_sales,
       aes(x = Month,
           y = Total_Sales,
           group = 1)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Monthly Sales Trend",
    x = "Month",
    y = "Total Sales"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


# 9. Top 10 Products

top_products <- data %>%
  group_by(Product.Name) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit),
    Total_Quantity = sum(Quantity)
  ) %>%
  arrange(desc(Total_Sales)) %>%
  head(10)

top_products


ggplot(top_products,
       aes(x = reorder(Product.Name, Total_Sales),
           y = Total_Sales)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Top 10 Products by Sales",
    x = "Product",
    y = "Total Sales"
  )


# 10. Profit by Category

profit_category <- data %>%
  group_by(Category) %>%
  summarise(
    Total_Profit = sum(Profit)
  ) %>%
  arrange(desc(Total_Profit))

profit_category


ggplot(profit_category,
       aes(x = reorder(Category, Total_Profit),
           y = Total_Profit)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Total Profit by Category",
    x = "Category",
    y = "Total Profit"
  )


# 11. Discount Analysis

discount_profit <- data %>%
  group_by(Discount) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit),
    Average_Profit = mean(Profit)
  )

discount_profit


ggplot(discount_profit,
       aes(x = Discount,
           y = Total_Profit)) +
  geom_line() +
  geom_point() +
  labs(
    title = "Discount vs Total Profit",
    x = "Discount (%)",
    y = "Total Profit"
  )


# 12. Payment Mode Analysis

payment_analysis <- data %>%
  group_by(Payment.Mode) %>%
  summarise(
    Total_Orders = n(),
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit)
  ) %>%
  arrange(desc(Total_Orders))

payment_analysis


ggplot(payment_analysis,
       aes(x = reorder(Payment.Mode, Total_Orders),
           y = Total_Orders)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Orders by Payment Mode",
    x = "Payment Mode",
    y = "Number of Orders"
  )


# 13. Top 10 Customers

top_customers <- data %>%
  group_by(Customer.Name) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit),
    Total_Orders = n()
  ) %>%
  arrange(desc(Total_Sales)) %>%
  head(10)

top_customers


# 14. City-wise Sales

city_sales <- data %>%
  group_by(City) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit),
    Total_Orders = n()
  ) %>%
  arrange(desc(Total_Sales))

city_sales


# 15. Profit Margin by Category

category_margin <- data %>%
  group_by(Category) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit)
  ) %>%
  mutate(
    Profit_Margin = (Total_Profit / Total_Sales) * 100
  ) %>%
  arrange(desc(Profit_Margin))

category_margin


ggplot(category_margin,
       aes(x = reorder(Category, Profit_Margin),
           y = Profit_Margin)) +
  geom_col() +
  coord_flip() +
  labs(
    title = "Profit Margin by Category",
    x = "Category",
    y = "Profit Margin (%)"
  )


# 16. Quantity vs Sales

ggplot(data,
       aes(x = Quantity,
           y = Sales)) +
  geom_point(alpha = 0.5) +
  labs(
    title = "Quantity vs Sales",
    x = "Quantity",
    y = "Sales"
  )


# 17. Region and Category Analysis

region_category <- data %>%
  group_by(Region, Category) %>%
  summarise(
    Total_Sales = sum(Sales),
    Total_Profit = sum(Profit),
    .groups = "drop"
  )

region_category


ggplot(region_category,
       aes(x = Category,
           y = Region,
           size = Total_Sales)) +
  geom_point() +
  labs(
    title = "Sales by Region and Category",
    x = "Category",
    y = "Region",
    size = "Total Sales"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  )


# 18. Overall Business KPIs

total_sales <- sum(data$Sales)

total_profit <- sum(data$Profit)

total_orders <- nrow(data)

total_quantity <- sum(data$Quantity)

average_order_value <- mean(data$Sales)

profit_margin <- (total_profit / total_sales) * 100



kpi_summary <- data.frame(
  Metric = c(
    "Total Sales",
    "Total Profit",
    "Total Orders",
    "Total Quantity",
    "Average Order Value",
    "Profit Margin"
  ),
  Value = c(
    total_sales,
    total_profit,
    total_orders,
    total_quantity,
    average_order_value,
    profit_margin
  )
)

kpi_summary
# 19. Best Performing Category / Region / Product / Customer

best_sales_category <- category_sales %>%
  slice_max(Total_Sales, n = 1)

best_profit_category <- profit_category %>%
  slice_max(Total_Profit, n = 1)

best_margin_category <- category_margin %>%
  slice_max(Profit_Margin, n = 1)

best_region <- region_sales %>%
  slice_max(Total_Sales, n = 1)

best_product <- top_products %>%
  slice_max(Total_Sales, n = 1)

best_customer <- top_customers %>%
  slice_max(Total_Sales, n = 1)


best_sales_category
best_profit_category
best_margin_category
best_region
best_product
best_customer
# 20. SAVE VISUALIZATIONS

if (!dir.exists("visualizations")) {
  dir.create("visualizations")
}

# Category Sales
ggsave(
  "visualizations/category_sales.png",
  width = 8,
  height = 5
)

# Monthly Sales
ggsave(
  "visualizations/monthly_sales.png",
  width = 10,
  height = 5
)

# Top 10 Products
ggsave(
  "visualizations/top_products.png",
  width = 8,
  height = 5
)

# Profit by Category
ggsave(
  "visualizations/profit_category.png",
  width = 8,
  height = 5
)

# Profit Margin
ggsave(
  "visualizations/profit_margin.png",
  width = 8,
  height = 5
)

# Payment Mode
ggsave(
  "visualizations/payment_mode.png",
  width = 8,
  height = 5
)

# Quantity vs Sales
ggsave(
  "visualizations/quantity_sales.png",
  width = 8,
  height = 5
)

# Region and Category
ggsave(
  "visualizations/region_category.png",
  width = 8,
  height = 5
)