# 1. Pacotes utilizados ---------------------------------------------------

library(ggplot2)
library(ggrepel)
library(data.table)
library(tidyr)
library(dplyr)
library(lubridate)

# 2. Criação da base histórica de despesas fixas --------------------------

## Este script cria e atualiza a base de dados para as despesas do 
## Condomínio SCRN 714/715, Bloco G, Entrada 20, por mês de referência e 
## a partir de 2012.

## O condomínio possui cinco tipos de despesas fixas todos os meses desde
## 2012: luz (CEB), água (CAESB), limpeza das escadas e corredores 
## (diarista), materiais de limpeza e reserva do caixa.

## Primeiro, cria-se um data table com datas para os meses de referência
## existentes entre 2012 e 2018 para cada uma das cinco despesas fixas.

#mes_ref <- data.table(
#  dia = c(rep(
#    "01", 
#    times = 420)
#    ),
#  mes = c(rep(c(
#    "01",
#    "02",
#    "03",
#    "04",
#    "05",
#    "06",
#    "07",
#    "08",
#    "09",
#    "10",
#    "11",
#    "12"),
#    each = 5, times = 7)
#    ),
#  ano = c(rep(c(
#    "2012",
#    "2013",
#    "2014",
#    "2015",
#    "2016",
#    "2017",
#    "2018"),
#    each = 60)
#    )
#  )

## Posteriormente, cria-se uma nova coluna unindo as demais do data.table
## no formato aaaa-mm-dd (forma padrão internacional ISO 8601)
#mes_ref <- mes_ref[, ISO_8601 := paste(ano, mes, dia, sep = "-")]

## Em seguida, mantém-se apenas a última coluna criada, contendo as datas 
## e a convertendo em formato de data.
#mes_ref <- mes_ref[,4]
#mes_ref <- as.Date(mes_ref$ISO_8601, format = "%Y-%m-%d")

## Depois, cria-se outro data table com as despesas fixas associadas aos
## meses de referência

