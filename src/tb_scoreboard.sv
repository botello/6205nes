

`ifndef TB_SCOREBOARD_SV
`define TB_SCOREBOARD_SV

class tb_scoreboard extends component_base;

   mailbox #(response_item) inbox;

   local int unsigned n_items;

   function new(string name ="tb_scoreboard", component_base parent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void configure();
      n_items = 10;
   endfunction

   virtual task run();
      response_item rsp;
      repeat (n_items) begin
         inbox.get(rsp);
         report_info("RUN", $sformatf("Received: %s", rsp.to_string()));
      end
   endtask

   virtual function void report();
      report_info("REPORT", $sformatf("Done: received %p item(s)", n_items));
   endfunction

endclass

`endif

