

`ifndef TB_GENERATOR_SV
`define TB_GENERATOR_SV

class tb_generator extends component_base;

   mailbox #(request_item) outbox;

   local int unsigned n_items;

   function new(string name ="tb_generator", component_base parent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void configure();
      n_items = 10;
   endfunction

   virtual task run();
      request_item req;

      repeat (n_items) begin
         req = new({name, "_req_item"});
         assert (req.randomize() > 0) else begin
            report_warning("RUN", $sformatf("Failed to randomize item: %s", req.to_string()));
         end
         outbox.put(req);
         report_info("RUN", $sformatf("Generated: %s", req.to_string()));
      end
   endtask

   virtual function void report();
      report_info("REPORT", $sformatf("Done: generated %p items", n_items));
   endfunction

endclass

`endif

