

`ifndef REQUEST_ITEM_SV
`define REQUEST_ITEM_SV

class request_item extends item_base;

   rand int unsigned id;

   function new(string name = "request_item");
      this.name = name;
   endfunction

   constraint spec_c {
      id < 100;
   }

   virtual function string to_string();
      return $sformatf("request [%p]", this.id);
   endfunction

endclass

`endif

