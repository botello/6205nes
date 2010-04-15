

`ifndef TB_GENERATOR_SV
`define TB_GENERATOR_SV

class tb_generator extends component_base;

   string name;

   function new(string name ="tb_generator", component_base parent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void configure();
      super.configure();
   endfunction

   virtual task run();
      super.run();
   endtask

   virtual function void report();
      super.report();
   endfunction

endclass

`endif

