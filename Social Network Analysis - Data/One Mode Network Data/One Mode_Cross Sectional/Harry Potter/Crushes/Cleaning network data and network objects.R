# This script is intended to instruct students on basic techniques for cleaning network data and network objects. We will start by demonstrating good practices for collecting/storing network data.Then we will go on to cleaning networks once they are stored as network objects in R studio. Some of what we do helps clean up network visualizations, but this is not the purpose of the script. We will cover cleaning network visualizations in another session. 

# Collecting and storing network data, we may come across people who have no connections to the group but are legitimate members of the group we are studying. These are called isolates. In an adjacency matrix, these individuals will have no 1's, only zeros. But what do you do if your data is in an edgelist? 

#The incorrect thing to do is to have their name in col1 (from) and nothing in col2 (to). In other words, leave the 'To' column blank. The below example shows why this is inadvisable. 

hog_crush_wrong <- read.csv(file.choose(), header=TRUE) # select Crushes Edgelist_INCORRECT.csv
# Take a look at the edgeist now it is in and you will see I added a few more characters to this group: Madeye, Flitwick, McGonagal, and Voldemort. They are all listed in the "Crusher" (from) column but have no connection to anyone in the "crush" column. This makes sense, since we know little about their romances from the Harry Potter Saga. 
hog_crush_wrong
library(igraph)
# But, when we make this a graph object, R does something funky.
crush_wrong_net <- graph_from_data_frame(hog_crush_wrong, directed = TRUE)
plot(crush_wrong_net)
# The new characters are all connected to a nameless node and it looks, on visual inspection, that they all have a crush on the smae person. 
# I have higlighted that node in the visualization below. The red node is nameless because the edgelist has empty (nameless) cells.    
V(crush_wrong_net)$wrong <- ifelse(V(crush_wrong_net)$name %in% c(""), "red", "white")
plot(crush_wrong_net, vertex.color = V(crush_wrong_net)$wrong)

# One way to deal with this is to delete the superfluous node. You do this using the delete_vertex() function
crush_wrong_net <- delete_vertices(crush_wrong_net, "")
plot(crush_wrong_net)
#This fixes the issue once you have the data in Rstudio, but the issue still exists in your dataset. If you choose to structure your network data this way, you will have to remember to remvoe this node every time. This may be harder to do/realise when dealing with large dense networks. 

## The correct way of recording isolates in an edgelist is list them as connected to themselves (known as a self loop)
hog_crush_correct <- read.csv(file.choose(), header=TRUE) # select Hogwarts Crushes Edgelist_CORRECT.csv
#Take a look at this edgelist and you will see that these individuals are connected to themselves
hog_crush_correct

#Now when you make this a graph object R does something different. 
Crush_correct_net <-  graph_from_data_frame(hog_crush_correct, directed = TRUE)
plot(Crush_correct_net)
# Now, they have self looped edges!!! These do not look great. To Remove them, you can use the delete_edges() command and select the edges that are looped by using the E() command coupled with the is.loop() option.
Crush_correct_net  <- delete_edges(Crush_correct_net , E(Crush_correct_net )[which_loop(Crush_correct_net )])
plot(Crush_correct_net)
# This is also something you will need to remember to do every time you bring in an edgelist with isolates. 


################################################################################
# Other things to do to clean a network object once in Rstudio. 

## You may want to add or remove nodes and vertices (nodes) from your networ. Only do this if you have legitimate reason to.  

## Deleting Nodes. You might decide to remove one or more nodes from your network. For example, in this hogwarts dataset, we may want to remove those who are not students at Hogwarts (i.e. remove teachers or adults). To do this, you would use the delete_vertices() option

#Basic
hog_crush_students <- delete_vertices(Crush_correct_net, "Voldemort")
plot(hog_crush_students)

#### Pro tip - if you are deleting multiple, it is worth making a vector with all the names of those you want to remove, then use the delete_vertices() command
hog_adults <- c("Severus Snape", "Lily Potter", "James Potter", "Nymphadora Tonks", "Remus Lupin", "Voldemort", "Flitwick", "McGonagal", "Madeye")
hog_crush_students <- delete_vertices(Crush_correct_net, hog_adults)
plot(hog_crush_students)
## This new version removed all unwanted nodes at once. 

## Deleting isolates.
### Sometimes, you want to remove the isolated nodes from your network because you only care about those who have connections to others. To do this, you identify those with no connections (degree = 0) and them remove them from your network. I suggest making a new object with this sub network. 
hog_crush_isol <- which(degree(Crush_correct_net)==0)
#Now you use the delete_vertices() command and remove those in the vector you just created (those with degree = 0)
Crush_no_isol <-delete_vertices(Crush_correct_net, hog_crush_isol)
plot(Crush_no_isol)
#Now this new object has only those nodes with ties to others in the network. 
#Adding Nodes - use add.vertices(graph name, numberof additional vertices, attribute = )
crush_added <- add.vertices(Crush_correct_net, 1, name = "Michael Corner")
plot(crush_added)

## Deleting edges 
### You may want to delete edges between two nodes. 
edges_to_delete <- E(Crush_correct_net)[(.from("Remus Lupin") & .to("Nymphadora Tonks"))]
Crush_edge_delete <- delete_edges(Crush_correct_net, edges_to_delete)
plot(Crush_edge_delete)
## To delete all edges between two nodes 
edges_to_delete2 <- E(Crush_correct_net)[(.from("Remus Lupin") & .to("Nymphadora Tonks")) | .from("Nymphadora Tonks") & .to("Remus Lupin")]
Crush_edge_delete <- delete_edges(Crush_correct_net, edges_to_delete2)
plot(Crush_edge_delete)

## Add Edges
crush_added <- add.edges(crush_added, edges = c("Michael Corner", "Ginny Weasley"))
plot(crush_added)
# Now to add the reciprocated tie
crush_added <- add.edges(crush_added, edges = c("Ginny Weasley", "Michael Corner"))
plot(crush_added)
