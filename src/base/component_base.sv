

`ifndef COMPONENT_BASE_SV
`define COMPONENT_BASE_SV

class component_base extends object_base;

   component_base parent;

   function new(string name = "component_base", component_base parent = null);
      if (parent != null && parent == this)
         $fatal("Circular reference");

      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void configure();
      report_info("CONFIG", "Started...");
   endfunction

   virtual task run();
      report_info("RUN", "Started...");
   endtask

   virtual function void report();
      report_info("REPORT", "Started...");
   endfunction

endclass

`endif

