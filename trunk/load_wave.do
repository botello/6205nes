onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider cpu_intf
add wave -noupdate -format Logic /tb_top/cpu_intf/clk
add wave -noupdate -format Logic /tb_top/cpu_intf/syn_clk
add wave -noupdate -format Logic /tb_top/cpu_intf/rst
add wave -noupdate -format Logic /tb_top/cpu_intf/nmi
add wave -noupdate -format Logic /tb_top/cpu_intf/irq
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_intf/addr_out
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_intf/data_out
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_intf/data_in
add wave -noupdate -format Logic /tb_top/cpu_intf/ren
add wave -noupdate -format Logic /tb_top/cpu_intf/wen
add wave -noupdate -format Logic /tb_top/cpu_intf/rdy
add wave -noupdate -format Logic /tb_top/cpu_intf/so
add wave -noupdate -divider cpu_ref_intf
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_ref_intf/addr_out
add wave -noupdate -format Literal /tb_top/cpu_ref_intf/data_out
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_ref_intf/data_in
add wave -noupdate -format Logic /tb_top/cpu_ref_intf/ren
add wave -noupdate -format Logic /tb_top/cpu_ref_intf/wen
add wave -noupdate -format Logic /tb_top/cpu_ref_intf/rdy
add wave -noupdate -format Logic /tb_top/cpu_ref_intf/so
add wave -noupdate -divider cpu_duv_intf
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_duv_intf/addr_out
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_duv_intf/data_out
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_duv_intf/data_in
add wave -noupdate -format Logic /tb_top/cpu_duv_intf/ren
add wave -noupdate -format Logic /tb_top/cpu_duv_intf/wen
add wave -noupdate -format Logic /tb_top/cpu_duv_intf/rdy
add wave -noupdate -format Logic /tb_top/cpu_duv_intf/so
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {625 ns}
