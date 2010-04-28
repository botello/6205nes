

`ifndef TB_DRIVER_SV
`define TB_DRIVER_SV

class tb_driver extends component_base;

   protected virtual tb_cpu_if vi;
   mailbox #(request_item) inbox;
   mailbox #(response_item) outbox;

   local int unsigned n_items;

   function new(string name = "tb_driver", component_base parent);
      this.name = name;
      this.parent = parent;
   endfunction

   virtual function void assign_vi(virtual interface tb_cpu_if vi);
      this.vi = vi;
   endfunction

   virtual function void configure();
      n_items = 10;
   endfunction

   virtual task run();
      request_item req;
      response_item rsp;

      wait_for_rst();
      repeat (n_items) begin
         @(posedge vi.clk);
         inbox.get(req);
         drive_req(req, rsp);
         outbox.put(rsp);
      end
   endtask

   protected task wait_for_rst();
      @(posedge vi.b_rst);
   endtask

   virtual protected task drive_req(request_item req, output response_item rsp);
      // drive item to interface.
      @(posedge vi.clk);
      vi.data_in = req.id;

      @(posedge vi.clk);
      vi.data_in = 'h0;

      report_info("RUN", $sformatf("Driven: %s", req.to_string()));
      // copy information to response message.
      rsp = new();
      rsp.id = req.id;
   endtask

   virtual function void report();
      report_info("REPORT", $sformatf("Done: driven %p item(s)", n_items));
   endfunction

endclass

`endif

