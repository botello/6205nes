

`ifndef RESPONSE_ITEM_SV
`define RESPONSE_ITEM_SV

class response_item extends item_base;

   int unsigned id;

   function new(string name = "response_item");
      this.name = name;
   endfunction

   virtual function string to_string();
      return $sformatf("%s [%p]", this.name, this.id);
   endfunction

endclass

`endif

