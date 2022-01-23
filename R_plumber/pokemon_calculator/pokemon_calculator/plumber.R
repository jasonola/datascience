#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(tidyverse)


#* get pokedata
#* @get /pokestats
get_pokemon_basestats <- function(pokename = "Pikachu"){
  data <- read_csv("pokemon.csv") %>%
    select(name, hp, attack, defense, sp_attack,sp_defense, speed) %>%
    filter(name %in% pokename)
}

calculate_other_stat <- function(stat,iv, ev, lvl) {

  floor(((2*stat+iv+floor(ev/4))*lvl)/100+5)

}

calculate_hp <- function(stat,iv, ev, lvl) {

  floor(((2*stat+iv+floor(ev/4))*lvl)/100)+lvl+10


}

#* @apiTitle Plumber Pokemon Calculator API

#* Returns calculated stats of Pokemon
#* @param pokemon choose pokemon
#* @param nature choose nature : 1 = Lonely, 2 = Brave...
#* @post /stat-calc
calc_stats <- function(pokemon = "Blissey", lvl=100, hp_iv=31,atk_iv=31,def_iv=31,sp_atk_iv=31,sp_def_iv=31,spd_iv=31,
                           hp_ev=255,atk_ev=255,def_ev=255,sp_atk_ev=255,sp_def_ev=255,spd_ev=255, nature="1") {

  lvl <- as.numeric(lvl)
  hp_iv <- as.numeric(hp_iv)
  atk_iv <- as.numeric(atk_iv)
  def_iv <- as.numeric(def_iv)
  sp_atk_iv <- as.numeric(sp_atk_iv)
  sp_def_iv <- as.numeric(sp_def_iv)
  spd_iv <- as.numeric(spd_iv)
  hp_ev <- as.numeric(hp_ev)
  atk_ev <- as.numeric(atk_ev)
  def_ev <- as.numeric(def_ev)
  sp_atk_ev <- as.numeric(sp_atk_ev)
  sp_def_ev <- as.numeric(sp_def_ev)
  spd_ev <- as.numeric(spd_ev)

  read_csv("pokemon.csv") %>%
    select(name, hp, attack, defense, sp_attack,sp_defense, speed) %>%
    filter(name %in% pokemon) %>%
    mutate(hp = calculate_hp(hp,hp_iv, hp_ev, lvl),
           attack = calculate_other_stat(attack,atk_iv, atk_ev, lvl),
           defense = calculate_other_stat(defense,def_iv, def_ev, lvl),
           sp_attack = calculate_other_stat(sp_attack,sp_atk_iv, sp_atk_ev, lvl),
           sp_defense = calculate_other_stat(sp_defense,sp_def_iv, sp_def_ev, lvl),
           speed = calculate_other_stat(speed,spd_iv, spd_ev, lvl)
    )



}


