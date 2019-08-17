# No olvidemos configurar el directorio de trabajo!
setwd("C:/Users/monte/Documents/EVENTOS/DATA SCIENCE UNI FIC 2019/Workspace_UNI_2019") 

# Llamamos a las librerías necesarias
library("sp")
library("rgdal")
library("rgeos")

# Cargamos un archivo .csv
Census.Data <-read.csv("practicaldata.csv")

# Cargamos un archivo shape
Output.Areas <- readOGR(".", "Camden_oa11")

# Unimos la información censal del archivo .csv con el archivo shape
OA.Census <- merge(Output.Areas, Census.Data, by.x="OA11CD", by.y="OA")

# Cargamos los puntos de viviendas en venta
House.Points <- readOGR(".", "Camden_house_sales")


#Agregamos nuestros datos de puntos en los polígonos utilizando puntos en sus operaciones
#Configuramos el sistema de referencia
proj4string(OA.Census) <- CRS("+init=EPSG:27700")
proj4string(House.Points) <- CRS("+init=EPSG:27700")

# Hacemos Punto en polígono: Da a los puntos los atributos de los polígonos en los que se encuentran
pip <- over(House.Points, OA.Census)

# Vinculamos los datos censales a nuestros puntos originales
House.Points@data <- cbind(House.Points@data, pip)

View(House.Points@data)

# Ahora veremos que se puede graficar los precios de las viviendas y las tasas locales de desempleo
plot(log(House.Points@data$Price), House.Points@data$Unemployed)


# GRAFICANDO MAPAS CON PUNTO EN POLÍGONO
# Usando la función agregada () podemos decidir qué números se devuelven de nuestros precios de 
# la vivienda (es decir, media, suma, mediana).

# Primero agregamos los precios de la vivienda por la columna OA11CD (nombres de OA), obtenemos la media de cada OA
OA <- aggregate(House.Points@data$Price, by = list(House.Points@data$OA11CD), mean)

# Cambiar los nombres de columna de los datos agregados
names(OA) <- c("OA11CD", "Price")

# Unir los datos agregados de vuelta al polígono OA.Census
OA.Census@data <- merge(OA.Census@data, OA, by = "OA11CD", all.x = TRUE)

# Ahora mapeamos los datos usando tmap. Tendremos datos faltantes donde hay 
# áreas de salida donde no se vendieron casas en 2015.
library(tmap)
tm_shape(OA.Census) + tm_fill(col = "Price", style = "quantile", title = "Mean House Price (£)")

#VEAMOS UN MODELO DE REGRESIÓN LINEAL ENTRE EL DESEMPLEO Y PRECIOS DE VIVIENDAS EN VENTA
model <- lm(OA.Census@data$Price ~ OA.Census@data$Unemployed)
summary(model)


#BUFFERING
# Esta técnica simple se usa comúnmente para determinar qué áreas son proximales a 
# ciertos objetos. Aquí usamos la función gBuffer () de la librería "rgeos"
#Creamos buffers de 200 metros para cada punto de vivienda
house_buffers <- gBuffer(House.Points, width = 200, byid = TRUE)
tm_shape(OA.Census) + tm_borders() +
  tm_shape(house_buffers) + tm_borders(col = "blue") +
  tm_shape(House.Points) + tm_dots(col = "red") 

# Unimos todos los buffers
union.buffers <- gUnaryUnion(house_buffers)

# map in tmap
tm_shape(OA.Census) + tm_borders() +
  tm_shape(union.buffers) + tm_fill(col = "blue", alpha = .4) + tm_borders(col = "blue") +
  tm_shape(House.Points) + tm_dots(col = "red") 

# CREANDO MAPAS INTERACTIVOS
# interactive maps in tmap
library(leaflet)

# turns view map on
tmap_mode("view")

# Veamos un mapa deslizante interactivo donde graficaremos los precios de viviendas
tm_shape(House.Points) + tm_dots(title = "House Prices (£)", border.col = "black", 
                                 border.lwd = 0.1, border.alpha = 0.2, col = "Price", style = "quantile", palette = "Reds") 

#Veamos un mapeo con burbujas
tm_shape(House.Points) + tm_bubbles(size = "Price", title.size = "House Prices (£)", border.col = "black", 
                                    border.lwd = 0.1, border.alpha = 0.4, legend.size.show = TRUE) 

#Ahora veamos un mapeo con polígonos
tm_shape(OA.Census) + tm_fill("Qualification", palette = "Reds", style = "quantile", 
                              title = "% with a Qualification") + tm_borders(alpha=.4)  

# Para volver tmap a la ventana de gráficos convencional , simplemente ejecute "tmap_mode("plot")" nuevamente
tmap_mode("plot")
