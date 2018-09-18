#Quizz openclassroom 
A <- c(6,4,6,4,6,4,6,4)
B <- c(1,4,1,4,1,4,1,4)
var_A <- var(A)
var_B <- var(B)

# Mediane ({n+1}/2, si pair alors {val(n+1)+val(n)}/2)
dataSet <- c(1,10,1,10,1,1,5,1,5,5)
s <- sort(dataSet)
median(dataSet)

#Mean 
mean(dataSet)

#Mode
y <- table(dataSet)
y
names(y)[which(y == max(y))]