#despesas <- data.table(
#  mes_referencia = mes_ref,
#  despesa = c(rep(c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa"),
#    times = 84)
#    ),
#  valor = c(
#    38.36,
#    272.00,
#    70.00,
#    15.00,
#    310.36, # jan./12
#    37.75,
#    272,
#    70,
#    15,
#    309.75, # fev./12
#    37.13,
#    272,
#    70,
#    15,
#    309.13, # mar./12
#    37.03,
#    278.2,
#    70,
#    15,
#    315.23, # abr./12
#    37.07,
#    301.28,
#    70,
#    15,
#    338.35, # maio/12
#    37.03,
#    302.4,
#    70,
#    15,
#    339.43, # jun./12
#    37.35,
#    302.4,
#    70,
#    15,
#    339.75, # jul./12
#    36.95,
#    265.77,
#    70,
#    15,
#    302.72, # ago./12
#    37,
#    307.71,
#    70,
#    15,
#    344.71, # set./12
#    37.75,
#    297.09,
#    70,
#    15,
#    334.84, # out./12
#    38.12,
#    308.34,
#    70,
#    15,
#    346.46, # nov./12
#    39.14,
#    302.4,
#    70,
#    20,
#    341.54, # dez./12
#    38.14,
#    302.4,
#    70,
#    20,
#    340.54, # jan./13
#    38.13,
#    302.4,
#    70,
#    20,
#    340.53, # fev./13
#    30.17,
#    302.4,
#    70,
#    20,
#    332.57, # mar./13
#    31.08,
#    318.4,
#    70,
#    30,
#    349.48, # abr./13
#    28.6,
#    331.2,
#    70,
#    30,
#    215.88, # maio/13
#    31.44,
#    334.38,
#    70,
#    30,
#    219.492, # jun./13
#    28.82,
#    331.2,
#    70,
#    30,
#    216.01, # jul./13
#    31.49,
#    311.16,
#    70,
#    30,
#    205.59, # ago./13
#    31.15,
#    331.2,
#    70,
#    30,
#    217.41, # set./13
#    32.89,
#    331.2,
#    70,
#    30,
#    218.45, # out./13
#    32.81,
#    331.2,
#    70,
#    30,
#    218.41, # nov./13
#    35.12,
#    331.2,
#    70,
#    30,
#    219.79, # dez./13
#    34.29,
#    334.51,
#    70,
#    30,
#    221.28, # jan./14
#    32.7,
#    331.2,
#    70,
#    30,
#    218.34, # fev./14
#    29.64,
#    327.89,
#    70,
#    30,
#    214.52, # mar./14
#    31.79,
#    344,
#    70,
#    30,
#    225.47, # abr./14
#    31.96,
#    355.2,
#    70,
#    30,
#    232.30, # maio/14
#    32,
#    355.2,
#    70,
#    30,
#    232.32, # jun./14
#    31.52,
#    355.2,
#    70,
#    30,
#    232.03, # jul./14
#    32.86,
#    355.2,
#    70,
#    30,
#    232.84, # ago./14
#    32.64,
#    355.2,
#    80,
#    45,
#    232.70, # set./14
#    37.09,
#    314.2,
#    80,
#    45,
#    210.77, # out./14
#    37.54,
#    355.2,
#    80,
#    45,
#    235.64, # nov./14
#    38.55,
#    355.2,
#    80,
#    45,
#    236.25, # dez./14
#    39.07,
#    365.85,
#    80,
#    45,
#    242.95, # jan./15
#    38.01,
#    355.2,
#    80,
#    50,
#    235.93, # fev./15
#    45.19,
#    355.2,
#    80,
#    50,
#    240.23, # mar./15
#    51.81,
#    381.16,
#    80,
#    50,
#    259.78, # abr./15
#    54.86,
#    412.8,
#    80,
#    50,
#    280.60, # maio/15
#    56.45,
#    412.8,
#    80,
#    50,
#    281.55, # jun./15
#    55.89,
#    421.05,
#    80,
#    50,
#    286.16, # jul./15
#    56.93,
#    412.8,
#    80,
#    50,
#    281.84, # ago./15
#    55.57,
#    412.8,
#    100,
#    50,
#    281.02, # set./15
#    61.68,
#    412.8,
#    100,
#    50,
#    284.69, # out./15
#    60.48,
#    412.8,
#    100,
#    50,
#    283.97, # nov./15
#    62.54,
#    412.8,
#    100,
#    50,
#    285.20, # dez./15
#    72.54,
#    412.8,
#    100,
#    50,
#    291.20, # jan./16
#    64.56,
#    419.2,
#    100,
#    65,
#    290.26, # fev./16
#    55.91,
#    424,
#    100,
#    65,
#    287.95, # mar./16
#    60.7,
#    417.64,
#    100,
#    65,
#    287.00, # abr./16
#    59.07,
#    424,
#    100,
#    65,
#    289.84, # maio/16
#    59.13,
#    424,
#    100,
#    20,
#    338.19, # jun./16
#    58.17,
#    441.6,
#    100,
#    20,
#    349.84, # jul./16
#    57.99,
#    457.6,
#    100,
#    20,
#    360.91, # ago./16
#    56.14,
#    457.6,
#    100,
#    20,
#    359.62, # set./16
#    58.06,
#    466.75,
#    100,
#    20,
#    367.37, # out./16
#    61.32,
#    457.6,
#    100,
#    20,
#    363.24, # nov./16
#    61.29,
#    457.6,
#    100,
#    20,
#    363.22, # dez./16
#    60.66,
#    457.6,
#    100,
#    20,
#    362.78, # jan./17
#    62.14,
#    457.6,
#    100,
#    20,
#    363.818, # fev./17
#    62.74,
#    457.6,
#    100,
#    20,
#    364.24, # mar./17
#    63.54,
#    467.2,
#    100,
#    20,
#    371.52, # abr./17
#    62.98,
#    466.9,
#    100,
#    20,
#    370.92, # maio/17
#    63.66,
#    465.6,
#    100,
#    20,
#    370.48, # jun./17
#    61.44,
#    472,
#    100,
#    20,
#    373.41, # jul./17
#    63.92,
#    472,
#    100,
#    20,
#    375.14, # ago./17
#    64.14,
#    409.65,
#    100,
#    20,
#    331.65, # set./17
#    65.86,
#    490.25,
#    100,
#    20,
#    389.28, # out./17
#    68.52,
#    472.56,
#    100,
#    20,
#    378.76, # nov./17
#    67.51,
#    472,
#    100,
#    20,
#    377.66, # dez./17
#    69.52,
#    481.76,
#    100,
#    20,
#    385.90, # jan./18
#    61.15,
#    472,
#    100,
#    20,
#    373.21, # fev./18
#    61.82,
#    472,
#    100,
#    20,
#    373.67, # mar./18
#    60.11,
#    481.91,
#    100,
#    20,
#    379.41, # abr./18
#    61.62,
#    450.76,
#    100,
#    20,
#    358.67, # maio/18
#    65.05,
#    472,
#    100,
#    20,
#    375.94, # jun./18
#    72.59,
#    486,
#    100,
#    20,
#    391.01, # jul./18
#    70.62,
#    472,
#    100,
#    20,
#    379.83, # ago./18
#    71.38,
#    486.45,
#    100,
#    20,
#    390.48, # set./18
#    71.2,
#    481.88,
#    100,
#    20,
#    387.16, # out./18
#    71.94,
#    481.88,
#    100,
#    20,
#    387.67, # nov./18
#    70.53,
#    472,
#    100,
#    20,
#    379.77) # dez./18
#  )
                                 
