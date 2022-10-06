library(rpart)
library(visNetwork)

# Basic classification tree
res <- rpart(Species~., data=iris)
visTree(res, main = "Iris classification Tree", width = "100%")

# Regression tree
res <- rpart(Petal.Length~., data=iris)
visTree(res, edgesFontSize = 14, nodesFontSize = 16, width = "100%")

rm(list=ls())

# Complex tree
data("solder")
res <- rpart(Opening~., data = solder, control = rpart.control(cp = 0.00005))
visTree(res, data = solder, nodesPopSize = TRUE, minNodeSize = 10, 
        maxNodeSize = 30, height = "800px")

# ----- Options
res <- rpart(Opening~., data = solder, control = rpart.control(cp = 0.005))

# fallen leaves + align edges label & size
visTree(res, fallenLeaves = TRUE, height = "500px", 
        edgesFontAlign = "middle", edgesFontSize = 20)

# disable rules in tooltip, and render tooltip faster
# enable hover highlight
visTree(res, rules = FALSE, tooltipDelay = 0, 
        highlightNearest = list(enabled = TRUE, degree = list(from = 50000, to = 0), 
                                hover = TRUE, algorithm = "hierarchical"))

# Change color with data.frame
colorVar <- data.frame(variable = names(solder), 
                       color = c("#339933", "#b30000","#4747d1","#88cc00", "#9900ff","#247856"))

colorY <- data.frame(modality = unique(solder$Opening), 
                     color = c("#AA00AA", "#CDAD15", "#213478"))

visTree(res, colorEdges = "#000099", colorVar = colorVar, colorY = colorY)

# Change color with vector
visTree(res, colorEdges = "#000099", 
        colorVar = substring(rainbow(6), 1, 7), 
        colorY = c("blue", "green", "orange"))


# Use visNetwork functions to add more options
visTree(res) %>% 
  visOptions(highlightNearest = TRUE)

