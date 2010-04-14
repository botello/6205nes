

`ifndef REQUEST_ITEM_SV
`define REQUEST_ITEM_SV

class request_item extends item_base;

   function new(string name = "request_item");
      this.name = name;
   endfunction

endclass

`endif

