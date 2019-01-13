library(dplyr)
my_data <- tbl_df(refine)
my_data
summarize (my_data)
#1: Clean up brand names. Clean up the 'company' column so all of the misspellings of the 
#brand names are standardized. For example, you can transform the values in the column to be: 
#philips, akzo, van houten and unilever (all lowercase).
mutate_at(my_data, my_data$company, funs(tolower(company), gsub("0", "o", my_data$company)))

 my_data %>% mutate(company = tolower(company)) %>% mutate (company = gsub("0", "o", company))


stepone <- my_data %>% mutate(company = tolower(company)) %>% mutate (company = gsub("0", "o", company)) %>% mutate (company = gsub ("f", "ph", company)) %>% mutate(company =gsub ("k z", "kz", company))
stepone
#question- is this the best way to do it? A bunch of then statements? What about for the 'phlips' for example- 
#should we change this to 'phillips' with a mutate command as well or is there a more efficient way to do this?

#2: Separate product code and number
#Separate the product code and product number into separate columns i.e. add two new columns called 
#product_code and product_number, containing the product code and number respectively
steptwo <- stepone %>% mutate (ProductCode = substr(`Product code / number`, 0,1)) %>% mutate(Number = substr(`Product code / number`, 3,5))

print(steptwo, n= 25)
#question- is substr from [3] to [5] the best way to do this or is there a way to say use the end? For cases 
#where the number was not necessiarly a one or two digit number

#3:Add Product Categories
#You learn that the product codes actually represent the following product categories:
#p = Smartphone
#v = TV
#x = Laptop
#q = Tablet
#In order to make the data more readable, add a column with the product category for each record.

stepthree <- steptwo %>% mutate(ProductCategory = case_when(
  ProductCode == "p" ~ "Smartphone",
  ProductCode == "v" ~ "TV",
  ProductCode == "x" ~ "Laptop",
  ProductCode == "q" ~ "Tablet"
))
stepthree
#4: Add full adderess for geocoding.
#You'd like to view the customer information on a map. In order to do that, 
#the addresses need to be in a form that can be easily geocoded. 
#Create a new column full_address that concatenates the three address fields (address, city, country), separated by commas.
stepfour <- stepthree %>% mutate (full_address = paste(address, city, country, sep = ','))
stepfour %>% select (full_address)

#5: Create dummy variables for company and product category
#Both the company name and product category are categorical variables i.e. they take only a fixed set of values. 
#In order to use them in further analysis you need to create dummy variables. Create dummy binary variables for 
#each of them with the prefix company_ and product_ i.e.,
#Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever.
#Add four binary (1 or 0) columns for product category: product_smartphone, product_tv, product_laptop and product_tablet.
stepfivea <- stepfour %>% mutate(company_phillips = as.numeric(company == 'phillips')) %>% mutate(company_akzo = as.numeric(company == 'akzo')) %>% mutate(company_van_houten = as.numeric(company == 'van_houten'))%>% mutate(company_unilever = as.numeric(company == "unilever"))
stepfiveb <- stepfivea %>% mutate(product_smartphone = as.numeric(ProductCategory == 'Smartphone')) %>% mutate(product_tv = as.numeric(ProductCategory == 'TV')) %>% mutate(product_laptop = as.numeric(ProductCategory =='Laptop')) %>% mutate(product_tablet = as.numeric(ProductCategory == 'Tablet'))
stepfiveb %>% select (product_laptop, product_tv, product_tablet, product_smartphone, ProductCategory)

write.csv(stepfiveb, 'McCormickDataWrangling.csv')


