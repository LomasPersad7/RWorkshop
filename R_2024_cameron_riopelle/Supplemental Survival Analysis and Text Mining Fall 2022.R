# Supplemental: Survival Analysis & Text Mining
# Cameron Riopelle, PhD
# 2022/11/08

# This section follows <https://www.emilyzabor.com/tutorials/survival_analysis_in_r_tutorial.html>
# with some adaptations. Another good resource is <https://web.njit.edu/~wguo/Math%20659_2011/R_survival%20package_intro.pdf>

# Note that some packages are being downloaded and installed from Github using the "remotes" library.
# Be aware that I have "commented out" the install.packages lines because I've already installed them.
# You would need to take out the hashtags the first time you run this code. CTRL + SHIFT + C comments out / in 
# multiple lines.

# install.packages("remotes")
# 
# #Note, you will probably need to interact with the console (e.g., type 1 and press ENTER) to continue
remotes::install_github("zabore/condsurv")
remotes::install_github("zabore/ezfun")
install.packages("ggsurvfit")
install.packages("tidycmprsk")

install.packages("lubridate")
install.packages("ggsurvfit")
install.packages("gtsummary")
install.packages("tidycmprsk")

library(survival)
library(lubridate)
library(ggsurvfit)
library(gtsummary)
library(tidycmprsk)
library(condsurv)
library(MASS)
library(dplyr)

data(Melanoma, package = "MASS")

Melanoma <- 
  Melanoma %>% 
  mutate(status = as.factor(recode(status, `2` = 0, `1` = 1, `3` = 2))
  )

Melanoma <- 
  Melanoma %>% 
  mutate(status = as.factor(recode(status, `2` = 0, `1` = 1, `3` = 2))
  )


# Kaplan-Meier Plots using ggsurvfit

lung <- 
  lung %>% 
  mutate(
    status = recode(status, `1` = 0, `2` = 1)
  )

survfit2(Surv(time, status) ~ 1, data = lung) %>% 
  ggsurvfit() +
  labs(
    x = "Days",
    y = "Overall survival probability"
  )

# With CI

survfit2(Surv(time, status) ~ 1, data = lung) %>% 
  ggsurvfit() +
  labs(
    x = "Days",
    y = "Overall survival probability"
  ) + 
  add_confidence_interval()

# With CI and risk table AND split by sex

survfit2(Surv(time, status==1) ~ sex, data = lung) %>% 
  ggsurvfit() +
  labs(
    x = "Days",
    y = "Overall survival probability"
  ) + 
  add_confidence_interval() +
  add_risktable()

#"A non-parametric estimate of the cumulative incidence of the event of interest. 
#At any point in time, the sum of the cumulative incidence of each event is equal 
#to the total cumulative incidence of any event (not true in the cause-specific setting). 
#Gray’s test is a modified Chi-squared test used to compare 2 or more groups.
#Estimate the cumulative incidence in the context of competing risks 
#using the cuminc function from the {tidycmprsk} package. 
#By default this requires the status to be a factor variable with censored patients coded as 0."

cuminc1 <- cuminc(Surv(time, status) ~ 1, data=Melanoma) 

ggcuminc1 <- ggcuminc(cuminc1) + 
  labs(
    x = "Days",
    y = "Cumul. Inc."
  ) 

ggcuminc1 + add_confidence_interval() + add_risktable()

cuminc(Surv(time, status) ~ 1, data = Melanoma) %>% 
  ggcuminc() + 
  labs(
    x = "Days"
  ) + 
  add_confidence_interval() +
  add_risktable()

# Cumulative Incidence by Ulceration Status

cuminc(Surv(time, status) ~ ulcer, data = Melanoma) %>% 
  ggcuminc() + 
  labs(
    x = "Days"
  ) + 
  add_confidence_interval() +
  add_risktable()

# Cox Proportional hazards regression

crr(Surv(time, status) ~ sex + age, data = Melanoma)

# Pretty table of hazard estimates

crr(Surv(time, status) ~ sex + age, data = Melanoma) %>% 
  tbl_regression(exp = TRUE)

# Checking fit

mv_fit <- coxph(Surv(time, status) ~ sex + age, data = lung)
cz <- cox.zph(mv_fit)
print(cz)

# If the covariate and overall model proporational hazards are significant, we would
# reject the null hypothesis of proprotional hazards (which we want NOT to reject)
# and conclude it's a good fit.

plot(cz)

# Supplemental: Text mining with R

# This section follows <https://www.tidytextmining.com/>

# install.packages("tidytext")
# install.packages("janeaustenr")
# install.packages("dplyr")
# install.packages("stringr")
# install.packages("tidyr")
# install.packages("ggplot2")

library(tidytext)
library(janeaustenr)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)

# Sentiment Analysis

get_sentiments("afinn")
get_sentiments("bing")
get_sentiments("bing")
get_sentiments("nrc")


tidy_books <- austen_books() %>%
  group_by(book) %>%
  mutate(
    linenumber = row_number(),
    chapter = cumsum(str_detect(text, 
                                regex("^chapter [\\divxlc]", 
                                      ignore_case = TRUE)))) %>%
  ungroup() %>%
  unnest_tokens(word, text)

nrc_joy <- get_sentiments("nrc") %>% 
  filter(sentiment == "joy")

tidy_books %>%
  filter(book == "Emma") %>%
  inner_join(nrc_joy) %>%
  count(word, sort = TRUE)


jane_austen_sentiment <- tidy_books %>%
  inner_join(get_sentiments("bing")) %>%
  count(book, index = linenumber %/% 80, sentiment) %>%
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) %>% 
  mutate(sentiment = positive - negative)




ggplot(jane_austen_sentiment, aes(index, sentiment, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~book, ncol = 2, scales = "free_x")


# Topic Modeling

# We can change k from 2 to any other number if we want to see if 
# there are other emergent topics


ap_lda <- LDA(AssociatedPress, k = 2, control = list(seed = 1234))
ap_lda

ap_topics <- tidy(ap_lda, matrix = "beta")
ap_topics


ap_top_terms <- ap_topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>% 
  ungroup() %>%
  arrange(topic, -beta)

ap_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(beta, term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered()