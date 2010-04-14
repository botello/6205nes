

`ifndef TB_GENERATOR_SV
`define TB_GENERATOR_SV

class tb_generator extends component_base;

   string name;

   function new(string name ="tb_generator");
      this.name = name;
   endfunction

   virtual function void configure();
   endfunction

   virtual task run();
   endtask

   virtual function void report();
   endfunction

endclass

`endif

