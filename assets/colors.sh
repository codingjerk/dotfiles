CJ_COLOR_BLACK='       0   0   0'
CJ_COLOR_DARK_GRAY=' 116 124 132'
CJ_COLOR_LIGHT_GRAY='199 204 209'
CJ_COLOR_WHITE='     243 244 245'

CJ_COLOR_RED='       204 122 143' # hue: 345
CJ_COLOR_ORANGE='    204 163 122' # hue: 30
CJ_COLOR_YELLOW='    217 217 152' # hue: 60
CJ_COLOR_GREEN='     152 217 184' # hue: 150
CJ_COLOR_BLUE='      152 195 217' # hue: 200
CJ_COLOR_ELECTRIC='  184 152 217' # hue: 270

CJ_COLOR_0="${CJ_COLOR_BLACK}"
CJ_COLOR_1="${CJ_COLOR_RED}"
CJ_COLOR_2="${CJ_COLOR_GREEN}"
CJ_COLOR_3="${CJ_COLOR_YELLOW}"
CJ_COLOR_4="${CJ_COLOR_BLUE}"
CJ_COLOR_5="${CJ_COLOR_ORANGE}"
CJ_COLOR_6="${CJ_COLOR_ELECTRIC}"
CJ_COLOR_7="${CJ_COLOR_LIGHT_GRAY}"
CJ_COLOR_8="${CJ_COLOR_DARK_GRAY}"
CJ_COLOR_9="${CJ_COLOR_RED}"
CJ_COLOR_A="${CJ_COLOR_GREEN}"
CJ_COLOR_B="${CJ_COLOR_YELLOW}"
CJ_COLOR_C="${CJ_COLOR_BLUE}"
CJ_COLOR_D="${CJ_COLOR_ORANGE}"
CJ_COLOR_E="${CJ_COLOR_ELECTRIC}"
CJ_COLOR_F="${CJ_COLOR_WHITE}"

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

CJ_COLOR_BG_HEX="$(echo $CJ_COLOR_BG | xargs printf '%02X%02X%02X')"
CJ_COLOR_FG_HEX="$(echo $CJ_COLOR_FG | xargs printf '%02X%02X%02X')"
