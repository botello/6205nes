onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/clk
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/b_rst
add wave -noupdate -divider {reference model}
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/syn_clk
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/b_nmi
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/b_irq
add wave -noupdate -format Literal -radix hexadecimal /tb_top/cpu_ref_intf/cpu_addr_out
add wave -noupdate -format Literal -radix unsigned /tb_top/cpu_ref_intf/cpu_data_out
add wave -noupdate -format Literal -radix unsigned /tb_top/cpu_ref_intf/cpu_data_in
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/ren
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/wen
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/rdy
add wave -noupdate -format Logic -radix unsigned /tb_top/cpu_ref_intf/so
add wave -noupdate -divider memory
add wave -noupdate -format Logic -radix unsigned /tb_top/mem_ref_top/debug_mode
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/io_joypad1_r
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/io_joypad1
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/io_joypad2_r
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/io_joypad2
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/io_spr_ram_dma_r
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/io_spr_ram_dma
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/mem_ram_r
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/mem_ram
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/mem_sram_r
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/mem_sram
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/mem_ioreg_r
add wave -noupdate -format Literal -radix unsigned /tb_top/mem_ref_top/mem_ioreg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ns} 0}
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
WaveRestoreZoom {0 ns} {210 ns}