#rm(mes_ref) # não será mais utilizado


# 3. Criação da base histórica de despesas pontuais -----------------------

## Ao longo da série histórica, o Condomínio teve despesas pontuais que
## incluem limpeza da caixa de gordura, limpeza da caixa d'água, compra
## de materiais elétricos, eletrônicos e de reforma, pagamento de 
## serviços de mão-de-obra, conserto da porta de entrada, entre outros.

## Para fins de simplificação, as despesas pontuais foram divididas em 
## quatro grupos principais:
## manutenção preventiva: limpeza da caixa d'água, limpeza da caixa de
## gordura, limpeza da laje e outros serviços realizados periodicamente
## com a intenção de reduzir a probabilidade de falha de uma máquina ou 
## equipamento, ou ainda a degradação de um serviço prestado;
## manutenção corretiva: conserto da porta de entrada, reforma da área
## interna, conserto dos corrimãos, desentupimento e outros que envolvam 
## reparos executados sem planejamento e em caráter emergencial;
## compra de materiais: compra de equipamentos elétricos, eletrônicos, 
## materiais de limpeza, materiais de reforma, entre outros;
## serviço de dedetização: realizado apenas uma única vez, mas que 
## deverá ser realizado novamente de forma preventiva.

#demais_despesas <- tribble(
#  ~mes_referencia, ~despesa, ~valor,
#  as.Date("2012-02-01", format = "%Y-%m-%d"),	"Compra de materiais",	729.98,
#  as.Date("2012-03-01", format = "%Y-%m-%d"),	"Compra de materiais",	85.00,
#  as.Date("2012-03-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	200.00,
#  as.Date("2012-04-01", format = "%Y-%m-%d"),	"Manutenção preventiva",	150.00,
#  as.Date("2012-05-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-05-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-06-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-07-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-08-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-08-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	500.00,
#  as.Date("2012-09-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-10-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	70.00,
#  as.Date("2012-10-01", format = "%Y-%m-%d"),	"Compra de materiais",	1200.00,
#  as.Date("2012-10-01", format = "%Y-%m-%d"),	"Compra de materiais",	975.00,
#  as.Date("2012-11-01", format = "%Y-%m-%d"),	"Compra de materiais",	85.00,
#  as.Date("2012-11-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-12-01", format = "%Y-%m-%d"),	"Compra de materiais",	70.00,
#  as.Date("2012-12-01", format = "%Y-%m-%d"),	"Compra de materiais",	109.17,
#  as.Date("2013-11-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	450.00,
#  as.Date("2014-01-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	30.00,
#  as.Date("2014-02-01", format = "%Y-%m-%d"),	"Compra de materiais",	3149.00,
#  as.Date("2014-11-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	289.85,
#  as.Date("2015-05-01", format = "%Y-%m-%d"),	"Manutenção preventiva",	756.00,
#  as.Date("2015-06-01", format = "%Y-%m-%d"),	"Manutenção preventiva",	800.00,
#  as.Date("2015-07-01", format = "%Y-%m-%d"),	"Compra de materiais",	1070.00,
#  as.Date("2016-01-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	1800.00,
#  as.Date("2016-04-01", format = "%Y-%m-%d"),	"Compra de materiais",	31.60,
#  as.Date("2016-05-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	280.00,
#  as.Date("2016-06-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	480.00,
#  as.Date("2016-11-01", format = "%Y-%m-%d"),	"Manutenção preventiva",	600.00,
#  as.Date("2016-12-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	700.00,
#  as.Date("2017-01-01", format = "%Y-%m-%d"),	"Compra de materiais",	310.00,
#  as.Date("2017-04-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	4658.00,
#  as.Date("2017-05-01", format = "%Y-%m-%d"),	"Compra de materiais",	383.80,
#  as.Date("2017-06-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	400.00,
#  as.Date("2017-06-01", format = "%Y-%m-%d"),	"Serviço de dedetização",	280.00,
#  as.Date("2017-06-01", format = "%Y-%m-%d"),	"Compra de materiais",	22.00,
#  as.Date("2017-07-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	160.00,
#  as.Date("2017-08-01", format = "%Y-%m-%d"),	"Manutenção preventiva",	300.00,
#  as.Date("2018-03-01", format = "%Y-%m-%d"),	"Manutenção corretiva",	150.00
#)
  

