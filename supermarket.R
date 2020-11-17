packages <- c("tidyverse", "simmer")

sapply(packages, function(x){require(x, character.only = T)})

##parameter
checkout_time_mean <- 3
checkout_time_sd <- 1

customer_arrival_time_mean <- 0.5
customer_arrival_time_sd <- 0.2
customer_number <- 100

checkout_time <- function(){
  
  rnorm(1, checkout_time_mean, checkout_time_sd)
  
}

customer_arrival <- function(){
  
  c(0, rnorm(customer_number - 1,
             customer_arrival_time_mean,
             customer_arrival_time_sd),
    -1)
  
}

customer <- trajectory("Customer path") %>% 
  seize("checkout") %>% 
  log_("At checkout") %>% 
  timeout(checkout_time) %>% 
  release("checkout")

supermarket <- simmer("supermarket") %>% 
  add_resource("checkout", 1) %>% 
  add_generator("Customer", customer, customer_arrival)

supermarket %>% run()

x <- supermarket %>% get_mon_arrivals() %>% 
  mutate(waiting_time = end_time - start_time - activity_time)
y <- supermarket %>% get_mon_resources()

supermarket %>% get_attribute(supermarket, "dick")
