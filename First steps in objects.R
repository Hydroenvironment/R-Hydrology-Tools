# Configura tu espacio de trabajo. El espacio entre comillas "" espera por la ruta de la carpeta a elegir.
setwd("C:\\Users\\monte\\Documents\\EVENTOS\\DATA SCIENCE UNI FIC 2019\\Workspace_UNI_2019") # puedes usar / (puedes usar \\ también!).

# Cargar un archivo .csv, recuerda que debes colocar los archivos que cargarás en tu directorio 
Ethnicity <- read.csv("Liverpool/tables/KS201EW_oa11.csv")
Rooms <- read.csv("Liverpool/tables/KS403EW_oa11.csv")
Qualifications <-read.csv("Liverpool/tables/KS501EW_oa11.csv")
Employment <-read.csv("Liverpool/tables/KS601EW_oa11.csv")

# Veamos los 100 casos en el área de desempleo
View(Employment)

# Ahora veamos los nombres de cada columna en un dataframe
names(Employment)

# Como seleccionamos solo una columna?
# ADVERTENCIA: Se sobreescribirán las etiquetas que realizó para los datos originales.
# Si lo hiciste por error debes volver a cargar los archivos.

Ethnicity <- Ethnicity[, c(1, 21)]
Rooms <- Rooms[, c(1, 13)]
Employment <- Employment[, c(1, 20)]
Qualifications <- Qualifications[, c(1, 20)]

# Para cambiar el nombre de una columna hacemos lo siguiente:
names(Employment)[2] <- "Unemployed"


# Para cambiar el nombre de la primera y segunda columna:
names(Ethnicity)<- c("OA", "White_British")
names(Rooms)<- c("OA", "Low_Occupancy")
names(Employment)<- c("OA", "Unemployed")
names(Qualifications)<- c("OA", "Qualification")


#1 Combinar etnicidad y habitaciones para crear un nuevo objeto llamado: "merged_data_1"
merged_data_1 <- merge(Ethnicity, Rooms, by="OA")

#2 Combinamos "merged_data_1" y empleo:
merged_data_2 <- merge(merged_data_1, Employment, by="OA")

#3 Combinamos "merged_data_2" con calificaciones:
Census.Data <- merge(merged_data_2, Qualifications, by="OA")

#4 Removemos los objetos "merged_data" ya que no los necesitaremos:
rm(merged_data_1, merged_data_2)

# Finalmente guardamos los datos del censo en un archivo .csv
write.csv(Census.Data, "practical_data.csv", row.names=F)
