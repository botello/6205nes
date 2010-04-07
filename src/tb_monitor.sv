

`ifndef TB_MONITOR_SV
`define TB_MONITOR_SV

class tb_monitor;

   protected virtual cpu_intf vi;
   bit disable_rmem;
   bit disable_wmem;

   function new(string name = "tb_monitor");
   endfunction

   virtual function void assign_vi(virtual interface cpu_intf vi);
      this.vi = vi;
   endfunction

   virtual task run();
      fork
         monitor_rmem();
         monitor_wmem();
      join
   endtask

   virtual protected task monitor_rmem();
      forever begin
         // Assuming reading from memory is instantaneous.
         @(posedge vi.clk);
         if (vi.ren) begin
            $display ("%p MEM READ [0x%x] = 0x%x", $time, vi.addr_out, vi.data_in);
         end
      end
   endtask

   virtual protected task monitor_wmem();
      forever begin
         @(posedge vi.clk);
         if (vi.wen) begin
            $display ("%p MEM WRITE [0x%x] = 0x%x", $time, vi.addr_out, vi.data_out);
         end
      end
   endtask

endclass

`endif

