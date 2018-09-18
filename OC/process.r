# Chargement
iris = read.table("iris_dataset.csv",sep=",",header=1) 
# On supprime l'identifiant des iris
iris["id"] = NULL
# On supprime les individus contenant au moins une valeur manquante
iris_dna = na.omit(iris)
sprintf("iris : %i individus, iris_dna : %i individus",nrow(iris),nrow(iris_dna))
# Affichage des diagrammes de dispersion
x11()
pairs(iris_dna[1:4], pch = 21,bg = c("red", "green3", "blue")[unclass(iris$species)])

iris_setosa = iris_dna[iris_dna["species"] == "setosa",]
iris_virginica = iris_dna[iris_dna["species"] == "virginica",]
iris_versicolor = iris_dna[iris_dna["species"] == "versicolor",]

# Coeff de correlation (coeff Pearson)
cor1 <- cor(iris_dna$petal_length, iris_dna$petal_width , method="pearson")
cor2 <- cor(iris_dna$petal_width, iris_dna$sepal_width, method="pearson")

# Regression linéaire (exemple) 
coeffs = lm(petal_width~petal_length,data=iris_dna)$coefficients
print(coeffs)
coeffs = as.numeric(coeffs)
a_dna = coeffs[2]
b_dna = coeffs[1]

coeffs = lm(sepal_width~petal_width,data=iris_setosa)$coefficients
coeffs = as.numeric(coeffs)
a_setosa = coeffs[2]
b_setosa = coeffs[1]

coeffs = lm(sepal_width~petal_width,data=iris_versicolor)$coefficients
coeffs = as.numeric(coeffs)
a_versicolor = coeffs[2]
b_versicolor = coeffs[1]

coeffs = lm(sepal_width~petal_width,data=iris_virginica)$coefficients
coeffs = as.numeric(coeffs)
a_virginica = coeffs[2]
b_virginica = coeffs[1]

coeffs = list(
  "cas 1" = list('a'= a_dna , 'b'= b_dna),
  "cas 2" = list('a'= a_setosa , 'b'= b_setosa),
  "cas 3" = list('a'= a_versicolor , 'b'= b_versicolor),
  "cas 4" = list('a'= a_virginica , 'b'= b_virginica)
)
lignes_modifiees = c()

a = coeffs[["cas 1"]][['a']]
b = coeffs[["cas 1"]][['b']]
for(i in 1:nrow(iris)){ # pour chaque individu de iris,...
  individu = iris[i,]
  if(is.na(individu["petal_width"])){ #... on test si individu["petal_width"] est nul.
    X = individu["petal_length"]
    Y = a*X + b
    iris[i,"petal_width"] = Y # on remplace la valeur manquante par Y
    lignes_modifiees = c(lignes_modifiees,i)
    print(sprintf("On a complété petal_width par %f a partir de petal_length=%f",Y,X))
  }
  if(is.na(individu["sepal_width"])){
    espece = individu["species"]
    X = individu["petal_width"]
    Y = a*X + b
    iris[i,"sepal_width"] = Y
    lignes_modifiees = c(lignes_modifiees,i)
    print(sprintf("On a complété sepal_width par %f a partir de l'espece %s et de petal_width=%f",Y,espece,X))
  }
}

print("Lignes modifiées:")
print(iris[lignes_modifiees,])