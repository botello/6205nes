

`ifndef TB_DRIVER_SV
`define TB_DRIVER_SV

class tb_driver extends component_base;

   protected virtual cpu_if vi;

   function new(string name = "tb_driver");
      this.name = name;
   endfunction

   virtual function void assign_vi(virtual interface cpu_if vi);
      this.vi = vi;
   endfunction

   virtual function void configure();
   endfunction

   virtual task run();
   endtask

   virtual function void report();
   endfunction

endclass

`endif

