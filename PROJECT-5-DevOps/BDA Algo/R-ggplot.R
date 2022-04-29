library(tidyverse)
library(tidyr)
library(MASS)
library(dplyr)
library(gapminder)
library(palmerpenguins)
library(ggplot2)

ggplot(data = BOD, 
       mapping = aes(x = Time,
                     y = demand)) +
      geom_point() +
      geom_line()

ggplot(BOD, aes(Time, demand)) +
  geom_point(size = 3) +
  geom_line(colour = "red")

CO2 %>% 
  ggplot(aes(conc, uptake,
         colour = Treatment)) +
  geom_point(size = 3, alpha = 0.5) +
  geom_smooth(method = lm, se = F) +
  facet_wrap(~Type) +
  labs(title = "conc of co2") +
  theme_bw()

CO2 %>% 
  ggplot(aes(Treatment, uptake)) +
  geom_boxplot() +
  geom_point(alpha = 0.5,
             aes(size = conc, colour = Plant)) +
  facet_wrap(~Type) +
  coord_flip() +
  theme_bw()

mpg %>% 
  filter(cty < 25) %>% 
  ggplot(aes(displ, cty)) +
  geom_point(aes(colour= drv,
                 size = trans)) +
  geom_smooth() +
  facet_wrap(~year, nrow = 1)

mpg %>% 
  filter(hwy < 35) %>% 
  ggplot(aes(x = displ,
             y = hwy,
             colour = drv)) +
  geom_point() + 
  geom_smooth(method = lm, se = F) +
  labs(x = "Engine Size", 
       y = "MPG on the Highway",
       title = "Fuel Efficiency") +
  theme_minimal()
# if we would have used colour = drv in
# geom_point then we would get single line
# since geom_point aesthetics will be linked to
# ggplot(), so basically if we want some aesthetics
# to be inherited by all the layers we would have to
# define that aesthetics inside ggplot

names(msleep)

# categorical 
msleep %>% 
  drop_na(vore) %>% 
  ggplot(aes(x = fct_infreq(vore))) +
  geom_bar(fill = "#97B3C6") +
  #coord_flip() +
  theme_bw() +
  labs(x = "vore",
       y = NULL,
       title = "Number of Vore")


# single numberic
msleep %>% 
  ggplot(aes(awake)) +
  geom_histogram(binwidth = 2, fill = "#97B3C6") +
  theme_bw() + 
  labs(x = "Total Sleep",
       y = NULL,
       title = "Histogram of total sleep")

# multiple numeric
msleep %>% 
  filter(bodywt < 2) %>% 
  ggplot(aes(bodywt, brainwt)) + 
  geom_point(aes(color = sleep_total,
                 size = awake)) +
  geom_smooth() +
  labs(x = "Body Weight",
       y = "Brain Weight",
       title = "Brain and Body Weight") +
  theme_minimal()

# 2 numeric variable and 1 categorical

View(Orange)

Orange %>% 
  filter(Tree != "2") %>% 
  ggplot(aes(age, circumference)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~Tree) +
  theme_bw() +
  labs(title = "labs and circumference")
  

Orange %>% 
  filter(Tree != "2") %>% 
  ggplot(aes(age, circumference, color = Tree)) +
  geom_point() +
  geom_line() + 
  theme_bw() +
  labs(title = "labs and circumference")
