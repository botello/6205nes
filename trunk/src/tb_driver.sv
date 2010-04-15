

`ifndef TB_DRIVER_SV
`define TB_DRIVER_SV

class tb_driver extends component_base;

   protected virtual cpu_if vi;

   function new(string name = "tb_driver", component_base parent);
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
      repeat (10) begin
         @(posedge vi.clk);
         report_info("RUN", "Dummy");
      end
   endtask

   virtual function void report();
      super.report();
   endfunction

endclass

`endif

