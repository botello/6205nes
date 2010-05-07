

`ifndef COMPONENT_BASE_SV
`define COMPONENT_BASE_SV

class component_base extends object_base;

   component_base parent;

   function new(string name = "component_base", component_base parent = null);
      if (parent != null && parent == this)
         $display("Circular reference");

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

   function void report_info(string id, string msg);
      $display("@%p INFO %s [%s] %s", $time, this.name, id, msg);
   endfunction

   function void report_warning(string id, string msg);
      $display("@%p WARNING %s [%s] %s", $time, this.name, id, msg);
   endfunction

   function void report_error(string id, string msg);
      $display("@%p ERROR %s [%s] %s", $time, this.name, id, msg);
   endfunction

   function void report_fatal(string id, string msg);
      $display("@%p FATAL %s [%s] %s", $time, this.name, id, msg);
      $finish();
   endfunction

endclass

`endif

