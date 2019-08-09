# Cargamos la información
Census.Data <-read.csv("practical_data.csv")

# En el archivo CSV tendremos a la mano izquierda los datos para eje x, 
# a la mano derecha es para eje y. Usaremos el comando $ para seleccionar la columna del data frame que queremos utilizar.
plot(Census.Data$Unemployed,Census.Data$Qualification)

# Agregamos etiquetas a los ejes
plot(Census.Data$Unemployed,Census.Data$Qualification,xlab="% in full time employment", ylab="% With a Qualification")

# Agregamos al final una opción para símbolos
# Mayores detalles en:https://www.statmethods.net/advgraphs/parameters.html
# Símbolos con pch=21 a pch=25 pueden tener borde y sombreado
plot(Census.Data$Unemployed,Census.Data$Qualification,xlab="% in full time employment",
     ylab="% With a Qualification",pch=21,col="mediumaquamarine",bg="black")

# Si se desea revisar nombres de otros colores, podemos usar el comando colors
colors()

# Creamos un gráfico de símbolos proporcionales
symbols(Census.Data$Unemployed,Census.Data$Qualification,  
        circles = Census.Data$White_British, fg="white", bg ="purple", inches = 0.2)

# Gráfico de burbujas (bubble plot)
symbols(Census.Data$Unemployed, Census.Data$Qualification,  circles = Census.Data$White_British, 
        fg="white", bg ="purple", inches = 0.2,  xlab="% in full time employment", ylab="% With a Qualification") +

# Agregamos una línea de regresión lineal y le damos color rojo
  abline(lm(Census.Data$Qualification~ Census.Data$Unemployed), col="red")


# Ahora probaremos a la librería ggplot2
library("ggplot2")

p <- ggplot(Census.Data, aes(Unemployed,Qualification))
p + geom_point()

p <- ggplot(Census.Data, aes(Unemployed,Qualification))
p + geom_point(aes(colour = White_British, size = Low_Occupancy))
