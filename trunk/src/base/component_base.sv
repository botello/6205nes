

`ifndef COMPONENT_BASE_SV
`define COMPONENT_BASE_SV

class component_base extends object_base;

   function new(string name = "component_base");
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

