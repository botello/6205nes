

`ifndef TB_MONITOR_SV
`define TB_MONITOR_SV

class tb_monitor extends component_base;

   protected virtual cpu_if vi;
   bit disable_rmem;
   bit disable_wmem;

   function new(string name = "tb_monitor", component_base patent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void assign_vi(virtual interface cpu_if vi);
      this.vi = vi;
   endfunction

   virtual function void configure();
      super.configure();
   endfunction

   virtual task run();
      super.run();
      fork
         monitor_rmem();
         monitor_wmem();
      join
   endtask

   virtual function void report();
      super.report();
   endfunction

   virtual protected task monitor_rmem();
      //forever begin
         // Assuming reading from memory is instantaneous.
         //@(posedge vi.clk);
         //if (vi.ren) begin
         //   $display ("%p MEM READ [0x%x] = 0x%x", $time, vi.addr_out, vi.data_in);
         //end
      //end
   endtask

   virtual protected task monitor_wmem();
      //forever begin
         //@(posedge vi.clk);
         //if (vi.wen) begin
         //   $display ("%p MEM WRITE [0x%x] = 0x%x", $time, vi.addr_out, vi.data_out);
         //end
      //end
   endtask

endclass

`endif

