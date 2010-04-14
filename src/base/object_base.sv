

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

endclass

`endif

