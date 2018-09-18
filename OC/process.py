# coding: utf-8

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import scipy.stats as st
import statsmodels.api as sm

# Chargement
iris = pd.read_csv("iris_dataset.csv")

# On renomme les colonnes
iris.columns = ["id","sepal_length","sepal_width","petal_length","petal_width","species"]

# On supprime l'identifiant des iris
del iris["id"]

# On supprime les individus contenant au moins une valeur manquante
iris_dna = iris.dropna(axis=0, how='any')
print("iris : {} individus, iris_dna : {} individus".format(len(iris),len(iris_dna)))

# Affichage des diagrammes de dispersion
sns.pairplot(iris_dna,hue="species")
plt.show()

iris_setosa = iris_dna[iris_dna["species"] == "setosa"]
iris_virginica = iris_dna[iris_dna["species"] == "virginica"]
iris_versicolor = iris_dna[iris_dna["species"] == "versicolor"]

# Coeff de correlation (calc avec covar)
cor1 = st.pearsonr(iris_dna["petal_length"],iris_dna["petal_width"])[0]
cor2 = st.pearsonr(iris_dna["petal_width"],iris_dna["sepal_width"])[0]
print("Result 1 : {}\nResult 2 : {}".format(cor1, cor2))

# Methode des moindres carres regression lineaire
def linearRegr(X,Y,xlab):
    X = X.copy()
    X['intercept'] = 1
    result = sm.OLS(Y, X).fit() # OLS = Ordinary Least Square (Moindres Carres Ordinaire)
    a,b = result.params[xlab],result.params["intercept"]
    print(result.params)
    return a,b

Y = iris_dna['petal_width']
X = iris_dna[['petal_length']]
a_dna, b_dna = linearRegr(X,Y,"petal_length")

Y = iris_setosa['sepal_width']
X = iris_setosa[['petal_width']]
a_setosa, b_setosa = linearRegr(X,Y,"petal_width")

Y = iris_virginica['sepal_width']
X = iris_virginica[['petal_width']]
a_virginica, b_virginica = linearRegr(X,Y,"petal_width")

Y = iris_versicolor['sepal_width']
X = iris_versicolor[['petal_width']]
a_versicolor, b_versicolor = linearRegr(X,Y,"petal_width")

coeffs = {
    "cas 1" : {'a': a_dna , 'b': b_dna},
    "cas 2" : {'a': a_setosa , 'b': b_setosa},
    "cas 3" : {'a': a_versicolor , 'b': b_versicolor},
    "cas 4" : {'a': a_virginica , 'b': b_virginica},
}
lignes_modifiees = []

a = coeffs["cas 1"]['a']
b = coeffs["cas 1"]['b']
for (i,individu) in iris.iterrows(): # pour chaque individu de iris,...
    if pd.isnull(individu["petal_width"]): #... on test si individu["petal_width"] est nul.
        X = individu["petal_length"]
        Y = a*X + b
        iris.loc[i,"petal_width"] = Y # on remplace la valeur manquante par Y
        lignes_modifiees.append(i)
        print("On a complete petal_width par {} a partir de petal_length={}".format(Y,X))
        
    if pd.isnull(individu["sepal_width"]):
        espece = individu["species"]
        X = individu["petal_width"]
        Y = a*X + b
        iris.loc[i,"sepal_width"] = Y # on remplace la valeur manquante par Y
        lignes_modifiees.append(i)
        print("On a complete sepal_width par {} a partir de l'espece:{} et de petal_width={}".format(Y,espece,X))

print("Lignes modifiees:")
print(lignes_modifiees)