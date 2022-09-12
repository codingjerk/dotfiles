# Theme: Nord (modified)
CJ_COLOR_DIM_BLACK='  59  66  82'
CJ_COLOR_BLACK='      46  52  64'
CJ_COLOR_DARK_GRAY='  97 110 136'
CJ_COLOR_LIGHT_GRAY='123 133 155'
CJ_COLOR_WHITE='     216 222 233'

CJ_COLOR_RED='       180 142 148'
CJ_COLOR_ORANGE='    136 192 208'
CJ_COLOR_YELLOW='    143 188 187'
CJ_COLOR_GREEN='     136 175 152'
CJ_COLOR_BLUE='      129 161 193'
CJ_COLOR_ELECTRIC='  180 142 173'

CJ_COLOR_0="${CJ_COLOR_BLACK}"
CJ_COLOR_1="${CJ_COLOR_RED}"
CJ_COLOR_2="${CJ_COLOR_GREEN}"
CJ_COLOR_3="${CJ_COLOR_YELLOW}"
CJ_COLOR_4="${CJ_COLOR_BLUE}"
CJ_COLOR_5="${CJ_COLOR_ORANGE}"
CJ_COLOR_6="${CJ_COLOR_ELECTRIC}"
CJ_COLOR_7="${CJ_COLOR_WHITE}"
CJ_COLOR_8="${CJ_COLOR_DARK_GRAY}"
CJ_COLOR_9="${CJ_COLOR_RED}"
CJ_COLOR_A="${CJ_COLOR_GREEN}"
CJ_COLOR_B="${CJ_COLOR_YELLOW}"
CJ_COLOR_C="${CJ_COLOR_BLUE}"
CJ_COLOR_D="${CJ_COLOR_ORANGE}"
CJ_COLOR_E="${CJ_COLOR_ELECTRIC}"
CJ_COLOR_F="${CJ_COLOR_LIGHT_GRAY}"

CJ_COLOR_BG="${CJ_COLOR_0}"
CJ_COLOR_FG="${CJ_COLOR_7}"

CJ_COLOR_0_HEX="$(echo ${CJ_COLOR_0} | xargs printf '%02X%02X%02X')"
CJ_COLOR_1_HEX="$(echo ${CJ_COLOR_1} | xargs printf '%02X%02X%02X')"
CJ_COLOR_2_HEX="$(echo ${CJ_COLOR_2} | xargs printf '%02X%02X%02X')"
CJ_COLOR_3_HEX="$(echo ${CJ_COLOR_3} | xargs printf '%02X%02X%02X')"
CJ_COLOR_4_HEX="$(echo ${CJ_COLOR_4} | xargs printf '%02X%02X%02X')"
CJ_COLOR_5_HEX="$(echo ${CJ_COLOR_5} | xargs printf '%02X%02X%02X')"
CJ_COLOR_6_HEX="$(echo ${CJ_COLOR_6} | xargs printf '%02X%02X%02X')"
CJ_COLOR_7_HEX="$(echo ${CJ_COLOR_7} | xargs printf '%02X%02X%02X')"
CJ_COLOR_8_HEX="$(echo ${CJ_COLOR_8} | xargs printf '%02X%02X%02X')"
CJ_COLOR_9_HEX="$(echo ${CJ_COLOR_9} | xargs printf '%02X%02X%02X')"
CJ_COLOR_A_HEX="$(echo ${CJ_COLOR_A} | xargs printf '%02X%02X%02X')"
CJ_COLOR_B_HEX="$(echo ${CJ_COLOR_B} | xargs printf '%02X%02X%02X')"
CJ_COLOR_C_HEX="$(echo ${CJ_COLOR_C} | xargs printf '%02X%02X%02X')"
CJ_COLOR_D_HEX="$(echo ${CJ_COLOR_D} | xargs printf '%02X%02X%02X')"
CJ_COLOR_E_HEX="$(echo ${CJ_COLOR_E} | xargs printf '%02X%02X%02X')"
CJ_COLOR_F_HEX="$(echo ${CJ_COLOR_F} | xargs printf '%02X%02X%02X')"

CJ_COLOR_DIM_BLACK_HEX="$(echo $CJ_COLOR_DIM_BLACK | xargs printf '%02X%02X%02X')"
CJ_COLOR_BG_HEX="$(echo $CJ_COLOR_BG | xargs printf '%02X%02X%02X')"
CJ_COLOR_FG_HEX="$(echo $CJ_COLOR_FG | xargs printf '%02X%02X%02X')"

cj_colors() {
  echo "0 (Black):     " "#${CJ_COLOR_0_HEX}" "(${CJ_COLOR_0})"
  echo "1 (Red)  :     " "#${CJ_COLOR_1_HEX}" "(${CJ_COLOR_1})"
  echo "2 (Green):     " "#${CJ_COLOR_2_HEX}" "(${CJ_COLOR_2})"
  echo "3 (Yellow):    " "#${CJ_COLOR_3_HEX}" "(${CJ_COLOR_3})"
  echo "4 (Blue):      " "#${CJ_COLOR_4_HEX}" "(${CJ_COLOR_4})"
  echo "5 (Cyan):      " "#${CJ_COLOR_5_HEX}" "(${CJ_COLOR_5})"
  echo "6 (Electic):   " "#${CJ_COLOR_6_HEX}" "(${CJ_COLOR_6})"
  echo "7 (White):     " "#${CJ_COLOR_7_HEX}" "(${CJ_COLOR_7})"
  echo "8 (Dark Gray): " "#${CJ_COLOR_8_HEX}" "(${CJ_COLOR_8})"
  echo "9:             " "#${CJ_COLOR_9_HEX}" "(${CJ_COLOR_9})"
  echo "A:             " "#${CJ_COLOR_A_HEX}" "(${CJ_COLOR_A})"
  echo "B:             " "#${CJ_COLOR_B_HEX}" "(${CJ_COLOR_B})"
  echo "C:             " "#${CJ_COLOR_C_HEX}" "(${CJ_COLOR_C})"
  echo "D:             " "#${CJ_COLOR_D_HEX}" "(${CJ_COLOR_D})"
  echo "E:             " "#${CJ_COLOR_E_HEX}" "(${CJ_COLOR_E})"
  echo "F (Light Gray):" "#${CJ_COLOR_F_HEX}" "(${CJ_COLOR_F})"
}