# 4. Junção das bases históricas ------------------------------------------

#despesas <- rbindlist(list(despesas,demais_despesas)) # junção

#rm(demais_despesas) # mantendo apenas um data.table

# 5. Atualização da base de dados -----------------------------------------

## Esta parte do script atualiza a base histórica conforme novas despesas
## surgem.

## 2019

#jan2019 <- data.table(
#  mes_referencia = as.Date(c(
#    "2019-01-01",
#    "2019-01-01",
#    "2019-01-01",
#    "2019-01-01",
#    "2019-01-01"
#    ), format = "%Y-%m-%d"
#    ),
#  despesa = c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa"
#    ),
#  valor = c(
#    69.77,
#    481.88,
#    100.00,
#    20.00,
#    386.15
#    )
#  )

#despesas <- rbindlist(list(despesas,jan2019)) # junção
#rm(jan2019) # mantendo apenas um data.table

#fev2019 <- data.table(
#  mes_referencia = as.Date(c(
#  "2019-02-01",
#  "2019-02-01",
#  "2019-02-01",
#  "2019-02-01",
#  "2019-02-01"
#  ), format = "%Y-%m-%d"
#  ),
#  despesa = c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa"
#    ),
#  valor = c(
#    73.87,
#    558.02,
#    100.00,
#    20.00,
#    442.32
#    )
#  )

#despesas <- rbindlist(list(despesas,fev2019))
#rm(fev2019) # mantendo apenas um data.table

#mar2019 <- data.table(
#  mes_referencia = as.Date(c(
#    "2019-03-01",
#    "2019-03-01",
#    "2019-03-01",
#    "2019-03-01",
#    "2019-03-01",
#    "2019-03-01"
#  ), format = "%Y-%m-%d"
#  ),
#  despesa = c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa",
#    "Manutenção preventiva"
#    ),
#  valor = c(
#    74.35,
#    538.08,
#    100.00,
#    20.00,
#    428.70,
#    400.00
#    )
#  )

#despesas <- rbindlist(list(despesas,mar2019))
#rm(mar2019) # mantendo apenas um data.table

#abr2019 <- data.table(
#  mes_referencia = as.Date(c(
#    "2019-04-01",
#    "2019-04-01",
#    "2019-04-01",
#    "2019-04-01",
#    "2019-04-01"
#    ), format = "%Y-%m-%d"
#    ),
#  despesa = c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa"
#    ),
#  valor = c(
#    77.00,
#    585.14,
#    100.00,
#    20.00,
#    463.50
#    )
#  )

#despesas <- rbindlist(list(despesas,abr2019))
#rm(abr2019) # mantendo apenas um data.table

