

`ifndef TB_MONITOR_SV
`define TB_MONITOR_SV

class tb_monitor extends component_base;

   protected virtual tb_cpu_if vi;
   bit disable_rmem;
   bit disable_wmem;

   function new(string name = "tb_monitor", component_base patent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void assign_vi(virtual interface tb_cpu_if vi);
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
      longint count = 0;
      forever begin
         // Assuming reading from memory is instantaneous.
         @(posedge vi.clk);
         if (vi.ren) begin
            $display ("%p [%p] MEM READ [0x%x] = 0x%x", $time, ++count, vi.cpu_addr_out, vi.cpu_data_in);
         end
      end
   endtask

   virtual protected task monitor_wmem();
      longint count = 0;
      forever begin
         @(posedge vi.clk);
         if (vi.wen) begin
            $display ("%p [%p] MEM WRITE [0x%x] = 0x%x", $time, ++count, vi.cpu_addr_out, vi.cpu_data_out);
         end
      end
   endtask

endclass

`endif

