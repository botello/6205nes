

`ifndef OBJECT_BASE_SV
`define OBJECT_BASE_SV

class object_base;

   string name;

   function new(string name = "object_base");
      this.name = name;
   endfunction

   virtual function string to_string();
      return name;
   endfunction

   function void report_info(string id, string msg);
      $display("@%p %s [%s] %s", $time, this.name, id, msg);
   endfunction

   function void report_warning(string id, string msg);
      $warning("@%p %s [%s] %s", $time, this.name, id, msg);
   endfunction

   function void report_error(string id, string msg);
      $error("@%p %s [%s] %s", $time, this.name, id, msg);
   endfunction

   function void report_fatal(string id, string msg);
      $fatal("@%p %s [%s] %s", $time, this.name, id, msg);
   endfunction

endclass

`endif

