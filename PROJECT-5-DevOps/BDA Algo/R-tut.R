library(tidyverse)
library(tidyr)
library(MASS)
library(dplyr)
library(gapminder)
library(palmerpenguins)
library(ggplot2)

data()
View(starwars)
attach(starwars)

starwars %>% 
  dplyr::select(gender, mass, height, species) %>% 
  filter(species == "Human") %>% 
  na.omit() %>% 
  mutate(height = height/100) %>% 
  mutate(BMI = mass / height^2) %>% 
  group_by(gender) %>% 
  summarise(Average_BMI = mean(BMI))

# reordering, renaming

sw <- starwars %>% 
  dplyr::select(name, mass, height) %>% 
  rename(weight = mass) %>% 
  View()

# recoding

sw <- starwars %>% 
  dplyr::select(name, height, mass, sex) %>% 
  rename(weight = mass) %>% 
  na.omit() %>% 
  mutate(height = height/100) %>% 
  filter(sex %in% c("male", "female")) %>% 
  mutate(sex = recode(sex,
                         male = "m",
                         female = "f")) %>%
  mutate(size = height > 1 & weight > 75,
         size = if_else(size == TRUE, "big", "small")) %>% 
  View()

# filtering tips

View(msleep)
my_data <- msleep %>% 
  dplyr::select(name, sleep_total) %>% 
  filter(between(sleep_total, 16, 18)) %>% 
  View()

my_data <- msleep %>% 
  dplyr::select(name, sleep_total) %>% 
  filter(near(sleep_total, 17, tol = 0.5)) %>% 
  View()

my_data <- msleep %>% 
  dplyr::select(name, conservation, sleep_total) %>% 
  filter(!is.na(conservation)) %>% 
  View()

# functions and objecs in R

View(cars)
my_age <- 12
your_age <- 14
sum(my_age, your_age)
plot(cars)
hist(cars$speed)
summary(cars)
class(cars)
class(cars$speed)
length(cars$speed)
unique(cars$speed)
subset <- cars[3:6, 1:2] %>% 
  View()
median(cars$dist)
new_data <- c(2, 4, 6, 3, NA, 9)
median(new_data, na.rm = TRUE)

# data exploration

dim(starwars)
str(starwars)
glimpse(starwars)
names(starwars)
table(hair_color)
View(sort(table(hair_color), decreasing = TRUE))
barplot(sort(table(hair_color), decreasing = TRUE))

starwars %>% 
  dplyr::select(hair_color) %>% 
  count(hair_color) %>% 
  arrange(desc(n)) %>% 
  View()

View(starwars[is.na(hair_color), ])
 
# clean data

starwars$gender <- as.factor(starwars$gender)
class(starwars$gender)
levels(starwars$gender)
starwars$gender <- factor((starwars$gender),
                          levels = c("masculine",
                                     "feminine")) 

levels(starwars$gender)

starwars %>% 
  dplyr::select(name, height, ends_with("color")) %>% 
  names()


starwars %>% 
  dplyr::select(name, height, ends_with("color")) %>% 
  filter(hair_color %in% c("blond", "brown") & 
           height < 180) %>% 
  View()

starwars %>% 
  dplyr::select(name, gender, hair_color, height) %>% 
  filter(!complete.cases(.)) %>% 
  drop_na(height) 

starwars %>% 
  dplyr::select(name, gender, hair_color, height) %>% 
  filter(!complete.cases(.)) %>% 
  mutate(hair_color = replace_na(hair_color, "none"))

Names <- c("Peter", "John", "Andrew", "Peter")
Age <- c(22, 33, 44, 22)

friends <- data.frame(Names, Age)

duplicated(friends)
friends[!duplicated(friends), ]
friends %>% distinct()

# data wrangling

View(gapminder)
attach(gapminder)
data <- dplyr::select(gapminder, country, year, lifeExp)

wide_data <- data %>% 
  pivot_wider(names_from = year, values_from = lifeExp)

View(wide_data)

long_data <- wide_data %>% 
  pivot_longer(2:13, 
               names_to = "year", 
               values_to = "lifeExp")
View(long_data)
 
# describe and summarize data
?msleep
View(msleep)
msleep
msleep %>% 
  drop_na(vore) %>% 
  dplyr::select(vore, sleep_total) %>% 
  group_by(vore) %>% 
  summarise(MIN_SLEEP = min(sleep_total),
            MAX_SLEEP = max(sleep_total),
            AVG_SLEEP = mean(sleep_total)) %>% 
  arrange(-AVG_SLEEP) %>% 
  View()
  
Cars93
glimpse(Cars93)
attach(Cars93)
table(Origin)
table(AirBags, Origin)
addmargins(table(AirBags, Origin), 1)
addmargins(table(AirBags, Origin), 2)
addmargins(table(AirBags, Origin))
prop.table(table(AirBags, Origin))*100
prop.table(table(AirBags, Origin), 2)*100
prop.table(table(AirBags, Origin), 1)*100
round(prop.table(table(AirBags, Origin), 1)*100)

Cars93 %>% 
  group_by(Origin, AirBags) %>% 
  summarise(number = n()) %>% 
  pivot_wider(names_from = Origin, values_from = number)