#maio2019 <- data.table(
#  mes_referencia = as.Date(c(
#    "2019-05-01",
#    "2019-05-01",
#    "2019-05-01",
#    "2019-05-01",
#    "2019-05-01",
#    "2019-05-01",
#    "2019-05-01"
#  ), format = "%Y-%m-%d"
#  ),
#  despesa = c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa",
#    "Manutenção corretiva",
#    "Serviço de digitalização de projetos microfilmados"
#  ),
#  valor = c(
#    74.12,
#    486.40,
#    100.00,
#    20.00,
#    392.36,
#    200.00,
#    1290.00
#  )
#)

#despesas <- rbindlist(list(despesas,maio2019))
#rm(maio2019) # mantendo apenas um data.table

#jun2019 <- data.table(
#  mes_referencia = as.Date(c(
#    "2019-06-01",
#    "2019-06-01",
#    "2019-06-01",
#    "2019-06-01",
#    "2019-06-01"
#  ), format = "%Y-%m-%d"
#  ),
#  despesa = c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa"
#  ),
#  valor = c(
#    73.76,
#    496.00,
#    100.00,
#    20.00,
#    398.83
#  )
#)

#despesas <- rbindlist(list(despesas,jun2019))
#rm(jun2019) # mantendo apenas um data.table

#jul2019 <- data.table(
#  mes_referencia = as.Date(c(
#    "2019-07-01",
#    "2019-07-01",
#    "2019-07-01",
#    "2019-07-01",
#    "2019-07-01"
#  ), format = "%Y-%m-%d"
#  ),
#  despesa = c(
#    "CEB", 
#    "CAESB", 
#    "Diarista",
#    "Materiais de limpeza",
#    "Reserva de caixa"
#  ),
#  valor = c(
#    74.75,
#    NA,
#    100.00,
#    20.00,
#    NA
#  )
#)

#despesas <- rbindlist(list(despesas,jul2019))
#rm(jul2019) # mantendo apenas um data.table

despesas <- despesas[order(mes_referencia)] # ordenando por data

write.csv(despesas, file = "Despesas.csv", row.names = FALSE) # salva a
# base mais atual na pasta "Condominio"

# 6. Carregamento da base de dados mais atual -----------------------------

despesas <- fread(file = "Despesas.csv")
despesas <- despesas[, mes_referencia := as.Date(mes_referencia, 
                                                 format = "%Y-%m-%d")]

# 7. Valor das despesas do mês do Condomínio ------------------------------

## Todo mês são enviadas as informações sobre gastos com a manutenção 
## predial (água, luz e limpeza) e reserva do caixa. A partir desses
## valores, é calculado o valor da despesa do condomínio e o total por
## apartamento naquele mês.

## O objeto abaixo é atualizado mensalmente com o resumo dessas despesas.

cond_mes <- despesas %>%
  filter(month(mes_referencia) == month(Sys.Date()) & 
           year(mes_referencia) == year(Sys.Date())) %>% 
  spread(despesa, valor) %>%
  select(one_of(c("CEB", 
                  "CAESB", 
                  "Diarista", 
                  "Materiais de limpeza", 
                  "Reserva de caixa"))) %>%
  mutate(TOTAL = round(CEB + CAESB + Diarista + 
                          `Materiais de limpeza` +
                          `Reserva de caixa`,2),
         "Subtotal por apartamento" = round(TOTAL/7,2),
         "Manutenção predial (responsabilidade inquilinos)" = round((CEB + CAESB + Diarista + 
                                        `Materiais de limpeza`)/7, 
                                      2), 
         "Caixa (responsabilidade proprietários)" = round(`Reserva de caixa`/7,2)) %>%
  gather(despesa, valor, 1:9)

save(cond_mes, file = "cond_mes.RData")

# 8. Visualização dos dados -----------------------------------------------

## Esta primeira visualização destaca a evolução das contas de água e luz
## ao longo do tempo, desde o início da série histórica.

## É interessante criar, primeiro, um novo objeto contendo apenas as
## despesas com água e luz na base.
despesas_luz_agua <- despesas[despesa == "CEB" | despesa == "CAESB"]

