

`ifndef ITEM_BASE_SV
`define ITEM_BASE_SV

class item_base extends object_base;

   function new(string name = "item_base");
      this.name = name;
   endfunction

endclass

`endif

