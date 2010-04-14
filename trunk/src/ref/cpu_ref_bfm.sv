

`ifndef CPU_REF_BFM_SV
`define CPU_REF_BFM_SV

class cpu_ref_bfm extends component_base;

   virtual cpu_intf vi;

   function new(string name = "cpu_ref_bfm");
      this.name = name;
   endfunction

   virtual function void assign_vi(virtual interface cpu_intf vi);
      this.vi = vi;
   endfunction
   /*
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
      vi.reset = 1;
      #20;
      vi.reset = 0;
   endtask: drive_sys_reset

   virtual task drive_cpu_halt (input cpu_halt_seq);

   endtask: drive_cpu_halt

   virtual task drive_cpu_go (input cpu_go_seq);

   endtask: drive_cpu_go
   */
endclass

`endif

