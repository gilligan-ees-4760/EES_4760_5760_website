#
#  EES 201 Homework Utilities
#
# message("Lecture Utils")
sb_const <- 5.6704E-8
zero_celsius <- 273.15 # K

base_methane_ppm <- 1.7
base_co2_ppm <- 400

solar_constant <- 1370 # W/m^2
r_earth <- 6.378E+6 # meters

albedo_earth <- 0.30
albedo_mars <- 0.17
albedo_venus <- 0.71

T_surf_earth <- 295
T_surf_mars <- 240
T_surf_venus <- 700

au_earth <- 1.00
au_mars <- 1.50
au_venus <- 0.72

elr_earth <- 6 # K/km
alr_dry <- 10

scinot <- function(x, places) {
  lx <- log10(x)
  ex <- floor(lx)
  mx <- lx %% 1
  return(paste(round(10^mx,places),' \\times 10^{',ex,'}',sep=''))
}


format_sc <- function(x, math_mode = FALSE) {
  s <- paste0(round(x), '~\\mathrm{W}/\\mathrm{m}^2')
  if (! math_mode) s <- paste0('\\(', s, '\\)')
  s
}

bare_rock <- function(solar_const, albedo, au = 1, eps = 1) {
  ((1 - albedo) * solar_const / au^2 / (4 * sb_const * eps))^0.25
}

layer_temp <- function(layers, solar_const = solar_constant,
                       albedo = albedo_earth, au = 1, eps = 1) {
  bare_rock(solar_const, albedo, au, eps) * (layers + 1)^0.25
}

sc_earth <- solar_constant
sc_venus <- solar_constant / au_venus^2
sc_mars <- solar_constant / au_mars^2

tbr_earth <- bare_rock(sc_earth, albedo_earth)
tbr_mars  <- bare_rock(sc_earth, albedo_mars, au_mars)
tbr_venus <- bare_rock(sc_earth, albedo_venus, au_venus)

ftoc <- function(x) {
  (x - 32) * 5./9.
}

ctof <- function(x) {
  x * 9./5. + 32.
}

ktoc <- function(x) {
  x - zero_celsius
}
ctok <- function(x) {
  x + zero_celsius
}

ftok <- function(x) {
  ctok(ftoc(x))
}

ktof <- function(x) {
  ctof(ktoc(x))
}

prte <- function(x, digits) {
  lx <- log10(x)
  ex <- floor(lx)
  mx <- lx %% 1
  return(paste(round(10^mx,digits),' \\times 10^{',ex,'}',sep=''))
}

prt <- function(x,digits,flag='',mark='') {
  formatC(x, digits=digits, format='f', flag=flag, big.mark=mark)
}

theme_set(theme_bw(base_size = 20))

