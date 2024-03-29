

`ifndef REQUEST_ITEM_SV
`define REQUEST_ITEM_SV

class request_item extends item_base;

   rand int unsigned id;
   rand bit [7:0] inst;

   function new(string name = "request_item");
      this.name = name;
   endfunction

   constraint spec_c {
      id < 100;
   }

   constraint inst_c {
      inst < 200 && inst > 45;
   }

   virtual function string to_string();
      return $sformatf("%s [%p]", this.name, this.id);
   endfunction

endclass

`endif

