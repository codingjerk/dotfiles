setopt ERR_EXIT NO_UNSET PIPE_FAIL

. "${CJ_DOTFILES}/assets/colors.sh"

printf '\033]P0%s' "${CJ_COLOR_0_HEX}"
printf '\033]P1%s' "${CJ_COLOR_1_HEX}"
printf '\033]P2%s' "${CJ_COLOR_2_HEX}"
printf '\033]P3%s' "${CJ_COLOR_3_HEX}"
printf '\033]P4%s' "${CJ_COLOR_4_HEX}"
printf '\033]P5%s' "${CJ_COLOR_5_HEX}"
printf '\033]P6%s' "${CJ_COLOR_6_HEX}"
printf '\033]P7%s' "${CJ_COLOR_7_HEX}"
printf '\033]P8%s' "${CJ_COLOR_8_HEX}"
printf '\033]P9%s' "${CJ_COLOR_9_HEX}"
printf '\033]PA%s' "${CJ_COLOR_A_HEX}"
printf '\033]PB%s' "${CJ_COLOR_B_HEX}"
printf '\033]PC%s' "${CJ_COLOR_C_HEX}"
printf '\033]PD%s' "${CJ_COLOR_D_HEX}"
printf '\033]PE%s' "${CJ_COLOR_E_HEX}"
printf '\033]PF%s' "${CJ_COLOR_F_HEX}"