ggplot(despesas_luz_agua, aes(x = mes_referencia, y = valor)) +
  geom_line(aes(color = despesa)) +
  scale_color_manual(values = c("#00AFBB", "#E7B800")) +
  # cria-se também um destaque para o aumento explosivo da conta de água
  # devido a um vazamento iniciado, provavelmente, em janeiro de 2019 e 
  # consertado em maio de 2019.
  geom_text_repel(aes(label = "Conserto do\nvazamento d'água"),
                  colour = "red",
                  alpha = 1,
                  ylim = 350,
                  size = 3,
                  arrow = arrow(length = unit(0.03, "npc"), 
                                type = "open", ends = "first"),
                  data = subset(despesas_luz_agua[despesa == "CAESB"], 
                                mes_referencia == "2019-04-01")) +
  theme_minimal() +
  guides(size = FALSE, color = guide_legend(title = "Despesa")) +
  labs(title = "Despesas com água e luz no Condomínio", 
       subtitle = "janeiro/2012 a abril/2019",
       x = "Ano", y = "Valor (R$)")

## Esta segunda visualização destaca as receitas e despesas do Condomínio
## desde o início da série histórica.

## A receita do prédio é obtida através da soma do gasto com água, luz,
## diarista, materiais de limpeza, reserva de caixa, taxa extra, seguro
## do prédio, salário do síndico. O valor total é dividido entre as 7 
## unidades autônomas e pago mensalmente - é a taxa de condomínio.

## A despesa do prédio é a soma de todos os gastos exceto a reserva de 
## caixa e taxa extra.

## Para criar a visualização de demonstração de resultados ao longo da
## série histórica, cria-se um objeto que contenha as despesas, receitas
## e a subtração das receitas pelas despesas, por mês.
dre <- despesas %>%
  group_by(mes_ref = floor_date(mes_referencia, "month")) %>%
  summarize(despesas = sum(valor[which(despesa != "Reserva de caixa" &
                                       despesa != "Taxa extra")]
                           ), 
            receitas = sum(valor[which(despesa == "CEB" |
                                       despesa == "CAESB" |
                                       despesa == "Diarista" |
                                       despesa == "Materiais de limpeza" |
                                       despesa == "Reserva de caixa")]
                           ),
            resultado = receitas - despesas,
            resultado_acum = cumsum(resultado)
            )

dre["resultado_acum"] <- cumsum(dre["resultado_acum"])


dre2 <- dre %>%
  select(mes_ref, despesas, receitas, resultado_acum) %>%
  gather(key = "DRE", value = "valor", 2:4)

dre2 <- dre2 %>%
  mutate(DRE = factor(DRE, levels = c("resultado_acum", "receitas",
                                         "despesas")))

ggplot(dre2, aes(x = mes_ref, y = valor)) +
  geom_area(aes(color = DRE, fill = DRE), alpha = 0.9, 
            position = position_dodge(0.8)) +
  scale_color_manual(values = c("gold", "darkgreen", "darkred"), 
                     guide = guide_legend(label = FALSE)) +
  scale_fill_manual(values = c("gold", "darkgreen", "darkred"), 
                    labels = c("Resultado\nacumulado", "Receitas",
                               "Despesas")) +
  geom_vline(xintercept = as.Date("2019-02-01", format = "%Y-%m-%d"), 
             linetype="dashed", color = "darkred") +
  geom_text_repel(aes(
    label = "FIM DA ADMINISTRAÇÃO DE MARLON ROBSON\nValor esperado em caixa reserva: R$ 4.999,89\nValor declarado em caixa reserva: R$ 2.201,86"), 
    colour = "red", alpha = 1, size = 3, xlim = as.Date(
      "2019-02-01", format = "%Y-%m-%d"), data = dre2 %>% 
      filter(DRE == "resultado_acum" & mes_ref == "2019-02-01")) +
  theme_minimal() +
  guides(color = FALSE) +
  labs(title = "Demonstração do Resultado do Exercício no Condomínio", 
       subtitle = "janeiro/2012 a abril/2019",
       x = "Mês de referência", y = "Valor (R$)")
