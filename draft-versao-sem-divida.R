
# qual o numero do no de juros
no_juros <- unique(matriz$nos_desp[which(matriz$nd=="Juros")])

# qual o numero do no de amortiza��o da d�vida
no_amort <- unique(matriz$nos_desp[which(matriz$nd=="Amortiza��o da D�vida")])

matriz_semdivida <- matriz %>%
  mutate(nd = replace(nd, nd=="Juros", "D�vida"),
         nd = replace(nd, nd=="Amortiza��o da D�vida", "D�vida"),
         nos_desp = replace(nos_desp, nd=="D�vida", min(no_juros,no_amort))) %>%
  filter(!(nr == "Emiss�es de t�tulos" & nd == "D�vida")) %>% # aten��o a esse filtro!
  group_by(nr,nd,nos_rec,nos_desp,cores_ramos)%>%
  summarize(p = sum(p),
            ramo = sum(ramo))

# View(matriz_semdivida %>% filter(!(nr == "Emiss�es de t�tulos" & nd == "D�vida")))
# remover n� que sobrou do vetor de nos e do vetor de cores

rotulos_divida <- c(unique(matriz_semdivida$nr),unique(matriz_semdivida$nd))

# eliminar <- 1:num_nos
# eliminar[] <- TRUE
# eliminar[max(no_juros,no_amort)] <- FALSE # como substitui o n� de maior �ndice pelo n�mero do n� de menor �ndice
# 
# rotulos_divida <- rotulos[eliminar]
# cores_nos_divida <- cores_nos[eliminar]
# 
# # renomear rotulo correspondente � d�vida
# rotulos_divida[min(no_juros,no_amort)] <- "D�vida"

# plotar
library(plotly)
p(matriz_semdivida,rotulos_divida)

# 
# 
# p_sem_divida <- plot_ly(
#   type = "sankey",
#   orientation = "h",
#   opacity = 0.2,
#   
#   textfont = list(
#     family = "Roboto Condensed Light, Source Sans Pro, Arial Narrow",
#     color = "black"
#   ),
#   
#   node = list(
#     label = rotulos_divida,
#     color = cores_nos_divida,
#     pad = 10,
#     thickness = 25,
#     line = list(
#       color = "",
#       width = 0
#     )
#   ),
#   
#   hoverlabel = list(
#     font = list(
#       family = "Roboto Condensed Light, Source Sans Pro, Arial Narrow"
#     )
#   ),
#   
#   link = list(
#     source = matriz_semdivida$nos_rec,
#     target = matriz_semdivida$nos_desp,
#     value =  matriz_semdivida$ramo,
#     color = matriz_semdivida$cores_ramos
#     #color =  "rgba(255,213,0,0.4)" # o pulo do gato! para deixar a cor translucida, � preciso usar rgba, e o �ltimo
#     # par�metro � a opacidade
#     
#     
#   )
# ) %>% 
#   layout(
#     title = "",
#     width = 700,
#     height = 800,
#     font = list(
#       family = "Roboto Condensed Light, Source Sans Pro, Arial Narrow",
#       size = 11,
#       color = "#004a93"
#     )
#   )
# 
# p_sem_divida
