set_global_assignment -entity "single16MHzPLL" -library "lib_single16MHzPLL" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "single16MHzPLL" -library "lib_single16MHzPLL" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "single16MHzPLL" -library "lib_single16MHzPLL" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_single16MHzPLL" -name SPD_FILE [file join $::quartus(sip_path) "single16MHzPLL.spd"]

set_global_assignment -library "lib_single16MHzPLL" -name MISC_FILE [file join $::quartus(sip_path) "single16MHzPLL_sim/single16MHzPLL.vo"]
