

`ifndef RESPONSE_ITEM_SV
`define RESPONSE_ITEM_SV

class response_item extends item_base;

   function new(string name = "response_item");
      this.name = name;
   endfunction

endclass

`endif

