
`ifndef CPU_BFM_SV
`define CPU_BFM_SV

class cpu_bfm;
/*
      virtual cpu_intf if0;

      function new(virtual 6502_if if0);
         this.if0 = if0;
      endfunction: new

      virtual task drive_mem_read (input bit  [31:0] addr,
                                   input bit         rd_bWr,
                                   output bit [31:0] data);

      endtask: drive_mem_read

      virtual task drive_mem_write (input bit [31:0] addr,
                                    input bit        rd_bWr,
                                    input bit [31:0] data);

      endtask: drive_mem_write

      virtual task drive_cpu_irq (input bit irq_seq);

      endtask: drive_cpu_irq

      virtual task drive_cpu_nmi (input bit nmi_seq);

      endtask: drive_cpu_nmi

      virtual task drive_sys_reset (input bit reset);
         if0.reset = 1;
         #20;
         if0.reset = 0;
      endtask: drive_sys_reset

      virtual task drive_cpu_halt (input cpu_halt_seq);

      endtask: drive_cpu_halt

      virtual task drive_cpu_go (input cpu_go_seq);

      endtask: drive_cpu_go
*/
endclass

`endif

