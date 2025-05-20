library(readr)
library(igraph)
my_data <- read_lines("C:/Users/trleppar/Documents/Teaching/SNA/Spring 2025/DATA/Tom_network_data/One Mode Network Data/One Mode_Cross Sectional/EU EMAILS/Core - Cross-sectional/email-EU-core.txt")

edge_data <- read.table("C:/Users/trleppar/Documents/Teaching/SNA/Spring 2025/DATA/Tom_network_data/One Mode Network Data/One Mode_Cross Sectional/EU EMAILS/Core - Cross-sectional/email-EU-core.txt", header = FALSE)

graph_network <- graph_from_data_frame(edge_data, directed = FALSE)

plot(graph_network)

graph_network_clean <- which(degree(graph_network)==0) # not working??? 
graph_network_clean  <- delete_edges(graph_network , E(graph_network )[which_loop(graph_network )])

plot(graph_network_clean)
